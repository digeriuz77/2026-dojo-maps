-- supabase/seed/seed_shared-affirmations-004.sql
-- MAPS Practice Module: Affirmations - Recognizing Strengths
-- Content Type: shared
--
-- Usage:
--   supabase db execute --file supabase/seed/seed_shared-affirmations-004.sql
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
    '00000000-0000-0001-0001-000000000004',
    'shared-affirmations-004',
    'Affirmations - Recognizing Strengths',
    'shared',
    'Building Confidence',
    'beginner',
    10,
    'Learn to offer genuine affirmations that recognize strengths, efforts, and positive qualities without sounding patronizing or judgmental',
    'Affirmations are statements that recognize positive qualities, efforts, or strengths. They differ from compliments because they are grounded in observation rather than evaluation. Good affirmations are specific, genuine, and help people see their own capabilities. This core skill builds confidence and alliance.',
    '{"name": "Riley", "role": "person", "background": "Has been working on making changes but feels discouraged by slow progress. Has had some successes but struggles to recognize them.", "personality_traits": ["discouraged", "self_critical", "effortful", "seeking_validation"], "tone_spectrum": {"word_complexity": 0.4, "sentence_length": 0.4, "emotional_expressiveness": 0.3, "disclosure_level": 0.3, "response_latency": 0.4, "confidence_level": 0.3}, "starting_tone_position": 0.3, "triggers": ["generic praise", "comparison to others", "toxic positivity", "dismissing difficulties"], "comfort_topics": ["effort recognition", "genuine acknowledgment", "strengths being seen", "progress noticed"]}'::jsonb,
    '{"start_node_id": "node_1", "nodes": {"node_1": {"id": "node_1", "persona_text": "I''ve been trying really hard, but honestly, I don''t feel like I''m making any progress. It''s frustrating.", "persona_mood": "discouraged_frustrated", "themes": ["Discouragement", "Effort", "Progress"], "choice_points": [{"id": "cp_node_1_0", "option_text": "Don''t be so hard on yourself. You''re doing great! Keep going and you''ll see results.", "preview_hint": "This is generic encouragement", "rapport_impact": 0, "trust_impact": 0, "tone_shift": 0.0, "technique_tags": ["encouragement"], "competency_links": [], "feedback": {"immediate": "This is generic encouragement rather than a specific affirmation. You haven''t acknowledged what they''ve actually done or the difficulty they''re experiencing.", "learning_note": "Good affirmations are specific and grounded in observation, not generic praise."}, "next_node_id": "node_2a", "exploration_depth": "surface"}, {"id": "cp_node_1_1", "option_text": "You''ve been putting in real effort, even though you don''t feel like you''re getting anywhere.", "preview_hint": "This affirms the effort", "rapport_impact": 1, "trust_impact": 1, "tone_shift": 0.15, "technique_tags": ["affirmation"], "competency_links": ["A6"], "feedback": {"immediate": "Excellent! You''ve affirmed their effort specifically, which validates their experience. You''ve acknowledged both their action and their feeling.", "learning_note": "Affirmations validate effort especially when progress feels slow or invisible."}, "next_node_id": "node_2b", "exploration_depth": "surface"}, {"id": "cp_node_1_2", "option_text": "What makes you feel like you''re not making progress?", "preview_hint": "This question explores but doesn''t affirm", "rapport_impact": 0, "trust_impact": 0, "tone_shift": 0.0, "technique_tags": ["open_question"], "competency_links": [], "feedback": {"immediate": "This is a good question, but after sharing vulnerability, an affirmation first would help them feel seen before exploring further.", "learning_note": "Questions can work, but affirmations first build safety for difficult conversations."}, "next_node_id": "node_2c", "exploration_depth": "surface"}], "is_endpoint": false, "endpoint_type": null}, "node_2a": {"id": "node_2a", "persona_text": "I suppose. I did do what we discussed last time. And I''ve been using the strategies. Maybe it''s just that I expected faster results.", "persona_mood": "reflective_hopeful", "themes": ["Effort", "Expectations"], "choice_points": [{"id": "cp_node_2a_0", "option_text": "You followed through on what we discussed and you''ve been using the strategies. That shows real commitment.", "preview_hint": "This affirms specific actions", "rapport_impact": 1, "trust_impact": 1, "tone_shift": 0.15, "technique_tags": ["affirmation"], "competency_links": ["A6"], "feedback": {"immediate": "Perfect! You''ve affirmed specific actions (followed through, using strategies) which shows you''re really listening and noticing what they''ve done.", "learning_note": "Specific affirmations are more powerful than generic praise because they show you''re paying attention."}, "next_node_id": "node_3a", "exploration_depth": "surface"}], "is_endpoint": false, "endpoint_type": null}, "node_2b": {"id": "node_2b", "persona_text": "Thanks. That means a lot to hear. Sometimes I think I''m just fooling myself that any of this matters.", "persona_mood": "vulnerable_doubting", "themes": ["Self-Doubt", "Validation"], "choice_points": [{"id": "cp_node_2b_0", "option_text": "You matter, and your efforts matter. Even when progress feels slow, you''re showing up and trying.", "preview_hint": "This is encouraging but somewhat generic", "rapport_impact": 0, "trust_impact": 0, "tone_shift": 0.0, "technique_tags": ["encouragement"], "competency_links": [], "feedback": {"immediate": "Well-intentioned, but this borders on reassurance rather than specific affirmation. You''re telling them they matter rather than affirming something you''ve observed.", "learning_note": "Affirmations work best when grounded in specific observations about the person."}, "next_node_id": "node_3b", "exploration_depth": "surface"}, {"id": "cp_node_2b_1", "option_text": "You''re questioning whether this matters, even though you keep showing up and working at it.", "preview_hint": "This reflects both the doubt and the effort", "rapport_impact": 1, "trust_impact": 1, "tone_shift": 0.15, "technique_tags": ["affirmation"], "competency_links": ["A6"], "feedback": {"immediate": "Excellent! You''ve affirmed the tension between their doubt and their consistent effort. This helps them see the contradiction in their thinking.", "learning_note": "Affirming complexity and effort helps people recognize strengths they might minimize."}, "next_node_id": "node_3c", "exploration_depth": "deep"}], "is_endpoint": false, "endpoint_type": null}, "node_2c": {"id": "node_2c", "persona_text": "I guess. I just wish I could see some tangible progress, you know?", "persona_mood": "frustrated_hopeful", "themes": ["Frustration", "Desire for Progress"], "choice_points": [{"id": "cp_node_2c_0", "option_text": "You''re feeling frustrated by the lack of visible progress, even though you''re putting in the work.", "preview_hint": "This reflects both the feeling and the effort", "rapport_impact": 1, "trust_impact": 1, "tone_shift": 0.15, "technique_tags": ["affirmation"], "competency_links": ["A6"], "feedback": {"immediate": "Good! You''ve acknowledged their frustration without dismissing it, while also noting their continued effort. This validates both feelings.", "learning_note": "Affirmations can acknowledge difficult feelings while still recognizing effort."}, "next_node_id": "node_3d", "exploration_depth": "surface"}], "is_endpoint": false, "endpoint_type": null}, "node_3a": {"id": "node_3a", "persona_text": "Yeah. I hadn''t thought about it that way. I am following through, aren''t I?", "persona_mood": "recognizing_confident", "themes": ["Self-Recognition", "Confidence"], "choice_points": [], "is_endpoint": true, "endpoint_type": "excellent_engagement"}, "node_3b": {"id": "node_3b", "persona_text": "I suppose. Thanks for trying to cheer me up.", "persona_mood": "polite_dismissive", "themes": ["Politeness"], "choice_points": [], "is_endpoint": true, "endpoint_type": "transactional_only"}, "node_3c": {"id": "node_3c", "persona_text": "That helps. Thank you. I think I needed to hear that.", "persona_mood": "grateful_relieved", "themes": ["Validation", "Relief"], "choice_points": [], "is_endpoint": true, "endpoint_type": "good_engagement"}, "node_3d": {"id": "node_3d", "persona_text": "It does help. Thanks for really listening to me and not just telling me to keep going.", "persona_mood": "appreciative_trusting", "themes": ["Trust", "Being Heard"], "choice_points": [], "is_endpoint": true, "endpoint_type": "excellent_engagement"}}}'::jsonb,
    ARRAY'[\"A6\", \"B6\"]',
    '{"dimensions": {"A6": {"description": "Rapport Building", "weight": 2.0, "positive_signals": ["specific_affirmation", "effort_recognition", "genuine_acknowledgment"], "negative_signals": ["generic_praise", "toxic_positivity", "dismissal"]}, "B6": {"description": "Communication", "weight": 1.0, "positive_signals": ["specific_language", "grounded_affirmations", "sincere_delivery"], "negative_signals": ["generic_compliments", "patronizing_tone", "rushed_affirmations"]}}, "overall_scoring_logic": "weighted_average"}'::jsonb,
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
-- WHERE code = 'shared-affirmations-004';
