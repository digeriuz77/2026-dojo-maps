-- supabase/seed/seed_colleague-team-dynamics-004.sql
-- MAPS Practice Module: Team Dynamics: Mediation and Facilitation
-- Content Type: colleague_facing
--
-- Usage:
--   supabase db execute --file supabase/seed/seed_colleague-team-dynamics-004.sql
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
    '00000000-0000-0003-0001-000000000004',
    'colleague-team-dynamics-004',
    'Team Dynamics: Mediation and Facilitation',
    'colleague_facing',
    'Team Working & Collaboration',
    'advanced',
    15,
    'Practice facilitating team dynamics discussions using reflections and open questions to help colleagues navigate interpersonal challenges while maintaining professional relationships',
    'Two colleagues are in conflict about working styles, communication, or project approaches. Your role is to use a facilitative coaching approach - helping them explore their perspectives, find common ground, and develop their own solutions while maintaining professional relationships. This applies core MI skills to complex workplace dynamics.',
    '{"name": "Casey (and Morgan)", "role": "colleagues in conflict", "background": "Casey and Morgan have worked together for 6 months. Tension has developed around Casey''s direct communication style vs Morgan''s collaborative approach. Both feel their approach is right and the other is causing problems. Team is feeling the impact.", "personality_traits": ["defensive", "frustrated", "committed", "righteous"], "tone_spectrum": {"word_complexity": 0.5, "sentence_length": 0.5, "emotional_expressiveness": 0.6, "disclosure_level": 0.4, "response_latency": 0.5, "confidence_level": 0.5}, "starting_tone_position": 0.3, "triggers": ["taking_sides", "agreement", "comparisons", "being_told_what_to_do"], "comfort_topics": ["being_understood", "having_input_heard", "fair_process", "mutual_respect"]}'::jsonb,
    '{"start_node_id": "node_1", "nodes": {"node_1": {"id": "node_1", "persona_text": "Honestly, I''m finding it difficult to work with Morgan. They''re always wanting to discuss everything endlessly, while I prefer to just get on with the work. It''s slowing us down.", "persona_mood": "frustrated_direct", "themes": ["Conflict", "Working_Style"], "choice_points": [{"id": "cp_node_1_0", "option_text": "Morgan does have a point though - collaboration is important for team cohesion.", "preview_hint": "This takes the other side", "rapport_impact": -1, "trust_impact": -1, "tone_shift": -0.15, "technique_tags": ["taking_sides"], "competency_links": [], "feedback": {"immediate": "You''ve taken Morgan''s side, which will make Casey defensive. In facilitation, we remain neutral and help both parties feel heard.", "learning_note": "Team mediation requires strict neutrality - taking sides destroys your credibility as a facilitator."}, "next_node_id": "node_2a", "exploration_depth": "surface"}, {"id": "cp_node_1_1", "option_text": "You''re finding it difficult to work with Morgan because you prefer getting things done while Morgan likes to discuss.", "preview_hint": "This reflects without judgment", "rapport_impact": 1, "trust_impact": 1, "tone_shift": 0.15, "technique_tags": ["simple_reflection"], "competency_links": ["A4", "A6"], "feedback": {"immediate": "Excellent reflection! You''ve captured Casey''s perspective without judgment while also reflecting Morgan''s approach. This neutrality builds trust.", "learning_note": "Reflecting both perspectives in conflict without taking sides is essential for facilitation."}, "next_node_id": "node_2b", "exploration_depth": "surface"}, {"id": "cp_node_1_2", "option_text": "What impact is this having on your work and the team?", "preview_hint": "This explores consequences", "rapport_impact": 0, "trust_impact": 0, "tone_shift": 0.0, "technique_tags": ["open_question"], "competency_links": [], "feedback": {"immediate": "Good open question that explores the impact while keeping the focus on the work rather than personalities.", "learning_note": "Questions that focus on work impact rather than personal criticism help maintain professionalism."}, "next_node_id": "node_2c", "exploration_depth": "deep"}], "is_endpoint": false, "endpoint_type": null}, "node_2b": {"id": "node_2b", "persona_text": "Exactly! I''m about results while Morgan is about process. We''re butting heads and frustrating each other.", "persona_mood": "frustrated_stuck", "themes": ["Stuck", "Values_Mismatch"], "choice_points": [{"id": "cp_node_2b_0", "option_text": "So you have different working styles - you''re focused on results, Morgan is focused on process.", "preview_hint": "This captures the difference", "rapport_impact": 1, "trust_impact": 1, "tone_shift": 0.15, "technique_tags": ["complex_reflection"], "competency_links": ["A4", "A6"], "feedback": {"immediate": "Excellent complex reflection! You''ve captured the core difference - results vs process - without judging either approach as right/wrong.", "learning_note": "Complex reflections capture value differences without taking sides in workplace conflicts."}, "next_node_id": "node_3a", "exploration_depth": "deep"}, {"id": "cp_node_2b_1", "option_text": "This butting heads is creating tension for both of you and the team.", "preview_hint": "This reflects the impact", "rapport_impact": 1, "trust_impact": 1, "tone_shift": 0.15, "technique_tags": ["reflection"], "competency_links": ["A6"], "feedback": {"immediate": "Good reflection! You''ve acknowledged that both are frustrated and this is affecting the team dynamic.", "learning_note": "Reflecting team impact helps colleagues see the broader consequences of conflict."}, "next_node_id": "node_3b", "exploration_depth": "surface"}], "is_endpoint": false, "endpoint_type": null}, "node_3a": {"id": "node_3a", "persona_text": "Yes! And honestly, I need Morgan''s collaborative approach sometimes. And Morgan probably needs my decisiveness other times.", "persona_mood": "insightful_integrating", "themes": ["Integration", "Recognition"], "choice_points": [{"id": "cp_node_3a_0", "option_text": "You''re seeing value in Morgan''s approach and recognizing when your decisiveness is needed.", "preview_hint": "This captures the integration", "rapport_impact": 1, "trust_impact": 1, "tone_shift": 0.2, "technique_tags": ["complex_reflection"], "competency_links": ["A4", "A6"], "feedback": {"immediate": "Excellent! This complex reflection captures the integration they''re recognizing - both approaches have value in different situations.", "learning_note": "Complex reflections that capture integration insights help move conflicts toward collaboration."}, "next_node_id": "node_end_excellent", "exploration_depth": "deep"}], "is_endpoint": false, "endpoint_type": null}, "node_3b": {"id": "node_3b", "persona_text": "I suppose we need to find a way to work together that uses both our strengths.", "persona_mood": "collaborative_open", "themes": ["Collaboration", "Openness"], "choice_points": [{"id": "cp_node_3b_0", "option_text": "You''re willing to find a way to work together that incorporates both your decisiveness and Morgan''s collaborative approach.", "preview_hint": "This affirms willingness", "rapport_impact": 1, "trust_impact": 1, "tone_shift": 0.2, "technique_tags": ["affirmation_reflection"], "competency_links": ["A4", "A6"], "feedback": {"immediate": "Perfect! You''ve affirmed their willingness to collaborate while capturing both their strength (decisiveness) and Morgan''s value (collaboration).", "learning_note": "Affirmations in team conflicts create safety for collaboration by validating willingness to find solutions."}, "next_node_id": "node_end_good", "exploration_depth": "surface"}], "is_endpoint": false, "endpoint_type": null}, "node_end_excellent": {"id": "node_end_excellent", "persona_text": "This conversation has really helped. I think we can find a way forward that respects both our styles.", "persona_mood": "empowered_hopeful", "themes": ["Hope", "Resolution"], "choice_points": [], "is_endpoint": true, "endpoint_type": "excellent_engagement"}, "node_end_good": {"id": "node_end_good", "persona_text": "Thanks for facilitating this. We need to figure this out ourselves, but this conversation helped us start talking productively.", "persona_mood": "grateful_productive", "themes": ["Gratitude", "First_Step"], "choice_points": [], "is_endpoint": true, "endpoint_type": "good_engagement"}}}'::jsonb,
    ARRAY'[\"A4\", \"A6\", \"B6\", \"C1\"]',
    '{"dimensions": {"A4": {"description": "Diplomacy", "weight": 2.0, "positive_signals": ["neutrality", "reflection", "acknowledging_both_sides"], "negative_signals": ["taking_sides", "judgment", "biased"]}, "A6": {"description": "Rapport Building", "weight": 1.5, "positive_signals": ["reflection", "affirmation", "creating_safety"], "negative_signals": ["taking_sides", "biased_language", "dismissive"]}, "B6": {"description": "Communication", "weight": 1.0, "positive_signals": ["facilitative_language", "open_exploration", "reflective_listening"], "negative_signals": ["direct_instructions", "evaluative_language", "one_way_communication"]}, "C1": {"description": "Self-Management (Staying Neutral)", "weight": 1.5, "positive_signals": ["staying_calm_under_pressure", "not_reacting_defensively", "maintaining_neutrality"], "negative_signals": ["getting_defensive", "losing_composure", "taking_sides"]}}, "overall_scoring_logic": "weighted_average"}'::jsonb,
    '{"framework_name": "MaPS Money Guidance Competency Framework", "framework_version": "September 2022", "sections": ["A4", "A6", "B6", "C1"], "tier_relevance": "Tier 2-3 (Internal Team Working)", "domains": ["Team Dynamics & Collaboration"], "context": "Mediation and Facilitation"}'::jsonb,
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
-- WHERE code = 'colleague-team-dynamics-004';
