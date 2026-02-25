"""
Tests for the Scoring Service
"""
import pytest
from app.services.scoring_service import DialogueContent, ScoringService


class TestScoringService:
    """Test suite for ScoringService"""

    def test_calculate_choice_points_correct_first_attempt_with_change_talk(self):
        """Test points calculation for correct answer on first attempt with change talk"""
        points = ScoringService.calculate_choice_points(
            is_correct=True,
            is_first_attempt=True,
            evoked_change_talk=True
        )
        expected = (ScoringService.CORRECT_TECHNIQUE_POINTS +
                   ScoringService.FIRST_ATTEMPT_BONUS +
                   ScoringService.CHANGE_TALK_BONUS)
        assert points == expected

    def test_calculate_choice_points_correct_first_attempt_no_change_talk(self):
        """Test points calculation for correct answer on first attempt without change talk"""
        points = ScoringService.calculate_choice_points(
            is_correct=True,
            is_first_attempt=True,
            evoked_change_talk=False
        )
        expected = (ScoringService.CORRECT_TECHNIQUE_POINTS +
                   ScoringService.FIRST_ATTEMPT_BONUS)
        assert points == expected

    EMPTY_DIALOGUE_CASES: list[tuple[DialogueContent, int]] = [
        ({}, 0),
        ({"start_node": "node_1", "nodes": []}, 0),
        ({"nodes": [{"id": "node_1", "is_ending": True, "practitioner_choices": []}]}, 0),
    ]

    def test_calculate_choice_points_correct_retry(self):
        """Test points calculation for correct answer on retry (not first attempt)"""
        points = ScoringService.calculate_choice_points(
            is_correct=True,
            is_first_attempt=False,
            evoked_change_talk=False
        )
        assert points == ScoringService.CORRECT_TECHNIQUE_POINTS

    def test_calculate_choice_points_incorrect(self):
        """Test points calculation for incorrect answer"""
        points = ScoringService.calculate_choice_points(
            is_correct=False,
            is_first_attempt=True,
            evoked_change_talk=True
        )
        assert points == 0

    def test_calculate_level_thresholds(self):
        """Test level calculation at various thresholds"""
        # Level 1: 0-499 points
        assert ScoringService.calculate_level(0) == 1
        assert ScoringService.calculate_level(499) == 1

        # Level 2: 500-1499 points
        assert ScoringService.calculate_level(500) == 2
        assert ScoringService.calculate_level(1499) == 2

        # Level 3: 1500-2999 points
        assert ScoringService.calculate_level(1500) == 3
        assert ScoringService.calculate_level(2999) == 3

        # Level 10: 30000+ points
        assert ScoringService.calculate_level(30000) == 10
        assert ScoringService.calculate_level(50000) == 10

    def test_calculate_completion_score_perfect(self):
        """Test completion score calculation for perfect completion"""
        score = ScoringService.calculate_completion_score(
            total_nodes=10,
            nodes_completed=10,
            correct_choices=10
        )
        assert score == 100

    def test_calculate_completion_score_partial(self):
        """Test completion score calculation for partial completion"""
        # 50% progress, 80% accuracy on completed nodes
        # progress_score = (5/10) * 50 = 25
        # accuracy_score = (4/5) * 50 = 40
        # total = 65
        score = ScoringService.calculate_completion_score(
            total_nodes=10,
            nodes_completed=5,
            correct_choices=4
        )
        assert score == 65

    def test_calculate_completion_score_zero_nodes(self):
        """Test completion score calculation with zero nodes"""
        score = ScoringService.calculate_completion_score(
            total_nodes=0,
            nodes_completed=0,
            correct_choices=0
        )
        assert score == 0

    def test_calculate_completion_score_zero_completed(self):
        """Test completion score calculation with zero completed nodes"""
        score = ScoringService.calculate_completion_score(
            total_nodes=10,
            nodes_completed=0,
            correct_choices=0
        )
        assert score == 0


    def test_calculate_max_points_available_finds_optimal_path(self):
        """Test max points uses highest-scoring path through branching nodes."""
        dialogue_content: DialogueContent = {
            "start_node": "node_1",
            "nodes": [
                {
                    "id": "node_1",
                    "is_ending": False,
                    "practitioner_choices": [
                        {
                            "is_correct": True,
                            "evokes_change_talk": True,
                            "next_node_id": "node_2",
                        },
                        {
                            "is_correct": True,
                            "evokes_change_talk": False,
                            "next_node_id": "node_3",
                        },
                    ],
                },
                {
                    "id": "node_2",
                    "is_ending": False,
                    "practitioner_choices": [
                        {
                            "is_correct": True,
                            "evokes_change_talk": True,
                            "next_node_id": "node_end",
                        }
                    ],
                },
                {
                    "id": "node_3",
                    "is_ending": False,
                    "practitioner_choices": [
                        {
                            "is_correct": False,
                            "evokes_change_talk": False,
                            "next_node_id": "node_end",
                        }
                    ],
                },
                {
                    "id": "node_end",
                    "is_ending": True,
                    "practitioner_choices": [],
                },
            ],
        }

        max_points = ScoringService.calculate_max_points_available(dialogue_content)

        # Best path: node_1(choice to node_2)=200 + node_2(choice to end)=200
        assert max_points == 400

    def test_calculate_max_points_available_handles_missing_nodes(self):
        """Test missing next-node references are handled safely."""
        dialogue_content: DialogueContent = {
            "start_node": "node_1",
            "nodes": [
                {
                    "id": "node_1",
                    "is_ending": False,
                    "practitioner_choices": [
                        {
                            "is_correct": True,
                            "evokes_change_talk": True,
                            "next_node_id": "does_not_exist",
                        }
                    ],
                }
            ],
        }
        max_points = ScoringService.calculate_max_points_available(dialogue_content)

        assert max_points == 200

    def test_calculate_max_points_available_handles_cycles(self):
        """Test cycles do not recurse infinitely and still compute max safely."""
        dialogue_content: DialogueContent = {
            "start_node": "node_1",
            "nodes": [
                {
                    "id": "node_1",
                    "is_ending": False,
                    "practitioner_choices": [
                        {
                            "is_correct": True,
                            "evokes_change_talk": False,
                            "next_node_id": "node_2",
                        }
                    ],
                },
                {
                    "id": "node_2",
                    "is_ending": False,
                    "practitioner_choices": [
                        {
                            "is_correct": True,
                            "evokes_change_talk": True,
                            "next_node_id": "node_1",
                        },
                        {
                            "is_correct": False,
                            "evokes_change_talk": False,
                            "next_node_id": "node_end",
                        },
                    ],
                },
                {
                    "id": "node_end",
                    "is_ending": True,
                    "practitioner_choices": [],
                },
            ],
        }
        max_points = ScoringService.calculate_max_points_available(dialogue_content)

        # node_1->node_2 gives 150, then best non-cycling choice from node_2 is 200 (cycle cut off)
        assert max_points == 350

    @pytest.mark.parametrize(
        ("dialogue_content", "expected"),
        EMPTY_DIALOGUE_CASES,
    )
    def test_calculate_max_points_available_empty_inputs(
        self, dialogue_content: DialogueContent, expected: int
    ):
        """Test empty/invalid dialogue content returns zero."""
        assert ScoringService.calculate_max_points_available(dialogue_content) == expected