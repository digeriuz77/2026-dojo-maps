-- supabase/seed/seed_shared-confidence-scaling-008.sql
-- MAPS Practice Module: Confidence Scaling - Assessment Practice
-- Content Type: shared
--
-- Usage:
--   supabase db execute --file supabase/seed/seed_shared-confidence-scaling-008.sql
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
    '00000000-0000-0001-0001-000000000008',
    'shared-confidence-scaling-008',
    'Confidence Scaling - Assessment Practice',
    'shared',
    'Assessment & Readiness',
    'beginner',
    10,
    'Learn to use confidence scaling to assess readiness and explore what would increase or decrease confidence about making changes',
    'Scaling questions use a numeric scale (typically 0-10) to assess confidence, importance, or readiness. They provide a concrete way to measure subjective experiences and explore what would move someone up or down the scale. This core skill applies universally to customer and colleague contexts.',
    '{"name": "Riley", "role": "person", "background": "Is considering making changes but feels uncertain about their ability to succeed. Has some motivation but also significant doubts.", "personality_traits": ["ambivalent", "uncertain", "hopeful", "self_doubting"], "tone_spectrum": {"word_complexity": 0.4, "sentence_length": 0.4, "emotional_expressiveness": 0.5, "disclosure_level": 0.4, "response_latency": 0.5, "confidence_level": 0.3}, "starting_tone_position": 0.3, "triggers": ["pressure", "unrealistic_expectations", "comparison_to_others", "being_rushed"], "comfort_topics": ["honesty", "own_pace", "acknowledgment_of_difficulty", "support"]}'::jsonb,
    '{"start_node_id": "node_1", "nodes": {"node_1": {"id": "node_1", "persona_text": "I''m thinking about making this change, but honestly, I''m not sure if I can actually do it. Part of me thinks I can, but another part worries I''ll fail.", "persona_mood": "uncertain_ambivalent", "themes": ["Uncertainty", "Self-Doubt", "Change"], "choice_points": [{"id": "cp_node_1_0", "option_text": "Of course you can do it! You just need to believe in yourself.", "preview_hint": "This is premature encouragement", "rapport_impact": 0, "trust_impact": 0, "tone_shift": 0.0, "technique_tags": ["premature_reassurance"], "competency_links": [], "feedback": {"immediate": "You''ve offered reassurance before understanding their actual confidence level. Scaling would help you assess where they really are.", "learning_note": "Scaling questions assess before we encourage or advise."}, "next_node_id": "node_2a", "exploration_depth": "surface"}, {"id": "cp_node_1_1", "option_text": "On a scale from 0 to 10, where 0 means not at all confident and 10 means completely confident, how confident are you that you could make this change?", "preview_hint": "This uses scaling to assess", "rapport_impact": 1, "trust_impact": 1, "tone_shift": 0.1, "technique_tags": ["confidence_scale"], "competency_links": ["A6", "B6"], "feedback": {"immediate": "Perfect scaling question! This gives you a concrete measure of their confidence and opens exploration.", "learning_note": "Scaling questions provide a measurable way to assess subjective states."}, "next_node_id": "node_2b", "exploration_depth": "deep"}, {"id": "cp_node_1_2", "option_text": "Why do you think you''d fail?", "preview_hint": "This focuses on the negative", "rapport_impact": -1, "trust_impact": -1, "tone_shift": -0.1, "technique_tags": ["negative_focus"], "competency_links": [], "feedback": {"immediate": "You''ve focused on their doubt rather than exploring their overall confidence. Scaling would be more balanced.", "learning_note": "Scaling questions assess both confidence and doubt together."}, "next_node_id": "node_2c", "exploration_depth": "surface"}], "is_endpoint": false, "endpoint_type": null}, "node_2b": {"id": "node_2b", "persona_text": "I''d say about a 6. I think I can do it, but I''m not completely sure.", "persona_mood": "measured_hopeful", "themes": ["Measured", "Hope", "Uncertainty"], "choice_points": [{"id": "cp_node_2b_0", "option_text": "A 6 isn''t bad, but we need to get you to a 10 before you start.", "preview_hint": "This sets unrealistic expectations", "rapport_impact": -1, "trust_impact": -1, "tone_shift": -0.15, "technique_tags": ["unrealistic_standard"], "competency_links": [], "feedback": {"immediate": "You''ve set an unrealistic standard. People can and do make changes with confidence less than 10.", "learning_note": "Scaling assesses readiness, not perfection."}, "next_node_id": "node_3a", "exploration_depth": "surface"}, {"id": "cp_node_2b_1", "option_text": "A 6 is pretty good. You''re more confident than not. What helps you be at a 6 rather than lower?", "preview_hint": "This explores strengths", "rapport_impact": 1, "trust_impact": 1, "tone_shift": 0.15, "technique_tags": ["scale_strength_exploration"], "competency_links": ["A6"], "feedback": {"immediate": "Excellent! You''ve validated their confidence while exploring what contributes to it. This builds on strengths.", "learning_note": "Exploring what maintains higher confidence identifies resources and strengths."}, "next_node_id": "node_3b", "exploration_depth": "deep"}, {"id": "cp_node_2b_2", "option_text": "What would need to happen for you to move from a 6 to a higher number?", "preview_hint": "This explores what would increase confidence", "rapport_impact": 1, "trust_impact": 1, "tone_shift": 0.1, "technique_tags": ["scale_moving_forward"], "competency_links": ["A6"], "feedback": {"immediate": "Great scaling follow-up! This helps them identify what would increase their confidence.", "learning_note": "Scale exploration questions help identify specific steps or resources needed."}, "next_node_id": "node_3c", "exploration_depth": "deep"}], "is_endpoint": false, "endpoint_type": null}, "node_3b": {"id": "node_3b", "persona_text": "Well, I''ve made changes before, so I know I can do it. And I have some support from people who believe in me.", "persona_mood": "resourceful_recognizing", "themes": ["Past_Success", "Support", "Resources"], "choice_points": [{"id": "cp_node_3b_0", "option_text": "So you have past experience with making changes and people who support you - those are real strengths that help you feel confident.", "preview_hint": "This reflects their strengths", "rapport_impact": 1, "trust_impact": 1, "tone_shift": 0.15, "technique_tags": ["affirmation_reflection"], "competency_links": ["A6"], "feedback": {"immediate": "Excellent affirmation! You''ve reflected their strengths and validated the resources they''ve identified.", "learning_note": "Affirmations after scaling exploration reinforce confidence and resources."}, "next_node_id": "node_end_excellent", "exploration_depth": "deep"}], "is_endpoint": false, "endpoint_type": null}, "node_3c": {"id": "node_3c", "persona_text": "I think having a clear plan would help. And maybe breaking it down into smaller steps so it doesn''t feel so overwhelming.", "persona_mood": "practical_thinking", "themes": ["Planning", "Practical", "Clarity"], "choice_points": [{"id": "cp_node_3c_0", "option_text": "So having a clear plan and breaking things into smaller steps would increase your confidence.", "preview_hint": "This captures their solution", "rapport_impact": 1, "trust_impact": 1, "tone_shift": 0.15, "technique_tags": ["reflection"], "competency_links": ["A6"], "feedback": {"immediate": "Perfect reflection! You''ve captured their own ideas about what would help. This is their solution, not yours.", "learning_note": "Scaling exploration helps people identify their own solutions."}, "next_node_id": "node_end_good", "exploration_depth": "deep"}], "is_endpoint": false, "endpoint_type": null}, "node_2a": {"id": "node_2a", "persona_text": "I suppose. Thanks for the encouragement.", "persona_mood": "polite_skeptical", "themes": ["Politeness", "Skepticism"], "choice_points": [], "is_endpoint": true, "endpoint_type": "neutral_end"}, "node_2c": {"id": "node_2c", "persona_text": "It''s not that I think I''d fail, I just have some concerns.", "persona_mood": "misheard_correcting", "themes": ["Correction", "Clarification"], "choice_points": [], "is_endpoint": true, "endpoint_type": "neutral_end"}, "node_3a": {"id": "node_3a", "persona_text": "That feels like too much pressure. Maybe I''m not ready.", "persona_mood": "pressured_withdrawing", "themes": ["Pressure", "Withdrawal"], "choice_points": [], "is_endpoint": true, "endpoint_type": "poor_engagement"}, "node_end_excellent": {"id": "node_end_excellent", "persona_text": "This has been really helpful. I feel more confident now that I can see my strengths.", "persona_mood": "confident_empowered", "themes": ["Confidence", "Empowerment", "Clarity"], "choice_points": [], "is_endpoint": true, "endpoint_type": "excellent_engagement"}, "node_end_good": {"id": "node_end_good", "persona_text": "Thanks for helping me think through this. I have a better sense of what I need.", "persona_mood": "grateful_clear", "themes": ["Gratitude", "Clarity"], "choice_points": [], "is_endpoint": true, "endpoint_type": "good_engagement"}}}'::jsonb,
    ARRAY'[\"A6\", \"B6\", \"2.1.1\"]',
    '{"dimensions": {"A6": {"description": "Rapport Building", "weight": 2.0, "positive_signals": ["scaling_question", "exploration_of_confidence", "strength_based"], "negative_signals": ["premature_reassurance", "unrealistic_expectations", "negative_focus"]}, "B6": {"description": "Professional Alliance", "weight": 1.5, "positive_signals": ["measurable_assessment", "collaborative_exploration", "following_their_lead"], "negative_signals": ["imposing_standards", "pressuring", "dismissing_concerns"]}, "2.1.1": {"description": "Complex Reflective Listening", "weight": 1.5, "positive_signals": ["reflection_of_strengths", "affirmation", "exploration"], "negative_signals": ["advice", "premature_encouragement", "ignoring_concerns"]}}, "overall_scoring_logic": "weighted_average"}'::jsonb,
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
-- WHERE code = 'shared-confidence-scaling-008';
