"""
Tests for the Scoring Service
"""
from app.services.scoring_service import ScoringService


class TestScoringService:
    """Test suite for ScoringService"""

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