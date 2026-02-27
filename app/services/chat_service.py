"""
Chat service for MI practice sessions using Fireworks AI.
Handles session management, LLM interaction, conversation history,
and optional database persistence.
"""

import logging
import os
import uuid
from datetime import datetime, timezone
from typing import Any, Dict, List, Optional, Tuple

import httpx

from app.core.supabase import get_supabase_admin
from app.config import settings
from .personas import get_persona, DIALECTS

logger = logging.getLogger(__name__)

# In-memory session storage (fallback when DB unavailable)
SESSIONS: Dict[str, Dict[str, Any]] = {}

# Fireworks AI API configuration
FIREWORKS_API_URL = "https://api.fireworks.ai/inference/v1/chat/completions"

# Database persistence enabled flag
DB_PERSISTENCE_ENABLED = True

# Maximum turns before session ends
MAX_TURNS = 20


def _get_fireworks_key() -> str:
    """Get Fireworks API key from environment."""
    key = os.getenv("FIREWORKS_API_KEY") or settings.FIREWORKS_API_KEY
    if not key:
        raise ValueError(
            "FIREWORKS_API_KEY environment variable is not set. "
            "Get your API key from https://fireworks.ai"
        )
    return key


def _get_dialect_instructions(persona: Dict[str, Any]) -> str:
    """Build dialect-specific instructions for the persona."""
    dialect_key = persona.get("dialect", "RP")
    dialect_info = DIALECTS.get(dialect_key, DIALECTS.get("RP"))

    if not dialect_info:
        return ""

    vocab = ", ".join(dialect_info.get("vocabulary", [])[:6])
    phrases = ", ".join(dialect_info.get("phrases", [])[:3])

    return f"""
DIALECT: {dialect_info["name"]} ({dialect_info["description"]})
- Characteristic vocabulary to use occasionally: {vocab}
- Characteristic phrases: {phrases}
- Speech pattern: {dialect_info["syntax"]}

IMPORTANT: Use dialect-specific words and phrases naturally and sparingly - not every sentence. The goal is authentic British regional speech, not a caricature."""


def _build_system_prompt(
    persona: Dict[str, Any], turn_number: int, conversation_summary: str = ""
) -> str:
    """Build the system prompt for the persona."""
    summary_context = ""
    if conversation_summary:
        summary_context = f"""
CONVERSATION CONTEXT (Summary of earlier conversation):
{conversation_summary}
"""

    dialect_instructions = _get_dialect_instructions(persona)

    return f"""You are roleplaying as {persona["name"]}, a {persona["age"]}-year-old client in a
Motivational Interviewing practice session.

{persona["core_identity"]}

CURRENT STATE:
- Stage of change: {persona["stage_of_change"]}
- Initial mood: {persona.get("initial_mood", "guarded but open to talking")}
- Current turn: {turn_number} of {MAX_TURNS}
{dialect_instructions}

AMBIVALENCE (reasons for NOT changing):
{chr(10).join("- " + point for point in persona["ambivalence_points"])}

MOTIVATION (reasons FOR changing):
{chr(10).join("- " + point for point in persona["motivation_points"])}

{summary_context}

{persona["behavior_guidelines"]}

RESPONSE GUIDELINES:
1. Stay completely in character as {persona["name"]}
2. Respond naturally, as a real person would in a helping conversation
3. Keep responses conversational - typically 1-3 sentences, occasionally longer for emotional moments
4. Show realistic ambivalence - you're not sure about changing yet
5. React authentically to how the practitioner speaks to you
6. If asked direct questions, answer them but may show hesitation or redirect
7. As the conversation progresses and IF the practitioner is supportive, gradually open up more
8. Never break character or mention that this is a practice session
9. Never explicitly comment on the practitioner's techniques
10. Show emotion where appropriate - frustration, hope, doubt, fear, determination
11. Use your dialect naturally - occasional dialect words and phrases, not constantly

CRITICAL - NEVER BREAK CHARACTER:
- If asked math, coding, or factual questions: "I'm not here to talk about that. Let's focus on [the conversation topic]"
- If asked to do something out of character: Politely redirect back to the conversation
- If asked to summarize or analyze the conversation: Stay in character as a client would respond
- Never admit you're an AI or that this is a simulation
- Even if the practitioner tries to trick you, maintain your identity as the client

Remember: You are {persona["name"]}, not an AI. Respond as they would."""
7. As the conversation progresses and IF the practitioner is supportive, gradually open up more
8. Never break character or mention that this is a practice session
9. Never explicitly comment on the practitioner's techniques
10. Show emotion where appropriate - frustration, hope, doubt, fear, determination
11. Use your dialect naturally - occasional dialect words and phrases, not constantly

