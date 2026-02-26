"""
Dialogue API endpoints

Handles dialogue node retrieval and choice submission.
"""
import logging

from fastapi import APIRouter, HTTPException, Depends, status
from supabase import Client
from typing import Optional

from app.core.supabase import get_supabase, get_supabase_admin, get_authenticated_client
from app.core.auth import get_current_user, AuthContext
from app.api.v1.modules import get_user_module_progress
from app.services.scoring_service import ScoringService
from app.models.modules import NodeResponse, ChoiceSubmit, ChoiceFeedback
from app.models.progress import UserProgress

router = APIRouter()
logger = logging.getLogger(__name__)


# =====================================================
# Helper Functions
# =====================================================

async def get_user_profile(user_id: str, supabase_admin: Client):
    """Get user profile from user_profiles table"""
    response = supabase_admin.table('user_profiles').select('*').eq('user_id', user_id).execute()
    if response.data:
        return response.data[0]
    return None


async def get_module_by_id(module_id: str, supabase: Client) -> dict:
    """Get module by ID"""
    response = supabase.table('learning_modules').select('*').eq('id', module_id).execute()
    if not response.data:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Module not found"
        )
    return response.data[0]


def find_dialogue_node(dialogue_content: dict, node_id: str) -> Optional[dict]:
    """Find a node in the dialogue tree"""
    nodes = dialogue_content.get('nodes', [])
    for node in nodes:
        if node.get('id') == node_id:
            return node
    return None


def get_node_number(dialogue_content: dict, node_id: str) -> int:
    """Get the sequential number of a node"""
    nodes = dialogue_content.get('nodes', [])
    for i, node in enumerate(nodes):
        if node.get('id') == node_id:
            return i + 1
    return 0


def is_correct_technique(choice: dict) -> bool:
    """Determine if a choice uses the correct MI technique.
    
    Parses the technique annotation from the JSON which uses patterns like:
    - "Simple Reflection (Effective)" - CORRECT technique
    - "Education/Warning (Non-MI)" - NOT MI-consistent
    - "Open Question (Premature)" - Questioning before reflection
    - "Confrontation (Non-MI)" - Not MI-consistent
    - "Reflection (Recovery)" - Recovering from a mistake (acceptable)
    """
    technique = choice.get('technique', '')
    
    # Extract the annotation in parentheses at the end
    # Pattern: "Technique Name (Annotation)"
    annotation_start = technique.rfind('(')
    annotation_end = technique.rfind(')')
    
    if annotation_start != -1 and annotation_end != -1 and annotation_end > annotation_start:
        annotation = technique[annotation_start + 1:annotation_end].lower().strip()
        
        # Effective techniques return True
        effective_annotations = ['effective', 'recovery']
        if annotation in effective_annotations:
            return True
        
        # Non-MI techniques return False
        non_mi_annotations = ['non-mi', 'non-m i']
        if annotation in non_mi_annotations:
            return False
        
        # Premature questioning is not ideal but not completely wrong
        if annotation == 'premature':
            return False
    
    # Fallback: if no clear annotation found, check for old keyword patterns
    technique_lower = technique.lower()
    non_mi_keywords = ['non-mi', 'righting reflex', 'educating', 'lecturing',
                       'defending', 'challenging', 'confrontation']



def determines_quality_label(choice: dict) -> str:
    """Determine quality label for a choice using three-tier system: Effective, Good, Ineffective.
    
    Logic (in order of priority):
    1. Technique annotation: (Effective) → Effective, (Ineffective)/(Non-MI) → Ineffective
    2. Technique has '+' → Effective (combining techniques)
    3. next_node_id contains 'poor' → Ineffective
    4. Feedback contains 'excellent', 'perfect', 'great' → Effective
    5. Feedback contains 'good' → Good
    6. Otherwise → Ineffective
    """
    technique = choice.get('technique', '')
    feedback = choice.get('feedback', '').lower()
    next_node_id = choice.get('next_node_id', '').lower()
    
    # Check technique annotation in parentheses
    annotation_start = technique.rfind('(')
    annotation_end = technique.rfind(')')
    if annotation_start != -1 and annotation_end != -1 and annotation_end > annotation_start:
        annotation = technique[annotation_start + 1:annotation_end].lower().strip()
        if annotation == 'effective':
            return 'Effective'
        if annotation in ['ineffective', 'non-mi', 'non-m i', 'premature']:
            return 'Ineffective'
    
    # Technique has '+' means combining multiple MI techniques (effective)
    if '+' in technique:
        return 'Effective'
    
    # Check next_node_id for quality hints
    if 'poor' in next_node_id or 'wrong' in next_node_id:
        return 'Ineffective'
    
    # Check feedback for quality indicators
    if any(word in feedback for word in ['excellent', 'perfect', 'great job', 'outstanding']):
        return 'Effective'
    
    if 'good' in feedback:
        return 'Good'
    
    # Default to ineffective if none of the above
    return 'Ineffective'

