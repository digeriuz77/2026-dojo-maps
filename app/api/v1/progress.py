"""
Progress API endpoints

Handles user progress tracking and statistics.

RESTful Patterns:
    GET /api/v1/progress/           - Get user stats and all progress (200 OK)
    GET /api/v1/progress/modules/   - Get all module progress (200 OK)
    GET /api/v1/progress/{id}      - Get specific module progress (200 OK)
"""

import logging

from fastapi import APIRouter, HTTPException, Depends, Query
from supabase import Client
from typing import List, Optional

from app.core.supabase import get_supabase, get_supabase_admin, get_authenticated_client
from app.core.auth import get_current_user, AuthContext
from app.models.progress import UserProgress, ProgressListResponse

router = APIRouter()
logger = logging.getLogger(__name__)


async def get_user_profile(user_id: str, supabase_admin: Client):
    """Get user profile from user_profiles table"""
    # Optimized: select only needed columns instead of *
    response = (
        supabase_admin.table("user_profiles")
        .select("user_id, display_name, modules_completed, change_talk_evoked, last_active_at")
        .eq("user_id", user_id)
        .execute()
    )
    if response.data:
        return response.data[0]
    return None


async def ensure_user_profile(
    current_user: AuthContext, supabase_admin: Client
) -> dict:
    """Ensure a user profile exists, auto-creating a minimal one if missing."""
    profile = await get_user_profile(current_user.user_id, supabase_admin)
    if profile:
        return profile

    try:
        created = (
            supabase_admin.table("user_profiles")
            .insert(
                {
                    "user_id": current_user.user_id,
                    "display_name": current_user.display_name,
                }
            )
            .execute()
        )
        if created.data:
            return created.data[0]
    except Exception:
        # Non-fatal: if profile trigger/constraints race, proceed with fallback.
        pass

    profile = await get_user_profile(current_user.user_id, supabase_admin)
    return profile or {"modules_completed": 0}


# =====================================================
# Endpoints
# =====================================================


@router.get("/", response_model=ProgressListResponse)
async def get_user_stats(
    current_user: AuthContext = Depends(get_current_user),
    supabase: Client = Depends(get_supabase),
):
    """
    Get user's overall statistics and all module progress.
    """
    supabase_admin = get_supabase_admin()

    # Get user profile
    profile = await ensure_user_profile(current_user, supabase_admin)

    # Get all progress using admin client to avoid RLS join issues
    # Then fetch module titles separately
    try:
        progress_response = (
            supabase_admin.table("user_progress")
            .select("id, module_id, status, completion_score, current_node_id, nodes_completed, techniques_demonstrated, started_at, completed_at")
            .eq("user_id", current_user.user_id)
            .order("started_at", desc=True)
            .execute()
        )
    except Exception as e:
        logger.error(f"[PROGRESS] Error fetching user progress: {e}")
        raise HTTPException(
            status_code=500, detail=f"Failed to fetch progress: {str(e)}"
        )

    # Get all module IDs we need to fetch
    module_ids = list(
        set([p.get("module_id") for p in progress_response.data if p.get("module_id")])
    )

    # Fetch module titles in batch
    module_titles = {}
    if module_ids:
        try:
            modules_response = (
                supabase_admin.table("learning_modules")
                .select("id, title")
                .in_("id", module_ids)
                .execute()
            )
            for mod in modules_response.data:
                module_titles[str(mod["id"])] = mod.get("title", "Unknown Module")
        except Exception as e:
            logger.warning(f"[PROGRESS] Could not fetch module titles: {e}")

    progress_list = []
    for p in progress_response.data:
        module_id = str(p.get("module_id", ""))
        module_title = module_titles.get(module_id, "Unknown Module")

        progress_list.append(
            UserProgress(
                id=str(p["id"]),
                module_id=module_id,
                module_title=module_title,
                status=p.get("status", "not_started"),
                completion_score=p.get("completion_score", 0),
                current_node_id=p.get("current_node_id"),
                nodes_completed=p.get("nodes_completed", []),
                techniques_demonstrated=p.get("techniques_demonstrated", {}),
                started_at=p.get("started_at"),
                completed_at=p.get("completed_at"),
            )
        )

    return ProgressListResponse(
        modules_completed=profile.get("modules_completed", 0), progress=progress_list
    )


