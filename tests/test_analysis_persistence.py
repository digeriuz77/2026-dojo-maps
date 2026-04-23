"""
Tests for analysis persistence service and profile update functionality
"""
from unittest.mock import MagicMock, patch

import pytest

from app.models.chat import ConversationAnalysis, MITechniqueUsed
from app.services.analysis_persistence_service import (
    save_conversation_analysis,
    get_analysis_by_id,
    get_user_analyses,
    get_all_analyses,
)


def _make_sample_analysis():
    """Create a sample ConversationAnalysis for testing"""
    return ConversationAnalysis(
        overall_score=4.0,
        foundational_trust_safety=4.0,
        empathic_partnership_autonomy=4.0,
        empowerment_clarity=4.0,
        mi_spirit_score=4.0,
        partnership_demonstrated=True,
        acceptance_demonstrated=True,
        compassion_demonstrated=True,
        evocation_demonstrated=True,
        techniques_used=[
            MITechniqueUsed(
                technique="open_question",
                turn_number=1,
                example="What brings you here today?",
                effectiveness="effective",
            )
        ],
        techniques_count={"open_question": 1},
        strengths=["Good rapport"],
        areas_for_improvement=["More reflections"],
        client_movement="toward_change",
        change_talk_evoked=True,
        transcript_summary="Test summary",
        summary="Test coaching summary",
        key_moments=[],
        suggestions_for_next_time=["Practice reflections"],
    )


def test_save_conversation_analysis_success(mock_supabase_client):
    """Test successful save of conversation analysis"""
    mock_supabase_client.table.return_value.insert.return_value.execute.return_value = MagicMock(
        data=[{"id": "test-analysis-id-123"}]
    )

    with patch(
        "app.services.analysis_persistence_service.get_supabase_admin",
        return_value=mock_supabase_client,
    ):
        analysis = _make_sample_analysis()
        result = save_conversation_analysis(
            session_id="session-123",
            analysis=analysis,
            transcript=[{"role": "user", "content": "Hello"}],
            persona_id="persona-1",
            persona_name="Test Client",
            user_id="user-123",
            total_turns=5,
        )

    assert result == "test-analysis-id-123"
    mock_supabase_client.table.assert_called_once_with("conversation_analyses")
    mock_supabase_client.table.return_value.insert.assert_called_once()


def test_save_conversation_analysis_no_data_returned(mock_supabase_client):
    """Test save when database returns no data"""
    mock_supabase_client.table.return_value.insert.return_value.execute.return_value = MagicMock(
        data=[]
    )

    with patch(
        "app.services.analysis_persistence_service.get_supabase_admin",
        return_value=mock_supabase_client,
    ):
        analysis = _make_sample_analysis()
        result = save_conversation_analysis(
            session_id="session-123",
            analysis=analysis,
            transcript=[{"role": "user", "content": "Hello"}],
        )

    assert result is None


def test_save_conversation_analysis_database_error(mock_supabase_client):
    """Test save when database throws an exception"""
    mock_supabase_client.table.return_value.insert.return_value.execute.side_effect = Exception(
        "Connection refused"
    )

    with patch(
        "app.services.analysis_persistence_service.get_supabase_admin",
        return_value=mock_supabase_client,
    ):
        analysis = _make_sample_analysis()
        result = save_conversation_analysis(
            session_id="session-123",
            analysis=analysis,
            transcript=[{"role": "user", "content": "Hello"}],
        )

    assert result is None


def test_get_analysis_by_id_success(mock_supabase_client):
    """Test retrieving analysis by ID"""
    expected_data = {"id": "analysis-123", "overall_score": 4.0}
    mock_supabase_client.table.return_value.select.return_value.eq.return_value.execute.return_value = MagicMock(
        data=[expected_data]
    )

    with patch(
        "app.services.analysis_persistence_service.get_supabase",
        return_value=mock_supabase_client,
    ):
        result = get_analysis_by_id("analysis-123")

    assert result == expected_data


def test_get_analysis_by_id_with_user_filter(mock_supabase_client):
    """Test retrieving analysis with user ID filter"""
    expected_data = {"id": "analysis-123", "overall_score": 4.0, "user_id": "user-123"}
    mock_supabase_client.table.return_value.select.return_value.eq.return_value.eq.return_value.execute.return_value = MagicMock(
        data=[expected_data]
    )

    with patch(
        "app.services.analysis_persistence_service.get_supabase",
        return_value=mock_supabase_client,
    ):
        result = get_analysis_by_id("analysis-123", user_id="user-123")

    assert result == expected_data


def test_get_analysis_by_id_not_found(mock_supabase_client):
    """Test retrieving non-existent analysis"""
    mock_supabase_client.table.return_value.select.return_value.eq.return_value.execute.return_value = MagicMock(
        data=[]
    )

    with patch(
        "app.services.analysis_persistence_service.get_supabase",
        return_value=mock_supabase_client,
    ):
        result = get_analysis_by_id("nonexistent-id")

    assert result is None


def test_get_user_analyses(mock_supabase_client):
    """Test retrieving all analyses for a user"""
    expected_data = [
        {"id": "analysis-1", "user_id": "user-123"},
        {"id": "analysis-2", "user_id": "user-123"},
    ]
    mock_supabase_client.table.return_value.select.return_value.eq.return_value.order.return_value.limit.return_value.execute.return_value = MagicMock(
        data=expected_data
    )

    with patch(
        "app.services.analysis_persistence_service.get_supabase",
        return_value=mock_supabase_client,
    ):
        result = get_user_analyses("user-123", limit=10)

    assert len(result) == 2
    assert result[0]["id"] == "analysis-1"


