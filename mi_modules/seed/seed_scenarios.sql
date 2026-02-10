-- seed_scenarios.sql
-- Seed training scenarios for MAPS MI Training Platform
-- Run after migrations and seed_profiles.sql

-- ============================================
-- Scenario 1: Close Ambivalent Client
-- ============================================
INSERT INTO scenarios (code, title, mi_skill_category, difficulty, estimated_minutes,
                      situation, learning_objective, persona_config, success_criteria, maps_rubric)
VALUES (
  'close-ambivalent-001',
  'Closing with Ambivalent Client',
  'rolling_with_resistance',
  'beginner',
  5,
  'A long-term client you have been working with for several months is considering making a significant life change. They have expressed interest but also have several concerns and ambivalence about committing to the change.',
  'Practice rolling with resistance and exploring ambivalence without prematurely jumping to closure. Help the client weigh their own motivations for change.',
  '{"persona_id": "mary", "name": "Mary", "defensiveness": 0.6, "trust_threshold": 0.5, "tone": 0.4, "resistance_level": 7}'::jsonb,
  '{"turn_range": [5, 8], "required_skills": ["open_question", "reflection"], "avoid_behaviors": ["advice_giving", "confrontation"], "state_goals": {"trust_delta": 0.1, "resistance_change": -1}}'::jsonb,
  '{"competencies": {"A6": {"weight": 0.3, "indicators": ["explores_ambivalence", "walks_the_line"]}, "B6": {"weight": 0.7, "indicators": ["rolls_with_resistance", "does_not_overcome"]}}}'::jsonb
) ON CONFLICT (code) DO NOTHING;

-- ============================================
-- Scenario 2: Handle Confrontational Client
-- ============================================
INSERT INTO scenarios (code, title, mi_skill_category, difficulty, estimated_minutes,
                      situation, learning_objective, persona_config, success_criteria, maps_rubric)
VALUES (
  'handle-confrontational-001',
  'Handling Confrontational Client',
  'rolling_with_resistance',
  'intermediate',
  8,
  'A new client has come in visibly frustrated and confrontational. They were mandated to attend and do not want to be there. They are testing your boundaries and expertise.',
  'Practice maintaining therapeutic stance under pressure, avoiding argumentative dance, and finding entry points for engagement.',
  '{"persona_id": "terry", "name": "Terry", "defensiveness": 0.7, "trust_threshold": 0.2, "tone": 0.3, "resistance_level": 9}'::jsonb,
  '{"turn_range": [6, 10], "required_skills": ["accurate_reflection", "acceptance"], "avoid_behaviors": ["arguing", "defending", "premature_advice"], "state_goals": {"trust_delta": 0.05, "resistance_change": -2}}'::jsonb,
  '{"competencies": {"A6": {"weight": 0.4, "indicators": ["defends_vs_undermines"]}, "B6": {"weight": 0.6, "indicators": ["avoids_argumentative_dance", "expresses_empathy_under_pressure"]}}}'::jsonb
) ON CONFLICT (code) DO NOTHING;

-- ============================================
-- Scenario 3: Explore Change Talk
-- ============================================
INSERT INTO scenarios (code, title, mi_skill_category, difficulty, estimated_minutes,
                      situation, learning_objective, persona_config, success_criteria, maps_rubric)
VALUES (
  'explore-change-talk-001',
  'Exploring Change Talk',
  'evoking',
  'beginner',
  5,
  'A client has started to express some interest in making a change. They are hinting at wanting something different but have not committed to action.',
  'Practice eliciting change talk by asking evocative questions and reflecting client motivations for change.',
  '{"persona_id": "jan", "name": "Jan", "defensiveness": 0.4, "trust_threshold": 0.5, "tone": 0.5, "resistance_level": 4}'::jsonb,
  '{"turn_range": [4, 7], "required_skills": ["open_question", "reflection_of_change_talk"], "avoid_beivers": ["closed_questions", "advice_giving"], "state_goals": {"change_talk_increase": true, "sustain_talk_decrease": true}}'::jsonb,
  '{"competencies": {"A3": {"weight": 0.5, "indicators": ["asks_evocative_questions"]}, "A4": {"weight": 0.5, "indicators": ["reflects_change_talk", "elaborates"]}}}'::jsonb
) ON CONFLICT (code) DO NOTHING;

-- ============================================
-- Scenario 4: Simple Reflections Practice
-- ============================================
INSERT INTO scenarios (code, title, mi_skill_category, difficulty, estimated_minutes,
                      situation, learning_objective, persona_config, success_criteria, maps_rubric)
VALUES (
  'simple-reflections-001',
  'Simple Reflections Practice',
  'listening',
  'beginner',
  4,
  'A client is sharing about their day and some challenges they faced. They are not in crisis but want to be heard and understood.',
  'Practice using simple reflections to show understanding and encourage the client to continue sharing.',
  '{"persona_id": "alex", "name": "Alex", "defensiveness": 0.3, "trust_threshold": 0.6, "tone": 0.6, "resistance_level": 2}'::jsonb,
  '{"turn_range": [3, 5], "required_skills": ["simple_reflection", "double_sided_reflection"], "avoid_behaviors": ["question_after_question", "advice_giving"], "state_goals": {"client_depth_increase": true, "engagement_maintained": true}}'::jsonb,
  '{"competencies": {"A1": {"weight": 0.3, "indicators": ["short_responses"]}, "A2": {"weight": 0.7, "indicators": ["reflects_content", "reflects_feeling"]}}}'::jsonb
) ON CONFLICT (code) DO NOTHING;