def evokes_change_talk(node: dict, choice: dict) -> bool:
    """Determine if a choice evokes change talk (simplified heuristic)"""
    feedback = choice.get('feedback', '').lower()
    return 'change talk' in feedback or 'evoked' in feedback


# =====================================================
# Endpoints
# =====================================================

@router.get("/module/{module_id}/node/{node_id}", response_model=NodeResponse)
async def get_dialogue_node(
    module_id: str,
    node_id: str,
    current_user: AuthContext = Depends(get_current_user),
    supabase: Client = Depends(get_supabase)
):
    """
    Get a dialogue node for a module.

    Returns the patient statement and available practitioner choices.
    If module not started, automatically starts it.
    """
    # Use authenticated client for user_progress reads so RLS can match current user
    auth_client = get_authenticated_client(current_user.raw_token)

    # Get module
    module = await get_module_by_id(module_id, supabase)

    # Check user progress - if not started, auto-start the module
    progress = await get_user_module_progress(current_user.user_id, module_id, auth_client)
    if not progress:
        logger.info(f"[DIALOGUE] Auto-starting module {module_id} for user {current_user.user_id}")

        # Get dialogue content to find start node
        dialogue_content = module.get('dialogue_content', {})
        start_node = dialogue_content.get('start_node', 'node_1')

        # Use admin client for RLS-protected insert
        supabase_admin = get_supabase_admin()
        try:
            insert_response = (
                supabase_admin.table("user_progress")
                .insert(
                    {
                        "user_id": current_user.user_id,
                        "module_id": module_id,
                        "status": "in_progress",
                        "current_node_id": start_node,
                    }
                )
                .execute()
            )
            if insert_response.data:
                progress = insert_response.data[0]
            else:
                raise HTTPException(
                    status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
                    detail="Failed to create module progress"
                )
        except HTTPException:
            raise
        except Exception as e:
            logger.error(f"[DIALOGUE] Auto-start failed: {e}")
            raise HTTPException(
                status_code=status.HTTP_400_BAD_REQUEST,
                detail="Module not started. Please start the module first."
            )

    # Find the node
    dialogue_content = module.get('dialogue_content', {})
    node = find_dialogue_node(dialogue_content, node_id)

    if not node:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail=f"Node {node_id} not found"
        )

    # Check if user can retry this node (has attempted before)
    nodes_completed = progress.get('nodes_completed', [])
    can_retry = node_id in nodes_completed

    total_nodes = len(dialogue_content.get('nodes', []))
    current_node_number = get_node_number(dialogue_content, node_id)

    return NodeResponse(
        node=node,
        module_id=module_id,
        progress_id=str(progress['id']),
        current_node_number=current_node_number,
        total_nodes=total_nodes,
        can_retry=can_retry
    )


