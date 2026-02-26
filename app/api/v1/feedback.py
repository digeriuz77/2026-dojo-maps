"""
Feedback API Routes - User feedback collection for MI Learning Platform

Stores user feedback after practice sessions in Supabase.

RESTful Patterns:
    POST /api/v1/feedback/     - Create new feedback (201 Created)
    GET  /api/v1/feedback/     - List feedback with pagination (200 OK)
"""

import logging
import uuid
from datetime import datetime
from typing import Optional, List

from fastapi import APIRouter, HTTPException, Depends, Query, status
from pydantic import BaseModel, Field

from app.core.auth import get_current_user, AuthContext
from app.core.supabase import get_supabase, get_supabase_admin

logger = logging.getLogger(__name__)
router = APIRouter(prefix="/feedback", tags=["Feedback"])


class FeedbackCreate(BaseModel):
    """User feedback submission model"""

    session_id: str = Field(..., description="ID of the practice session")
    conversation_id: Optional[str] = Field(None, description="Optional conversation ID")
    persona_practiced: Optional[str] = Field(
        None, description="Name of persona practiced with"
    )
    helpfulness_score: int = Field(..., ge=0, le=10, description="Rating from 0-10")
    what_was_helpful: Optional[str] = Field(
        None, description="What the user found helpful"
    )
    improvement_suggestions: Optional[str] = Field(
        None, description="Suggestions for improvement"
    )
    user_email: Optional[str] = Field(None, description="Optional user email")


class FeedbackOut(BaseModel):
    """Feedback response model"""

    id: str
    session_id: str
    conversation_id: Optional[str]
    persona_practiced: Optional[str]
    helpfulness_score: int
    what_was_helpful: Optional[str]
    improvement_suggestions: Optional[str]
    user_email: Optional[str]
    user_id: Optional[str]
    created_at: str


class FeedbackListResponse(BaseModel):
    """Paginated feedback list response"""

    items: List[FeedbackOut]
    total: int
    skip: int
    limit: int


@router.post("/", response_model=FeedbackOut, status_code=status.HTTP_201_CREATED)
async def create_feedback(
    feedback: FeedbackCreate,
    auth: Optional[AuthContext] = Depends(get_current_user),
):
    """
    Submit user feedback after a practice session.

    Accessible by: All users (no authentication required)
    Stores feedback in Supabase user_feedback table.

    Returns: 201 Created with the created feedback object
    """
    try:
        supabase = get_supabase()

        # Prepare data for insertion
        feedback_data = {
            "id": str(uuid.uuid4()),
            "session_id": feedback.session_id,
            "conversation_id": feedback.conversation_id,
            "persona_practiced": feedback.persona_practiced,
            "helpfulness_score": feedback.helpfulness_score,
            "what_was_helpful": feedback.what_was_helpful,
            "improvement_suggestions": feedback.improvement_suggestions,
            "user_email": feedback.user_email,
            "user_id": auth.user_id if auth else None,
            "created_at": datetime.utcnow().isoformat(),
        }

        # Store in Supabase
        result = supabase.table("user_feedback").insert(feedback_data).execute()

        if not result.data:
            raise HTTPException(status_code=500, detail="Failed to store feedback")

        logger.info(f"Feedback submitted successfully: {feedback_data['id']}")

        return FeedbackOut(**result.data[0])

    except HTTPException:
        raise
    except Exception as e:
        logger.error(f"Failed to submit feedback: {e}", exc_info=True)
        raise HTTPException(
            status_code=500, detail=f"Failed to submit feedback: {str(e)}"
        )


@router.get("/", response_model=FeedbackListResponse)
async def list_feedback(
    skip: int = Query(0, ge=0, description="Number of records to skip"),
    limit: int = Query(50, ge=1, le=100, description="Maximum records to return"),
    min_score: Optional[int] = Query(None, ge=0, le=10, description="Filter by minimum helpfulness score"),
    auth: AuthContext = Depends(get_current_user),
):
    """
    Get aggregate feedback statistics.

    Accessible by: Admin users only
    Returns paginated feedback with optional filtering by score.

    Query Parameters:
        skip: Number of records to skip (pagination)
        limit: Maximum records to return (1-100)
        min_score: Optional filter for minimum helpfulness score
    """
    try:
        # Check admin role
        if auth.role not in ["admin", "moderator"]:
            raise HTTPException(status_code=status.HTTP_403_FORBIDDEN, detail="Admin access required")

        supabase = get_supabase_admin()

        # Build query with optional filtering
        query = supabase.table("user_feedback").select("id", count="exact")

        if min_score is not None:
            query = query.gte("helpfulness_score", min_score)

        # Get total count
        count_result = query.execute()
        total = count_result.count or 0

        # Get paginated data
        query = supabase.table("user_feedback").select("*")

        if min_score is not None:
            query = query.gte("helpfulness_score", min_score)

        result = query.order("created_at", desc=True).range(skip, skip + limit - 1).execute()

        items = [FeedbackOut(**item) for item in result.data] if result.data else []

        return FeedbackListResponse(
            items=items,
            total=total,
            skip=skip,
            limit=limit
        )

    except HTTPException:
        raise
    except Exception as e:
        logger.error(f"Failed to get feedback: {e}", exc_info=True)
        raise HTTPException(
            status_code=500, detail=f"Failed to retrieve feedback: {str(e)}"
        )