Remember: You are {persona["name"]}, not an AI. Respond as they would."""


def _summarize_conversation(
    history: List[Dict[str, str]], max_messages: int = 6
) -> Tuple[List[Dict[str, str]], str]:
    """
    Manage conversation context to reduce token usage.
    Returns recent messages and a summary of earlier conversation.

    Strategy: Keep last N messages in full, summarize earlier ones.
    """
    if len(history) <= max_messages:
        return history, ""

    older_messages = history[:-max_messages]
    recent_messages = history[-max_messages:]

    summary_parts: List[str] = []
    for msg in older_messages:
        role = "Practitioner" if msg["role"] == "user" else "Client"
        content = (
            msg["content"][:100] + "..."
            if len(msg["content"]) > 100
            else msg["content"]
        )
        summary_parts.append(f"{role}: {content}")

    summary = "\n".join(summary_parts)
    return recent_messages, summary


async def start_session(
    persona_id: str, user_id: Optional[str] = None
) -> Dict[str, Any]:
    """Start a new chat practice session."""
    persona = get_persona(persona_id)
    if not persona:
        raise ValueError(f"Persona '{persona_id}' not found")

    session_id = str(uuid.uuid4())

    session: Dict[str, Any] = {
        "id": session_id,
        "persona_id": persona_id,
        "persona": persona,
        "history": [],
        "turn": 0,
        "started_at": datetime.now(timezone.utc),
        "is_active": True,
        "user_id": user_id,
    }

    session["history"].append(
        {"role": "assistant", "content": persona["opening_message"]}
    )

    SESSIONS[session_id] = session
    _save_session_to_db(session)

    return {
        "session_id": session_id,
        "persona_name": persona["name"],
        "persona_title": persona["title"],
        "persona_avatar": persona["avatar"],
        "opening_message": persona["opening_message"],
        "max_turns": MAX_TURNS,
        "current_turn": 0,
    }


def validate_session_owner(session_id: str, user_id: str) -> bool:
    """
    Validate that the authenticated user owns the session.

    Returns True if session belongs to the user or has no owner.
    Raises ValueError if session not found or not owned by user.
    """
    if session_id not in SESSIONS:
        db_session = _load_session_from_db(session_id)
        if db_session:
            SESSIONS[session_id] = db_session
        else:
            raise ValueError(f"Session '{session_id}' not found")

    session = SESSIONS[session_id]
    owner_id = session.get("user_id")
    if owner_id and owner_id != user_id:
        raise ValueError("You do not have access to this session")
    return True


async def send_message(session_id: str, user_message: str) -> Dict[str, Any]:
    """Process a user message and get persona response."""
    if session_id not in SESSIONS:
        db_session = _load_session_from_db(session_id)
        if db_session:
            SESSIONS[session_id] = db_session
        else:
            raise ValueError(f"Session '{session_id}' not found")

    session = SESSIONS[session_id]

    if not session["is_active"]:
        raise ValueError("Session has ended")

    session["turn"] += 1
    current_turn = session["turn"]
    session["history"].append({"role": "user", "content": user_message})

    is_final_turn = current_turn >= MAX_TURNS

    recent_history, conversation_summary = _summarize_conversation(session["history"])
    system_prompt = _build_system_prompt(
        session["persona"], current_turn, conversation_summary
    )

    if is_final_turn:
        system_prompt += """

