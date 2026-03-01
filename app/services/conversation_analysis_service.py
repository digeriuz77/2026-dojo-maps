"""
Conversation Analysis Service for MI Practice Sessions.
Analyzes conversations using MAPS framework and MI technique detection.
"""

import os
import httpx
import json
from typing import Dict, Any, List, Optional

from app.config import settings

# Fireworks AI API configuration
FIREWORKS_API_URL = "https://api.fireworks.ai/inference/v1/chat/completions"
MAX_ANALYSIS_MESSAGES = 36
MAX_ANALYSIS_HEAD_MESSAGES = 8
MAX_ANALYSIS_TAIL_MESSAGES = 24
MAX_ANALYSIS_CHARS_PER_MESSAGE = 220
MAX_ANALYSIS_CONVERSATION_CHARS = 6500
ANALYSIS_RESPONSE_MAX_TOKENS = 1200
ALLOWED_CLIENT_MOVEMENT = {"toward_change", "stable", "away_from_change"}
ALLOWED_KEY_MOMENT_IMPACT = {"positive", "negative", "neutral"}
ALLOWED_TECHNIQUE_EFFECTIVENESS = {
    "effective",
    "partially_effective",
    "ineffective",
}


def _get_fireworks_key() -> str:
    """Get Fireworks API key from environment."""
    key = (os.getenv("FIREWORKS_API_KEY") or settings.FIREWORKS_API_KEY or "").strip()
    if not key:
        raise ValueError(
            "FIREWORKS_API_KEY environment variable is not set. "
            "Get your API key from https://fireworks.ai"
        )
    return key


ANALYSIS_SYSTEM_PROMPT = """You are an expert Motivational Interviewing (MI) assessor for MAPS.
Return ONLY valid JSON (no markdown) that matches this structure exactly:
{
  "overall_score": 1-5 float,
  "foundational_trust_safety": 1-5 float,
  "empathic_partnership_autonomy": 1-5 float,
  "empowerment_clarity": 1-5 float,
  "mi_spirit_score": 1-5 float,
  "partnership_demonstrated": bool,
  "acceptance_demonstrated": bool,
  "compassion_demonstrated": bool,
  "evocation_demonstrated": bool,
  "techniques_used": [{"technique": str, "turn_number": int, "example": str, "effectiveness": "effective|partially_effective|ineffective"}],
  "techniques_count": {"open_question": int, "closed_question": int, "simple_reflection": int, "complex_reflection": int, "affirmation": int, "summary": int, "giving_advice": int, "directing": int},
  "strengths": [str],
  "areas_for_improvement": [str],
  "client_movement": "toward_change|stable|away_from_change",
  "change_talk_evoked": bool,
  "transcript_summary": str,
  "summary": str,
  "key_moments": [{"turn": int, "moment": str, "impact": "positive|negative|neutral"}],
  "suggestions_for_next_time": [str]
}

Rules:
- Ground feedback in the transcript evidence.
- Keep examples short (<=120 chars each).
- Keep techniques_used <= 8 items.
- Keep strengths/areas_for_improvement/suggestions_for_next_time <= 5 items each.
- Keep transcript_summary concise (4-6 sentences) and summary concise (5-8 sentences)."""

ANALYSIS_USER_PROMPT = """Persona: {persona_name}
Transcript:
{conversation}"""


def _to_bool(value: Any, default: bool = False) -> bool:
    if isinstance(value, bool):
        return value
    if isinstance(value, (int, float)):
        return value != 0
    if isinstance(value, str):
        lowered = value.strip().lower()
        if lowered in {"true", "1", "yes", "y"}:
            return True
        if lowered in {"false", "0", "no", "n"}:
            return False
    return default


def _to_score(value: Any, default: float = 3.0) -> float:
    try:
        score = float(value)
    except (TypeError, ValueError):
        score = default
    return max(1.0, min(5.0, score))


def _to_non_negative_int(value: Any, default: int = 0) -> int:
    try:
        parsed = int(float(value))
    except (TypeError, ValueError):
        return default
    return max(0, parsed)


def _to_text(value: Any, default: str = "", max_chars: int = 1500) -> str:
    if value is None:
        return default
    text = str(value).strip()
    if not text:
        return default
    return text[:max_chars]


def _normalize_string_list(value: Any, max_items: int = 5) -> List[str]:
    if not isinstance(value, list):
        return []

    normalized: List[str] = []
    for item in value:
        text = _to_text(item)
        if not text:
            continue
        normalized.append(text)
        if len(normalized) >= max_items:
            break
    return normalized


