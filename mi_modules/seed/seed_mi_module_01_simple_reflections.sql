-- supabase/seed/seed_mi_module_01_simple_reflections.sql
-- MAPS Practice Module 1: Simple Reflections - Building Engagement
-- Customer-Facing Financial Guidance Context
--
-- Usage:
--   supabase db execute --file supabase/seed/seed_mi_module_01_simple_reflections.sql
-- Or paste into Supabase SQL Editor

-- ============================================
-- INSERT MAPS PRACTICE MODULE
-- ============================================
INSERT INTO mi_practice_modules (
    id,
    code,
    title,
    mi_focus_area,
    difficulty_level,
    estimated_minutes,
    learning_objective,
    scenario_context,
    persona_config,
    dialogue_structure,
    target_competencies,
    maps_rubric,
    is_active
) VALUES (
    'bc863919-5fcc-4ce6-a52a-4e7cf75d02ae',
    'maps-simple-reflections-001',
    'Module 1: Simple Reflections - Building Engagement',
    'Reflective Listening',
    'beginner',
    5,
    'Learn to create simple, accurate reflections that demonstrate understanding and build professional relationships with customers',
    'Simple reflections capture the essence of what the customer said without adding interpretation or judgment. They demonstrate listening, build trust, and encourage customers to elaborate. Effective reflections are brief, accurate, and focused on observable content. This module focuses on customer-facing financial guidance conversations.',
    '{
        "name": "Jordan",
        "role": "customer",
        "background": "Does not recognize there is a financial concern or feels it''s not significant enough to address.",
        "personality_traits": ["defensive", "guarded", "minimizing", "autonomous"],
        "tone_spectrum": {
            "word_complexity": 0.3,
            "sentence_length": 0.3,
            "emotional_expressiveness": 0.2,
            "disclosure_level": 0.1,
            "response_latency": 0.3,
            "confidence_level": 0.2
        },
        "starting_tone_position": 0.2,
        "triggers": ["direct criticism", "being told what to do", "lecturing", "judgment"],
        "comfort_topics": ["autonomy", "understanding", "being heard", "personal choice"]
    }'::jsonb,
    '{
        "start_node_id": "node_1",
        "nodes": {
            "node_1": {
                "id": "node_1",
                "persona_text": "My partner sent me here because of my spending. I don''t really think it''s a problem.",
                "persona_mood": "defensive_not_ready",
                "themes": ["Hesitation", "Change"],
                "choice_points": [
                    {
                        "id": "cp_node_1_0",
                        "option_text": "Overspending can lead to debt, missed payments, and many other financial problems.",
                        "preview_hint": "MAPS-consistent approach",
                        "rapport_impact": 0,
                        "hesitation_impact": 0,
                        "tone_shift": 0.0,
                        "technique_tags": ["unknown"],
                        "competency_links": [],
                        "feedback": {
                            "immediate": "This is education/warning, not reflection. You''re providing information instead of reflecting what they said. This can create hesitation.",
                            "learning_note": "Reflections build rapport by showing you understand the customer''s perspective."
                        },
                        "next_node_id": "node_2a",
                        "exploration_depth": "surface"
                    },
                    {
                        "id": "cp_node_1_1",
                        "option_text": "You don''t see your spending as a problem for you.",
                        "preview_hint": "MAPS-consistent approach",
                        "rapport_impact": 0,
                        "hesitation_impact": 0,
                        "tone_shift": 0.0,
                        "technique_tags": ["unknown"],
                        "competency_links": [],
                        "feedback": {
                            "immediate": "Perfect! This is a simple, accurate reflection of exactly what they said. It demonstrates you''re listening without judgment.",
                            "learning_note": "Reflections build rapport by showing you understand the customer''s perspective."
                        },
                        "next_node_id": "node_2b",
                        "exploration_depth": "surface"
                    },
                    {
                        "id": "cp_node_1_2",
                        "option_text": "Why do you think it''s not a problem?",
                        "preview_hint": "MAPS-consistent approach",
                        "rapport_impact": 0,
                        "hesitation_impact": 0,
                        "tone_shift": 0.0,
                        "technique_tags": ["unknown"],
                        "competency_links": [],
                        "feedback": {
                            "immediate": "While questions can be useful, starting with a reflection demonstrates better listening. You missed an opportunity to reflect first.",
                            "learning_note": "Reflections build rapport by showing you understand the customer''s perspective."
                        },
                        "next_node_id": "node_2c",
                        "exploration_depth": "surface"
                    }
                ],
                "is_endpoint": false,
                "endpoint_type": null
            },
            "node_2a": {
                "id": "node_2a",
                "persona_text": "Yeah, I know all that. They''ve been telling me that for years. It hasn''t made any difference.",
                "persona_mood": "neutral_uncertain",
                "themes": ["General"],
                "choice_points": [
                    {
                        "id": "cp_node_2a_0",
                        "option_text": "But the financial risks are real and serious.",
                        "preview_hint": "MAPS-consistent approach",
                        "rapport_impact": 0,
                        "hesitation_impact": 0,
                        "tone_shift": 0.0,
                        "technique_tags": ["unknown"],
                        "competency_links": [],
                        "feedback": {
                            "immediate": "This confronts and argues with the customer, which increases hesitation. You''re defending your position rather than understanding theirs.",
                            "learning_note": "Watch for customer hesitation signals - defensiveness or disengagement."
                        },
                        "next_node_id": "node_3a",
                        "exploration_depth": "surface"
                    },
                    {
                        "id": "cp_node_2a_1",
                        "option_text": "All that information about financial risks hasn''t changed anything for you so far.",
                        "preview_hint": "MAPS-consistent approach",
                        "rapport_impact": 0,
                        "hesitation_impact": 0,
                        "tone_shift": 0.0,
                        "technique_tags": ["unknown"],
                        "competency_links": [],
                        "feedback": {
                            "immediate": "Good! This reflects their experience without arguing. You acknowledge the information hasn''t helped them change.",
                            "learning_note": "Continue practicing MAPS techniques to build your professional skills."
                        },
                        "next_node_id": "node_3b",
                        "exploration_depth": "surface"
                    }
                ],
                "is_endpoint": false,
                "endpoint_type": null
            },
            "node_2b": {
                "id": "node_2b",
                "persona_text": "That''s right. I enjoy shopping. It helps me relax. I don''t want to change.",
                "persona_mood": "neutral_uncertain",
                "themes": ["Financial Concerns", "Goals", "Change"],
                "choice_points": [
                    {
                        "id": "cp_node_2b_0",
                        "option_text": "You enjoy shopping and it helps you relax, so you don''t want to change.",
                        "preview_hint": "MAPS-consistent approach",
                        "rapport_impact": 0,
                        "hesitation_impact": 0,
                        "tone_shift": 0.0,
                        "technique_tags": ["unknown"],
                        "competency_links": [],
                        "feedback": {
                            "immediate": "Excellent! This reflects both their enjoyment of shopping and their desire not to change. This honors their perspective.",
                            "learning_note": "Continue practicing MAPS techniques to build your professional skills."
                        },
                        "next_node_id": "node_3c",
                        "exploration_depth": "surface"
                    },
                    {
                        "id": "cp_node_2b_1",
                        "option_text": "But relaxation is important, and there are healthier ways to achieve it.",
                        "preview_hint": "MAPS-consistent approach",
                        "rapport_impact": 0,
                        "hesitation_impact": 0,
                        "tone_shift": 0.0,
                        "technique_tags": ["unknown"],
                        "competency_links": [],
                        "feedback": {
                            "immediate": "This jumps to solutions and alternatives rather than reflecting their current perspective. This can create hesitation.",
                            "learning_note": "Watch for customer hesitation signals - defensiveness or disengagement."
                        },
                        "next_node_id": "node_3d",
                        "exploration_depth": "surface"
                    }
                ],
                "is_endpoint": false,
                "endpoint_type": null
            },
            "node_2c": {
                "id": "node_2c",
                "persona_text": "Because I don''t. It''s something I choose to do, and I''m not hurting anyone.",
                "persona_mood": "neutral_uncertain",
                "themes": ["Autonomy"],
                "choice_points": [
                    {
                        "id": "cp_node_2c_0",
                        "option_text": "You see this as your choice and you don''t see it as hurting anyone.",
                        "preview_hint": "MAPS-consistent approach",
                        "rapport_impact": 0,
                        "hesitation_impact": 0,
                        "tone_shift": 0.0,
                        "technique_tags": ["unknown"],
                        "competency_links": [],
                        "feedback": {
                            "immediate": "Good! This reflects both their sense of choice and their view about not hurting others.",
                            "learning_note": "Continue practicing MAPS techniques to build your professional skills."
                        },
                        "next_node_id": "node_3e",
                        "exploration_depth": "surface"
                    },
                    {
                        "id": "cp_node_2c_1",
                        "option_text": "But debt can hurt your family financially.",
                        "preview_hint": "MAPS-consistent approach",
                        "rapport_impact": 0,
                        "hesitation_impact": 0,
                        "tone_shift": 0.0,
                        "technique_tags": ["unknown"],
                        "competency_links": [],
                        "feedback": {
                            "immediate": "This confronts and argues rather than reflecting their perspective. This will likely increase hesitation.",
                            "learning_note": "Watch for customer hesitation signals - defensiveness or disengagement."
                        },
                        "next_node_id": "node_3f",
                        "exploration_depth": "surface"
                    }
                ],
                "is_endpoint": false,
                "endpoint_type": null
            }
        }
    }'::jsonb,
    ARRAY['B6', '2.1.2', 'A2', 'A6', 'A1', '2.1.1'],
    '{
        "dimensions": {
            "A6": {
                "description": "Rapport Building",
                "weight": 1.5,
                "positive_signals": ["simple_reflection", "affirmation", "open_question"],
                "negative_signals": ["confrontation", "educating", "righting_reflex"]
            },
            "B6": {
                "description": "Professional Alliance",
                "weight": 1.5,
                "positive_signals": ["validation", "empathy", "reflection"],
                "negative_signals": ["judgment", "pressure", "explanation"]
            },
            "2.1.1": {
                "description": "Simple Reflective Listening",
                "weight": 2.0,
                "positive_signals": ["simple_reflection", "repeating", "rephrasing"],
                "negative_signals": ["interpretation", "advice", "questioning"]
            }
        },
        "overall_scoring_logic": "weighted_average"
    }'::jsonb,
    true
) ON CONFLICT (code) DO UPDATE SET
    title = EXCLUDED.title,
    mi_focus_area = EXCLUDED.mi_focus_area,
    difficulty_level = EXCLUDED.difficulty_level,
    estimated_minutes = EXCLUDED.estimated_minutes,
    learning_objective = EXCLUDED.learning_objective,
    scenario_context = EXCLUDED.scenario_context,
    persona_config = EXCLUDED.persona_config,
    dialogue_structure = EXCLUDED.dialogue_structure,
    target_competencies = EXCLUDED.target_competencies,
    maps_rubric = EXCLUDED.maps_rubric,
    is_active = EXCLUDED.is_active,
    updated_at = NOW();

-- ============================================
-- VERIFICATION QUERY
-- ============================================
-- Uncomment to verify insertion:
-- SELECT code, title, mi_focus_area, difficulty_level, estimated_minutes, is_active
-- FROM mi_practice_modules
-- WHERE code = 'maps-simple-reflections-001';
