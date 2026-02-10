-- supabase/seed/seed_shared-summarizing-005.sql
-- MAPS Practice Module: Summarizing - Linking and Transitioning
-- Content Type: shared
--
-- Usage:
--   supabase db execute --file supabase/seed/seed_shared-summarizing-005.sql
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
    '00000000-0000-0001-0001-000000000005',
    'shared-summarizing-005',
    'Summarizing - Linking and Transitioning',
    'shared',
    'Reflective Listening',
    'intermediate',
    12,
    'Learn to summarize key points, link themes together, and transition smoothly between topics while maintaining the conversation flow',
    'Summaries pull together what has been shared, demonstrate attentive listening, and help people see patterns in their thinking. Linking summaries connect themes and show how ideas relate. Transitions move conversations forward naturally. This core skill applies universally to customer and colleague contexts.',
    '{"name": "Morgan", "role": "person", "background": "Has been reflecting on a situation and has shared multiple thoughts and concerns. Is processing ideas and trying to make sense of different aspects.", "personality_traits": ["reflective", "processing", "thoughtful", "seeking_clarity"], "tone_spectrum": {"word_complexity": 0.5, "sentence_length": 0.5, "emotional_expressiveness": 0.5, "disclosure_level": 0.4, "response_latency": 0.5, "confidence_level": 0.5}, "starting_tone_position": 0.5, "triggers": ["interruptions", "jumping_to_conclusions", "being_rushed", "misinterpretation"], "comfort_topics": ["being_understood", "clarity", "own_pace", "accurate_reflection"]}'::jsonb,
    '{"start_node_id": "node_1", "nodes": {"node_1": {"id": "node_1", "persona_text": "I''ve been thinking about this situation a lot. On one hand, I really want to make changes because I can see the benefits. But on the other hand, I''m worried about the effort involved and whether I can actually sustain it. And then there''s the timing - is now the right time?", "persona_mood": "contemplative_complex", "themes": ["Ambivalence", "Change", "Timing"], "choice_points": [{"id": "cp_node_1_0", "option_text": "Why don''t you just start now? There''s no point in waiting.", "preview_hint": "This gives direction", "rapport_impact": -1, "trust_impact": -1, "tone_shift": -0.15, "technique_tags": ["advice"], "competency_links": [], "feedback": {"immediate": "You''ve jumped to advice before fully understanding their thinking. Summarizing first would help them see their situation more clearly.", "learning_note": "Summaries organize thinking before solutions are considered."}, "next_node_id": "node_2a", "exploration_depth": "surface"}, {"id": "cp_node_1_1", "option_text": "So you''re feeling pulled in different directions - you can see the benefits of making changes, but you''re also concerned about the effort required and whether now is the right time.", "preview_hint": "This summarizes their ambivalence", "rapport_impact": 1, "trust_impact": 1, "tone_shift": 0.15, "technique_tags": ["summary"], "competency_links": ["A6", "B6"], "feedback": {"immediate": "Excellent summary! You''ve captured the key elements of their ambivalence - benefits, effort concerns, and timing questions.", "learning_note": "Summaries help people see their thinking organized and reflected back clearly."}, "next_node_id": "node_2b", "exploration_depth": "deep"}, {"id": "cp_node_1_2", "option_text": "I think you should focus on the benefits and not worry so much about the effort.", "preview_hint": "This dismisses concerns", "rapport_impact": -1, "trust_impact": -1, "tone_shift": -0.15, "technique_tags": ["minimizing"], "competency_links": [], "feedback": {"immediate": "You''ve dismissed their concerns rather than acknowledging them. Effective summaries honor all aspects of what''s shared.", "learning_note": "Summaries should be balanced, not selective."}, "next_node_id": "node_2c", "exploration_depth": "surface"}], "is_endpoint": false, "endpoint_type": null}, "node_2b": {"id": "node_2b", "persona_text": "Exactly! And it''s like I''m going in circles. I see the benefits, then I worry about the effort, then I question the timing, then I''m back to the benefits again.", "persona_mood": "frustrated_cyclical", "themes": ["Cycles", "Processing", "Pattern"], "choice_points": [{"id": "cp_node_2b_0", "option_text": "You''re going in circles - seeing benefits, worrying about effort, questioning timing, then back to benefits.", "preview_hint": "This reflects the pattern", "rapport_impact": 0, "trust_impact": 0, "tone_shift": 0.0, "technique_tags": ["reflection"], "competency_links": ["A6"], "feedback": {"immediate": "Good reflection that captures the cyclical pattern they''ve described.", "learning_note": "Reflections can capture patterns in thinking."}, "next_node_id": "node_3a", "exploration_depth": "surface"}, {"id": "cp_node_2b_1", "option_text": "So you''re noticing a cycle in your thinking - the benefits draw you in, but then concerns about effort and timing create hesitation, which brings you back to weighing the benefits again.", "preview_hint": "This links the pattern with meaning", "rapport_impact": 1, "trust_impact": 1, "tone_shift": 0.15, "technique_tags": ["linked_summary"], "competency_links": ["A6", "B6"], "feedback": {"immediate": "Excellent linked summary! You''ve captured the cycle and shown how each part connects to the next.", "learning_note": "Linked summaries show how thoughts and feelings connect to each other."}, "next_node_id": "node_3b", "exploration_depth": "deep"}], "is_endpoint": false, "endpoint_type": null}, "node_3b": {"id": "node_3b", "persona_text": "That''s exactly how it feels! And hearing it summarized like that helps me see that maybe the cycle itself is telling me something.", "persona_mood": "insightful_curious", "themes": ["Insight", "Pattern_Recognition", "Meaning"], "choice_points": [{"id": "cp_node_3b_0", "option_text": "What do you think the cycle is telling you?", "preview_hint": "This invites exploration", "rapport_impact": 0, "trust_impact": 0, "tone_shift": 0.0, "technique_tags": ["open_question"], "competency_links": [], "feedback": {"immediate": "Perfect open question following the summary. This invites them to explore the meaning they''ve recognized.", "learning_note": "Questions after summaries invite deeper exploration of insights."}, "next_node_id": "node_end_excellent", "exploration_depth": "deep"}], "is_endpoint": false, "endpoint_type": null}, "node_2a": {"id": "node_2a", "persona_text": "I suppose so. But I''d like to feel more ready before I start.", "persona_mood": "hesitant_withdrawn", "themes": ["Hesitation", "Autonomy"], "choice_points": [], "is_endpoint": true, "endpoint_type": "needs_more_time"}, "node_2c": {"id": "node_2c", "persona_text": "I think you''re not really hearing my concerns about the effort.", "persona_mood": "dismissed_frustrated", "themes": ["Dismissed", "Frustration"], "choice_points": [], "is_endpoint": true, "endpoint_type": "poor_engagement"}, "node_3a": {"id": "node_3a", "persona_text": "Yeah, it''s frustrating. But talking about it helps.", "persona_mood": "acknowledged_relieved", "themes": ["Acknowledgment", "Relief"], "choice_points": [], "is_endpoint": true, "endpoint_type": "neutral_end"}, "node_end_excellent": {"id": "node_end_excellent", "persona_text": "This has been really helpful. I feel like I can see my thinking more clearly now.", "persona_mood": "clarity_grateful", "themes": ["Clarity", "Gratitude", "Understanding"], "choice_points": [], "is_endpoint": true, "endpoint_type": "excellent_engagement"}}}'::jsonb,
    ARRAY'[\"A6\", \"B6\", \"2.1.1\"]',
    '{"dimensions": {"A6": {"description": "Rapport Building", "weight": 2.0, "positive_signals": ["summary", "linked_summary", "accurate_reflection"], "negative_signals": ["advice", "dismissing", "minimizing"]}, "B6": {"description": "Professional Alliance", "weight": 1.5, "positive_signals": ["organized_reflection", "linking_themes", "transition_smooth"], "negative_signals": ["fragmented", "interruptions", "jumping_ahead"]}, "2.1.1": {"description": "Complex Reflective Listening", "weight": 1.5, "positive_signals": ["synthesis", "pattern_recognition", "linking"], "negative_signals": ["selective_reflection", "missing_elements", "disorganized"]}}, "overall_scoring_logic": "weighted_average"}'::jsonb,
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
-- WHERE code = 'shared-summarizing-005';
