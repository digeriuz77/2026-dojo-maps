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

    Query Parameters:
        skip: Number of records to skip for pagination
        limit: Maximum entries to return (1-100)

    Returns: 200 OK with paginated leaderboard entries
    """
    supabase_admin = get_supabase_admin()

    # Get total count for pagination
    count_response = supabase_admin.table('user_profiles').select('id', count='exact').execute()
    total = count_response.count or 0

    # Get paginated users
    response = supabase_admin.table('user_profiles') \
        .select('*') \
        .order('modules_completed', desc=True) \
        .order('created_at', desc=False) \
        .range(skip, skip + limit - 1) \
        .execute()

    entries = []
    current_user_entry = None

    for i, profile in enumerate(response.data, start=skip + 1):
        entry = LeaderboardEntry(
            rank=i,
            display_name=profile.get('display_name') or f"User {profile['user_id'][:8]}",
            modules_completed=profile.get('modules_completed', 0)
        )

        # Check if this is the current user
        if profile['user_id'] == current_user.user_id:
            current_user_entry = entry

        entries.append(entry)

    # If current user not in current page, get their rank
    if not current_user_entry:
        user_profile_response = supabase_admin.table('user_profiles') \
            .select('*') \
            .eq('user_id', current_user.user_id) \
            .execute()

        if user_profile_response.data:
            # Get user's rank by counting users with more modules completed
            user_modules = user_profile_response.data[0].get('modules_completed', 0)
            rank_response = supabase_admin.table('user_profiles') \
                .select('id') \
                .gt('modules_completed', user_modules) \
                .execute()

            user_rank = len(rank_response.data) + 1

            current_user_entry = LeaderboardEntry(
                rank=user_rank,
                display_name=user_profile_response.data[0].get('display_name') or f"You",
                modules_completed=user_modules
            )

    return LeaderboardListResponse(
        entries=entries,
        current_user=current_user_entry,
        total=total,
        skip=skip,
        limit=limit
    )
