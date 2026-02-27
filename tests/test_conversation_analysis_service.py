import json
from unittest.mock import patch

import pytest

import app.services.conversation_analysis_service as analysis_service


def test_format_conversation_compacts_and_omits_middle():
    transcript = []
    for i in range(25):
        transcript.append(
            {"role": "user", "content": f"user message {i} " + ("x" * 400)}
        )
        transcript.append(
            {
                "role": "assistant",
                "content": f"assistant message {i} " + ("y" * 400),
            }
        )

    formatted = analysis_service._format_conversation(transcript, "Client")

    assert "omitted for brevity" in formatted
    assert len(formatted) <= analysis_service.MAX_ANALYSIS_CONVERSATION_CHARS

    non_empty_lines = [line for line in formatted.splitlines() if line.strip()]
    assert non_empty_lines
    assert max(len(line) for line in non_empty_lines) < 320


def test_parse_analysis_json_extracts_wrapped_json_object():
    wrapped = """Here is the analysis:
```json
{"overall_score": 4.2, "client_movement": "toward_change"}
```
"""

    parsed = analysis_service._parse_analysis_json(wrapped)

    assert parsed["overall_score"] == 4.2
    assert parsed["client_movement"] == "toward_change"


@pytest.mark.asyncio
async def test_analyze_conversation_uses_capped_output_tokens():
    captured = {}

    response_body = {
        "overall_score": 4.0,
        "foundational_trust_safety": 4.0,
        "empathic_partnership_autonomy": 4.0,
        "empowerment_clarity": 4.0,
        "mi_spirit_score": 4.0,
        "partnership_demonstrated": True,
        "acceptance_demonstrated": True,
        "compassion_demonstrated": True,
        "evocation_demonstrated": True,
        "techniques_used": [],
        "techniques_count": {
            "open_question": 1,
            "closed_question": 0,
            "simple_reflection": 1,
            "complex_reflection": 0,
            "affirmation": 1,
            "summary": 0,
            "giving_advice": 0,
            "directing": 0,
        },
        "strengths": ["Used open questions"],
        "areas_for_improvement": ["Offer more summaries"],
        "client_movement": "toward_change",
        "change_talk_evoked": True,
        "transcript_summary": "Short summary.",
        "summary": "Short coaching summary.",
        "key_moments": [],
        "suggestions_for_next_time": ["Reflect change talk."],
    }

    class FakeResponse:
        status_code = 200

        def json(self):
            return {
                "choices": [
                    {
                        "message": {
                            "content": json.dumps(response_body),
                        }
                    }
                ]
            }

    class FakeAsyncClient:
        def __init__(self, *args, **kwargs):
            captured["timeout"] = kwargs.get("timeout")

        async def __aenter__(self):
            return self

        async def __aexit__(self, exc_type, exc, tb):
            return False

        async def post(self, url, headers=None, json=None):
            captured["url"] = url
            captured["headers"] = headers
            captured["payload"] = json
            return FakeResponse()

    transcript = [
        {"role": "assistant", "content": "Welcome to the session."},
        {
            "role": "user",
            "content": "I want to change but I keep delaying and feel uncertain.",
        },
        {
            "role": "assistant",
            "content": "It sounds like part of you is ready, and part feels stuck.",
        },
    ]

    with patch.object(analysis_service, "_get_fireworks_key", return_value="test-key"):
        with patch(
            "app.services.conversation_analysis_service.httpx.AsyncClient",
            FakeAsyncClient,
        ):
            result = await analysis_service.analyze_conversation(
                transcript=transcript,
                persona_name="Client",
            )

    assert result["overall_score"] == 4.0
    assert captured["payload"]["max_tokens"] == analysis_service.ANALYSIS_RESPONSE_MAX_TOKENS
    assert captured["payload"]["messages"][0]["content"] == analysis_service.ANALYSIS_SYSTEM_PROMPT
    assert "Transcript:" in captured["payload"]["messages"][1]["content"]