-- ============================================
-- Scenario 5: Complex Reflections
-- ============================================
INSERT INTO scenarios (code, title, mi_skill_category, difficulty, estimated_minutes,
                      situation, learning_objective, persona_config, success_criteria, maps_rubric)
VALUES (
  'complex-reflections-001',
  'Complex Reflections Practice',
  'listening',
  'intermediate',
  6,
  'A client is sharing a complex situation with multiple layers - intellectual understanding, emotional response, and ambivalence about next steps.',
  'Practice using complex reflections to connect the dots and add meaning to what the client has shared.',
  '{"persona_id": "jordan", "name": "Jordan", "defensiveness": 0.5, "trust_threshold": 0.5, "tone": 0.5, "resistance_level": 4}'::jsonb,
  '{"turn_range": [4, 7], "required_skills": ["complex_reflection", "reflection_of_discrepancy"], "avoid_behaviors": ["advice_giving", "summarizing_too_early"], "state_goals": {"client_deepens_reflection": true, "awareness_increased": true}}'::jsonb,
  '{"competencies": {"A1": {"weight": 0.2, "indicators": ["brief_responses"]}, "A2": {"weight": 0.8, "indicators": ["adds_meaning", "reflects_discrepancy", "integrates"]}}}'::jsonb
) ON CONFLICT (code) DO NOTHING;

-- ============================================
-- Scenario 6: Affirmation Practice
-- ============================================
INSERT INTO scenarios (code, title, mi_skill_category, difficulty, estimated_minutes,
                      situation, learning_objective, persona_config, success_criteria, maps_rubric)
VALUES (
  'affirmation-practice-001',
  'Affirmation Practice',
  'evoking',
  'beginner',
  4,
  'A client has just completed a small but meaningful step toward their goal. They are feeling proud but also uncertain about maintaining progress.',
  'Practice using affirmations to recognize client strengths and support self-efficacy.',
  '{"persona_id": "mary", "name": "Mary", "defensiveness": 0.4, "trust_threshold": 0.6, "tone": 0.6, "resistance_level": 3}'::jsonb,
  '{"turn_range": [3, 5], "required_skills": ["affirmation", "supporting_self_efficacy"], "avoid_behaviors": ["empty_praise", "comparisons"], "state_goals": {"self_efficacy_increased": true, "client_acceptance": true}}'::jsonb,
  '{"competencies": {"A5": {"weight": 1.0, "indicators": ["affirms", "supports_self_efficacy"]}}}'::jsonb
) ON CONFLICT (code) DO NOTHING;

-- ============================================
-- Scenario 7: Sustain Talk and Discord
-- ============================================
INSERT INTO scenarios (code, title, mi_skill_category, difficulty, estimated_minutes,
                      situation, learning_objective, persona_config, success_criteria, maps_rubric)
VALUES (
  'sustain-talk-001',
  'Responding to Sustain Talk',
  'rolling_with_resistance',
  'intermediate',
  7,
  'A client who was previously making progress is now expressing strong sustain talk and reasons not to change. They are questioning whether the change is worth it.',
  'Practice recognizing and responding to sustain talk and discord without becoming defensive or trying to convince.',
  '{"persona_id": "jan", "name": "Jan", "defensiveness": 0.6, "trust_threshold": 0.4, "tone": 0.4, "resistance_level": 7}'::jsonb,
  '{"turn_range": [5, 9], "required_skills": ["refecting_sustain_talk", "emphasizing_autonomy"], "avoid_behaviors": ["arguing_for_change", "minimizing_concerns"], "state_goals": {"client_heard": true, "engagement_maintained": true}}'::jsonb,
  '{"competencies": {"A6": {"weight": 0.6, "indicators": ["receives_sustain_talk", "does_not_fight"]}, "B6": {"weight": 0.4, "indicators": ["emphasizes_autonomy", "does_not_come_across"]}}}'::jsonb
) ON CONFLICT (code) DO NOTHING;

-- ============================================
-- Scenario 8: Developing Discrepancy
-- ============================================
INSERT INTO scenarios (code, title, mi_skill_category, difficulty, estimated_minutes,
                      situation, learning_objective, persona_config, success_criteria, maps_rubric)
VALUES (
  'developing-discrepancy-001',
  'Developing Discrepancy',
  'evoking',
  'advanced',
  10,
  'A client is stuck in their current situation. They have important values that are not being met by their current behavior, but they have become accustomed to the status quo.',
  'Practice developing discrepancy in a non-confrontational way by exploring the gap between current behavior and deeper values.',
  '{"persona_id": "terry", "name": "Terry", "defensiveness": 0.5, "trust_threshold": 0.5, "tone": 0.5, "resistance_level": 5}'::jsonb,
  '{"turn_range": [6, 12], "required_skills": ["values_exploration", "reflection_of_discrepancy", "looking_forward"], "avoid_behaviors": ["moralizing", "direct_challenge"], "state_goals": {"values_identified": true, "discrepancy_recognized": true}}'::jsonb,
  '{"competencies": {"A3": {"weight": 0.4, "indicators": ["explores_values"]}, "A4": {"weight": 0.6, "indicators": ["develops_discrepancy", "helps_client_see_gap"]}}}'::jsonb
) ON CONFLICT (code) DO NOTHING;

-- Verify scenarios were inserted
SELECT code, title, mi_skill_category, difficulty, estimated_minutes
FROM scenarios
ORDER BY difficulty, mi_skill_category;
