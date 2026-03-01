from unittest.mock import patch


def test_analyze_transcript_returns_fallback_when_provider_fails(client):
    payload = {
        "transcript": [
            {"role": "user", "content": "I need to improve this conversation."},
            {"role": "assistant", "content": "Tell me what feels hardest right now."},
        ],
        "persona_name": "Client",
    }

    with patch(
        "app.api.v1.chat_practice.conversation_analysis_service.analyze_conversation",
        side_effect=Exception("provider unavailable"),
    ):
        with patch(
            "app.api.v1.chat_practice.save_conversation_analysis",
            return_value=None,
        ):
            response = client.post("/api/v1/chat-practice/analyze", json=payload)

    assert response.status_code == 200

    body = response.json()
    assert "analysis" in body
    assert 1.0 <= body["analysis"]["overall_score"] <= 5.0
    assert "fallback" in body["analysis"]["summary"].lower()
