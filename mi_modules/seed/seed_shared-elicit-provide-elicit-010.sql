-- supabase/seed/seed_shared-elicit-provide-elicit-010.sql
-- MAPS Practice Module: Elicit-Provide-Elicit - Information Exchange
-- Content Type: shared
--
-- Usage:
--   supabase db execute --file supabase/seed/seed_shared-elicit-provide-elicit-010.sql
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
    '00000000-0000-0001-0001-000000000010',
    'shared-elicit-provide-elicit-010',
    'Elicit-Provide-Elicit - Information Exchange',
    'shared',
    'Information Giving',
    'intermediate',
    12,
    'Learn to share information in a way that respects autonomy by eliciting first, providing information with permission, then eliciting understanding and reactions',
    'Elicit-Provide-Elicit (EPE) is a collaborative approach to information sharing. Instead of giving unsolicited advice, we first elicit what the person already knows, ask permission to share information, provide it neutrally, then elicit their understanding and reactions. This applies universally to customer and colleague contexts.',
    '{"name": "Jordan", "role": "person", "background": "Is considering options and may need information to make decisions. Values autonomy and prefers to come to their own conclusions rather than being told what to do.", "personality_traits": ["autonomous", "curious", "thoughtful", "independent"], "tone_spectrum": {"word_complexity": 0.5, "sentence_length": 0.5, "emotional_expressiveness": 0.4, "disclosure_level": 0.4, "response_latency": 0.5, "confidence_level": 0.5}, "starting_tone_position": 0.5, "triggers": ["unsolicited_advice", "being_told_what_to_do", "information_dumping", "expert_posturing"], "comfort_topics": ["permission", "autonomy", "collaboration", "respect"]}'::jsonb,
    '{"start_node_id": "node_1", "nodes": {"node_1": {"id": "node_1", "persona_text": "I''m trying to figure out my options, but I''m not sure what''s available or what would work best for me.", "persona_mood": "curious_uncertain", "themes": ["Curiosity", "Uncertainty", "Options"], "choice_points": [{"id": "cp_node_1_0", "option_text": "Let me tell you about the main options. Option A has these benefits... Option B has these benefits...", "preview_hint": "This provides unsolicited information", "rapport_impact": 0, "trust_impact": 0, "tone_shift": 0.0, "technique_tags": ["information_dump"], "competency_links": [], "feedback": {"immediate": "You''ve jumped to providing information without first understanding what they already know or want. Elicit first.", "learning_note": "EPE starts with eliciting - understanding what they know before sharing."}, "next_node_id": "node_2a", "exploration_depth": "surface"}, {"id": "cp_node_1_1", "option_text": "What have you already heard about the options available to you?", "preview_hint": "This elicits first", "rapport_impact": 1, "trust_impact": 1, "tone_shift": 0.1, "technique_tags": ["elicit_knowledge"], "competency_links": ["A6", "A3"], "feedback": {"immediate": "Perfect elicitation! This starts the EPE process by understanding what they already know.", "learning_note": "Eliciting first respects their autonomy and avoids information they already have."}, "next_node_id": "node_2b", "exploration_depth": "deep"}, {"id": "cp_node_1_2", "option_text": "What would be most helpful for you to know right now?", "preview_hint": "This elicits information needs", "rapport_impact": 1, "trust_impact": 1, "tone_shift": 0.1, "technique_tags": ["elicit_needs"], "competency_links": ["A6"], "feedback": {"immediate": "Excellent question! This elicits what information would be most relevant to them right now.", "learning_note": "Eliciting information needs ensures relevance and respects priorities."}, "next_node_id": "node_2c", "exploration_depth": "deep"}], "is_endpoint": false, "endpoint_type": null}, "node_2b": {"id": "node_2b", "persona_text": "I''ve heard about a few options, but I''m not sure I understand them fully or which would be best for my situation.", "persona_mood": "seeking_clarity", "themes": ["Information_Gap", "Clarity_Seeking", "Decision_Making"], "choice_points": [{"id": "cp_node_2b_0", "option_text": "I can explain the options to you. Here''s what you need to know...", "preview_hint": "This provides without permission", "rapport_impact": 0, "trust_impact": 0, "tone_shift": 0.0, "technique_tags": ["unsolicited_provision"], "competency_links": [], "feedback": {"immediate": "You''ve offered information without asking permission. In EPE, we ask before providing.", "learning_note": "Asking permission before sharing information respects autonomy."}, "next_node_id": "node_3a", "exploration_depth": "surface"}, {"id": "cp_node_2b_1", "option_text": "Would it be helpful if I shared some information about the options you mentioned?", "preview_hint": "This asks permission", "rapport_impact": 1, "trust_impact": 1, "tone_shift": 0.15, "technique_tags": ["permission_request"], "competency_links": ["A3", "A6"], "feedback": {"immediate": "Perfect! You''ve asked permission before providing information, which honors their autonomy.", "learning_note": "Permission requests are the heart of collaborative information sharing."}, "next_node_id": "node_3b", "exploration_depth": "deep"}], "is_endpoint": false, "endpoint_type": null}, "node_2c": {"id": "node_2c", "persona_text": "I''d like to understand the pros and cons of each option, and maybe get a sense of what might work best for someone in my situation.", "persona_mood": "focused_specific", "themes": ["Specific_Needs", "Pros_Cons", "Relevance"], "choice_points": [{"id": "cp_node_2c_0", "option_text": "I can help with that. Would you like me to share some information about the pros and cons of different options?", "preview_hint": "This combines eliciting with permission", "rapport_impact": 1, "trust_impact": 1, "tone_shift": 0.15, "technique_tags": ["permission_elicit"], "competency_links": ["A3", "A6"], "feedback": {"immediate": "Excellent! You''ve confirmed understanding of their needs and asked permission to share.", "learning_note": "EPE respects both their needs and their autonomy."}, "next_node_id": "node_3c", "exploration_depth": "deep"}], "is_endpoint": false, "endpoint_type": null}, "node_3b": {"id": "node_3b", "persona_text": "Yes, that would be helpful.", "persona_mood": "receptive_open", "themes": ["Receptiveness", "Openness"], "choice_points": [{"id": "cp_node_3b_0", "option_text": "Here''s what I can share about the options... [provides information neutrally]. What makes sense to you from what I''ve shared?", "preview_hint": "This provides and elicits understanding", "rapport_impact": 1, "trust_impact": 1, "tone_shift": 0.1, "technique_tags": ["provide_elicit"], "competency_links": ["A3", "A6"], "feedback": {"immediate": "Excellent EPE! You''ve provided information neutrally and now elicit their understanding.", "learning_note": "The final ''elicit'' checks understanding and reactions to the information."}, "next_node_id": "node_4a", "exploration_depth": "deep"}], "is_endpoint": false, "endpoint_type": null}, "node_3c": {"id": "node_3c", "persona_text": "Yes, please. I''d like to understand my options better.", "persona_mood": "engaged_interested", "themes": ["Engagement", "Interest"], "choice_points": [{"id": "cp_node_3c_0", "option_text": "Here''s some information about the pros and cons... [provides information]. What stands out to you from this?", "preview_hint": "This provides and elicits reactions", "rapport_impact": 1, "trust_impact": 1, "tone_shift": 0.1, "technique_tags": ["provide_elicit"], "competency_links": ["A3", "A6"], "feedback": {"immediate": "Perfect EPE! After providing information neutrally, you elicit their reactions.", "learning_note": "Eliciting reactions helps people process information through their own values."}, "next_node_id": "node_4b", "exploration_depth": "deep"}], "is_endpoint": false, "endpoint_type": null}, "node_2a": {"id": "node_2a", "persona_text": "Thanks for the information. I''ll think about it.", "persona_mood": "polite_withdrawn", "themes": ["Politeness", "Withdrawal"], "choice_points": [], "is_endpoint": true, "endpoint_type": "transactional_only"}, "node_3a": {"id": "node_3a", "persona_text": "Okay, go ahead. I''m listening.", "persona_mood": "passive_receiving", "themes": ["Passivity", "Reception"], "choice_points": [], "is_endpoint": true, "endpoint_type": "neutral_end"}, "node_4a": {"id": "node_4a", "persona_text": "That''s helpful. I think I understand my options better now, and I can see what might work for me.", "persona_mood": "clarity_empowered", "themes": ["Clarity", "Empowerment", "Understanding"], "choice_points": [], "is_endpoint": true, "endpoint_type": "excellent_engagement"}, "node_4b": {"id": "node_4b", "persona_text": "This really helps. I can see pros and cons I hadn''t considered. This gives me a lot to think about.", "persona_mood": "thoughtful_grateful", "themes": ["Thoughtfulness", "Gratitude", "Processing"], "choice_points": [], "is_endpoint": true, "endpoint_type": "excellent_engagement"}}}'::jsonb,
    ARRAY'[\"A3\", \"A6\", \"B6\"]',
    '{"dimensions": {"A3": {"description": "Impartiality (Non-Directive)", "weight": 2.0, "positive_signals": ["elicit_first", "permission_request", "neutral_provision"], "negative_signals": ["unsolicited_advice", "information_dump", "directive_language"]}, "A6": {"description": "Rapport Building", "weight": 1.5, "positive_signals": ["asking_permission", "respecting_autonomy", "collaborative"], "negative_signals": ["expert_positioning", "prescribing", "being_expert"]}, "B6": {"description": "Professional Alliance", "weight": 1.5, "positive_signals": ["information_exchange", "two_way", "responsive"], "negative_signals": ["one_way_communication", "lecture", "imposing_knowledge"]}}, "overall_scoring_logic": "weighted_average"}'::jsonb,
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
-- WHERE code = 'shared-elicit-provide-elicit-010';
