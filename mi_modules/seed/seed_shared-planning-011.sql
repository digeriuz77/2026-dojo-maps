-- supabase/seed/seed_shared-planning-011.sql
-- MAPS Practice Module: Planning - Developing Change Plans
-- Content Type: shared
--
-- Usage:
--   supabase db execute --file supabase/seed/seed_shared-planning-011.sql
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
    '00000000-0000-0001-0001-000000000011',
    'shared-planning-011',
    'Planning - Developing Change Plans',
    'shared',
    'Planning & Commitment',
    'advanced',
    15,
    'Learn to support people in developing their own change plans using collaborative questioning, reflection, and affirmation while honoring their autonomy and pace',
    'Planning in MI is collaborative - the person develops their own plan with your support rather than receiving a prescribed plan. This involves exploring what they want to do, how they''ll do it, their confidence, and potential obstacles. Planning applies universally to customer and colleague contexts.',
    '{"name": "Casey", "role": "person", "background": "Has been contemplating change and is now considering taking action. Has some ideas about what to do but needs help organizing thoughts into a concrete plan.", "personality_traits": ["contemplating", "hopeful", "uncertain", "motivated"], "tone_spectrum": {"word_complexity": 0.5, "sentence_length": 0.5, "emotional_expressiveness": 0.5, "disclosure_level": 0.5, "response_latency": 0.5, "confidence_level": 0.5}, "starting_tone_position": 0.5, "triggers": ["being_told_what_to_do", "prescriptive_plans", "pressure_to_commit", "unrealistic_expectations"], "comfort_topics": ["own_ideas", "autonomy", "support", "realistic_pace"]}'::jsonb,
    '{"start_node_id": "node_1", "nodes": {"node_1": {"id": "node_1", "persona_text": "I think I''m ready to move forward. I''ve been thinking about this for a while and I want to make a change.", "persona_mood": "ready_committed", "themes": ["Readiness", "Commitment", "Action"], "choice_points": [{"id": "cp_node_1_0", "option_text": "Great! Here''s what you should do: First, set a specific date. Second, make a list of steps. Third, identify support people.", "preview_hint": "This prescribes the plan", "rapport_impact": -1, "trust_impact": -1, "tone_shift": -0.15, "technique_tags": ["prescriptive_planning"], "competency_links": [], "feedback": {"immediate": "You''ve prescribed a plan rather than helping them develop their own. In MI, planning is collaborative.", "learning_note": "Planning in MI helps people develop their own strategies, not follow ours."}, "next_node_id": "node_2a", "exploration_depth": "surface"}, {"id": "cp_node_1_1", "option_text": "You''re feeling ready to move forward and want to make this change.", "preview_hint": "This reflects commitment", "rapport_impact": 1, "trust_impact": 1, "tone_shift": 0.15, "technique_tags": ["reflection_of_commitment"], "competency_links": ["A6"], "feedback": {"immediate": "Excellent reflection of commitment talk! You''ve captured their readiness before moving to planning.", "learning_note": "Reflect commitment talk before moving to planning."}, "next_node_id": "node_2b", "exploration_depth": "deep"}, {"id": "cp_node_1_2", "option_text": "What are you thinking about doing first?", "preview_hint": "This invites their ideas", "rapport_impact": 1, "trust_impact": 1, "tone_shift": 0.1, "technique_tags": ["planning_question"], "competency_links": ["A6", "A3"], "feedback": {"immediate": "Perfect! You''re inviting their own ideas about next steps rather than prescribing.", "learning_note": "Planning questions invite the person''s own strategies."}, "next_node_id": "node_2c", "exploration_depth": "deep"}], "is_endpoint": false, "endpoint_type": null}, "node_2b": {"id": "node_2b", "persona_text": "Yes, and I have some ideas about what I want to do. I think starting small makes sense, and I want to build in some support for myself.", "persona_mood": "strategic_thoughtful", "themes": ["Strategy", "Planning", "Support"], "choice_points": [{"id": "cp_node_2b_0", "option_text": "Excellent ideas! So you''re thinking about starting small and building in support.", "preview_hint": "This reflects their strategy", "rapport_impact": 1, "trust_impact": 1, "tone_shift": 0.15, "technique_tags": ["reflection_of_strategy"], "competency_links": ["A6"], "feedback": {"immediate": "Excellent reflection! You''ve captured their strategy and affirmed their thinking.", "learning_note": "Reflecting planning strategies reinforces the person''s ownership of their plan."}, "next_node_id": "node_3a", "exploration_depth": "deep"}, {"id": "cp_node_2b_1", "option_text": "What specific steps are you thinking about taking first?", "preview_hint": "This explores concrete steps", "rapport_impact": 1, "trust_impact": 1, "tone_shift": 0.1, "technique_tags": ["concrete_planning"], "competency_links": ["A6"], "feedback": {"immediate": "Perfect question! This invites them to specify their concrete steps.", "learning_note": "Planning questions help translate ideas into specific actions."}, "next_node_id": "node_3b", "exploration_depth": "deep"}], "is_endpoint": false, "endpoint_type": null}, "node_2c": {"id": "node_2c", "persona_text": "I think I''ll start with one small change - maybe just setting aside time each day to focus on this. And I want to tell a friend so I have some accountability.", "persona_mood": "specific_committed", "themes": ["Specific_Action", "Accountability", "Small_Steps"], "choice_points": [{"id": "cp_node_2c_0", "option_text": "So your plan is to start with one small change - setting aside daily time - and you''ll tell a friend for accountability.", "preview_hint": "This summarizes their plan", "rapport_impact": 1, "trust_impact": 1, "tone_shift": 0.15, "technique_tags": ["planning_summary"], "competency_links": ["A6"], "feedback": {"immediate": "Perfect planning summary! You''ve captured their specific steps and accountability plan.", "learning_note": "Planning summaries clarify and confirm the person''s own strategy."}, "next_node_id": "node_3c", "exploration_depth": "deep"}], "is_endpoint": false, "endpoint_type": null}, "node_3a": {"id": "node_3a", "persona_text": "Exactly! And I feel good about this plan. It feels realistic and doable.", "persona_mood": "confident_optimistic", "themes": ["Confidence", "Optimism", "Realism"], "choice_points": [{"id": "cp_node_3a_0", "option_text": "On a scale from 0 to 10, how confident are you that you can follow through with this plan?", "preview_hint": "This assesses confidence", "rapport_impact": 1, "trust_impact": 1, "tone_shift": 0.1, "technique_tags": ["confidence_scale"], "competency_links": ["A6"], "feedback": {"immediate": "Perfect scaling question! This assesses confidence and may reveal areas needing adjustment.", "learning_note": "Confidence scaling during planning helps assess feasibility."}, "next_node_id": "node_4a", "exploration_depth": "deep"}], "is_endpoint": false, "endpoint_type": null}, "node_3b": {"id": "node_3b", "persona_text": "I''m thinking I''ll set aside 15 minutes each morning. And I''ll ask my friend to check in with me weekly.", "persona_mood": "specific_detailed", "themes": ["Specifics", "Details", "Structure"], "choice_points": [{"id": "cp_node_3b_0", "option_text": "So you have a specific time and duration - 15 minutes each morning - and a weekly check-in for accountability.", "preview_hint": "This confirms the details", "rapport_impact": 1, "trust_impact": 1, "tone_shift": 0.15, "technique_tags": ["summary_of_details"], "competency_links": ["A6"], "feedback": {"immediate": "Excellent summary! You''ve captured the specific details of their plan.", "learning_note": "Summaries confirm planning details and reinforce ownership."}, "next_node_id": "node_end_excellent", "exploration_depth": "deep"}], "is_endpoint": false, "endpoint_type": null}, "node_3c": {"id": "node_3c", "persona_text": "Yes, that''s it. And honestly, I feel like I can actually do this.", "persona_mood": "confident_capable", "themes": ["Confidence", "Capability", "Commitment"], "choice_points": [{"id": "cp_node_3c_0", "option_text": "You''re feeling confident about your plan and believe you can follow through.", "preview_hint": "This reflects confidence and commitment", "rapport_impact": 1, "trust_impact": 1, "tone_shift": 0.15, "technique_tags": ["affirmation"], "competency_links": ["A6"], "feedback": {"immediate": "Perfect affirmation! You''ve reflected their confidence and commitment.", "learning_note": "Affirmations during planning reinforce confidence and commitment."}, "next_node_id": "node_end_excellent", "exploration_depth": "deep"}], "is_endpoint": false, "endpoint_type": null}, "node_4a": {"id": "node_4a", "persona_text": "I''d say about an 8 or 9. I feel really good about this plan.", "persona_mood": "high_confidence", "themes": ["High_Confidence", "Readiness"], "choice_points": [{"id": "cp_node_4a_0", "option_text": "That''s a high level of confidence. What helps you feel so confident about this plan?", "preview_hint": "This explores confidence sources", "rapport_impact": 1, "trust_impact": 1, "tone_shift": 0.15, "technique_tags": ["confidence_exploration"], "competency_links": ["A6"], "feedback": {"immediate": "Perfect! This explores the sources of their confidence, reinforcing their strengths.", "learning_note": "Exploring confidence sources during planning identifies strengths and resources."}, "next_node_id": "node_end_excellent", "exploration_depth": "deep"}], "is_endpoint": false, "endpoint_type": null}, "node_2a": {"id": "node_2a", "persona_text": "Okay, I can try that. Thanks for the plan.", "persona_mood": "compliant_passive", "themes": ["Compliance", "Passivity"], "choice_points": [], "is_endpoint": true, "endpoint_type": "transactional_only"}, "node_end_excellent": {"id": "node_end_excellent", "persona_text": "This has been really helpful. I have a clear plan that I developed myself, and I feel confident about following through.", "persona_mood": "empowered_committed", "themes": ["Empowerment", "Commitment", "Ownership"], "choice_points": [], "is_endpoint": true, "endpoint_type": "excellent_engagement"}}}'::jsonb,
    ARRAY'[\"A3\", \"A6\", \"B6\"]',
    '{"dimensions": {"A3": {"description": "Impartiality (Non-Directive)", "weight": 2.0, "positive_signals": ["collaborative_planning", "their_ideas", "honoring_autonomy"], "negative_signals": ["prescriptive", "imposing_plan", "directing_steps"]}, "A6": {"description": "Rapport Building", "weight": 1.5, "positive_signals": ["affirmation", "reflection_of_strategy", "confidence_exploration"], "negative_signals": ["correcting_plan", "expert_judgment", "imposing_expertise"]}, "B6": {"description": "Professional Alliance", "weight": 1.5, "positive_signals": ["collaborative", "supportive", "following_lead"], "negative_signals": ["directive", "prescriptive", "expert_positioned"]}}, "overall_scoring_logic": "weighted_average"}'::jsonb,
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
-- WHERE code = 'shared-planning-011';
