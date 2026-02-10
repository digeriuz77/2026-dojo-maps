-- supabase/seed/seed_shared-decisional-balance-009.sql
-- MAPS Practice Module: Decisional Balance - Exploring Pros and Cons
-- Content Type: shared
--
-- Usage:
--   supabase db execute --file supabase/seed/seed_shared-decisional-balance-009.sql
-- Or paste into Supabase SQL Editor

-- ============================================
-- INSERT MAPS PRACTICE MODULE
-- ============================================
INSERT INTO mi_practice_modules (
    id,
    code,
    title,
    content_type,
    mi_focus_area,
    difficulty_level,
    estimated_minutes,
    learning_objective,
    scenario_context,
    persona_config,
    dialogue_structure,
    target_competencies,
    maps_rubric,
    maps_framework_alignment,
    is_active
) VALUES (
    '00000000-0000-0001-0001-000000000009',
    'shared-decisional-balance-009',
    'Decisional Balance - Exploring Pros and Cons',
    'shared',
    'Decision Making',
    'intermediate',
    12,
    'Learn to explore both sides of ambivalence by examining reasons for change (pros) and reasons against change (cons) without taking sides',
    'Decisional balance explores the pros and cons of both changing and staying the same. This helps people see their ambivalence more clearly and weigh their options. Unlike pushing for change, decisional balance honors both sides of the dilemma. This applies universally to customer and colleague contexts.',
    '{"name": "Riley", "role": "person", "background": "Is seriously considering making a change but is genuinely torn. Can see many reasons to change and many reasons not to change. Feeling stuck in the middle.", "personality_traits": ["ambivalent", "analytical", "thoughtful", "torn"], "tone_spectrum": {"word_complexity": 0.5, "sentence_length": 0.5, "emotional_expressiveness": 0.5, "disclosure_level": 0.5, "response_latency": 0.5, "confidence_level": 0.4}, "starting_tone_position": 0.4, "triggers": ["taking_sides", "pushing_for_change", "minimizing_cons", "rushing"], "comfort_topics": ["balanced_exploration", "being_heard", "honesty", "respect_for_both_sides"]}'::jsonb,
    '{"start_node_id": "node_1", "nodes": {"node_1": {"id": "node_1", "persona_text": "I''m really going back and forth on this. On one hand, I can see all the benefits of making this change. But on the other hand, there are real reasons not to change. I''m stuck.", "persona_mood": "ambivalent_stuck", "themes": ["Ambivalence", "Decision_Making", "Conflict"], "choice_points": [{"id": "cp_node_1_0", "option_text": "The benefits clearly outweigh the drawbacks. You should focus on the positive and go for it.", "preview_hint": "This pushes for change", "rapport_impact": -1, "trust_impact": -1, "tone_shift": -0.15, "technique_tags": ["taking_sides"], "competency_links": [], "feedback": {"immediate": "You''ve taken sides and dismissed their concerns. Decisional balance requires genuinely exploring both sides.", "learning_note": "Decisional balance honors both pros and cons equally."}, "next_node_id": "node_2a", "exploration_depth": "surface"}, {"id": "cp_node_1_1", "option_text": "You''re feeling torn because you can see both the benefits of changing and the reasons not to change.", "preview_hint": "This reflects the ambivalence", "rapport_impact": 1, "trust_impact": 1, "tone_shift": 0.15, "technique_tags": ["double_sided_reflection"], "competency_links": ["A6", "B6"], "feedback": {"immediate": "Excellent double-sided reflection! You''ve captured both sides without favoring either one.", "learning_note": "Double-sided reflections honor both sides of ambivalence."}, "next_node_id": "node_2b", "exploration_depth": "deep"}, {"id": "cp_node_1_2", "option_text": "What are some of the benefits you''re seeing?", "preview_hint": "This explores pros first", "rapport_impact": 0, "trust_impact": 0, "tone_shift": 0.0, "technique_tags": ["pro_exploration"], "competency_links": [], "feedback": {"immediate": "Good question that starts exploring benefits. After exploring pros, you''ll want to explore cons for true balance.", "learning_note": "Decisional balance explores both pros and cons systematically."}, "next_node_id": "node_2c", "exploration_depth": "deep"}], "is_endpoint": false, "endpoint_type": null}, "node_2b": {"id": "node_2b", "persona_text": "Exactly! So the benefits are clear - I''d be healthier, I''d feel better, I''d save money. But the reasons not to change are also real - it''s hard, I''d have to give up something I enjoy, and I''m not sure I can sustain it.", "persona_mood": "articulate_clear", "themes": ["Clarity", "Pros", "Cons"], "choice_points": [{"id": "cp_node_2b_0", "option_text": "So on the pro side, you see health benefits, feeling better, and saving money. On the con side, you''re concerned about difficulty, giving up something you enjoy, and sustainability.", "preview_hint": "This summarizes both sides", "rapport_impact": 1, "trust_impact": 1, "tone_shift": 0.15, "technique_tags": ["decisional_balance_summary"], "competency_links": ["A6", "B6"], "feedback": {"immediate": "Excellent decisional balance summary! You''ve captured both pros and cons equally.", "learning_note": "Decisional balance summaries give equal weight to both sides."}, "next_node_id": "node_3a", "exploration_depth": "deep"}, {"id": "cp_node_2b_1", "option_text": "Those are good concerns, but the benefits are much more important.", "preview_hint": "This minimizes the cons", "rapport_impact": -1, "trust_impact": -1, "tone_shift": -0.15, "technique_tags": ["minimizing_cons"], "competency_links": [], "feedback": {"immediate": "You''ve minimized their concerns rather than honoring them. Decisional balance requires genuine respect for both sides.", "learning_note": "When we minimize cons, people stop trusting the collaborative process."}, "next_node_id": "node_3b", "exploration_depth": "surface"}], "is_endpoint": false, "endpoint_type": null}, "node_2c": {"id": "node_2c", "persona_text": "I''d be healthier, I''d feel better, and honestly, I''d be proud of myself for doing it.", "persona_mood": "motivated_focused", "themes": ["Health", "Pride", "Benefits"], "choice_points": [{"id": "cp_node_2c_0", "option_text": "Those are important benefits. What are some of the reasons not to change?", "preview_hint": "This balances with cons", "rapport_impact": 1, "trust_impact": 1, "tone_shift": 0.1, "technique_tags": ["balanced_exploration"], "competency_links": ["A6"], "feedback": {"immediate": "Perfect! After hearing pros, you''ve invited them to share cons. This creates true decisional balance.", "learning_note": "Decisional balance requires exploring both pros and cons."}, "next_node_id": "node_3c", "exploration_depth": "deep"}], "is_endpoint": false, "endpoint_type": null}, "node_3a": {"id": "node_3a", "persona_text": "That''s exactly it. And hearing both sides laid out like that helps me see the situation more clearly. I still don''t know what to do, but I understand my thinking better.", "persona_mood": "clarity_insight", "themes": ["Clarity", "Insight", "Understanding"], "choice_points": [{"id": "cp_node_3a_0", "option_text": "So seeing both sides laid out gives you more clarity about your thinking, even though you''re still undecided.", "preview_hint": "This reflects the benefit of the process", "rapport_impact": 1, "trust_impact": 1, "tone_shift": 0.15, "technique_tags": ["reflection_of_process"], "competency_links": ["A6"], "feedback": {"immediate": "Excellent reflection! You''ve captured the value of the process itself - gaining clarity even without deciding.", "learning_note": "Decisional balance brings clarity even when decisions aren''t made."}, "next_node_id": "node_end_excellent", "exploration_depth": "deep"}], "is_endpoint": false, "endpoint_type": null}, "node_3c": {"id": "node_3c", "persona_text": "Well, it would be really hard, and I''d be giving up something I enjoy. Plus, I''ve tried before and failed, so I''m worried I can''t sustain it.", "persona_mood": "honest_vulnerable", "themes": ["Difficulty", "Loss", "Fear_of_Failure"], "choice_points": [{"id": "cp_node_3c_0", "option_text": "So you''re concerned about the difficulty, losing something you enjoy, and your ability to sustain it given past attempts.", "preview_hint": "This honors their concerns", "rapport_impact": 1, "trust_impact": 1, "tone_shift": 0.15, "technique_tags": ["summary_of_cons"], "competency_links": ["A6"], "feedback": {"immediate": "Excellent summary! You''ve captured their concerns with respect and validation.", "learning_note": "Decisional balance honors concerns as genuine and important."}, "next_node_id": "node_end_good", "exploration_depth": "deep"}], "is_endpoint": false, "endpoint_type": null}, "node_2a": {"id": "node_2a", "persona_text": "I suppose you''re right. I''ll focus on the positive.", "persona_mood": "compliant_convinced", "themes": ["Compliance", "Uncertainty"], "choice_points": [], "is_endpoint": true, "endpoint_type": "neutral_end"}, "node_3b": {"id": "node_3b", "persona_text": "But those concerns are real to me. I don''t feel like you''re really hearing that.", "persona_mood": "dismissed_frustrated", "themes": ["Dismissed", "Frustration"], "choice_points": [], "is_endpoint": true, "endpoint_type": "poor_engagement"}, "node_end_excellent": {"id": "node_end_excellent", "persona_text": "This has been really helpful. I feel like I understand my situation better, even though I''m still figuring out what to do.", "persona_mood": "clarity_grateful", "themes": ["Clarity", "Gratitude", "Process"], "choice_points": [], "is_endpoint": true, "endpoint_type": "excellent_engagement"}, "node_end_good": {"id": "node_end_good", "persona_text": "Thanks for letting me share both sides. It helps to talk about it.", "persona_mood": "appreciative_heard", "themes": ["Appreciation", "Being_Heard"], "choice_points": [], "is_endpoint": true, "endpoint_type": "good_engagement"}}}'::jsonb,
    ARRAY'[\"A6\", \"B6\", \"2.1.1\"]',
    '{"dimensions": {"A6": {"description": "Rapport Building", "weight": 2.0, "positive_signals": ["double_sided_reflection", "honoring_both_sides", "balanced_exploration"], "negative_signals": ["taking_sides", "minimizing_concerns", "pushing_agenda"]}, "B6": {"description": "Professional Alliance", "weight": 1.5, "positive_signals": ["neutral", "balanced", "exploring_both_sides"], "negative_signals": ["biased", "one_sided", "directive"]}, "2.1.1": {"description": "Complex Reflective Listening", "weight": 1.5, "positive_signals": ["pros_and_cons", "ambivalence_honored", "synthesis"], "negative_signals": ["selective_reflection", "pushing_change", "ignoring_concerns"]}}, "overall_scoring_logic": "weighted_average"}'::jsonb,
    '{"framework_name": "MaPS Money Guidance Competency Framework", "framework_version": "September 2022", "sections": ["A6", "B6"], "tier_relevance": "All Tiers", "domains": ["Universal Skill"]}'::jsonb,
    true
) ON CONFLICT (code) DO UPDATE SET
    title = EXCLUDED.title,
    content_type = EXCLUDED.content_type,
    mi_focus_area = EXCLUDED.mi_focus_area,
    difficulty_level = EXCLUDED.difficulty_level,
    estimated_minutes = EXCLUDED.estimated_minutes,
    learning_objective = EXCLUDED.learning_objective,
    scenario_context = EXCLUDED.scenario_context,
    persona_config = EXCLUDED.persona_config,
    dialogue_structure = EXCLUDED.dialogue_structure,
    target_competencies = EXCLUDED.target_competencies,
    maps_rubric = EXCLUDED.maps_rubric,
    maps_framework_alignment = EXCLUDED.maps_framework_alignment,
    is_active = EXCLUDED.is_active,
    updated_at = NOW();

-- ============================================
-- VERIFICATION QUERY
-- ============================================
-- Uncomment to verify insertion:
-- SELECT code, title, content_type, mi_focus_area, difficulty_level, estimated_minutes, is_active
-- FROM mi_practice_modules
-- WHERE code = 'shared-decisional-balance-009';