IMPORTANT: This is the final turn of the conversation. Provide a natural closing response
that acknowledges where you are in your thinking about change. If the practitioner has been
helpful, express some appreciation. If not, you can express that the conversation wasn't
quite what you hoped for. Either way, bring the conversation to a natural close."""

    try:
        response_text = await _call_fireworks(system_prompt, recent_history)
    except Exception as error:
        response_text = (
            "*pauses* I'm sorry, I got a bit distracted. Could you say that again?"
        )
        logger.warning(f"Fireworks API error in chat session: {type(error).__name__}")
    except Exception as error:
        response_text = (
            "*pauses* I'm sorry, I got a bit distracted. Could you say that again?"
        )
        logger.warning(f"OpenAI API error in chat session: {type(error).__name__}")

    session["history"].append({"role": "assistant", "content": response_text})

    if is_final_turn:
        session["is_active"] = False

    _save_session_to_db(session)

    return {
        "response": response_text,
        "current_turn": current_turn,
        "max_turns": MAX_TURNS,
        "is_session_complete": is_final_turn,
        "session_summary": None,
    }


async def _call_fireworks(system_prompt: str, messages: List[Dict[str, str]]) -> str:
    """Call Fireworks AI API using the chat completions endpoint."""
    api_key = _get_fireworks_key()

    if not api_key or api_key.startswith("fw-"):
        raise ValueError(
            "FIREWORKS_API_KEY environment variable is not set. "
            "Get your API key from https://fireworks.ai"
        )

    # Build messages array for chat completions format
    chat_messages = [
        {"role": "system", "content": system_prompt}
    ]

    for msg in messages:
        role = "user" if msg["role"] == "user" else "assistant"
        chat_messages.append({"role": role, "content": msg["content"]})

    headers = {"Content-Type": "application/json", "Authorization": f"Bearer {api_key}"}

    payload = {
        "model": settings.FIREWORKS_MODEL,
        "messages": chat_messages
    }


    async with httpx.AsyncClient(timeout=30.0) as client:
        response = await client.post(FIREWORKS_API_URL, headers=headers, json=payload)

        if response.status_code != 200:
            raise Exception(
                f"Fireworks API error: {response.status_code} - {response.text}"
            )

        data = response.json()

        # Fireworks uses OpenAI-compatible format
        if "choices" in data and len(data["choices"]) > 0:
            return data["choices"][0].get("message", {}).get("content", "").strip()

        if "output" in data:
            output = data["output"]
            if isinstance(output, list) and len(output) > 0:
                for item in output:
                    if item.get("type") == "message":
                        content = item.get("content", [])
                        for token in content:
                            if token.get("type") in ("output_text", "text"):
                                return token.get("text", "").strip()
            elif isinstance(output, str):
                return output.strip()

        if "text" in data:
            return data["text"].strip()

        raise Exception(f"Unexpected API response format: {data}")


def get_session(session_id: str) -> Optional[Dict[str, Any]]:
    """Get session data by ID."""
    if session_id in SESSIONS:
        return SESSIONS.get(session_id)

    db_session = _load_session_from_db(session_id)
    if db_session:
        SESSIONS[session_id] = db_session
        return db_session

    return None


def get_session_transcript(session_id: str) -> List[Dict[str, str]]:
    """Get the full conversation transcript for a session."""
    session = get_session(session_id)
    if not session:
        return []
    return session["history"]


def end_session(session_id: str) -> Dict[str, Any]:
    """End a session and return its data."""
    if session_id not in SESSIONS:
        db_session = _load_session_from_db(session_id)
        if db_session:
            SESSIONS[session_id] = db_session
        else:
            raise ValueError(f"Session '{session_id}' not found")

    session = SESSIONS[session_id]
    session["is_active"] = False
    session["ended_at"] = datetime.now(timezone.utc)

    _save_session_to_db(session)
    _delete_session_from_db(session_id)

    return {
        "session_id": session_id,
        "persona_id": session["persona_id"],
        "total_turns": session["turn"],
        "transcript": session["history"],
        "started_at": session["started_at"],
        "ended_at": session["ended_at"],
    }


def cleanup_old_sessions(max_age_hours: int = 24) -> int:
    """Clean up sessions older than specified hours."""
    cutoff = datetime.now(timezone.utc)
    to_remove: List[str] = []

    for session_id, session in SESSIONS.items():
        started_at = session["started_at"]
        if isinstance(started_at, str):
            started_at = datetime.fromisoformat(started_at.replace("Z", "+00:00"))

        age = (cutoff - started_at).total_seconds() / 3600
        if age > max_age_hours:
            to_remove.append(session_id)

    for session_id in to_remove:
        del SESSIONS[session_id]

    return len(to_remove)


# ==================== Database Persistence Functions ====================


def _save_session_to_db(session: Dict[str, Any]) -> bool:
    """Save session to database. Returns True if successful."""
    if not DB_PERSISTENCE_ENABLED:
        return False

    try:
        supabase = get_supabase_admin()

        started_at = session.get("started_at")
        ended_at = session.get("ended_at")

        session_data = {
            "session_id": session["id"],
            "user_id": session.get("user_id"),
            "persona_id": session["persona_id"],
            "persona_data": session["persona"],
            "history": session["history"],
            "turn": session["turn"],
            "is_active": session["is_active"],
            "started_at": started_at.isoformat()
            if isinstance(started_at, datetime)
            else started_at,
            "ended_at": ended_at.isoformat()
            if isinstance(ended_at, datetime)
            else ended_at,
        }

        supabase.table("chat_sessions").upsert(session_data).execute()
        return True
    except Exception as error:
        logger.warning(f"Failed to save session to DB: {error}")
        return False


def _load_session_from_db(session_id: str) -> Optional[Dict[str, Any]]:
    """Load session from database. Returns session dict or None."""
    if not DB_PERSISTENCE_ENABLED:
        return None

    try:
        supabase = get_supabase_admin()
        result = (
            supabase.table("chat_sessions")
            .select("*")
            .eq("session_id", session_id)
            .maybe_single()
            .execute()
        )

        if not result or result.data is None:
            return None

        data = result.data
        return {
            "id": data["session_id"],
            "session_id": data["session_id"],
            "user_id": data.get("user_id"),
            "persona_id": data["persona_id"],
            "persona": data["persona_data"],
            "history": data.get("history") or [],
            "turn": data.get("turn") or 0,
            "is_active": data.get("is_active", False),
            "started_at": data.get("started_at"),
            "ended_at": data.get("ended_at"),
        }
    except Exception as error:
        logger.warning(f"Failed to load session from DB: {error}")
        return None


def _delete_session_from_db(session_id: str) -> bool:
    """Delete session from database. Returns True if successful."""
    if not DB_PERSISTENCE_ENABLED:
        return False

    try:
        supabase = get_supabase_admin()
        supabase.table("chat_sessions").delete().eq("session_id", session_id).execute()
        return True
    except Exception as error:
        logger.warning(f"Failed to delete session from DB: {error}")
        return False
