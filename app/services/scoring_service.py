"""Scoring service utilities used by dialogue progression."""


class ScoringService:
    """Service for calculating module completion quality."""

    @staticmethod
    def calculate_completion_score(
        total_nodes: int, nodes_completed: int, correct_choices: int
    ) -> int:
        """
        Calculate module completion score (0-100).

        Args:
            total_nodes: Total nodes in module
            nodes_completed: Number of nodes completed
            correct_choices: Number of correct technique choices

        Returns:
            int: Completion score (0-100)
        """
        if total_nodes == 0:
            return 0

        progress_score = (nodes_completed / total_nodes) * 50
        accuracy_score = (
            (correct_choices / nodes_completed) * 50 if nodes_completed > 0 else 0
        )
        return int(progress_score + accuracy_score)