@router.get("/modules/", response_model=ProgressListResponse)
async def get_all_module_progress(
    skip: int = Query(0, ge=0, description="Number of records to skip"),
    limit: int = Query(50, ge=1, le=100, description="Maximum records to return"),
    status: Optional[str] = Query(
        None, description="Filter by status (not_started, in_progress, completed)"
    ),
    current_user: AuthContext = Depends(get_current_user),
    supabase: Client = Depends(get_supabase),
):
    """
    Get all module progress for the current user.

    Query Parameters:
        skip: Number of records to skip (pagination)
        limit: Maximum records to return (1-100)
        status: Optional filter by status

    Returns: 200 OK with list of progress entries
    """
    supabase_admin = get_supabase_admin()

    # Get user profile
    profile = await ensure_user_profile(current_user, supabase_admin)

    # Build query with optional filtering using admin client to avoid RLS join issues
    try:
        query = (
            supabase_admin.table("user_progress")
            .select("id, module_id, status, completion_score, current_node_id, nodes_completed, techniques_demonstrated, started_at, completed_at")
            .eq("user_id", current_user.user_id)
        )

        if status:
            query = query.eq("status", status)

        progress_response = query.order("started_at", desc=True).execute()
    except Exception as e:
        logger.error(f"[PROGRESS] Error fetching module progress: {e}")
        raise HTTPException(
            status_code=500, detail=f"Failed to fetch progress: {str(e)}"
        )

    # Get total count
    total = len(progress_response.data) if progress_response.data else 0

    # Apply pagination
    paginated_data = (
        progress_response.data[skip : skip + limit] if progress_response.data else []
    )

    # Get all module IDs we need to fetch
    module_ids = list(
        set([p.get("module_id") for p in progress_response.data if p.get("module_id")])
    )

    # Fetch module titles in batch
    module_titles = {}
    if module_ids:
        try:
            modules_response = (
                supabase_admin.table("learning_modules")
                .select("id, title")
                .in_("id", module_ids)
                .execute()
            )
            for mod in modules_response.data:
                module_titles[str(mod["id"])] = mod.get("title", "Unknown Module")
        except Exception as e:
            logger.warning(f"[PROGRESS] Could not fetch module titles: {e}")

    progress_list = []
    for p in paginated_data:
        module_id = str(p.get("module_id", ""))
        module_title = module_titles.get(module_id, "Unknown Module")

        progress_list.append(
            UserProgress(
                id=str(p["id"]),
                module_id=module_id,
                module_title=module_title,
                status=p.get("status", "not_started"),
                completion_score=p.get("completion_score", 0),
                current_node_id=p.get("current_node_id"),
                nodes_completed=p.get("nodes_completed", []),
                techniques_demonstrated=p.get("techniques_demonstrated", {}),
                started_at=p.get("started_at"),
                completed_at=p.get("completed_at"),
            )
        )

    return ProgressListResponse(
        modules_completed=profile.get("modules_completed", 0), progress=progress_list
    )


@router.get("/{module_id}", response_model=UserProgress)
async def get_module_progress(
    module_id: str,
    current_user: AuthContext = Depends(get_current_user),
    supabase: Client = Depends(get_supabase),
):
    """
    Get progress for a specific module.
    """
    supabase_admin = get_supabase_admin()

    try:
        response = (
            supabase_admin.table("user_progress")
            .select("id, module_id, status, completion_score, current_node_id, nodes_completed, techniques_demonstrated, started_at, completed_at")
            .eq("user_id", current_user.user_id)
            .eq("module_id", module_id)
            .execute()
        )
    except Exception as e:
        logger.error(f"[PROGRESS] Error fetching module progress: {e}")
        raise HTTPException(
            status_code=500, detail=f"Failed to fetch progress: {str(e)}"
        )

    if not response.data:
        raise HTTPException(
            status_code=404, detail="Progress not found for this module"
        )

    p = response.data[0]

    # Fetch module title
    module_title = "Unknown Module"
    try:
        module_response = (
            supabase_admin.table("learning_modules")
            .select("title")
            .eq("id", module_id)
            .execute()
        )
        if module_response.data:
            module_title = module_response.data[0].get("title", "Unknown Module")
    except Exception as e:
        logger.warning(f"[PROGRESS] Could not fetch module title: {e}")

    return UserProgress(
        id=str(p["id"]),
        module_id=str(p["module_id"]),
        module_title=module_title,
        status=p.get("status", "not_started"),
        completion_score=p.get("completion_score", 0),
        current_node_id=p.get("current_node_id"),
        nodes_completed=p.get("nodes_completed", []),
        techniques_demonstrated=p.get("techniques_demonstrated", {}),
        started_at=p.get("started_at"),
        completed_at=p.get("completed_at"),
    )
