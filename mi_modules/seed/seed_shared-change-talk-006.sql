-- supabase/seed/seed_shared-change-talk-006.sql
-- MAPS Practice Module: Recognizing & Evoking Change Talk
-- Content Type: shared
--
-- Usage:
--   supabase db execute --file supabase/seed/seed_shared-change-talk-006.sql
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
    '00000000-0000-0001-0001-000000000006',
    'shared-change-talk-006',
    'Recognizing & Evoking Change Talk',
    'shared',
    'Evoking',
    'intermediate',
    15,
    'Learn to recognize different types of change talk (desire, ability, reasons, need, commitment) and use reflections and questions to evoke more',
    'Change talk is any speech that favors movement toward change. Types include Desire (wanting to change), Ability (feeling capable), Reasons (benefits of change), Need (importance of change), and Commitment (taking steps). Recognizing and evoking change talk is a core MI skill that applies universally.',
    '{"name": "Casey", "role": "person", "background": "Has been considering a change for some time. Can see both sides but is starting to lean toward making a change. Has some motivation and some concerns.", "personality_traits": ["contemplating", "ambivalent", "hopeful", "cautious"], "tone_spectrum": {"word_complexity": 0.5, "sentence_length": 0.5, "emotional_expressiveness": 0.5, "disclosure_level": 0.5, "response_latency": 0.5, "confidence_level": 0.5}, "starting_tone_position": 0.5, "triggers": ["pressure_to_decide", "being_told_what_to_do", "minimizing_difficulty", "rushing"], "comfort_topics": ["autonomy", "being_understood", "own_pace", "genuine_support"]}'::jsonb,
    '{"start_node_id": "node_1", "nodes": {"node_1": {"id": "node_1", "persona_text": "I''ve been thinking about this for a while. Part of me thinks I should make a change, and part of me isn''t so sure. I can see how it would help, but I''m also worried about the difficulty.", "persona_mood": "ambivalent_contemplating", "themes": ["Ambivalence", "Change", "Consideration"], "choice_points": [{"id": "cp_node_1_0", "option_text": "The benefits clearly outweigh the difficulties. You should just do it.", "preview_hint": "This directs toward change", "rapport_impact": -1, "trust_impact": -1, "tone_shift": -0.15, "technique_tags": ["direction_change_talk"], "competency_links": [], "feedback": {"immediate": "You''ve taken sides and pushed toward change. Instead, recognize and reflect their own change talk to help them explore it.", "learning_note": "When you hear change talk, reflect it rather than adding your own persuasion."}, "next_node_id": "node_2a", "exploration_depth": "surface"}, {"id": "cp_node_1_1", "option_text": "You''re thinking about making a change, and you can see how it would help.", "preview_hint": "This reflects desire/reason change talk", "rapport_impact": 1, "trust_impact": 1, "tone_shift": 0.15, "technique_tags": ["reflection_of_change_talk"], "competency_links": ["A6", "B6"], "feedback": {"immediate": "Excellent reflection! You''ve captured their desire and reason change talk without adding your own agenda.", "learning_note": "Reflecting change talk strengthens it and encourages more."}, "next_node_id": "node_2b", "exploration_depth": "deep"}, {"id": "cp_node_1_2", "option_text": "What worries you about the difficulty?", "preview_hint": "This focuses on sustaining talk", "rapport_impact": 0, "trust_impact": 0, "tone_shift": 0.0, "technique_tags": ["sustain_talk_question"], "competency_links": [], "feedback": {"immediate": "You''ve focused on their sustaining talk (reasons not to change) rather than their change talk. Look for opportunities to reflect change talk instead.", "learning_note": "Sustain talk favors status quo - change talk favors movement. We reflect change talk to strengthen it."}, "next_node_id": "node_2c", "exploration_depth": "surface"}], "is_endpoint": false, "endpoint_type": null}, "node_2b": {"id": "node_2b", "persona_text": "Yeah, I think it would really help. I''d feel better, and I''d probably be healthier too. And honestly, I''m starting to feel like I want to make this change for myself.", "persona_mood": "motivated_desire", "themes": ["Desire", "Reasons", "Motivation"], "choice_points": [{"id": "cp_node_2b_0", "option_text": "Great! You''re feeling better and healthier, and you want this for yourself.", "preview_hint": "This is too enthusiastic", "rapport_impact": 0, "trust_impact": 0, "tone_shift": 0.0, "technique_tags": ["enthusiastic_agreement"], "competency_links": [], "feedback": {"immediate": "You''ve agreed enthusiastically but missed the opportunity to deepen the change talk with a reflective question.", "learning_note": "After reflecting change talk, evocative questions can strengthen it further."}, "next_node_id": "node_3a", "exploration_depth": "surface"}, {"id": "cp_node_2b_1", "option_text": "You''re seeing that it would help you feel better and be healthier, and you''re feeling a personal desire to make this change.", "preview_hint": "This reflects multiple types of change talk", "rapport_impact": 1, "trust_impact": 1, "tone_shift": 0.15, "technique_tags": ["complex_reflection_change_talk"], "competency_links": ["A6", "B6"], "feedback": {"immediate": "Excellent complex reflection! You''ve captured desire, reasons, and ability - multiple types of change talk.", "learning_note": "Complex reflections can weave together multiple types of change talk."}, "next_node_id": "node_3b", "exploration_depth": "deep"}, {"id": "cp_node_2b_2", "option_text": "What else helps you feel motivated to change?", "preview_hint": "This evokes more change talk", "rapport_impact": 1, "trust_impact": 1, "tone_shift": 0.1, "technique_tags": ["evoking_question"], "competency_links": ["A6"], "feedback": {"immediate": "Perfect evoking question! This invites them to generate more change talk.", "learning_note": "Evoking questions after change talk reflections strengthen and expand motivation."}, "next_node_id": "node_3c", "exploration_depth": "deep"}], "is_endpoint": false, "endpoint_type": null}, "node_3b": {"id": "node_3b", "persona_text": "Exactly. And I think I could actually do it if I set my mind to it. I''ve done hard things before.", "persona_mood": "confident_capable", "themes": ["Ability", "Confidence", "Past_Success"], "choice_points": [{"id": "cp_node_3b_0", "option_text": "You''re feeling capable because you''ve succeeded at difficult things in the past.", "preview_hint": "This reflects ability change talk", "rapport_impact": 1, "trust_impact": 1, "tone_shift": 0.15, "technique_tags": ["reflection_of_ability"], "competency_links": ["A6"], "feedback": {"immediate": "Excellent reflection of ability change talk! You''ve captured their confidence and connected it to past success.", "learning_note": "Ability change talk reflects confidence in capacity to change."}, "next_node_id": "node_end_excellent", "exploration_depth": "deep"}], "is_endpoint": false, "endpoint_type": null}, "node_3c": {"id": "node_3c", "persona_text": "Well, I think about my family and how this would help them too. And I think about the future - I want to be around for a long time.", "persona_mood": "purposeful_connected", "themes": ["Purpose", "Connection", "Future"], "choice_points": [{"id": "cp_node_3c_0", "option_text": "So your family and your future are important motivators for making this change.", "preview_hint": "This reflects deeper reasons", "rapport_impact": 1, "trust_impact": 1, "tone_shift": 0.15, "technique_tags": ["reflection_of_reasons"], "competency_links": ["A6"], "feedback": {"immediate": "Perfect reflection! You''ve captured the deeper meaning and reasons that motivate them.", "learning_note": "Evoking questions often reveal deeper reasons for change."}, "next_node_id": "node_end_good", "exploration_depth": "deep"}], "is_endpoint": false, "endpoint_type": null}, "node_2a": {"id": "node_2a", "persona_text": "I suppose. But I don''t like being told what to do.", "persona_mood": "resistant_autonomous", "themes": ["Resistance", "Autonomy"], "choice_points": [], "is_endpoint": true, "endpoint_type": "poor_engagement"}, "node_2c": {"id": "node_2c", "persona_text": "Yeah, there are a lot of reasons to be worried. It would be really hard.", "persona_mood": "discouraged_sustaining", "themes": ["Discouragement", "Sustain_Talk"], "choice_points": [], "is_endpoint": true, "endpoint_type": "neutral_end"}, "node_3a": {"id": "node_3a", "persona_text": "Thanks. I think I''m getting there.", "persona_mood": "polite_progress", "themes": ["Politeness", "Progress"], "choice_points": [], "is_endpoint": true, "endpoint_type": "neutral_end"}, "node_end_excellent": {"id": "node_end_excellent", "persona_text": "This conversation has really helped. I feel more confident and ready to take action.", "persona_mood": "committed_ready", "themes": ["Commitment", "Readiness", "Action"], "choice_points": [], "is_endpoint": true, "endpoint_type": "excellent_engagement"}, "node_end_good": {"id": "node_end_good", "persona_text": "Thanks for listening. I feel more motivated now.", "persona_mood": "motivated_grateful", "themes": ["Motivation", "Gratitude"], "choice_points": [], "is_endpoint": true, "endpoint_type": "good_engagement"}}}'::jsonb,
    ARRAY'[\"A6\", \"B6\", \"2.1.1\"]',
    '{"dimensions": {"A6": {"description": "Rapport Building", "weight": 2.0, "positive_signals": ["reflection_of_change_talk", "evoking_questions", "complex_reflection"], "negative_signals": ["direction", "taking_sides", "premature_advice"]}, "B6": {"description": "Professional Alliance", "weight": 1.5, "positive_signals": ["recognizing_change_talk", "following_motivation", "collaborative"], "negative_signals": ["imposing_agenda", "arguing_for_change", "dismissing_sustain_talk"]}, "2.1.1": {"description": "Complex Reflective Listening", "weight": 1.5, "positive_signals": ["desire_talk", "ability_talk", "reason_talk", "need_talk", "commitment_talk"], "negative_signals": ["sustain_talk_focus", "counter_arguing", "confrontation"]}}, "overall_scoring_logic": "weighted_average"}'::jsonb,
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
-- WHERE code = 'shared-change-talk-006';
