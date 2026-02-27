import pytest
from unittest.mock import patch

import app.services.chat_service as chat_service


def test_ensure_complete_sentence_trims_to_last_sentence_boundary():
    text = "I can see why this matters. I want to raise it in a one-to-one but"

    result = chat_service._ensure_complete_sentence(text)

    assert result == "I can see why this matters."


def test_ensure_complete_sentence_adds_period_when_no_sentence_end():
    text = "I want to raise it privately with Sam"

    result = chat_service._ensure_complete_sentence(text)

    assert result.endswith(".")


def test_ensure_complete_sentence_keeps_complete_response():
    text = "Would a one-to-one chat be better?"

    result = chat_service._ensure_complete_sentence(text)

    assert result == text


@pytest.mark.asyncio
async def test_call_fireworks_trims_response_when_finish_reason_is_length():
    captured = {}

    class FakeResponse:
        status_code = 200

        @staticmethod
        def json():
            return {
                "choices": [
                    {
                        "message": {
                            "content": "I can see why this matters. I want to raise it in a one-to-one but"
                        },
                        "finish_reason": "length",
                    }
                ]
            }

    class FakeAsyncClient:
        def __init__(self, *args, **kwargs):
            pass

        async def __aenter__(self):
            return self

        async def __aexit__(self, exc_type, exc, tb):
            return False

        async def post(self, url, headers=None, json=None):
            captured["url"] = url
            captured["headers"] = headers
            captured["payload"] = json
            return FakeResponse()

    with patch.object(chat_service, "_get_fireworks_key", return_value="test-key"):
        with patch("app.services.chat_service.httpx.AsyncClient", FakeAsyncClient):
            result = await chat_service._call_fireworks(
                "system prompt",
                [{"role": "user", "content": "hello"}],
            )

    assert result == "I can see why this matters."
    assert captured["payload"]["max_tokens"] == chat_service.CHAT_RESPONSE_MAX_TOKENS


@pytest.mark.asyncio
async def test_call_fireworks_keeps_response_when_not_truncated():
    class FakeResponse:
        status_code = 200

        @staticmethod
        def json():
            return {
                "choices": [
                    {
                        "message": {"content": "I can do that. Let's try it."},
                        "finish_reason": "stop",
                    }
                ]
            }

    class FakeAsyncClient:
        def __init__(self, *args, **kwargs):
            pass

        async def __aenter__(self):
            return self

        async def __aexit__(self, exc_type, exc, tb):
            return False

        async def post(self, url, headers=None, json=None):
            return FakeResponse()

    with patch.object(chat_service, "_get_fireworks_key", return_value="test-key"):
        with patch("app.services.chat_service.httpx.AsyncClient", FakeAsyncClient):
            result = await chat_service._call_fireworks(
                "system prompt",
                [{"role": "user", "content": "hello"}],
            )

    assert result == "I can do that. Let's try it."
