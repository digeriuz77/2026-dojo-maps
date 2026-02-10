-- supabase/seed/seed_customer-debt-initial-001.sql
-- MAPS Practice Module: Debt Advice: Initial Engagement
-- Content Type: customer_facing
--
-- Usage:
--   supabase db execute --file supabase/seed/seed_customer-debt-initial-001.sql
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
    '00000000-0000-0002-0001-000000000001',
    'customer-debt-initial-001',
    'Debt Advice: Initial Engagement',
    'customer_facing',
    'Building Rapport in Debt Context',
    'beginner',
    10,
    'Practice initial engagement with a customer seeking debt advice, using reflections to build trust while exploring their situation',
    'A customer has been referred or come in for debt advice. They may feel ashamed, overwhelmed, or defensive. Your role is to build rapport, understand their situation from their perspective, and help them feel heard without judgment. This scenario applies core reflection skills to a specific MAPS Domain 2 (Debt) context.',
    '{"name": "Jordan", "role": "customer seeking debt advice", "background": "Has multiple debts including credit cards, payday loans, and arrears. Feeling overwhelmed and ashamed. Referred by a friend who suggested they get help.", "personality_traits": ["embarrassed", "overwhelmed", "hopeless", "defensive"], "tone_spectrum": {"word_complexity": 0.3, "sentence_length": 0.3, "emotional_expressiveness": 0.4, "disclosure_level": 0.2, "response_latency": 0.4, "confidence_level": 0.2}, "starting_tone_position": 0.2, "triggers": ["judgment about spending", "being told what to do", "being asked about income", "feeling blamed"], "comfort_topics": ["being understood", "not being judged", "having options", "taking control"]}'::jsonb,
    '{"start_node_id": "node_1", "nodes": {"node_1": {"id": "node_1", "persona_text": "I... I didn''t want to come here. My friend said I should, but I don''t know what you can do that I can''t do myself.", "persona_mood": "embarrassed_defensive", "themes": ["Shame", "Hesitation"], "choice_points": [{"id": "cp_node_1_0", "option_text": "Many people feel that way at first, but debt advice can really help you get back on track.", "preview_hint": "This is reassurance, not reflection", "rapport_impact": 0, "trust_impact": 0, "tone_shift": 0.0, "technique_tags": ["reassurance"], "competency_links": [], "feedback": {"immediate": "This is reassurance rather than reflecting what they said. While well-intentioned, it misses their hesitation and doesn''t show you understand their perspective.", "learning_note": "In debt advice, reflecting emotions helps customers feel heard rather than persuaded."}, "next_node_id": "node_2a", "exploration_depth": "surface"}, {"id": "cp_node_1_1", "option_text": "You didn''t really want to come today, and you''re not sure how anyone can help.", "preview_hint": "This reflects both their reluctance and doubt", "rapport_impact": 1, "trust_impact": 1, "tone_shift": 0.15, "technique_tags": ["simple_reflection"], "competency_links": ["A6"], "feedback": {"immediate": "Excellent! This reflection captures both their reluctance and their uncertainty about how debt advice helps. It validates their feelings without judging.", "learning_note": "Reflecting hesitation builds trust - it shows you hear them, not just their debt."}, "next_node_id": "node_2b", "exploration_depth": "surface"}, {"id": "cp_node_1_2", "option_text": "What do you think a debt adviser can help you with?", "preview_hint": "This question invites but may feel challenging", "rapport_impact": 0, "trust_impact": 0, "tone_shift": 0.0, "technique_tags": ["open_question"], "competency_links": [], "feedback": {"immediate": "This is an open question, but after sharing something vulnerable, they might benefit from having their feelings reflected first.", "learning_note": "Questions can work, but following a reflection with a question usually builds more trust."}, "next_node_id": "node_2c", "exploration_depth": "surface"}], "is_endpoint": false, "endpoint_type": null}, "node_2a": {"id": "node_2a", "persona_text": "I suppose. It''s just... I''ve got myself into this mess, haven''t I? I should be able to sort it out.", "persona_mood": "self_blaming", "themes": ["Shame", "Self-Blame"], "choice_points": [{"id": "cp_node_2a_0", "option_text": "Well, you''ve accumulated these debts, but lots of people struggle with debt.", "preview_hint": "This acknowledges but dismisses their feelings", "rapport_impact": 0, "trust_impact": 0, "tone_shift": 0.0, "technique_tags": ["normalizing"], "competency_links": [], "feedback": {"immediate": "You''ve acknowledged their situation but not their emotional experience. They''re feeling shame and blame - reflecting that would help more.", "learning_note": "Debt conversations often involve shame - reflecting the emotion, not just the facts, builds trust."}, "next_node_id": "node_3a", "exploration_depth": "surface"}, {"id": "cp_node_2a_1", "option_text": "You feel like you should be able to handle this yourself, and that bothers you.", "preview_hint": "This reflects the self-blame", "rapport_impact": 1, "trust_impact": 1, "tone_shift": 0.15, "technique_tags": ["simple_reflection"], "competency_links": ["A6", "B6"], "feedback": {"immediate": "Good reflection. You''ve captured both their sense of responsibility and their discomfort about needing help. This helps them feel understood rather than judged.", "learning_note": "Reflecting self-blame without arguing helps reduce shame in debt conversations."}, "next_node_id": "node_3b", "exploration_depth": "surface"}], "is_endpoint": false, "endpoint_type": null}, "node_2b": {"id": "node_2b", "persona_text": "Yeah. I''m just... I''m embarrassed, to be honest. I never thought I''d be in this position.", "persona_mood": "vulnerable_open", "themes": ["Shame", "Vulnerability"], "choice_points": [{"id": "cp_node_2b_0", "option_text": "There''s no need to be embarrassed - debt is very common and you''re doing the right thing by coming here.", "preview_hint": "This is reassurance/dismissal", "rapport_impact": 0, "trust_impact": 0, "tone_shift": 0.0, "technique_tags": ["reassurance"], "competency_links": [], "feedback": {"immediate": "While intended to be supportive, dismissing their embarrassment doesn''t help them feel understood. They''ve just shared something vulnerable.", "learning_note": "When someone shares shame in debt conversations, reflecting it validates their courage in coming."}, "next_node_id": "node_3c", "exploration_depth": "surface"}, {"id": "cp_node_2b_1", "option_text": "You''re feeling embarrassed about being in this position.", "preview_hint": "This reflects their emotion", "rapport_impact": 1, "trust_impact": 1, "tone_shift": 0.15, "technique_tags": ["simple_reflection"], "competency_links": ["A6", "B6"], "feedback": {"immediate": "Excellent. By simply reflecting their embarrassment without trying to fix it, you''ve created space for them to share more. This builds trust.", "learning_note": "Naming difficult emotions in debt conversations - when reflected, not fixed - helps customers process them."}, "next_node_id": "node_3d", "exploration_depth": "surface"}], "is_endpoint": false, "endpoint_type": null}, "node_2c": {"id": "node_2c", "persona_text": "I don''t know really. Maybe help me work out a plan? Or talk to my creditors? I''m not sure what happens here.", "persona_mood": "uncertain_open", "themes": ["Information-Seeking", "Openness"], "choice_points": [{"id": "cp_node_2c_0", "option_text": "I can help with both of those things. We can look at your situation, work out a budget, and I can even negotiate with creditors for you.", "preview_hint": "This jumps to solutions too quickly", "rapport_impact": 0, "trust_impact": 0, "tone_shift": 0.0, "technique_tags": ["information"], "competency_links": [], "feedback": {"immediate": "You''ve provided helpful information, but by jumping to solutions you haven''t explored their feelings about the situation. Building rapport comes first.", "learning_note": "In debt advice, understanding the customer''s emotional experience is as important as explaining the process."}, "next_node_id": "node_3e", "exploration_depth": "surface"}, {"id": "cp_node_2c_1", "option_text": "So you''re wondering what debt advice actually involves - whether it''s about planning, or talking to creditors, or something else.", "preview_hint": "This reflects their uncertainty", "rapport_impact": 1, "trust_impact": 1, "tone_shift": 0.15, "technique_tags": ["complex_reflection"], "competency_links": ["A6", "B6"], "feedback": {"immediate": "Excellent complex reflection! You''ve captured their uncertainty about the process while implicitly showing the range of what you can help with.", "learning_note": "Complex reflections in debt conversations can acknowledge both the question and the range of possibilities."}, "next_node_id": "node_3f", "exploration_depth": "surface"}], "is_endpoint": false, "endpoint_type": null}, "node_3a": {"id": "node_3a", "persona_text": "I suppose. But can we just get on with it? I don''t really want to talk about my feelings.", "persona_mood": "defensive_closed", "themes": ["Avoidance"], "choice_points": [], "is_endpoint": true, "endpoint_type": "transactional_only"}, "node_3b": {"id": "node_3b", "persona_text": "Yeah. But I guess that''s why I''m here, isn''t it? Because I can''t do it alone anymore.", "persona_mood": "accepting_hopeful", "themes": ["Readiness", "Hope"], "choice_points": [], "is_endpoint": true, "endpoint_type": "good_engagement"}, "node_3c": {"id": "node_3c", "persona_text": "Maybe you''re right. But it''s still hard to admit, you know?", "persona_mood": "vulnerability_acknowledged", "themes": ["Trust Building"], "choice_points": [], "is_endpoint": true, "endpoint_type": "good_engagement"}, "node_3d": {"id": "node_3d", "persona_text": "Yeah. Thanks for saying that. It helps to not feel judged.", "persona_mood": "relieved_trusting", "themes": ["Trust", "Relief"], "choice_points": [], "is_endpoint": true, "endpoint_type": "excellent_engagement"}, "node_3e": {"id": "node_3e", "persona_text": "Oh, okay. That sounds helpful I suppose.", "persona_mood": "neutral_polite", "themes": ["Information Received"], "choice_points": [], "is_endpoint": true, "endpoint_type": "transactional_only"}, "node_3f": {"id": "node_3f", "persona_text": "That''s helpful to know. I''m feeling a bit lost with it all to be honest.", "persona_mood": "open_admitting", "themes": ["Vulnerability", "Opening Up"], "choice_points": [], "is_endpoint": true, "endpoint_type": "excellent_engagement"}}}'::jsonb,
    ARRAY'[\"A6\", \"A3\", \"A5\", \"B6\"]',
    '{"dimensions": {"A6": {"description": "Rapport Building", "weight": 2.0, "positive_signals": ["simple_reflection", "complex_reflection", "emotional_reflection"], "negative_signals": ["reassurance_too_early", "dismissal", "jumping_to_solutions"]}, "A3": {"description": "Impartiality (Non-Judgmental)", "weight": 1.5, "positive_signals": ["reflection_without_judgment", "validating_embarrassment", "normalizing_shame"], "negative_signals": ["blaming_language", "moral_judgment", "criticism"]}, "B6": {"description": "Communication", "weight": 1.5, "positive_signals": ["clear_reflection", "appropriate_emotion_language", "listening_indicators"], "negative_signals": ["jargon", "information_dumping", "interrupting"]}}, "overall_scoring_logic": "weighted_average"}'::jsonb,
    '{"framework_name": "MaPS Money Guidance Competency Framework", "framework_version": "September 2022", "sections": ["A3", "A6", "B6"], "tier_relevance": "Tier 1-2 (Debt Advice)", "domains": ["Domain 2: Debt"], "external_reference": "https://www.moneyandpensionsservice.org.uk/money-guidance-competency-framework"}'::jsonb,
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
-- WHERE code = 'customer-debt-initial-001';
