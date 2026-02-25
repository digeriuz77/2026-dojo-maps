"""
Scoring Service for calculating points and levels

Implements the MI Learning Platform gamification logic:
- Correct technique: 100 points
- First attempt bonus: +50 points
- Change talk evoked: +50 points
- Module completion: +200 points
"""

from typing import TypedDict


class PractitionerChoice(TypedDict, total=False):
    """Dialogue choice data needed for scoring calculations."""

    is_correct: bool
    evokes_change_talk: bool
    next_node_id: str


class DialogueNode(TypedDict, total=False):
    """Dialogue node data needed for path traversal."""

    id: str
    is_ending: bool
    practitioner_choices: list[PractitionerChoice]


class DialogueContent(TypedDict, total=False):
    """Top-level module dialogue payload."""

    start_node: str
    nodes: list[DialogueNode]


class ScoringService:
    """Service for calculating points and levels"""

    # Point values
    CORRECT_TECHNIQUE_POINTS: int = 100
    FIRST_ATTEMPT_BONUS: int = 50
    CHANGE_TALK_BONUS: int = 50
    MODULE_COMPLETION_BONUS: int = 200

    # Level thresholds
    LEVEL_THRESHOLDS: list[int] = [
        0,  # Level 1
        500,  # Level 2
        1500,  # Level 3
        3000,  # Level 4
        5000,  # Level 5
        8000,  # Level 6
        12000,  # Level 7
        17000,  # Level 8
        23000,  # Level 9
        30000,  # Level 10
    ]

    @staticmethod
    def calculate_choice_points(
        is_correct: bool, is_first_attempt: bool, evoked_change_talk: bool
    ) -> int:
        """
        Calculate points earned for a dialogue choice.

        Args:
            is_correct: Whether the technique was correct
            is_first_attempt: Whether this is the first attempt at this node
            evoked_change_talk: Whether the choice evoked change talk

        Returns:
            int: Points earned
        """
        points = 0
        if is_correct:
            points += ScoringService.CORRECT_TECHNIQUE_POINTS
            if is_first_attempt:
                points += ScoringService.FIRST_ATTEMPT_BONUS
            if evoked_change_talk:
                points += ScoringService.CHANGE_TALK_BONUS
        return points

    @staticmethod
    def calculate_level(total_points: int) -> int:
        """
        Calculate user level based on total points.

        Args:
            total_points: User's total points

        Returns:
            int: User's level (1-10)
        """
        level = 1
        for i, threshold in enumerate(ScoringService.LEVEL_THRESHOLDS):
            if i == 0:
                continue  # Skip first threshold (0 points = level 1)
            if total_points >= threshold:
                level = i + 1
            else:
                break
        return min(level, 10)  # Cap at level 10

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

    @staticmethod
    def get_next_level_threshold(current_level: int) -> int:
        """
        Get the points needed for the next level.

        Args:
            current_level: Current user level

        Returns:
            int: Points needed for next level, or 0 if at max level
        """
        if current_level - 1 < len(ScoringService.LEVEL_THRESHOLDS):
            return ScoringService.LEVEL_THRESHOLDS[current_level - 1]
        return 0

    @staticmethod
    def calculate_max_points_available(dialogue_content: DialogueContent) -> int:
        """Calculate the maximum achievable points for a module dialogue tree.

        Traverses the dialogue graph from the start node, recursively evaluating
        each branch and selecting the path with the highest total score. Cycles
        and missing nodes are handled safely by terminating that branch.

        Args:
            dialogue_content: Module dialogue JSON containing start node and nodes.

        Returns:
            int: Maximum points a user can achieve by following the optimal path.
        """
        raw_nodes = dialogue_content.get("nodes")
        if not isinstance(raw_nodes, list) or not raw_nodes:
            return 0

        node_map: dict[str, DialogueNode] = {}
        for node in raw_nodes:
            node_id = node.get("id")
            if isinstance(node_id, str) and node_id:
                node_map[node_id] = node

        if not node_map:
            return 0

        start_node_id = dialogue_content.get("start_node", "node_1")
        def get_max_points_for_path(node_id: str, visited: set[str]) -> int:
            if node_id in visited:
                return 0

            node = node_map.get(node_id)
            if node is None or node.get("is_ending", False):
                return 0

            choices = node.get("practitioner_choices", [])
            best_path_points = 0
            for choice in choices:
                is_correct = bool(choice.get("is_correct", False))
                evokes_change_talk = bool(choice.get("evokes_change_talk", False))
                choice_points = ScoringService.calculate_choice_points(
                    is_correct=is_correct,
                    is_first_attempt=True,
                    evoked_change_talk=evokes_change_talk,
                )

                next_node_id = choice.get("next_node_id", "")
                next_points = get_max_points_for_path(next_node_id, visited | {node_id})
                best_path_points = max(best_path_points, choice_points + next_points)

            return best_path_points

        return get_max_points_for_path(start_node_id, set())
