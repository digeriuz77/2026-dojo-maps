-- supabase/seed/seed_customer-financial-anxiety-003.sql
-- MAPS Practice Module: Supporting Financial Anxiety
-- Content Type: customer_facing
--
-- Usage:
--   supabase db execute --file supabase/seed/seed_customer-financial-anxiety-003.sql
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
    '00000000-0000-0002-0001-000000000003',
    'customer-financial-anxiety-003',
    'Supporting Financial Anxiety',
    'customer_facing',
    'Domain 1 (Knowing Customer)',
    'intermediate',
    12,
    'Practice supporting customers experiencing financial anxiety using reflection, normalization, and exploration while maintaining professional boundaries',
    'A customer is experiencing significant anxiety about their financial situation. They may feel overwhelmed, ashamed, or hopeless. Your role is to use MI skills to provide emotional support, normalize their experience, and help them explore their concerns without becoming therapeutic or directive. Domain 1 (Knowing Your Customer) requires understanding the person behind the problem.',
    '{"name": "Alex", "role": "customer", "background": "Age 35, experiencing significant financial stress due to debt and expenses. Feeling overwhelmed and anxious. Has been avoiding dealing with finances because it feels too stressful. Some shame about the situation.", "personality_traits": ["anxious", "overwhelmed", "ashamed", "avoidant"], "tone_spectrum": {"word_complexity": 0.4, "sentence_length": 0.4, "emotional_expressiveness": 0.6, "disclosure_level": 0.3, "response_latency": 0.6, "confidence_level": 0.2}, "starting_tone_position": 0.2, "triggers": ["judgment", "pressure_to_act_quickly", "dismissal_of_feelings", "being_told_what_to_do"], "comfort_topics": ["being_understood", "validation", "non_judgmental_support", "going_at_own_pace"]}'::jsonb,
    '{"start_node_id": "node_1", "nodes": {"node_1": {"id": "node_1", "persona_text": "Honestly, I''m really stressed about my finances. I can barely sleep, and I feel like I''m drowning. I don''t know how I got here, and I don''t see a way out.", "persona_mood": "overwhelmed_anxious", "themes": ["Overwhelm", "Anxiety", "Hopelessness"], "choice_points": [{"id": "cp_node_1_0", "option_text": "Don''t worry, lots of people are in the same situation. You''ll get through it.", "preview_hint": "This minimizes their feelings", "rapport_impact": -1, "trust_impact": -1, "tone_shift": -0.15, "technique_tags": ["minimizing"], "competency_links": [], "feedback": {"immediate": "You''ve minimized their feelings rather than acknowledging their distress. When someone is anxious, they need validation, not reassurance that minimizes.", "learning_note": "Financial anxiety requires acknowledgment and validation, not minimization."}, "next_node_id": "node_2a", "exploration_depth": "surface"}, {"id": "cp_node_1_1", "option_text": "You''re feeling really overwhelmed and stressed, and it''s affecting your sleep. You feel like you''re drowning and don''t see a way out.", "preview_hint": "This reflects their experience", "rapport_impact": 1, "trust_impact": 1, "tone_shift": 0.15, "technique_tags": ["complex_reflection"], "competency_links": ["A6", "A1"], "feedback": {"immediate": "Excellent complex reflection! You''ve captured the depth of their distress without judgment or minimization.", "learning_note": "Complex reflections of financial distress show understanding without judgment."}, "next_node_id": "node_2b", "exploration_depth": "deep"}, {"id": "cp_node_1_2", "option_text": "You need to stop avoiding this and start dealing with it. The first step is creating a budget.", "preview_hint": "This directs and pressures", "rapport_impact": -1, "trust_impact": -1, "tone_shift": -0.2, "technique_tags": ["premature_direction"], "competency_links": [], "feedback": {"immediate": "You''ve jumped to direction before acknowledging their emotional state. Anxious customers need support before solutions.", "learning_note": "Financial anxiety requires emotional support before practical solutions."}, "next_node_id": "node_2c", "exploration_depth": "surface"}], "is_endpoint": false, "endpoint_type": null}, "node_2b": {"id": "node_2b", "persona_text": "Exactly. And honestly, I feel ashamed that I let it get this bad. I should have managed things better.", "persona_mood": "ashamed_self_critical", "themes": ["Shame", "Self-Criticism", "Regret"], "choice_points": [{"id": "cp_node_2b_0", "option_text": "You shouldn''t be ashamed. These things happen to everyone.", "preview_hint": "This dismisses the shame", "rapport_impact": 0, "trust_impact": 0, "tone_shift": 0.0, "technique_tags": ["dismissive_reassurance"], "competency_links": [], "feedback": {"immediate": "You''ve dismissed their shame rather than understanding it. Shame needs acknowledgment and normalization, not dismissal.", "learning_note": "Shame about finances needs acknowledgment, not dismissal."}, "next_node_id": "node_3a", "exploration_depth": "surface"}, {"id": "cp_node_2b_1", "option_text": "You''re feeling ashamed that things got this difficult, and you''re being hard on yourself for not managing better.", "preview_hint": "This reflects the shame", "rapport_impact": 1, "trust_impact": 1, "tone_shift": 0.15, "technique_tags": ["reflection_of_shame"], "competency_links": ["A6", "A1"], "feedback": {"immediate": "Excellent reflection! You''ve acknowledged their shame without judgment, which creates safety.", "learning_note": "Reflecting shame without judgment helps people feel safe despite their distress."}, "next_node_id": "node_3b", "exploration_depth": "deep"}, {"id": "cp_node_2b_2", "option_text": "Many people experience financial difficulties and feel similarly ashamed. It''s a very common response.", "preview_hint": "This normalizes the experience", "rapport_impact": 1, "trust_impact": 1, "tone_shift": 0.1, "technique_tags": ["normalization"], "competency_links": ["A6"], "feedback": {"immediate": "Good normalization! This helps them see they''re not alone in feeling ashamed.", "learning_note": "Normalization helps reduce shame by showing it''s a common experience."}, "next_node_id": "node_3c", "exploration_depth": "deep"}], "is_endpoint": false, "endpoint_type": null}, "node_3b": {"id": "node_3b", "persona_text": "Yeah. And I''ve been avoiding dealing with it because it just feels too overwhelming. Every time I think about it, I get anxious.", "persona_mood": "avoidant_anxious", "themes": ["Avoidance", "Overwhelm", "Anxiety"], "choice_points": [{"id": "cp_node_3b_0", "option_text": "So you''ve been avoiding thinking about your finances because it feels too overwhelming and makes you anxious.", "preview_hint": "This reflects the avoidance", "rapport_impact": 1, "trust_impact": 1, "tone_shift": 0.15, "technique_tags": ["reflection_of_avoidance"], "competency_links": ["A6"], "feedback": {"immediate": "Perfect reflection! You''ve captured the avoidance cycle without judgment.", "learning_note": "Reflecting avoidance without judgment helps people understand their patterns."}, "next_node_id": "node_4a", "exploration_depth": "deep"}], "is_endpoint": false, "endpoint_type": null}, "node_3c": {"id": "node_3c", "persona_text": "Really? I thought I was the only one who felt this way about money problems.", "persona_mood": "surprised_relieved", "themes": ["Surprise", "Relief", "Connection"], "choice_points": [{"id": "cp_node_3c_0", "option_text": "Yes, financial difficulties often bring up strong feelings. It''s a very human response to a stressful situation.", "preview_hint": "This normalizes with empathy", "rapport_impact": 1, "trust_impact": 1, "tone_shift": 0.15, "technique_tags": ["empathetic_normalization"], "competency_links": ["A6", "A1"], "feedback": {"immediate": "Excellent empathetic normalization! You''ve validated their experience and reduced isolation.", "learning_note": "Normalization with empathy reduces shame and isolation."}, "next_node_id": "node_4b", "exploration_depth": "deep"}], "is_endpoint": false, "endpoint_type": null}, "node_2a": {"id": "node_2a", "persona_text": "I suppose. But it doesn''t feel like that helps much.", "persona_mood": "dismissed_unheard", "themes": ["Dismissed", "Unheard"], "choice_points": [], "is_endpoint": true, "endpoint_type": "poor_engagement"}, "node_2c": {"id": "node_2c", "persona_text": "I know I should deal with it, but I can''t right now. This is too much pressure.", "persona_mood": "pressured_withdrawing", "themes": ["Pressure", "Withdrawal"], "choice_points": [], "is_endpoint": true, "endpoint_type": "poor_engagement"}, "node_3a": {"id": "node_3a", "persona_text": "I suppose you''re right, but I still feel terrible about it.", "persona_mood": "polite_ashamed", "themes": ["Politeness", "Shame"], "choice_points": [], "is_endpoint": true, "endpoint_type": "neutral_end"}, "node_4a": {"id": "node_4a", "persona_text": "That''s exactly it. And talking about it like this actually helps. I feel a bit less alone with it.", "persona_mood": "relieved_connected", "themes": ["Relief", "Connection", "Less_Alone"], "choice_points": [], "is_endpoint": true, "endpoint_type": "excellent_engagement"}, "node_4b": {"id": "node_4b", "persona_text": "This has been really helpful. I don''t feel quite so ashamed now, and I feel like I might be able to face this eventually.", "persona_mood": "hopeful_grateful", "themes": ["Hope", "Gratitude", "Possibility"], "choice_points": [], "is_endpoint": true, "endpoint_type": "excellent_engagement"}}}'::jsonb,
    ARRAY'[\"A1\", \"A6\", \"B6\"]',
    '{"dimensions": {"A1": {"description": "Understanding the Person", "weight": 2.0, "positive_signals": ["empathy", "acknowledging_distress", "non_judgmental"], "negative_signals": ["dismissive", "judgmental", "minimizing"]}, "A6": {"description": "Rapport Building", "weight": 1.5, "positive_signals": ["validation", "normalization", "reflection"], "negative_signals": ["dismissing_feelings", "premature_solutions", "being_expert"]}, "B6": {"description": "Communication", "weight": 1.5, "positive_signals": ["empathetic", "supportive", "paced"], "negative_signals": ["directive", "pressuring", "insensitive"]}}, "overall_scoring_logic": "weighted_average"}'::jsonb,
    '{"framework_name": "MaPS Money Guidance Competency Framework", "framework_version": "September 2022", "sections": ["A1", "A6", "B6"], "tier_relevance": "Tier 1-2 (Customer Support)", "domains": ["Domain 1: Knowing Your Customer"], "context": "Financial Stress and Anxiety"}'::jsonb,
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
-- WHERE code = 'customer-financial-anxiety-003';
