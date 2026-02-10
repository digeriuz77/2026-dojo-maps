-- supabase/seed/seed_customer-savings-goals-004.sql
-- MAPS Practice Module: Savings Goal Setting
-- Content Type: customer_facing
--
-- Usage:
--   supabase db execute --file supabase/seed/seed_customer-savings-goals-004.sql
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
    '00000000-0000-0002-0001-000000000004',
    'customer-savings-goals-004',
    'Savings Goal Setting',
    'customer_facing',
    'Domain 5 (Budgeting & Savings)',
    'beginner',
    12,
    'Practice facilitating savings goal exploration using evoking and planning skills while helping customers identify their own motivations and strategies',
    'A customer is considering saving money but hasn''t set specific goals. Your role is to use facilitative coaching - helping them explore what matters to them, what they want to save for, and how they might approach it. Domain 5 (Budgeting) requires impartial guidance that supports customer decision-making without directing outcomes.',
    '{"name": "Casey", "role": "customer", "background": "Age 28, wants to save but hasn''t set specific goals. Has some disposable income but tends to spend impulsively. Knows they should save but lacks motivation and specific direction.", "personality_traits": ["hopeful", "uncertain", "motivated_but_vague", "impulsive"], "tone_spectrum": {"word_complexity": 0.5, "sentence_length": 0.5, "emotional_expressiveness": 0.5, "disclosure_level": 0.4, "response_latency": 0.5, "confidence_level": 0.4}, "starting_tone_position": 0.4, "triggers": ["being_told_what_to_save_for", "pressure", "judgment_about_spending", "prescriptive_advice"], "comfort_topics": ["own_goals", "autonomy", "exploration", "support"]}'::jsonb,
    '{"start_node_id": "node_1", "nodes": {"node_1": {"id": "node_1", "persona_text": "I know I should be saving money, but honestly, I''m not really sure what I''m saving for. I just know I should have something put aside.", "persona_mood": "uncertain_vague", "themes": ["Uncertainty", "Should_Mindset", "Vague_Motivation"], "choice_points": [{"id": "cp_node_1_0", "option_text": "You should save for an emergency fund first - that''s the most important. Everyone needs three to six months of expenses.", "preview_hint": "This prescribes goals", "rapport_impact": -1, "trust_impact": -1, "tone_shift": -0.15, "technique_tags": ["prescriptive"], "competency_links": [], "feedback": {"immediate": "You''ve prescribed what they should save for rather than exploring what matters to them. Their goals should come from them.", "learning_note": "Savings goals work best when they''re personally meaningful, not prescribed."}, "next_node_id": "node_2a", "exploration_depth": "surface"}, {"id": "cp_node_1_1", "option_text": "You know you should be saving, but you''re not sure what your goals are.", "preview_hint": "This reflects their experience", "rapport_impact": 1, "trust_impact": 1, "tone_shift": 0.15, "technique_tags": ["simple_reflection"], "competency_links": ["A6", "A3"], "feedback": {"immediate": "Good reflection! You''ve captured their uncertainty without judgment.", "learning_note": "Reflections of uncertainty are non-judgmental and create safety."}, "next_node_id": "node_2b", "exploration_depth": "surface"}, {"id": "cp_node_1_2", "option_text": "What kinds of things might you want to save for? What would feel meaningful to have money set aside for?", "preview_hint": "This invites exploration of goals", "rapport_impact": 1, "trust_impact": 1, "tone_shift": 0.1, "technique_tags": ["evoking_question"], "competency_links": ["A6"], "feedback": {"immediate": "Perfect evoking question! This invites them to explore what would be meaningful for them.", "learning_note": "Evoking questions help people identify personally meaningful goals."}, "next_node_id": "node_2c", "exploration_depth": "deep"}], "is_endpoint": false, "endpoint_type": null}, "node_2b": {"id": "node_2b", "persona_text": "Yeah. I mean, I know saving is important. I just haven''t really thought about what I''m working toward.", "persona_mood": "acknowledging_open", "themes": ["Acknowledgment", "Openness", "Lack_of_Clarity"], "choice_points": [{"id": "cp_node_2b_0", "option_text": "What matters to you in life? Sometimes understanding our values can help clarify saving goals.", "preview_hint": "This connects goals to values", "rapport_impact": 1, "trust_impact": 1, "tone_shift": 0.1, "technique_tags": ["values_exploration"], "competency_links": ["A6", "A3"], "feedback": {"immediate": "Excellent values exploration! This helps connect saving to what matters most to them.", "learning_note": "Connecting goals to values creates intrinsic motivation."}, "next_node_id": "node_3a", "exploration_depth": "deep"}], "is_endpoint": false, "endpoint_type": null}, "node_2c": {"id": "node_2c", "persona_text": "Well, I''ve thought about maybe traveling sometime. And I know I''ll need a car eventually. And honestly, having some security would feel good.", "persona_mood": "exploring_emerging", "themes": ["Emerging_Goals", "Possibilities", "Security"], "choice_points": [{"id": "cp_node_2c_0", "option_text": "So you''re thinking about travel, a future car, and having financial security - those are all meaningful goals.", "preview_hint": "This reflects their goals", "rapport_impact": 1, "trust_impact": 1, "tone_shift": 0.15, "technique_tags": ["summary_of_goals"], "competency_links": ["A6"], "feedback": {"immediate": "Excellent summary! You''ve captured their emerging goals and validated them.", "learning_note": "Summaries of emerging goals help people see their own thinking clearly."}, "next_node_id": "node_3b", "exploration_depth": "deep"}, {"id": "cp_node_2c_1", "option_text": "Which of those feels most important or exciting to you right now?", "preview_hint": "This explores priority", "rapport_impact": 1, "trust_impact": 1, "tone_shift": 0.1, "technique_tags": ["priority_exploration"], "competency_links": ["A6"], "feedback": {"immediate": "Perfect priority question! This helps them identify what feels most motivating right now.", "learning_note": "Priority questions help identify the most motivating goals."}, "next_node_id": "node_3c", "exploration_depth": "deep"}], "is_endpoint": false, "endpoint_type": null}, "node_3a": {"id": "node_3a", "persona_text": "Well, I value freedom and experiences. And I guess security matters to me too - I don''t want to be stressed about money.", "persona_mood": "values_emerging", "themes": ["Values", "Freedom", "Security"], "choice_points": [{"id": "cp_node_3a_0", "option_text": "So freedom, experiences, and security are important values for you. How might saving connect to those values?", "preview_hint": "This links savings to values", "rapport_impact": 1, "trust_impact": 1, "tone_shift": 0.15, "technique_tags": ["values_linking"], "competency_links": ["A6", "A3"], "feedback": {"immediate": "Excellent values linking! You''re helping them see how saving supports what matters to them.", "learning_note": "Linking savings to values creates intrinsic motivation."}, "next_node_id": "node_4a", "exploration_depth": "deep"}], "is_endpoint": false, "endpoint_type": null}, "node_3b": {"id": "node_3b", "persona_text": "Yeah, and hearing them listed like that makes them feel more real. Like these are actually things I could work toward.", "persona_mood": "motivated_realizing", "themes": ["Motivation", "Realization", "Possibility"], "choice_points": [{"id": "cp_node_3b_0", "option_text": "So seeing your goals listed is helping them feel more real and possible for you.", "preview_hint": "This reflects the insight", "rapport_impact": 1, "trust_impact": 1, "tone_shift": 0.15, "technique_tags": ["reflection_of_insight"], "competency_links": ["A6"], "feedback": {"immediate": "Perfect reflection! You''ve captured how the summary is helping them see possibilities.", "learning_note": "Reflections of insights reinforce self-awareness and motivation."}, "next_node_id": "node_end_excellent", "exploration_depth": "deep"}], "is_endpoint": false, "endpoint_type": null}, "node_3c": {"id": "node_3c", "persona_text": "I think having that security would feel really good. Just knowing I have something set aside would reduce my stress.", "persona_mood": "value_clarified", "themes": ["Security", "Stress_Reduction", "Prioritized"], "choice_points": [{"id": "cp_node_3c_0", "option_text": "So security feels most important - having something set aside would give you peace of mind and reduce stress.", "preview_hint": "This captures the prioritized goal", "rapport_impact": 1, "trust_impact": 1, "tone_shift": 0.15, "technique_tags": ["goal_confirmation"], "competency_links": ["A6"], "feedback": {"immediate": "Excellent! You''ve captured their prioritized goal and the emotional benefit.", "learning_note": "Confirming prioritized goals with their emotional benefits strengthens motivation."}, "next_node_id": "node_end_excellent", "exploration_depth": "deep"}], "is_endpoint": false, "endpoint_type": null}, "node_4a": {"id": "node_4a", "persona_text": "I guess saving would give me more freedom to travel and have experiences. And security would reduce my money stress. That makes sense.", "persona_mood": "insightful_motivated", "themes": ["Insight", "Motivation", "Connection"], "choice_points": [], "is_endpoint": true, "endpoint_type": "excellent_engagement"}, "node_2a": {"id": "node_2a", "persona_text": "I suppose that makes sense. I''ll try to save for an emergency fund.", "persona_mood": "compliant_unmotivated", "themes": ["Compliance", "Lack_of_Ownership"], "choice_points": [], "is_endpoint": true, "endpoint_type": "transactional_only"}, "node_end_excellent": {"id": "node_end_excellent", "persona_text": "This has been really helpful. I feel like I have some actual goals now, not just a vague sense that I should save.", "persona_mood": "empowered_clear", "themes": ["Empowerment", "Clarity", "Motivation"], "choice_points": [], "is_endpoint": true, "endpoint_type": "excellent_engagement"}}}'::jsonb,
    ARRAY'[\"A3\", \"A5\", \"A6\", \"B6\"]',
    '{"dimensions": {"A3": {"description": "Impartiality (Non-Directive)", "weight": 2.0, "positive_signals": ["exploration", "their_goals", "values_based"], "negative_signals": ["prescriptive", "imposing_goals", "directing"]}, "A5": {"description": "Flexibility", "weight": 1.5, "positive_signals": ["responsive", "following_lead", "adapting"], "negative_signals": ["one_size_fits_all", "rigid", "formulaic"]}, "A6": {"description": "Rapport Building", "weight": 1.5, "positive_signals": ["reflection", "affirmation", "evoking"], "negative_signals": ["prescribing", "imposing_values", "being_expert"]}, "B6": {"description": "Communication", "weight": 1.0, "positive_signals": ["open_exploration", "collaborative", "questioning"], "negative_signals": ["directive", "lecture", "one_way"]}}, "overall_scoring_logic": "weighted_average"}'::jsonb,
    '{"framework_name": "MaPS Money Guidance Competency Framework", "framework_version": "September 2022", "sections": ["A3", "A5", "A6", "B6"], "tier_relevance": "Tier 1-2 (Savings Guidance)", "domains": ["Domain 5: Budgeting & Savings"], "context": "Savings Goal Setting"}'::jsonb,
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
-- WHERE code = 'customer-savings-goals-004';
