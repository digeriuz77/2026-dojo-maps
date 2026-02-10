-- supabase/seed/seed_shared-collaborative-climate-007.sql
-- MAPS Practice Module: Collaborative Climate - Partnership & Autonomy
-- Content Type: shared
--
-- Usage:
--   supabase db execute --file supabase/seed/seed_shared-collaborative-climate-007.sql
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
    '00000000-0000-0001-0001-000000000007',
    'shared-collaborative-climate-007',
    'Collaborative Climate - Partnership & Autonomy',
    'shared',
    'Engagement & Partnership',
    'beginner',
    10,
    'Learn to establish a collaborative partnership that honors autonomy and supports the person''s own decision-making process',
    'A collaborative climate is essential for MI. It involves partnership, acceptance, compassion, and evocation. The person is the primary resource for their own change. This means respecting autonomy, avoiding expert positioning, and supporting rather than directing. This foundation applies universally to all contexts.',
    '{"name": "Morgan", "role": "person", "background": "Is used to being told what to do by experts and authorities. Expects advice and direction. May be skeptical about a different approach.", "personality_traits": ["skeptical", "expectant", "autonomous", "cautious"], "tone_spectrum": {"word_complexity": 0.5, "sentence_length": 0.5, "emotional_expressiveness": 0.4, "disclosure_level": 0.4, "response_latency": 0.5, "confidence_level": 0.5}, "starting_tone_position": 0.4, "triggers": ["being_told_what_to_do", "expert_positioning", "being_corrected", "prescriptive_language"], "comfort_topics": ["partnership", "respect", "autonomy", "collaboration"]}'::jsonb,
    '{"start_node_id": "node_1", "nodes": {"node_1": {"id": "node_1", "persona_text": "So, what do you think I should do? I''m here for your expert opinion.", "persona_mood": "expectant_deferential", "themes": ["Expectation", "Expert_Seeking", "Deference"], "choice_points": [{"id": "cp_node_1_0", "option_text": "Based on my experience, I think you should start by setting clear goals and creating a plan.", "preview_hint": "This positions yourself as expert", "rapport_impact": 0, "trust_impact": 0, "tone_shift": 0.0, "technique_tags": ["expert_positioning"], "competency_links": [], "feedback": {"immediate": "You''ve taken the expert role and provided direction. In MI, we''re partners, not experts telling people what to do.", "learning_note": "Collaborative climate means partnership, not expert positioning."}, "next_node_id": "node_2a", "exploration_depth": "surface"}, {"id": "cp_node_1_1", "option_text": "I appreciate you asking, but I see my role differently. You''re the expert on your life, and I''m here to help you explore your own thinking.", "preview_hint": "This establishes partnership", "rapport_impact": 1, "trust_impact": 1, "tone_shift": 0.15, "technique_tags": ["partnership_statement"], "competency_links": ["A6", "A3"], "feedback": {"immediate": "Excellent! You''ve respectfully reframed your role and positioned them as the expert on their own life.", "learning_note": "Partnership statements clarify that they are the primary resource."}, "next_node_id": "node_2b", "exploration_depth": "deep"}, {"id": "cp_node_1_2", "option_text": "What are your thoughts about what might help?", "preview_hint": "This immediately redirects to them", "rapport_impact": 1, "trust_impact": 1, "tone_shift": 0.1, "technique_tags": ["collaborative_question"], "competency_links": ["A6"], "feedback": {"immediate": "Good! You''ve immediately redirected the question back to them, reinforcing that their ideas matter most.", "learning_note": "Redirecting expert-seeking questions back to the person builds partnership."}, "next_node_id": "node_2c", "exploration_depth": "deep"}], "is_endpoint": false, "endpoint_type": null}, "node_2b": {"id": "node_2b", "persona_text": "That''s different from what I''m used to. Usually people just tell me what to do. But I suppose I do know myself best.", "persona_mood": "surprisingly_open", "themes": ["Surprise", "Self-Knowledge", "Openness"], "choice_points": [{"id": "cp_node_2b_0", "option_text": "Exactly! So let''s work together to figure out what makes sense for you.", "preview_hint": "This reinforces collaboration", "rapport_impact": 1, "trust_impact": 1, "tone_shift": 0.15, "technique_tags": ["collaborative_invitation"], "competency_links": ["A6", "A3"], "feedback": {"immediate": "Perfect! You''ve reinforced the collaborative approach and invited them into partnership.", "learning_note": "Collaborative invitations reinforce partnership and shared work."}, "next_node_id": "node_3a", "exploration_depth": "deep"}, {"id": "cp_node_2b_1", "option_text": "You''re surprised because you''re used to being told what to do, but you recognize that you know yourself best.", "preview_hint": "This reflects their insight", "rapport_impact": 1, "trust_impact": 1, "tone_shift": 0.15, "technique_tags": ["complex_reflection"], "competency_links": ["A6"], "feedback": {"immediate": "Excellent complex reflection! You''ve captured both their surprise and their self-knowledge insight.", "learning_note": "Reflections that capture insights about self-knowledge reinforce autonomy."}, "next_node_id": "node_3b", "exploration_depth": "deep"}], "is_endpoint": false, "endpoint_type": null}, "node_2c": {"id": "node_2c", "persona_text": "Well, I''ve been thinking about it, and I have some ideas. But I''m not sure if they''re the right ones.", "persona_mood": "tentative_uncertain", "themes": ["Tentativeness", "Uncertainty", "Ideas"], "choice_points": [{"id": "cp_node_2c_0", "option_text": "Your ideas are the ones that matter most. You know yourself better than anyone else.", "preview_hint": "This validates autonomy", "rapport_impact": 1, "trust_impact": 1, "tone_shift": 0.15, "technique_tags": ["autonomy_affirmation"], "competency_links": ["A3", "A6"], "feedback": {"immediate": "Excellent! You''ve validated their autonomy and reinforced that their ideas are what matter.", "learning_note": "Autonomy affirmations support the person''s role as decision-maker."}, "next_node_id": "node_3c", "exploration_depth": "deep"}], "is_endpoint": false, "endpoint_type": null}, "node_3a": {"id": "node_3a", "persona_text": "I like that. It feels different - more like we''re in this together.", "persona_mood": "collaborative_engaged", "themes": ["Collaboration", "Partnership", "Engagement"], "choice_points": [], "is_endpoint": true, "endpoint_type": "excellent_engagement"}, "node_3b": {"id": "node_3b", "persona_text": "That''s true. And it feels good to have that recognized rather than just being told what to do.", "persona_mood": "validated_respected", "themes": ["Validation", "Respect", "Self-Agency"], "choice_points": [], "is_endpoint": true, "endpoint_type": "excellent_engagement"}, "node_3c": {"id": "node_3c", "persona_text": "Thanks. That helps me feel more confident about sharing my thoughts.", "persona_mood": "confident_safe", "themes": ["Confidence", "Safety", "Sharing"], "choice_points": [], "is_endpoint": true, "endpoint_type": "excellent_engagement"}, "node_2a": {"id": "node_2a", "persona_text": "Okay, thanks for the advice. I''ll try that.", "persona_mood": "compliant_passive", "themes": ["Compliance", "Passivity"], "choice_points": [], "is_endpoint": true, "endpoint_type": "transactional_only"}}}'::jsonb,
    ARRAY'[\"A3\", \"A6\", \"B6\"]',
    '{"dimensions": {"A3": {"description": "Impartiality (Non-Directive)", "weight": 2.0, "positive_signals": ["partnership", "honoring_autonomy", "collaborative"], "negative_signals": ["expert_positioning", "directing", "prescribing"]}, "A6": {"description": "Rapport Building", "weight": 1.5, "positive_signals": ["respect", "validation", "autonomy_support"], "negative_signals": ["authority", "correction", "being_expert"]}, "B6": {"description": "Professional Alliance", "weight": 1.5, "positive_signals": ["two_way_partnership", "equal_status", "collaborative"], "negative_signals": ["one_way_expertise", "hierarchical", "directive"]}}, "overall_scoring_logic": "weighted_average"}'::jsonb,
    '{"framework_name": "MaPS Money Guidance Competency Framework", "framework_version": "September 2022", "sections": ["A3", "A6", "B6"], "tier_relevance": "All Tiers", "domains": ["Universal Skill"]}'::jsonb,
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
-- WHERE code = 'shared-collaborative-climate-007';
