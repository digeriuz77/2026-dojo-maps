"""
Analysis Persistence Service

Handles saving conversation analysis results to Supabase database
and retrieving them for reporting and analytics.
"""

import logging
from datetime import datetime, timezone
from typing import Any, Dict, List, Optional

from app.core.supabase import get_supabase, get_supabase_admin
from app.models.chat import ConversationAnalysis

logger = logging.getLogger(__name__)


def save_conversation_analysis(
    session_id: str,
    analysis: ConversationAnalysis,
    transcript: List[Dict[str, str]],
    persona_id: Optional[str] = None,
    persona_name: Optional[str] = None,
    user_id: Optional[str] = None,
    total_turns: int = 0,
) -> Optional[str]:
    """
    Save a conversation analysis to the database.

    Args:
        session_id: The session identifier
        analysis: The ConversationAnalysis object
        transcript: The full conversation transcript
        persona_id: ID of the persona used
        persona_name: Name of the persona
        user_id: ID of the user (if authenticated)
        total_turns: Number of turns in the conversation

    Returns:
        The ID of the saved analysis, or None if failed
    """
    try:
        # Use admin client to bypass RLS for inserts
        supabase = get_supabase_admin()

        analysis_data = {
            "session_id": session_id,
            "user_id": user_id,
            "persona_id": persona_id,
            "persona_name": persona_name,
            "overall_score": analysis.overall_score,
            "foundational_trust_safety": analysis.foundational_trust_safety,
            "empathic_partnership_autonomy": analysis.empathic_partnership_autonomy,
            "empowerment_clarity": analysis.empowerment_clarity,
            "mi_spirit_score": analysis.mi_spirit_score,
            "partnership_demonstrated": analysis.partnership_demonstrated,
            "acceptance_demonstrated": analysis.acceptance_demonstrated,
            "compassion_demonstrated": analysis.compassion_demonstrated,
            "evocation_demonstrated": analysis.evocation_demonstrated,
            "techniques_count": analysis.techniques_count,
            "techniques_used": [
                {
                    "technique": technique.technique,
                    "turn_number": technique.turn_number,
                    "example": technique.example,
                    "effectiveness": technique.effectiveness,
                }
                for technique in analysis.techniques_used
            ],
            "strengths": analysis.strengths,
            "areas_for_improvement": analysis.areas_for_improvement,
            "client_movement": analysis.client_movement,
            "change_talk_evoked": analysis.change_talk_evoked,
            "transcript_summary": analysis.transcript_summary,
            "summary": analysis.summary,
            "key_moments": analysis.key_moments,
            "suggestions_for_next_time": analysis.suggestions_for_next_time,
            "transcript": transcript,
            "total_turns": total_turns,
            "created_at": datetime.now(timezone.utc).isoformat(),
        }

        try:
            result = (
                supabase.table("conversation_analyses").insert(analysis_data).execute()
            )
        except Exception as database_error:
            logger.error(
                f"Database error during analysis insert: {database_error}",
                exc_info=True,
            )
            if "conversation_id" in analysis_data:
                del analysis_data["conversation_id"]
                try:
                    result = (
                        supabase.table("conversation_analyses")
                        .insert(analysis_data)
                        .execute()
                    )
                except Exception as retry_error:
                    logger.error(f"Retry also failed: {retry_error}", exc_info=True)
                    return None
            else:
                return None

        if result.data and len(result.data) > 0:
            analysis_id = result.data[0]["id"]
            logger.info(f"Analysis saved successfully: {analysis_id}")
            return analysis_id

        logger.error("Failed to save analysis: No data returned")
        return None

    except Exception as error:
        logger.error(f"Failed to save conversation analysis: {error}", exc_info=True)
        return None


def get_analysis_by_id(
    analysis_id: str, user_id: Optional[str] = None
) -> Optional[Dict[str, Any]]:
    """
    Retrieve a specific analysis by ID.

    Args:
        analysis_id: The analysis ID
        user_id: Optional user ID for access control

    Returns:
        The analysis data or None if not found
    """
    try:
        supabase = get_supabase()

        query = (
            supabase.table("conversation_analyses").select("*").eq("id", analysis_id)
        )
        if user_id:
            query = query.eq("user_id", user_id)

        result = query.execute()
        if result.data and len(result.data) > 0:
            return result.data[0]
        return None

    except Exception as error:
        logger.error(f"Failed to retrieve analysis: {error}", exc_info=True)
        return None


def get_user_analyses(user_id: str, limit: int = 50) -> List[Dict[str, Any]]:
    """
    Get all analyses for a specific user.

    Args:
        user_id: The user ID
        limit: Maximum number of results

    Returns:
        List of analysis records
    """
    try:
        supabase = get_supabase()

        result = (
            supabase.table("conversation_analyses")
            .select("*")
            .eq("user_id", user_id)
            .order("created_at", desc=True)
            .limit(limit)
            .execute()
        )

        return result.data or []

    except Exception as error:
        logger.error(f"Failed to retrieve user analyses: {error}", exc_info=True)
        return []


def get_all_analyses(limit: int = 100, offset: int = 0) -> List[Dict[str, Any]]:
    """
    Get all analyses (admin only).

    Args:
        limit: Maximum number of results
        offset: Pagination offset

    Returns:
        List of analysis records
    """
    try:
        supabase = get_supabase()

        result = (
            supabase.table("conversation_analyses")
            .select("*")
            .order("created_at", desc=True)
            .limit(limit)
            .offset(offset)
            .execute()
        )

        return result.data or []

    except Exception as error:
        logger.error(f"Failed to retrieve analyses: {error}", exc_info=True)
        return []