@router.post("/submit", response_model=ChoiceFeedback)
async def submit_choice(
    choice_data: ChoiceSubmit,
    current_user: AuthContext = Depends(get_current_user),
    supabase: Client = Depends(get_supabase)
):
    """
    Submit a dialogue choice and get feedback.

    Processes the user's choice, awards points, and returns the next node.
    """
    supabase_admin = get_supabase_admin()

    # Use authenticated client for user_progress reads so RLS can match current user
    auth_client = get_authenticated_client(current_user.raw_token)

    # Get module and progress
    module = await get_module_by_id(choice_data.module_id, supabase)
    progress = await get_user_module_progress(current_user.user_id, choice_data.module_id, auth_client)

    # Auto-start if not started
    if not progress:
        logger.info(f"[DIALOGUE] Auto-starting module {choice_data.module_id} for user {current_user.user_id}")

        dialogue_content = module.get('dialogue_content', {})
        start_node = dialogue_content.get('start_node', 'node_1')

        try:
            insert_response = (
                supabase_admin.table("user_progress")
                .insert(
                    {
                        "user_id": current_user.user_id,
                        "module_id": choice_data.module_id,
                        "status": "in_progress",
                        "current_node_id": start_node,
                    }
                )
                .execute()
            )
            if insert_response.data:
                progress = insert_response.data[0]
            else:
                raise HTTPException(
                    status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
                    detail="Failed to create module progress"
                )
        except HTTPException:
            raise
        except Exception as e:
            logger.error(f"[DIALOGUE] Auto-start failed: {e}")
            raise HTTPException(
                status_code=status.HTTP_400_BAD_REQUEST,
                detail="Module not started. Please start the module first."
            )

    # Validate that submitted node matches user's current position
    if choice_data.node_id != progress.get("current_node_id"):
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Choice submission does not match your current node. Please refresh and try again.",
        )

    # Find the current node
    dialogue_content = module.get('dialogue_content', {})
    node = find_dialogue_node(dialogue_content, choice_data.node_id)

    if not node:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail=f"Node {choice_data.node_id} not found"
        )

    # Find the selected choice by ID (more reliable than text matching)
    choices = node.get('practitioner_choices', [])
    selected_choice = None

    for i, choice in enumerate(choices):
        choice_id = f"choice_{i}"
        if choice_id == choice_data.choice_id:
            selected_choice = choice
            break

    if not selected_choice:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Invalid choice"
        )

    # Determine if correct and if evokes change talk
    is_correct = is_correct_technique(selected_choice)
    evoked_ct = evokes_change_talk(node, selected_choice)

    # Determine if first attempt
    nodes_completed = progress.get('nodes_completed', [])
    is_first_attempt = choice_data.node_id not in nodes_completed

    # Calculate and accumulate points
    choice_points = ScoringService.calculate_choice_points(
        is_correct=is_correct,
        is_first_attempt=is_first_attempt,
        evoked_change_talk=evoked_ct,
    )
    total_points_earned = (progress.get('points_earned', 0) or 0) + choice_points

    # Determine quality label using three-tier system
    quality_label = determines_quality_label(selected_choice)
    
    # is_correct based on quality label (Effective/Good = correct, Ineffective = incorrect)
    is_correct = quality_label != 'Ineffective'

    # Record attempt using admin client to bypass RLS.
    # Do not fail the user flow if analytics table/schema is temporarily out of sync.
    try:
        supabase_admin.table('dialogue_attempts').insert({
            'user_id': current_user.user_id,
            'module_id': choice_data.module_id,
            'progress_id': progress['id'],
            'node_id': choice_data.node_id,
            'choice_id': choice_data.choice_id,
            'choice_text': choice_data.choice_text,
            'technique': choice_data.technique,
            'is_correct_technique': is_correct,
            'feedback_text': selected_choice.get('feedback', ''),
            'evoked_change_talk': evoked_ct,
        }).execute()
    except Exception as e:
        logger.warning(f"[DIALOGUE] Failed to record dialogue_attempts row (continuing): {e}")

    # Update progress
    new_nodes_completed = list(nodes_completed)
    if is_first_attempt and is_correct:
        new_nodes_completed.append(choice_data.node_id)

    next_node_id = selected_choice.get('next_node_id')

    # Check if module is complete (no next node or reached end)
    is_module_complete = (
        not next_node_id or
        next_node_id.startswith('node_end') or
        next_node_id == 'end'
    )

    completion_score = progress.get('completion_score', 0)

    if is_module_complete:
        total_nodes = len(dialogue_content.get('nodes', []))
        correct_attempts = len(new_nodes_completed)
        completion_score = ScoringService.calculate_completion_score(
            total_nodes=total_nodes,
            nodes_completed=len(new_nodes_completed),
            correct_choices=correct_attempts
        )

    # P1-10: Fixed double-counting. total_points_earned already includes current
    # choice points + previous points. Use it directly instead of adding again.
    points_earned = total_points_earned

    # Update progress record
    update_data = {
        'current_node_id': next_node_id if not is_module_complete else choice_data.node_id,
        'nodes_completed': new_nodes_completed,
    }

    if is_module_complete:
        update_data.update({
            'status': 'completed',
            'completion_score': completion_score,
            'completed_at': 'now()'
        })

    # Use admin client for update to bypass RLS
    supabase_admin.table('user_progress').update(update_data).eq('id', progress['id']).execute()

    # Update user profile
    profile = await get_user_profile(current_user.user_id, supabase_admin)
    if profile:
        modules_completed = profile.get('modules_completed', 0)
        change_talk_evoked = profile.get('change_talk_evoked', 0) + (1 if evoked_ct else 0)

        supabase_admin.table('user_profiles').update({
            'modules_completed': modules_completed + (1 if is_module_complete else 0),
            'change_talk_evoked': change_talk_evoked,
            'last_active_at': 'now()'
        }).eq('user_id', current_user.user_id).execute()

        return ChoiceFeedback(
            is_correct=is_correct,
            quality_label=quality_label,
            feedback_text=selected_choice.get('feedback', ''),
            evoked_change_talk=evoked_ct,
            next_node_id=next_node_id if not is_module_complete else None,
            is_module_complete=is_module_complete,
            completion_score=completion_score if is_module_complete else None,
        )

    # Fallback if no profile (shouldn't happen)
    return ChoiceFeedback(
        is_correct=is_correct,
        quality_label=quality_label,
        feedback_text=selected_choice.get('feedback', ''),
        evoked_change_talk=evoked_ct,
        next_node_id=next_node_id if not is_module_complete else None,
        is_module_complete=is_module_complete,
        completion_score=completion_score if is_module_complete else None,
    )
