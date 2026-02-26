"""Reliability regression tests for dialogue submit and progress resume flows."""

from unittest.mock import MagicMock, patch

from app.core.auth import AuthContext, get_current_user
from app.core.supabase import get_supabase
from app.main import app


def _auth_context() -> AuthContext:
    return AuthContext(
        user_id="test-user-id-123",
        email="test@example.com",
        display_name="Test User",
        is_authenticated=True,
        raw_token="test-token",
    )


class TestDialogueAndProgressReliability:
    def setup_method(self):
        app.dependency_overrides[get_current_user] = lambda: _auth_context()
        app.dependency_overrides[get_supabase] = lambda: MagicMock()

    def teardown_method(self):
        app.dependency_overrides.clear()

    @patch("app.api.v1.dialogue.get_module_by_id")
    @patch("app.api.v1.dialogue.get_user_module_progress")
    @patch("app.api.v1.dialogue.get_user_profile")
    @patch("app.api.v1.dialogue.get_supabase_admin")
    def test_submit_choice_does_not_fail_when_dialogue_attempts_insert_errors(
        self,
        mock_get_supabase_admin,
        mock_get_user_profile,
        mock_get_user_module_progress,
        mock_get_module_by_id,
        client,
    ):
        module_id = "test-module-id-123"
        mock_get_module_by_id.return_value = {
            "id": module_id,
            "dialogue_content": {
                "start_node": "node_1",
                "nodes": [
                    {
                        "id": "node_1",
                        "patient_statement": "I feel stuck.",
                        "patient_context": "Ambivalence",
                        "practitioner_choices": [
                            {
                                "text": "Tell me more about what feels stuck.",
                                "technique": "Open Question",
                                "next_node_id": "node_2",
                                "feedback": "Good open question.",
                            }
                        ],
                    }
                ],
            },
        }
        mock_get_user_module_progress.return_value = {
            "id": "progress-1",
            "user_id": "test-user-id-123",
            "module_id": module_id,
            "current_node_id": "node_1",
            "nodes_completed": [],
            "points_earned": 0,
            "completion_score": 0,
        }
        mock_get_user_profile.return_value = {
            "user_id": "test-user-id-123",
            "modules_completed": 0,
            "change_talk_evoked": 0,
        }

        admin_client = MagicMock()

        def table_side_effect(table_name: str):
            table_mock = MagicMock()
            if table_name == "dialogue_attempts":
                table_mock.insert.side_effect = Exception("schema mismatch")
                return table_mock

            table_mock.insert.return_value = table_mock
            table_mock.update.return_value = table_mock
            table_mock.eq.return_value = table_mock
            table_mock.execute.return_value = MagicMock(data=[{"ok": True}])
            return table_mock

        admin_client.table.side_effect = table_side_effect
        mock_get_supabase_admin.return_value = admin_client

        response = client.post(
            "/api/v1/dialogue/submit",
            json={
                "module_id": module_id,
                "node_id": "node_1",
                "choice_id": "choice_0",
                "choice_text": "Tell me more about what feels stuck.",
                "technique": "Open Question",
            },
        )

        assert response.status_code == 200
        data = response.json()
        assert data["next_node_id"] == "node_2"
        assert data["is_module_complete"] is False

    @patch("app.api.v1.progress.get_authenticated_client")
    def test_get_module_progress_returns_current_node_for_resume(
        self,
        mock_get_authenticated_client,
        client,
    ):
        module_id = "test-module-id-123"
        progress_row = {
            "id": "progress-1",
            "module_id": module_id,
            "status": "in_progress",
            "current_node_id": "node_2",
            "nodes_completed": ["node_1"],
            "completion_score": 0,
            "techniques_demonstrated": {},
            "started_at": "2026-01-01T00:00:00Z",
            "completed_at": None,
            "learning_modules": {"id": module_id, "title": "Test Module", "dialogue_content": {}},
        }

        auth_client = MagicMock()
        auth_client.table.return_value.select.return_value.eq.return_value.eq.return_value.execute.return_value = MagicMock(
            data=[progress_row]
        )
        mock_get_authenticated_client.return_value = auth_client

        response = client.get(f"/api/v1/progress/{module_id}")

        assert response.status_code == 200
        data = response.json()
        assert data["module_id"] == module_id
        assert data["current_node_id"] == "node_2"

