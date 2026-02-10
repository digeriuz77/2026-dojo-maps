-- supabase/seed/seed_customer-pensions-exploration-005.sql
-- MAPS Practice Module: Pensions Exploration: Future Planning Discussion
-- Content Type: customer_facing
--
-- Usage:
--   supabase db execute --file supabase/seed/seed_customer-pensions-exploration-005.sql
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
    '00000000-0000-0002-0001-000000000005',
    'customer-pensions-exploration-005',
    'Pensions Exploration: Future Planning Discussion',
    'customer_facing',
    'Domain 11 (Pensions)',
    'intermediate',
    12,
    'Practice facilitating pensions exploration conversations using impartial guidance that helps customers think about their future without being directive',
    'A customer is considering pension options but feels overwhelmed by the complexity and long-term implications. Your role is to use facilitative coaching - helping them explore their priorities, timeline preferences, and information needs while respecting their autonomy. Domain 11 (Pensions) requires impartial guidance that supports customer decision-making without directing outcomes.',
    '{"name": "Jordan", "role": "customer considering pensions", "background": "Age 45, thinking about pension options for the first time. Has some savings through work but feels confused by all the options and terminology. Worried about making the wrong decision.", "personality_traits": ["confused", "overwhelmed", "cautious", "seeking_guidance"], "tone_spectrum": {"word_complexity": 0.4, "sentence_length": 0.4, "emotional_expressiveness": 0.5, "disclosure_level": 0.3, "response_latency": 0.5, "confidence_level": 0.3}, "starting_tone_position": 0.3, "triggers": ["pressure_to_decide", "complex_jargon", "being_told_what_to_do", "comparisons_to_others"], "comfort_topics": ["having_options_explained", "own_pace", "clarity", "impartial_guidance"]}'::jsonb,
    '{"start_node_id": "node_1", "nodes": {"node_1": {"id": "node_1", "persona_text": "I keep hearing I need to think about my pension, but honestly, it all sounds so complicated. State pension, private pension, workplace pension... I don''t know where to start.", "persona_mood": "overwhelmed_confused", "themes": ["Overwhelm", "Information_Overload"], "choice_points": [{"id": "cp_node_1_0", "option_text": "Let me explain the differences between State pension, private pensions, and workplace pensions.", "preview_hint": "This jumps to education", "rapport_impact": 0, "trust_impact": 0, "tone_shift": 0.0, "technique_tags": ["education"], "competency_links": [], "feedback": {"immediate": "You''ve jumped to education before understanding their experience. In pensions work, we help customers identify their questions first before providing information.", "learning_note": "Domain 11 guidance: explore before educate. What matters most to them?"}, "next_node_id": "node_2a", "exploration_depth": "surface"}, {"id": "cp_node_1_1", "option_text": "The different pension options feel confusing and overwhelming to figure out.", "preview_hint": "This reflects their experience", "rapport_impact": 1, "trust_impact": 1, "tone_shift": 0.15, "technique_tags": ["simple_reflection"], "competency_links": ["A6", "A3"], "feedback": {"immediate": "Excellent reflection! You''ve validated their feeling of overwhelm without dismissing it. This creates safety for exploring their concerns.", "learning_note": "Reflecting pension overwhelm validates their experience and reduces defensiveness."}, "next_node_id": "node_2b", "exploration_depth": "surface"}, {"id": "cp_node_1_2", "option_text": "What concerns do you have about your pension situation?", "preview_hint": "This invites exploration", "rapport_impact": 0, "trust_impact": 0, "tone_shift": 0.0, "technique_tags": ["open_question"], "competency_links": [], "feedback": {"immediate": "Perfect! This open question invites them to share their specific concerns. Their answers will help you provide relevant, targeted information.", "learning_note": "Open questions help identify what customers actually need to know about pensions."}, "next_node_id": "node_2c", "exploration_depth": "deep"}], "is_endpoint": false, "endpoint_type": null}, "node_2a": {"id": "node_2a", "persona_text": "I suppose. I worry about whether I''ll have enough money. And I''m confused about when I can even access my pension - the rules keep changing.", "persona_mood": "anxious_uncertain", "themes": ["Financial_Security", "Confusion"], "choice_points": [{"id": "cp_node_2a_0", "option_text": "The pension age is currently 67, but there are proposals to change it to 68. You''ll need to check regularly for updates.", "preview_hint": "This is information-dumping", "rapport_impact": 0, "trust_impact": 0, "tone_shift": 0.0, "technique_tags": ["information_dump"], "competency_links": [], "feedback": {"immediate": "You''ve provided factual information but haven''t acknowledged their anxiety. In pensions work, we address concerns first, then provide information.", "learning_note": "Address emotional concerns before factual information in pensions conversations."}, "next_node_id": "node_3a", "exploration_depth": "surface"}, {"id": "cp_node_2a_1", "option_text": "You''re worried about having enough money, and you''re also confused by the changing pension age rules.", "preview_hint": "This captures both concerns", "rapport_impact": 1, "trust_impact": 1, "tone_shift": 0.15, "technique_tags": ["complex_reflection"], "competency_links": ["A6"], "feedback": {"immediate": "Excellent! You''ve captured both their financial anxiety and their confusion about rules. This validates both concerns.", "learning_note": "Complex reflections in pensions help acknowledge multiple concerns simultaneously."}, "next_node_id": "node_3b", "exploration_depth": "surface"}], "is_endpoint": false, "endpoint_type": null}, "node_2b": {"id": "node_2b", "persona_text": "Thanks for understanding. I think what matters most is having some certainty - knowing what I''ll have and when I''ll get it.", "persona_mood": "relieved_clarity_seeking", "themes": ["Certainty", "Clarity"], "choice_points": [{"id": "cp_node_2b_0", "option_text": "Certainty is important to you - knowing what you''ll have and when you can access it.", "preview_hint": "This affirms their value", "rapport_impact": 1, "trust_impact": 1, "tone_shift": 0.15, "technique_tags": ["affirmation_reflection"], "competency_links": ["A6"], "feedback": {"immediate": "Perfect! You''ve affirmed their need for certainty while accurately reflecting their priority. This helps them feel understood.", "learning_note": "Affirmations in pensions conversations validate customer values and priorities."}, "next_node_id": "node_3c", "exploration_depth": "deep"}, {"id": "cp_node_2b_1", "option_text": "What does having certainty mean to you in terms of your pension?", "preview_hint": "This deepens exploration", "rapport_impact": 0, "trust_impact": 0, "tone_shift": 0.0, "technique_tags": ["open_question"], "competency_links": [], "feedback": {"immediate": "Excellent! This open question helps them explore what certainty means to them - essential for providing relevant guidance.", "learning_note": "Open questions about values help tailor information to individual needs."}, "next_node_id": "node_3d", "exploration_depth": "deep"}], "is_endpoint": false, "endpoint_type": null}, "node_2c": {"id": "node_2c", "persona_text": "Well, I want to know I''ll be able to cover my basic expenses. And I want to know I can access some money if I really need it for emergencies.", "persona_mood": "practical_specific", "themes": ["Practical_Needs", "Security"], "choice_points": [{"id": "cp_node_2c_0", "option_text": "So covering expenses and having emergency access are your priorities for pension planning.", "preview_hint": "This summarizes their needs", "rapport_impact": 1, "trust_impact": 1, "tone_shift": 0.15, "technique_tags": ["summary"], "competency_links": ["A6"], "feedback": {"immediate": "Excellent summary! You''ve captured their practical priorities accurately. This helps focus the conversation on what matters to them.", "learning_note": "Summaries in pensions conversations help clarify practical priorities."}, "next_node_id": "node_3e", "exploration_depth": "deep"}], "is_endpoint": false, "endpoint_type": null}, "node_3a": {"id": "node_3a", "persona_text": "That''s helpful information about the pension age, but I still need to do my own research.", "persona_mood": "polite_withdrawn", "themes": ["Autonomy", "Independence"], "choice_points": [], "is_endpoint": true, "endpoint_type": "transactional_only"}, "node_3b": {"id": "node_3b", "persona_text": "That''s good to know. I think I feel a bit clearer on what to research next.", "persona_mood": "relieved_guided", "themes": ["Relief", "Direction"], "choice_points": [], "is_endpoint": true, "endpoint_type": "good_engagement"}, "node_3c": {"id": "node_3c", "persona_text": "That''s exactly what I meant. Thanks for listening rather than just telling me things.", "persona_mood": "appreciative_collaborative", "themes": ["Collaboration", "Trust"], "choice_points": [], "is_endpoint": true, "endpoint_type": "excellent_engagement"}, "node_3d": {"id": "node_3d", "persona_text": "Covering basics and having emergency access - yeah, that sums it up. So where do I start?", "persona_mood": "ready_to_engage", "themes": ["Readiness", "Next_Steps"], "choice_points": [], "is_endpoint": true, "endpoint_type": "excellent_engagement"}, "node_3e": {"id": "node_3e", "persona_text": "This conversation has really helped. I feel like I understand my priorities better now.", "persona_mood": "empowered_confident", "themes": ["Empowerment", "Clarity"], "choice_points": [], "is_endpoint": true, "endpoint_type": "excellent_engagement"}}}'::jsonb,
    ARRAY'[\"A3\", \"A5\", \"A6\", \"B6\"]',
    '{"dimensions": {"A3": {"description": "Impartiality (Non-Directive)", "weight": 2.0, "positive_signals": ["exploratory", "presenting_options", "respecting_autonomy"], "negative_signals": ["directing_choice", "recommending_specific_options", "imposing_views"]}, "A5": {"description": "Flexibility", "weight": 1.5, "positive_signals": ["adapting_to_customer", "responsive_to_needs", "following_their_lead"], "negative_signals": ["one_size_fits_all", "rigid_approach", "formulaic"]}, "A6": {"description": "Rapport Building", "weight": 1.5, "positive_signals": ["reflection", "validation", "acknowledgment"], "negative_signals": ["information_dumping", "dismissing_concerns", "being_prescriptive"]}, "B6": {"description": "Communication", "weight": 1.0, "positive_signals": ["clear_explanations", "jargon_free", "responsive_listening"], "negative_signals": ["using_pension_jargon", "overwhelming_with_detail", "one_way_communication"]}}, "overall_scoring_logic": "weighted_average"}'::jsonb,
    '{"framework_name": "MaPS Money Guidance Competency Framework", "framework_version": "September 2022", "sections": ["A3", "A5", "A6", "B6"], "tier_relevance": "Tier 1-2 (Pensions Guidance)", "domains": ["Domain 11: Pensions"], "external_reference": "https://www.moneyandpensionsservice.org.uk/money-guidance-competency-framework"}'::jsonb,
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
-- WHERE code = 'customer-pensions-exploration-005';
