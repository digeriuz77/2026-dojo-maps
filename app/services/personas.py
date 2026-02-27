"""
Workplace personas for MAPS coaching practice sessions.
These are simulated employees/managers for practicing facilitative coaching.

Architecture:
- Primary: Fetch from Supabase with in-memory caching (15 min TTL)
- Fallback: Use hardcoded FALLBACK_PERSONAS if Supabase unavailable
"""

import json
import logging
from datetime import datetime, timedelta, timezone
from typing import Dict, Any, Optional, List

from app.core.supabase import get_supabase_admin
from app.data.fallback_personas import FALLBACK_PERSONAS

logger = logging.getLogger(__name__)

# ==========================================
# British Dialect Configurations (hardcoded)
# ==========================================

DIALECTS = {
    "RP": {
        "name": "Received Pronunciation",
        "description": "Standard British English, often associated with educated speakers in Southern England",
        "vocabulary": [
            "rather",
            "quite",
            "I say",
            "indeed",
            "absolutely",
            "magnificent",
        ],
        "phrases": [
            "What do you think about...?",
            "I must say",
            "If you don't mind my saying",
        ],
        "syntax": "Longer, more structured sentences. Formal vocabulary.",
    },
    "northern": {
        "name": "Northern England",
        "description": "Working class Northern cities - Manchester, Leeds, Newcastle",
        "vocabulary": [
            "aye",
            "nowt",
            "summat",
            "reet",
            "gerronwith",
            "bairn",
            "lass",
            "lad",
        ],
        "phrases": [
            "I'll have to have a think about that",
            "That's reet good that is",
            "Nay, I dunno",
        ],
        "syntax": "Direct, practical, uses local slang. Shorter sentences.",
    },
    "cockney": {
        "name": "Cockney",
        "description": "East London working class dialect",
        "vocabulary": [
            "blimey",
            "gonna",
            "wanna",
            "innit",
            "chers",
            "mate",
            "duck",
            "proper",
        ],
        "phrases": ["Cor blimey", "Don't mate, I'll...", "It were alright, innit"],
        "syntax": "Relaxed, uses glottal stops, dropped H's.",
    },
    "scottish": {
        "name": "Scottish",
        "description": "Scottish English with Scots vocabulary",
        "vocabulary": ["wee", "aye", "nae", "dinnae", "ken", "braw", "heid"],
        "phrases": ["I'll need tae think oan that", "Wee bit", "Ach, it'll be fine"],
        "syntax": "Direct, uses Scots words alongside English. Warm tone.",
    },
    "west_country": {
        "name": "West Country",
        "description": "Bristol, Somerset, Devon - rural Southwest England",
        "vocabulary": ["beeen", "zummer", "nowt", "wozza", "alright duck", "lover"],
        "phrases": [
            "I don't know about that",
            "It were a lovely day",
            "I'll have a ponder",
        ],
        "syntax": "Drawling vowels, friendly tone, more relaxed syntax.",
    },
}

# ==========================================
# Cache Configuration
# ==========================================

personas_cache: Dict[str, Dict[str, Any]] = {}
cache_expiry: Optional[datetime] = None
CACHE_TTL_MINUTES = 15

# ==========================================
# Helper Functions
# ==========================================


def _clean_string(val: Any) -> str:
    """Strip literal quotes from DB strings if saved awkwardly."""
    if not val:
        return ""
    if isinstance(val, str):
        val = val.strip()
        if (val.startswith("'") and val.endswith("'")) or (
            val.startswith('"') and val.endswith('"')
        ):
            return val[1:-1]
    return str(val) if val else ""


def _clean_json_array(val: Any) -> List[str]:
    """Parse stringified JSON arrays from the database."""
    if not val:
        return []
    if isinstance(val, list):
        return val
    if isinstance(val, str):
        try:
            clean_str = _clean_string(val)
            return json.loads(clean_str)
        except json.JSONDecodeError:
            logger.warning(f"Failed to parse JSON array from DB: {val}")
            return []
    return []


# ==========================================
# Public API Functions
# ==========================================


def get_all_personas() -> Dict[str, Dict[str, Any]]:
    """
    Fetch all available personas from Supabase with in-memory caching.
    Falls back to hardcoded FALLBACK_PERSONAS if Supabase unavailable.
    Cache TTL: 15 minutes
    """
    global personas_cache, cache_expiry

    now = datetime.now(timezone.utc)

    # Return cache if still valid
    if personas_cache and cache_expiry and now < cache_expiry:
        return personas_cache

    try:
        supabase = get_supabase_admin()

        # Fetch active personas ordered by display_order
        response = (
            supabase.table("personas")
            .select("*")
            .eq("is_active", True)
            .order("display_order")
            .execute()
        )

        if not response.data:
            logger.warning(
                "No active personas found in Supabase. Using hardcoded fallback."
            )
            return FALLBACK_PERSONAS

        db_personas = {}
        for row in response.data:
            # Use key_name as the lookup key (matches old structure)
            p_id = row.get("key_name") or row.get("id")

            db_personas[p_id] = {
                "id": p_id,
                "name": row.get("name", "Unknown"),
                "age": row.get("age", 30),
                "title": row.get("title", ""),
                "description": row.get("description", ""),
                "avatar": row.get("avatar", "👤"),
                "stage_of_change": row.get("stage_of_change", "contemplation"),
                "initial_mood": _clean_string(row.get("initial_mood"))
                or "guarded but open to talking",
                # Voice and dialect with defaults
                "voice": row.get("voice", "neutral"),
                "dialect": row.get("dialect", "RP"),
                # Cleaned data fields
                "core_identity": _clean_string(row.get("core_identity")),
                "ambivalence_points": _clean_json_array(row.get("ambivalence_points")),
                "motivation_points": _clean_json_array(row.get("motivation_points")),
                "behavior_guidelines": _clean_string(row.get("behavior_guidelines")),
                "opening_message": _clean_string(row.get("opening_message")),
            }

        # Update cache
        personas_cache = db_personas
        cache_expiry = now + timedelta(minutes=CACHE_TTL_MINUTES)
        logger.info(f"Successfully cached {len(db_personas)} personas from Supabase.")

        return db_personas

    except Exception as e:
        logger.error(
            f"Error fetching personas from Supabase: {e}. Falling back to hardcoded data."
        )
        return FALLBACK_PERSONAS


def get_persona(persona_id: str) -> Optional[Dict[str, Any]]:
    """Get a persona by ID."""
    personas = get_all_personas()
    persona = personas.get(persona_id)
    if not persona:
        return None

    if not persona.get("initial_mood"):
        persona = {**persona, "initial_mood": "guarded but open to talking"}

    return persona


def get_persona_list() -> List[Dict[str, Any]]:
    """Get a simplified list of personas for display."""
    personas = get_all_personas()
    return [
        {
            "id": p["id"],
            "name": p["name"],
            "title": p["title"],
            "description": p["description"],
            "avatar": p["avatar"],
            "stage_of_change": p.get("stage_of_change", "contemplation"),
            "dialect": p.get("dialect", "RP"),
        }
        for p in personas.values()
    ]


def refresh_personas_cache() -> None:
    """Force refresh the personas cache."""
    global personas_cache, cache_expiry
    personas_cache = {}
    cache_expiry = None
    logger.info("Personas cache cleared. Next request will fetch fresh data.")


# Backwards compatibility - keep PERSONAS as alias for FALLBACK_PERSONAS
PERSONAS = FALLBACK_PERSONAS