def _normalize_techniques_count(value: Any) -> Dict[str, int]:
    default = _get_default_analysis()["techniques_count"].copy()
    if not isinstance(value, dict):
        return default

    for key in list(default.keys()):
        if key in value:
            default[key] = _to_non_negative_int(value.get(key), default[key])

    for key, count in value.items():
        if isinstance(key, str) and key not in default:
            default[key] = _to_non_negative_int(count, 0)

    return default


def _normalize_techniques_used(value: Any, max_items: int = 8) -> List[Dict[str, Any]]:
    if not isinstance(value, list):
        return []

    normalized: List[Dict[str, Any]] = []
    for index, item in enumerate(value):
        if not isinstance(item, dict):
            continue

        technique = _to_text(item.get("technique"), max_chars=120)
        example = _to_text(item.get("example"), max_chars=120)
        if not technique and not example:
            continue

        effectiveness = str(item.get("effectiveness") or "").strip().lower()
        if effectiveness not in ALLOWED_TECHNIQUE_EFFECTIVENESS:
            effectiveness = "partially_effective"

        turn_number = _to_non_negative_int(item.get("turn_number"), index + 1)
        if turn_number < 1:
            turn_number = index + 1

        normalized.append(
            {
                "technique": technique or "Unspecified technique",
                "turn_number": turn_number,
                "example": example or "No example provided",
                "effectiveness": effectiveness,
            }
        )
        if len(normalized) >= max_items:
            break

    return normalized


def _normalize_key_moments(value: Any, max_items: int = 8) -> List[Dict[str, Any]]:
    if not isinstance(value, list):
        return []

    normalized: List[Dict[str, Any]] = []
    for index, item in enumerate(value):
        if not isinstance(item, dict):
            continue

        turn = _to_non_negative_int(item.get("turn"), index + 1)
        if turn < 1:
            turn = index + 1

        moment = _to_text(item.get("moment"), max_chars=220)
        if not moment:
            continue

        impact = str(item.get("impact") or "").strip().lower()
        if impact not in ALLOWED_KEY_MOMENT_IMPACT:
            impact = "neutral"

        normalized.append({"turn": turn, "moment": moment, "impact": impact})
        if len(normalized) >= max_items:
            break

    return normalized


def _normalize_analysis_payload(value: Any) -> Dict[str, Any]:
    fallback = _get_default_analysis()
    payload = value if isinstance(value, dict) else {}

    client_movement = str(payload.get("client_movement") or "").strip().lower()
    if client_movement not in ALLOWED_CLIENT_MOVEMENT:
        client_movement = fallback["client_movement"]

    strengths = _normalize_string_list(payload.get("strengths"), max_items=5)
    if not strengths:
        strengths = fallback["strengths"]

    areas_for_improvement = _normalize_string_list(
        payload.get("areas_for_improvement"), max_items=5
    )
    if not areas_for_improvement:
        areas_for_improvement = fallback["areas_for_improvement"]

    suggestions_for_next_time = _normalize_string_list(
        payload.get("suggestions_for_next_time"), max_items=5
    )
    if not suggestions_for_next_time:
        suggestions_for_next_time = fallback["suggestions_for_next_time"]

    transcript_summary = _to_text(
        payload.get("transcript_summary"), fallback["transcript_summary"], max_chars=2000
    )
    summary = _to_text(payload.get("summary"), fallback["summary"], max_chars=2500)

    return {
        "overall_score": _to_score(payload.get("overall_score"), fallback["overall_score"]),
        "foundational_trust_safety": _to_score(
            payload.get("foundational_trust_safety"),
            fallback["foundational_trust_safety"],
        ),
        "empathic_partnership_autonomy": _to_score(
            payload.get("empathic_partnership_autonomy"),
            fallback["empathic_partnership_autonomy"],
        ),
        "empowerment_clarity": _to_score(
            payload.get("empowerment_clarity"), fallback["empowerment_clarity"]
        ),
        "mi_spirit_score": _to_score(
            payload.get("mi_spirit_score"), fallback["mi_spirit_score"]
        ),
        "partnership_demonstrated": _to_bool(
            payload.get("partnership_demonstrated"),
            fallback["partnership_demonstrated"],
        ),
        "acceptance_demonstrated": _to_bool(
            payload.get("acceptance_demonstrated"),
            fallback["acceptance_demonstrated"],
        ),
        "compassion_demonstrated": _to_bool(
            payload.get("compassion_demonstrated"),
            fallback["compassion_demonstrated"],
        ),
        "evocation_demonstrated": _to_bool(
            payload.get("evocation_demonstrated"),
            fallback["evocation_demonstrated"],
        ),
        "techniques_used": _normalize_techniques_used(payload.get("techniques_used")),
        "techniques_count": _normalize_techniques_count(payload.get("techniques_count")),
        "strengths": strengths,
        "areas_for_improvement": areas_for_improvement,
        "client_movement": client_movement,
        "change_talk_evoked": _to_bool(
            payload.get("change_talk_evoked"), fallback["change_talk_evoked"]
        ),
        "transcript_summary": transcript_summary,
        "summary": summary,
        "key_moments": _normalize_key_moments(payload.get("key_moments")),
        "suggestions_for_next_time": suggestions_for_next_time,
    }


