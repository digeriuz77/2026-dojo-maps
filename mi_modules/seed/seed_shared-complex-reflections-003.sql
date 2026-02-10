-- supabase/seed/seed_shared-complex-reflections-003.sql
-- MAPS Practice Module: Complex & Double-Sided Reflections - Exploring Ambivalence
-- Content Type: shared
--
-- Usage:
--   supabase db execute --file supabase/seed/seed_shared-complex-reflections-003.sql
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
    '00000000-0000-0001-0001-000000000003',
    'shared-complex-reflections-003',
    'Complex & Double-Sided Reflections - Exploring Ambivalence',
    'shared',
    'Reflective Listening',
    'beginner',
    15,
    'Learn to use complex reflections to capture deeper meaning and double-sided reflections to acknowledge ambivalence without pushing for resolution',
    'Complex reflections add meaning, emotion, or deeper understanding beyond what was explicitly said. Double-sided reflections acknowledge both sides of ambivalence (reasons to change AND reasons to stay the same), helping people hold their complexity without feeling pushed. This core skill applies universally to customer and colleague contexts.',
    '{"name": "Morgan", "role": "person", "background": "Recognizes there is an issue and is considering making changes but has not yet committed. Feeling torn between different options.", "personality_traits": ["ambivalent", "thoughtful", "cautious", "analytical"], "tone_spectrum": {"word_complexity": 0.4, "sentence_length": 0.4, "emotional_expressiveness": 0.4, "disclosure_level": 0.3, "response_latency": 0.5, "confidence_level": 0.4}, "starting_tone_position": 0.4, "triggers": ["pushing_for_change", "taking_sides", "rushing_to_resolution", "minimizing_difficulty"], "comfort_topics": ["autonomy", "understanding", "being_heard", "personal_choice"]}'::jsonb,
    '{"start_node_id": "node_1", "nodes": {"node_1": {"id": "node_1", "persona_text": "I''ve been thinking about making some changes. There are good reasons to do it, but honestly, I also have good reasons not to. I''m going back and forth.", "persona_mood": "ambivalent_contemplative", "themes": ["Ambivalence", "Change"], "choice_points": [{"id": "cp_node_1_0", "option_text": "You just need to focus on the reasons to change and the benefits you''ll get.", "preview_hint": "This pushes for change", "rapport_impact": -1, "trust_impact": -1, "tone_shift": -0.1, "technique_tags": ["direction_change_talk"], "competency_links": [], "feedback": {"immediate": "This pushes toward change rather than exploring ambivalence. When someone is genuinely torn, pushing one side can create resistance.", "learning_note": "Ambivalence is normal in change - our role is to explore it, not resolve it."}, "next_node_id": "node_2a", "exploration_depth": "surface"}, {"id": "cp_node_1_1", "option_text": "You''re seeing good reasons to make this change, and you also have good reasons not to.", "preview_hint": "This captures both sides", "rapport_impact": 0, "trust_impact": 0, "tone_shift": 0.0, "technique_tags": ["complex_reflection"], "competency_links": [], "feedback": {"immediate": "Excellent! This double-sided reflection acknowledges both sides of their ambivalence without trying to resolve it.", "learning_note": "Double-sided reflections honor complexity and create safety for exploring ambivalence."}, "next_node_id": "node_2b", "exploration_depth": "surface"}, {"id": "cp_node_1_2", "option_text": "What''s behind your hesitation?", "preview_hint": "This questions rather than reflects", "rapport_impact": 0, "trust_impact": 0, "tone_shift": 0.0, "technique_tags": ["question"], "competency_links": [], "feedback": {"immediate": "This jumps to questioning their hesitation rather than reflecting what they''ve shared. Reflection first would build more trust.", "learning_note": "Reflections acknowledge experience, questions probe it."}, "next_node_id": "node_2c", "exploration_depth": "surface"}], "is_endpoint": false, "endpoint_type": null}, "node_2b": {"id": "node_2b", "persona_text": "Exactly! For example, if I make this change, I''ll feel better and healthier. But on the other hand, I''d be giving up something I enjoy, and I''m not sure I can sustain it anyway.", "persona_mood": "open_exploring", "themes": ["Goals", "Barriers", "Change"], "choice_points": [{"id": "cp_node_2b_0", "option_text": "There''s a lot you''d gain and also something you''d lose, plus you''re uncertain about sustaining the change.", "preview_hint": "This captures the complexity", "rapport_impact": 0, "trust_impact": 0, "tone_shift": 0.0, "technique_tags": ["complex_reflection"], "competency_links": [], "feedback": {"immediate": "Excellent complex reflection! You''ve synthesized multiple elements - what they''d gain, what they''d lose, and their sustainability concern.", "learning_note": "Complex reflections synthesize multiple themes and show deep understanding."}, "next_node_id": "node_3a", "exploration_depth": "deep"}, {"id": "cp_node_2b_1", "option_text": "You''re scared of failing again like you did before.", "preview_hint": "This is inaccurate", "rapport_impact": -1, "trust_impact": -1, "tone_shift": -0.1, "technique_tags": ["inaccurate_reflection"], "competency_links": [], "feedback": {"immediate": "This doesn''t accurately reflect what they shared. They mentioned uncertainty but you''ve jumped to fear without their input.", "learning_note": "Complex reflections must accurately capture what was said, not what you assume."}, "next_node_id": "node_3b", "exploration_depth": "surface"}], "is_endpoint": false, "endpoint_type": null}, "node_3a": {"id": "node_3a", "persona_text": "That''s exactly it! I''m scared I''ll fail, but I''m also scared I''ll regret not trying. Either way, there''s fear.", "persona_mood": "fearful_paradox", "themes": ["Fear", "Paradox"], "choice_points": [{"id": "cp_node_3a_0", "option_text": "You''re caught between fearing failure if you try and regret if you don''t.", "preview_hint": "This captures the paradox", "rapport_impact": 1, "trust_impact": 1, "tone_shift": 0.15, "technique_tags": ["double_sided_reflection"], "competency_links": [], "feedback": {"immediate": "Perfect! This names the painful paradox - both paths involve fear. This helps them see their dilemma clearly.", "learning_note": "Double-sided reflections of emotions help people recognize and hold complex feelings."}, "next_node_id": "node_end_good", "exploration_depth": "deep"}], "is_endpoint": false, "endpoint_type": null}, "node_3b": {"id": "node_3b", "persona_text": "I suppose... this conversation helps. I''m still torn but I understand my thinking better.", "persona_mood": "appreciative_conflicted", "themes": ["Understanding", "Ambivalence"], "choice_points": [], "is_endpoint": true, "endpoint_type": "neutral_end"}, "node_end_good": {"id": "node_end_good", "persona_text": "This has been really helpful. I can see my situation more clearly now, even if I''m still conflicted.", "persona_mood": "clarity_gained", "themes": ["Insight", "Self-Awareness"], "choice_points": [], "is_endpoint": true, "endpoint_type": "good_engagement"}}}'::jsonb,
    ARRAY'[\"A6\", \"B6\", \"2.1.1\"]',
    '{"dimensions": {"A6": {"description": "Rapport Building", "weight": 1.5, "positive_signals": ["complex_reflection", "double_sided_reflection", "ambivalence_honoring"], "negative_signals": ["pushing_for_change", "taking_sides", "minimizing"]}, "B6": {"description": "Professional Alliance", "weight": 1.5, "positive_signals": ["validation", "empathy", "reflection"], "negative_signals": ["judgment", "pressure", "explanation"]}, "2.1.1": {"description": "Complex Reflective Listening", "weight": 2.0, "positive_signals": ["complex_reflection", "meaning_addition", "emotion_reflection"], "negative_signals": ["interpretation", "advice", "questioning"]}}, "overall_scoring_logic": "weighted_average"}'::jsonb,
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
-- WHERE code = 'shared-complex-reflections-003';
