-- supabase/seed/seed_colleague-career-development-002.sql
-- MAPS Practice Module: Career Development: Coaching Conversation
-- Content Type: colleague_facing
--
-- Usage:
--   supabase db execute --file supabase/seed/seed_colleague-career-development-002.sql
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
    '00000000-0000-0003-0001-000000000001',
    'colleague-career-development-002',
    'Career Development: Coaching Conversation',
    'colleague_facing',
    'Colleague Coaching & Development',
    'intermediate',
    12,
    'Practice a facilitative coaching approach to career development conversations, helping colleagues explore their goals, strengths, and growth areas while respecting their autonomy',
    'A colleague is in a career development discussion. They may feel uncertain about their direction, defensive about performance, or anxious about expectations. Your role is to use a facilitative coaching approach - helping them reflect on their aspirations, recognize their strengths, and identify their own development goals. This applies core MI skills to internal workplace contexts.',
    '{"name": "Jordan", "role": "colleague", "background": "Has been in their current role for 2 years. Feeling uncertain about career direction. Considering options but unsure about their strengths or what they really want. Some anxiety about performance expectations.", "personality_traits": ["uncertain", "reflective", "cautious", "growth_oriented"], "tone_spectrum": {"word_complexity": 0.5, "sentence_length": 0.5, "emotional_expressiveness": 0.4, "disclosure_level": 0.4, "response_latency": 0.5, "confidence_level": 0.4}, "starting_tone_position": 0.4, "triggers": ["being compared to others", "pressure to decide", "judgment about choices", "unrealistic expectations"], "comfort_topics": ["being understood", "own pace", "strengths recognition", "genuine support"]}'::jsonb,
    '{"start_node_id": "node_1", "nodes": {"node_1": {"id": "node_1", "persona_text": "I''ve been thinking a lot about my career lately. Honestly, I''m not sure if I''m on the right path or if I should be making changes.", "persona_mood": "uncertain_contemplative", "themes": ["Uncertainty", "Career Direction"], "choice_points": [{"id": "cp_node_1_0", "option_text": "What direction are you thinking about? Maybe we should look at some options.", "preview_hint": "This jumps to solutions quickly", "rapport_impact": 0, "trust_impact": 0, "tone_shift": 0.0, "technique_tags": ["solution_focused"], "competency_links": [], "feedback": {"immediate": "You''ve moved quickly to exploring options before understanding their thinking. In career conversations, it''s valuable to first help them reflect on what they''re experiencing.", "learning_note": "Career conversations benefit from exploration before solution-seeking."}, "next_node_id": "node_2a", "exploration_depth": "surface"}, {"id": "cp_node_1_1", "option_text": "You''re uncertain about whether you''re on the right career path.", "preview_hint": "This reflects their uncertainty", "rapport_impact": 1, "trust_impact": 1, "tone_shift": 0.15, "technique_tags": ["simple_reflection"], "competency_links": ["A6", "B6"], "feedback": {"immediate": "Excellent reflection! You''ve captured their uncertainty without judgment. This creates safety for exploring their career concerns.", "learning_note": "Reflecting career uncertainty helps colleagues feel understood rather than pressured."}, "next_node_id": "node_2b", "exploration_depth": "surface"}, {"id": "cp_node_1_2", "option_text": "What''s making you question your career path right now?", "preview_hint": "This explores the source of uncertainty", "rapport_impact": 0, "trust_impact": 0, "tone_shift": 0.0, "technique_tags": ["open_question"], "competency_links": [], "feedback": {"immediate": "Good open question that invites exploration. After sharing something vulnerable, this helps them process their thoughts while feeling supported.", "learning_note": "Open questions about career concerns help identify underlying motivations and values."}, "next_node_id": "node_2c", "exploration_depth": "deep"}], "is_endpoint": false, "endpoint_type": null}, "node_2a": {"id": "node_2a", "persona_text": "I suppose. I enjoy some aspects of my role, but other parts feel draining. I''m wondering if there''s something better suited to my strengths.", "persona_mood": "contemplative_open", "themes": ["Strengths", "Fit", "Exploration"], "choice_points": [{"id": "cp_node_2a_0", "option_text": "Let''s look at your strengths. What do you consider your key skills?", "preview_hint": "This moves to assessment quickly", "rapport_impact": 0, "trust_impact": 0, "tone_shift": 0.0, "technique_tags": ["assessment_question"], "competency_links": [], "feedback": {"immediate": "You''ve moved quickly to assessment. In career coaching, it''s valuable to help them reflect on their experience before formalizing strengths.", "learning_note": "Career conversations work best when colleagues self-identify strengths through reflection."}, "next_node_id": "node_3a", "exploration_depth": "surface"}, {"id": "cp_node_2a_1", "option_text": "Parts of your role feel draining while other aspects work well for your strengths.", "preview_hint": "This reflects the complexity", "rapport_impact": 1, "trust_impact": 1, "tone_shift": 0.15, "technique_tags": ["complex_reflection"], "competency_links": ["A6", "B6"], "feedback": {"immediate": "Excellent complex reflection! You''ve captured both the positive (works well) and the negative (draining) aspects without judgment.", "learning_note": "Complex reflections help colleagues see the nuance in their experience."}, "next_node_id": "node_3b", "exploration_depth": "deep"}], "is_endpoint": false, "endpoint_type": null}, "node_2b": {"id": "node_2b", "persona_text": "Yeah. I think I''m good at the relationship building and problem-solving parts. But the administrative work and reporting just drains me.", "persona_mood": "self_aware_clear", "themes": ["Strengths Recognition", "Energy Analysis"], "choice_points": [{"id": "cp_node_2b_0", "option_text": "So you''ve identified relationship building and problem-solving as strengths, while administration and reporting feel draining.", "prompt": "This summarizes what they''ve shared", "rapport_impact": 1, "trust_impact": 1, "tone_shift": 0.15, "technique_tags": ["summary"], "competency_links": ["A6"], "feedback": {"immediate": "Excellent summary! You''ve captured their self-identified strengths and energy drains accurately. This helps them see their own insights validated.", "learning_note": "Summaries in career conversations confirm understanding and organize thinking."}, "next_node_id": "node_3c", "exploration_depth": "deep"}, {"id": "cp_node_2b_1", "option_text": "What is it about relationship building that gives you energy?", "prompt": "This explores strengths more deeply", "rapport_impact": 0, "trust_impact": 0, "tone_shift": 0.0, "technique_tags": ["open_question"], "competency_links": [], "feedback": {"immediate": "Perfect! Following their insight with an open question helps them explore what gives them energy. This builds self-awareness.", "learning_note": "Questions about what gives energy help identify core strengths and values."}, "next_node_id": "node_3d", "exploration_depth": "deep"}], "is_endpoint": false, "endpoint_type": null}, "node_2c": {"id": "node_2c", "persona_text": "Exactly! And I realize that when I''m doing the parts I enjoy, I''m energized. When I''m doing the draining parts, I''m exhausted.", "persona_mood": "insightful_motivated", "themes": ["Self-Awareness", "Realization"], "choice_points": [{"id": "cp_node_2c_0", "option_text": "So you''ve had a realization - your energy levels tell you a lot about what fits and what doesn''t.", "prompt": "This captures the insight", "rapport_impact": 1, "trust_impact": 1, "tone_shift": 0.15, "technique_tags": ["reflection_insight"], "competency_links": ["A6"], "feedback": {"immediate": "Perfect! You''ve amplified their own insight and named what it means. This helps them see their own thinking clearly.", "learning_note": "Amplifying insights helps colleagues recognize their own wisdom and decision-making ability."}, "next_node_id": "node_3e", "exploration_depth": "deep"}], "is_endpoint": false, "endpoint_type": null}, "node_3a": {"id": "node_3a", "persona_text": "I don''t know... I''d need to think about my options more. Maybe later we can discuss this further?", "persona_mood": "withdrawing_unsure", "themes": ["Withdrawing", "Uncertainty"], "choice_points": [], "is_endpoint": true, "endpoint_type": "needs_more_time"}, "node_3b": {"id": "node_3b", "persona_text": "That''s really helpful. I hadn''t thought about my work in that way before.", "persona_mood": "insightful_grateful", "themes": ["Gratitude", "New Perspective"], "choice_points": [], "is_endpoint": true, "endpoint_type": "good_engagement"}, "node_3c": {"id": "node_3c", "persona_text": "It does help. I think I need to explore how I could do more of what energizes me and less of what drains me.", "persona_mood": "motivated_directional", "themes": ["Direction", "Motivation"], "choice_points": [], "is_endpoint": true, "endpoint_type": "excellent_engagement"}, "node_3d": {"id": "node_3d", "persona_text": "Relationship building gives me energy because it connects me with people. Problem-solving satisfies my need to figure things out. That makes sense.", "persona_mood": "clarity_confident", "themes": ["Clarity", "Self-Understanding"], "choice_points": [], "is_endpoint": true, "endpoint_type": "excellent_engagement"}, "node_3e": {"id": "node_3e", "persona_text": "This conversation has been really helpful. I feel like I have a clearer sense of what I want and what I don''t want in my next role.", "persona_mood": "empowered_ready", "themes": ["Empowerment", "Clarity"], "choice_points": [], "is_endpoint": true, "endpoint_type": "excellent_engagement"}}}'::jsonb,
    ARRAY'[\"A6\", \"A4\", \"B6\", \"C2\"]',
    '{"dimensions": {"A6": {"description": "Rapport Building", "weight": 2.0, "positive_signals": ["reflection", "open_question", "affirmation"], "negative_signals": ["assessment_too_early", "directive", "advice_giving"]}, "A4": {"description": "Diplomacy", "weight": 1.5, "positive_signals": ["sensitive_exploration", "respectful_pace", "honors_autonomy"], "negative_signals": ["pressuring", "imposing_timeline", "making_assumptions"]}, "B6": {"description": "Communication", "weight": 1.0, "positive_signals": ["collaborative", "clear", "two_way"], "negative_signals": ["one_way", "vague", "jargon_heavy"]}, "C2": {"description": "Improve Practice (Self-Development)", "weight": 1.0, "positive_signals": ["self_reflection", "insight_recognition", "growth_mindset"], "negative_signals": ["external_validation_only", "defensive_to_feedback", "fixed_mindset"]}}, "overall_scoring_logic": "weighted_average"}'::jsonb,
    '{"framework_name": "MaPS Money Guidance Competency Framework", "framework_version": "September 2022", "sections": ["A4", "A6", "B6", "C2"], "tier_relevance": "Tier 2-3 (Internal Coaching)", "domains": ["Colleague Development"], "context": "Career and Performance Conversations"}'::jsonb,
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
-- WHERE code = 'colleague-career-development-002';