def get_default_analysis(error_message: Optional[str] = None) -> Dict[str, Any]:
    """Public fallback analysis payload used when provider calls fail."""
    return _normalize_analysis_payload(_get_default_analysis(error_message))


def _compact_message_text(text: str, limit: int = MAX_ANALYSIS_CHARS_PER_MESSAGE) -> str:
    """Normalize and trim message content for analysis efficiency."""
    normalized = " ".join((text or "").split())
    if len(normalized) <= limit:
        return normalized
    return normalized[: limit - 1].rstrip() + "…"


def _format_conversation(transcript: List[Dict[str, str]], persona_name: str) -> str:
    """Format transcript as compact turn lines for token-efficient analysis."""
    lines: List[str] = []
    turn = 0

    for msg in transcript:
        role = msg.get("role")
        if role not in {"user", "assistant"}:
            continue

        content = _compact_message_text(str(msg.get("content", "")))
        if not content:
            continue

        if role == "user":
            turn += 1
            lines.append(f"[T{turn}] Practitioner: {content}")
        else:
            visible_turn = turn if turn > 0 else 1
            lines.append(f"[T{visible_turn}] {persona_name}: {content}")

    if len(lines) > MAX_ANALYSIS_MESSAGES:
        head = lines[:MAX_ANALYSIS_HEAD_MESSAGES]
        tail = lines[-MAX_ANALYSIS_TAIL_MESSAGES:]
        omitted = len(lines) - len(head) - len(tail)
        lines = [
            *head,
            f"[... {omitted} earlier messages omitted for brevity ...]",
            *tail,
        ]

    conversation = "\n".join(lines)
    if len(conversation) > MAX_ANALYSIS_CONVERSATION_CHARS:
        conversation = conversation[: MAX_ANALYSIS_CONVERSATION_CHARS - 1].rstrip() + "…"

    return conversation


async def analyze_conversation(
    transcript: List[Dict[str, str]], persona_name: str = "Client"
) -> Dict[str, Any]:
    """
    Analyze a practice conversation and return detailed feedback.

    Args:
        transcript: List of messages with 'role' and 'content' keys
        persona_name: Name of the client persona for formatting

    Returns:
        Detailed analysis dictionary
    """
    api_key = _get_fireworks_key()

    # Format the conversation
    formatted_conversation = _format_conversation(transcript, persona_name)

    # Build the analysis request
    prompt = ANALYSIS_USER_PROMPT.format(
        persona_name=persona_name, conversation=formatted_conversation
    )

    headers = {"Content-Type": "application/json", "Authorization": f"Bearer {api_key}"}

    payload = {
        "model": settings.FIREWORKS_MODEL,
        "messages": [
            {
                "role": "system",
                "content": ANALYSIS_SYSTEM_PROMPT,
            },
            {"role": "user", "content": prompt},
        ],
        "temperature": 0.2,
        "top_p": 0.9,
        "max_tokens": ANALYSIS_RESPONSE_MAX_TOKENS,
        "response_format": {"type": "json_object"},
    }

    async with httpx.AsyncClient(timeout=60.0) as client:
        response = await client.post(FIREWORKS_API_URL, headers=headers, json=payload)

        # Some model families may not support JSON response_format.
        if response.status_code == 400:
            error_text = (response.text or "").lower()
            if "response_format" in error_text or "json_object" in error_text:
                retry_payload = {k: v for k, v in payload.items() if k != "response_format"}
                response = await client.post(
                    FIREWORKS_API_URL, headers=headers, json=retry_payload
                )

        if response.status_code != 200:
            raise Exception(
                f"Fireworks API error: {response.status_code} - {response.text[:400]}"
            )

        data = response.json()

    # Extract response text
    response_text = _extract_response_text(data)

    # Parse JSON from response
    analysis = _normalize_analysis_payload(_parse_analysis_json(response_text))

    return analysis


