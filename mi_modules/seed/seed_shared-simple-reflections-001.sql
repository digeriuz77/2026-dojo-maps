-- supabase/seed/seed_shared-simple-reflections-001.sql
-- MAPS Practice Module: Simple Reflections - Core Skill Practice
-- Content Type: shared
--
-- Usage:
--   supabase db execute --file supabase/seed/seed_shared-simple-reflections-001.sql
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
    '00000000-0000-0001-0001-000000000001',
    'shared-simple-reflections-001',
    'Simple Reflections - Core Skill Practice',
    'shared',
    'Reflective Listening',
    'beginner',
    5,
    'Learn to create simple, accurate reflections that demonstrate understanding and build professional relationships',
    'Simple reflections capture the essence of what someone said without adding interpretation or judgment. They demonstrate listening, build trust, and encourage others to elaborate. Effective reflections are brief, accurate, and focused on observable content. This core skill applies universally to customer and colleague interactions.',
    '{"name": "Alex", "role": "person", "background": "Does not recognize there is an issue or feels it''s not significant enough to address.", "personality_traits": ["defensive", "guarded", "minimizing", "autonomous"], "tone_spectrum": {"word_complexity": 0.3, "sentence_length": 0.3, "emotional_expressiveness": 0.2, "disclosure_level": 0.1, "response_latency": 0.3, "confidence_level": 0.2}, "starting_tone_position": 0.2, "triggers": ["direct criticism", "being told what to do", "lecturing", "judgment"], "comfort_topics": ["autonomy", "understanding", "being heard", "personal choice"]}'::jsonb,
    '{"start_node_id": "node_1", "nodes": {"node_1": {"id": "node_1", "persona_text": "My partner sent me here because of my habits. I don''t really think it''s a problem.", "persona_mood": "defensive_not_ready", "themes": ["Hesitation", "Change"], "choice_points": [{"id": "cp_node_1_0", "option_text": "There are real risks and consequences if you don''t address this.", "preview_hint": "Notice: This is education/warning, not reflection", "rapport_impact": 0, "hesitation_impact": 0, "tone_shift": 0.0, "technique_tags": ["warning"], "competency_links": [], "feedback": {"immediate": "This is education/warning, not reflection. You''re providing information instead of reflecting what they said. This can create hesitation.", "learning_note": "Reflections build rapport by showing you understand the person''s perspective."}, "next_node_id": "node_2a", "exploration_depth": "surface"}, {"id": "cp_node_1_1", "option_text": "You don''t see this as a problem for you.", "preview_hint": "Notice: This is a simple reflection", "rapport_impact": 0, "hesitation_impact": 0, "tone_shift": 0.0, "technique_tags": ["simple_reflection"], "competency_links": [], "feedback": {"immediate": "Perfect! This is a simple, accurate reflection of exactly what they said. It demonstrates you''re listening without judgment.", "learning_note": "Reflections build rapport by showing you understand the person''s perspective."}, "next_node_id": "node_2b", "exploration_depth": "surface"}, {"id": "cp_node_1_2", "option_text": "Why do you think it''s not a problem?", "preview_hint": "Notice: This is a closed question", "rapport_impact": 0, "hesitation_impact": 0, "tone_shift": 0.0, "technique_tags": ["closed_question"], "competency_links": [], "feedback": {"immediate": "While questions can be useful, starting with a reflection demonstrates better listening. You missed an opportunity to reflect first.", "learning_note": "Reflections build rapport by showing you understand the person''s perspective."}, "next_node_id": "node_2c", "exploration_depth": "surface"}], "is_endpoint": false, "endpoint_type": null}, "node_2a": {"id": "node_2a", "persona_text": "Yeah, I know all that. They''ve been telling me that for years. It hasn''t made any difference.", "persona_mood": "neutral_uncertain", "themes": ["General"], "choice_points": [{"id": "cp_node_2a_0", "option_text": "But the risks are real and serious.", "preview_hint": "This confronts rather than reflects", "rapport_impact": 0, "hesitation_impact": 0, "tone_shift": 0.0, "technique_tags": ["confrontation"], "competency_links": [], "feedback": {"immediate": "This confronts and argues, which increases hesitation. You''re defending your position rather than understanding theirs.", "learning_note": "Watch for hesitation signals - defensiveness or disengagement."}, "next_node_id": "node_3a", "exploration_depth": "surface"}, {"id": "cp_node_2a_1", "option_text": "All that information hasn''t changed anything for you so far.", "preview_hint": "This reflects their experience", "rapport_impact": 0, "hesitation_impact": 0, "tone_shift": 0.0, "technique_tags": ["simple_reflection"], "competency_links": [], "feedback": {"immediate": "Good! This reflects their experience without arguing. You acknowledge the information hasn''t helped them change.", "learning_note": "Continue practicing to build your professional skills."}, "next_node_id": "node_3b", "exploration_depth": "surface"}], "is_endpoint": false, "endpoint_type": null}, "node_2b": {"id": "node_2b", "persona_text": "That''s right. I enjoy it. It helps me relax. I don''t want to change.", "persona_mood": "neutral_uncertain", "themes": ["Concerns", "Goals", "Change"], "choice_points": [{"id": "cp_node_2b_0", "option_text": "You enjoy it and it helps you relax, so you don''t want to change.", "preview_hint": "This reflects both sides accurately", "rapport_impact": 0, "hesitation_impact": 0, "tone_shift": 0.0, "technique_tags": ["simple_reflection"], "competency_links": [], "feedback": {"immediate": "Excellent! This reflects both their enjoyment and their desire not to change. This honors their perspective.", "learning_note": "Continue practicing to build your professional skills."}, "next_node_id": "node_3c", "exploration_depth": "surface"}, {"id": "cp_node_2b_1", "option_text": "But relaxation is important, and there are healthier ways to achieve it.", "preview_hint": "This jumps to solutions", "rapport_impact": 0, "hesitation_impact": 0, "tone_shift": 0.0, "technique_tags": ["advice"], "competency_links": [], "feedback": {"immediate": "This jumps to solutions rather than reflecting their current perspective. This can create hesitation.", "learning_note": "Watch for hesitation signals - defensiveness or disengagement."}, "next_node_id": "node_3d", "exploration_depth": "surface"}], "is_endpoint": false, "endpoint_type": null}, "node_2c": {"id": "node_2c", "persona_text": "Because I don''t. It''s something I choose to do, and I''m not hurting anyone.", "persona_mood": "neutral_uncertain", "themes": ["Autonomy"], "choice_points": [{"id": "cp_node_2c_0", "option_text": "You see this as your choice and you don''t see it as hurting anyone.", "preview_hint": "Accurate reflection", "rapport_impact": 0, "hesitation_impact": 0, "tone_shift": 0.0, "technique_tags": ["simple_reflection"], "competency_links": [], "feedback": {"immediate": "Good! This reflects both their sense of choice and their view about not hurting others.", "learning_note": "Continue practicing to build your professional skills."}, "next_node_id": "node_3e", "exploration_depth": "surface"}, {"id": "cp_node_2c_1", "option_text": "But it could hurt others around you.", "preview_hint": "This confronts rather than reflects", "rapport_impact": 0, "hesitation_impact": 0, "tone_shift": 0.0, "technique_tags": ["confrontation"], "competency_links": [], "feedback": {"immediate": "This confronts and argues rather than reflecting their perspective. This will likely increase hesitation.", "learning_note": "Watch for hesitation signals - defensiveness or disengagement."}, "next_node_id": "node_3f", "exploration_depth": "surface"}], "is_endpoint": false, "endpoint_type": null}, "node_3a": {"id": "node_3a", "persona_text": "This conversation isn''t going to help either.", "persona_mood": "disengaged", "themes": ["General"], "choice_points": [], "is_endpoint": true, "endpoint_type": "failed_engagement"}, "node_3b": {"id": "node_3b", "persona_text": "Finally, someone who actually listens. Yeah, I''ve heard it all before.", "persona_mood": "open_receptive", "themes": ["Rapport"], "choice_points": [], "is_endpoint": true, "endpoint_type": "good_engagement"}, "node_3c": {"id": "node_3c", "persona_text": "Exactly! I''m glad you understand that. It''s not as simple as people think.", "persona_mood": "appreciative", "themes": ["Validation"], "choice_points": [], "is_endpoint": true, "endpoint_type": "good_engagement"}, "node_3d": {"id": "node_3d", "persona_text": "I guess... but I''m not sure I''m ready to change anything.", "persona_mood": "neutral_uncertain", "themes": ["Ambivalence"], "choice_points": [], "is_endpoint": true, "endpoint_type": "neutral_end"}, "node_3e": {"id": "node_3e", "persona_text": "Right. I appreciate that you understand my position.", "persona_mood": "appreciative", "themes": ["Validation"], "choice_points": [], "is_endpoint": true, "endpoint_type": "good_engagement"}, "node_3f": {"id": "node_3f", "persona_text": "Here we go again... more judgment.", "persona_mood": "defensive", "themes": ["Hesitation"], "choice_points": [], "is_endpoint": true, "endpoint_type": "failed_engagement"}}}'::jsonb,
    ARRAY'[\"A6\", \"B6\", \"2.1.1\"]',
    '{"dimensions": {"A6": {"description": "Rapport Building", "weight": 1.5, "positive_signals": ["simple_reflection", "affirmation", "open_question"], "negative_signals": ["confrontation", "educating", "advice"]}, "B6": {"description": "Professional Alliance", "weight": 1.5, "positive_signals": ["validation", "empathy", "reflection"], "negative_signals": ["judgment", "pressure", "explanation"]}, "2.1.1": {"description": "Simple Reflective Listening", "weight": 2.0, "positive_signals": ["simple_reflection", "repeating", "rephrasing"], "negative_signals": ["interpretation", "advice", "questioning"]}}, "overall_scoring_logic": "weighted_average"}'::jsonb,
    '{"framework_name": "MaPS Money Guidance Competency Framework", "framework_version": "September 2022", "sections": ["A6", "B6"], "tier_relevance": "All Tiers", "domains": ["Domain 1: Knowing your customer"]}'::jsonb,
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
-- WHERE code = 'shared-simple-reflections-001';