def test_get_all_analyses(mock_supabase_client):
    """Test retrieving all analyses (admin)"""
    expected_data = [
        {"id": "analysis-1"},
        {"id": "analysis-2"},
    ]
    mock_supabase_client.table.return_value.select.return_value.order.return_value.limit.return_value.offset.return_value.execute.return_value = MagicMock(
        data=expected_data
    )

    with patch(
        "app.services.analysis_persistence_service.get_supabase",
        return_value=mock_supabase_client,
    ):
        result = get_all_analyses(limit=2, offset=0)

    assert len(result) == 2


def test_get_user_analyses_error_returns_empty_list(mock_supabase_client):
    """Test that user analyses returns empty list on error"""
    mock_supabase_client.table.return_value.select.return_value.eq.return_value.order.return_value.limit.return_value.execute.side_effect = Exception(
        "Database error"
    )

    with patch(
        "app.services.analysis_persistence_service.get_supabase",
        return_value=mock_supabase_client,
    ):
        result = get_user_analyses("user-123")

    assert result == []


def test_get_all_analyses_error_returns_empty_list(mock_supabase_client):
    """Test that all analyses returns empty list on error"""
    mock_supabase_client.table.return_value.select.return_value.order.return_value.limit.return_value.offset.return_value.execute.side_effect = Exception(
        "Database error"
    )

    with patch(
        "app.services.analysis_persistence_service.get_supabase",
        return_value=mock_supabase_client,
    ):
        result = get_all_analyses()

    assert result == []


@pytest.mark.asyncio
async def test_update_user_profile_from_analysis_success():
    """Test successful profile update from analysis"""
    from app.api.v1.chat_practice import _update_user_profile_from_analysis
    from app.core.auth import AuthContext

    mock_profile = {
        "change_talk_evoked": 2,
        "reflections_offered": 5,
    }

    mock_supabase = MagicMock()
    mock_supabase.table.return_value.select.return_value.eq.return_value.maybe_single.return_value.execute.return_value = MagicMock(
        data=mock_profile
    )
    mock_supabase.table.return_value.update.return_value.eq.return_value.execute.return_value = MagicMock(
        data=[{"id": "profile-123"}]
    )

    auth = AuthContext(user_id="user-123", email="test@example.com")
    analysis = _make_sample_analysis()

    with patch(
        "app.api.v1.chat_practice.get_supabase_admin", return_value=mock_supabase
    ):
        await _update_user_profile_from_analysis(auth, analysis)

    mock_supabase.table.return_value.update.assert_called_once()
    update_call = mock_supabase.table.return_value.update.call_args[0][0]
    assert update_call["change_talk_evoked"] == 3  # 2 + 1
    assert update_call["reflections_offered"] == 5  # 5 + 0


@pytest.mark.asyncio
async def test_update_user_profile_from_analysis_no_auth():
    """Test profile update with no auth context"""
    from app.api.v1.chat_practice import _update_user_profile_from_analysis

    analysis = _make_sample_analysis()
    result = await _update_user_profile_from_analysis(None, analysis)
    assert result is None


@pytest.mark.asyncio
async def test_update_user_profile_from_analysis_no_user_id():
    """Test profile update with auth but no user_id"""
    from app.api.v1.chat_practice import _update_user_profile_from_analysis
    from app.core.auth import AuthContext

    auth = AuthContext(user_id="", email="test@example.com")
    analysis = _make_sample_analysis()
    result = await _update_user_profile_from_analysis(auth, analysis)
    assert result is None


@pytest.mark.asyncio
async def test_update_user_profile_from_analysis_no_profile_found():
    """Test profile update when user profile doesn't exist"""
    from app.api.v1.chat_practice import _update_user_profile_from_analysis
    from app.core.auth import AuthContext

    mock_supabase = MagicMock()
    mock_supabase.table.return_value.select.return_value.eq.return_value.maybe_single.return_value.execute.return_value = MagicMock(
        data=None
    )

    auth = AuthContext(user_id="user-123", email="test@example.com")
    analysis = _make_sample_analysis()

    with patch(
        "app.api.v1.chat_practice.get_supabase_admin", return_value=mock_supabase
    ):
        result = await _update_user_profile_from_analysis(auth, analysis)

    assert result is None
    mock_supabase.table.return_value.update.assert_not_called()


@pytest.mark.asyncio
async def test_update_user_profile_from_analysis_database_error():
    """Test profile update when database throws error"""
    from app.api.v1.chat_practice import _update_user_profile_from_analysis
    from app.core.auth import AuthContext

    mock_supabase = MagicMock()
    mock_supabase.table.return_value.select.return_value.eq.return_value.maybe_single.return_value.execute.side_effect = Exception(
        "Database connection failed"
    )

    auth = AuthContext(user_id="user-123", email="test@example.com")
    analysis = _make_sample_analysis()

    with patch(
        "app.api.v1.chat_practice.get_supabase_admin", return_value=mock_supabase
    ):
        result = await _update_user_profile_from_analysis(auth, analysis)

    assert result is None
