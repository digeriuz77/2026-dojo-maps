"""
Leaderboard API endpoints

Handles leaderboard rankings and user rankings.

RESTful Patterns:
    GET /api/v1/leaderboard/     - List leaderboard with pagination (200 OK)
"""
from pydantic import BaseModel
from fastapi import APIRouter, Depends, Query
from supabase import Client
from typing import Optional, List

from app.core.supabase import get_supabase, get_supabase_admin
from app.core.auth import get_current_user, AuthContext
from app.models.progress import LeaderboardEntry

router = APIRouter()


class LeaderboardListResponse(BaseModel):
    """Paginated leaderboard response"""

    entries: List[LeaderboardEntry]
    current_user: Optional[LeaderboardEntry]
    total: int
    skip: int
    limit: int


@router.get("/", response_model=LeaderboardListResponse)
async def get_leaderboard(
    skip: int = Query(0, ge=0, description="Number of records to skip"),
    limit: int = Query(50, ge=1, le=100, description="Maximum entries to return"),
    current_user: AuthContext = Depends(get_current_user),
    supabase: Client = Depends(get_supabase)
):
    """
    Get the leaderboard with top users by points.

    Includes the current user's rank if not in top list.
    Uses optimized RPC functions for efficiency.

    Query Parameters:
        skip: Number of records to skip for pagination
        limit: Maximum entries to return (1-100)

    Returns: 200 OK with paginated leaderboard entries
    """
    supabase_admin = get_supabase_admin()

    # Get paginated leaderboard using optimized RPC function
    # Replaces: select('*') + Python sorting with SQL ROW_NUMBER()
    response = supabase_admin.rpc("get_leaderboard", {"p_skip": skip, "p_limit": limit}).execute()

    entries = []
    current_user_entry = None

    for row in response.data or []:
        entry = LeaderboardEntry(
            rank=row.get("rank", 0),
            display_name=row.get("display_name", f"User {str(row.get('user_id', ''))[:8]}"),
            modules_completed=row.get("modules_completed", 0)
        )

        # Check if this is the current user
        if str(row.get("user_id")) == str(current_user.user_id):
            current_user_entry = entry

        entries.append(entry)

    # If current user not in current page, get their rank using optimized RPC
    if not current_user_entry:
        rank_result = supabase_admin.rpc("get_user_rank", {"p_user_id": current_user.user_id}).execute()
        
        if rank_result.data:
            user_rank = rank_result.data[0].get("rank", 0)
            total = rank_result.data[0].get("total_users", 0)
            
            # Get user's display name
            user_profile = supabase_admin.table("user_profiles").select("display_name, modules_completed").eq("user_id", current_user.user_id).maybe_single().execute()
            
            display_name = "You"
            user_modules = 0
            if user_profile.data:
                display_name = user_profile.data.get("display_name") or "You"
                user_modules = user_profile.data.get("modules_completed", 0)
            
            current_user_entry = LeaderboardEntry(
                rank=user_rank,
                display_name=display_name,
                modules_completed=user_modules
            )
        else:
            total = 0
    else:
        # Get total count
        count_response = supabase_admin.table('user_profiles').select('id', count='exact').execute()
        total = count_response.count or 0

    return LeaderboardListResponse(
        entries=entries,
        current_user=current_user_entry,
        total=total,
        skip=skip,
        limit=limit
    )