def _extract_response_text(data: Dict[str, Any]) -> str:
    """Extract text from Fireworks API response."""
    # Fireworks uses OpenAI-compatible format
    if "choices" in data and len(data["choices"]) > 0:
        choice = data["choices"][0]
        if "message" in choice:
            return choice["message"].get("content", "").strip()
        if "text" in choice:
            return choice["text"].strip()

    # Fallback to other formats
    if "output" in data:
        output = data["output"]
        if isinstance(output, list) and len(output) > 0:
            for item in output:
                if item.get("type") == "message":
                    content = item.get("content", [])
                    for c in content:
                        if c.get("type") == "output_text":
                            return c.get("text", "").strip()
                        if c.get("type") == "text":
                            return c.get("text", "").strip()
        elif isinstance(output, str):
            return output.strip()

    if "text" in data:
        return data["text"].strip()

    raise Exception(f"Unexpected API response format: {data}")


def _parse_analysis_json(response_text: str) -> Dict[str, Any]:
    """Parse JSON from the analysis response."""
    # Try to find JSON in the response
    # Sometimes the model wraps it in markdown code blocks
    text = response_text.strip()

    # Remove markdown code blocks if present
    if text.startswith("```json"):
        text = text[7:]
    elif text.startswith("```"):
        text = text[3:]

    if text.endswith("```"):
        text = text[:-3]

    text = text.strip()

    try:
        return json.loads(text)
    except json.JSONDecodeError:
        # Retry by extracting the first JSON object when the model adds wrappers.
        start = text.find("{")
        end = text.rfind("}")
        if start != -1 and end != -1 and end > start:
            try:
                return json.loads(text[start : end + 1])
            except json.JSONDecodeError as e:
                return _get_default_analysis(f"Failed to parse analysis: {str(e)}")

        return _get_default_analysis("Failed to parse analysis: no valid JSON object found")


def _get_default_analysis(error_message: Optional[str] = None) -> Dict[str, Any]:
    """Return a default analysis structure when parsing fails."""
    return {
        "overall_score": 3.0,
        "foundational_trust_safety": 3.0,
        "empathic_partnership_autonomy": 3.0,
        "empowerment_clarity": 3.0,
        "mi_spirit_score": 3.0,
        "partnership_demonstrated": False,
        "acceptance_demonstrated": False,
        "compassion_demonstrated": False,
        "evocation_demonstrated": False,
        "techniques_used": [],
        "techniques_count": {
            "open_question": 0,
            "closed_question": 0,
            "simple_reflection": 0,
            "complex_reflection": 0,
            "affirmation": 0,
            "summary": 0,
            "giving_advice": 0,
            "directing": 0,
        },
        "strengths": ["Analysis could not be completed"],
        "areas_for_improvement": ["Please try again"],
        "client_movement": "stable",
        "change_talk_evoked": False,
        "transcript_summary": "Analysis could not be generated. Please try again.",
        "summary": error_message
        or "Analysis could not be generated. Please try again.",
        "key_moments": [],
        "suggestions_for_next_time": [
            "Practice with longer conversations for more detailed feedback"
        ],
    }


def calculate_technique_balance(techniques_count: Dict[str, int]) -> Dict[str, Any]:
    """Calculate OARS balance and other technique metrics."""
    oars = {
        "open_questions": techniques_count.get("open_question", 0),
        "affirmations": techniques_count.get("affirmation", 0),
        "reflections": techniques_count.get("simple_reflection", 0)
        + techniques_count.get("complex_reflection", 0),
        "summaries": techniques_count.get("summary", 0),
    }

    total_oars = sum(oars.values())
    non_mi = techniques_count.get("giving_advice", 0) + techniques_count.get(
        "directing", 0
    )

    # Calculate reflection to question ratio
    total_questions = techniques_count.get("open_question", 0) + techniques_count.get(
        "closed_question", 0
    )
    reflection_ratio = (
        oars["reflections"] / total_questions if total_questions > 0 else 0
    )

    # Calculate open vs closed question ratio
    open_question_ratio = (
        techniques_count.get("open_question", 0) / total_questions
        if total_questions > 0
        else 0
    )

    return {
        "oars_breakdown": oars,
        "total_oars": total_oars,
        "non_mi_behaviors": non_mi,
        "reflection_to_question_ratio": round(reflection_ratio, 2),
        "open_question_percentage": round(open_question_ratio * 100, 1),
        "mi_adherent_percentage": round(
            total_oars / (total_oars + non_mi) * 100
            if (total_oars + non_mi) > 0
            else 0,
            1,
        ),
    }
