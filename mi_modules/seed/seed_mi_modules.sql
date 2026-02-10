-- seed_mi_modules.sql
-- Seed structured practice modules for MAPS Training Platform
-- Focus: Facilitative coaching skills for Money, Pension, and Debt Advice scenarios
-- Based on MaPS Money Guidance Competency Framework (September 2022)
--
-- MaPS Framework Key Concepts:
-- - Facilitation over instruction (Domain 1.2.9)
-- - Empowerment and behavior change
-- - Impartial, non-directive guidance
-- - Helping customers identify their own goals and priorities (1.2.3)
--
-- Module Types:
-- - 'external': Customer-facing modules (Debt advice, Pension guidance)
-- - 'internal': Colleague-facing modules (Workload support, Team development)

-- ============================================
-- Module 1: Building Rapport (MaPS A6)
-- Focus: Establishing connection and trust
-- Type: BOTH - applicable to both customers and colleagues
-- ============================================
INSERT INTO mi_practice_modules (code, title, mi_focus_area, difficulty, estimated_minutes,
                                learning_objective, scenario_context, persona_config, 
                                dialogue_structure, maps_rubric, module_type, maps_framework_alignment)
VALUES (
  'maps-rapport-001',
  'Building Rapport',
  'rapport_building',
  'beginner',
  5,
  'Establish connection and create safety before discussing financial or work matters. Practice empathy and rapport-building skills (MaPS A6).',
  'First conversation with someone who has been referred for support. They are unsure about discussing their situation.',
  '{
    "name": "Sarah",
    "background": "Colleague in the pensions team experiencing burnout",
    "role": "colleague",
    "personality": {
      "defensiveness": 0.5,
      "openness": 0.4,
      "verbal_frequency": "moderate"
    },
    "tone_spectrum": {
      "start": 0.3,
      "end": 0.7,
      "start_description": "guarded, uncertain",
      "end_description": "relaxed, engaged"
    }
  }'::jsonb,
  '{
    "start_node": "greeting",
    "nodes": {
      "greeting": {
        "text": "Hi, I was told you wanted to talk to me about how I have been doing. I am not really sure why this is necessary.",
        "choices": [
          {
            "id": "c1",
            "response": "Thanks for taking the time. Tell me a bit about what has been going on for you.",
            "rapport_impact": 2,
            "tone_shift": 0.1,
            "techniques": ["open_question", "empathic_listening"],
            "feedback": "Good open question that invites them to share on their own terms.",
            "maps_competencies": ["A6", "B6"],
            "maps_principles": ["customer_chooses_topic"],
            "next_node": "context_sharing"
          },
          {
            "id": "c2",
            "response": "I understand this might feel awkward. Let us just get to know each other a bit first.",
            "rapport_impact": 1,
            "tone_shift": 0.05,
            "techniques": ["empathic_acknowledgment", "agenda_free"],
            "feedback": "Validates their discomfort but stays at surface level.",
            "maps_competencies": ["A6", "A4"],
            "maps_principles": ["non_directive"],
            "next_node": "agenda_free"
          },
          {
            "id": "c3",
            "response": "Your manager is concerned about you. You seem really stressed.",
            "rapport_impact": -1,
            "tone_shift": -0.1,
            "techniques": ["interpretation", "non_impartial"],
            "feedback": "This comes across as colluding with management rather than being supportive.",
            "maps_competencies": ["A3"],
            "maps_principles": ["avoid_collusion"],
            "next_node": "defensive_response"
          }
        ]
      },
      "context_sharing": {
        "text": "Well, the pensions team has been really busy lately. With the auto-enrolment changes and everything, I do not know if I can keep up.",
        "choices": [
          {
            "id": "c4",
            "response": "Things have changed and you are not sure if you can keep up.",
            "rapport_impact": 2,
            "tone_shift": 0.1,
            "techniques": ["reflection", "empathic_listening"],
            "feedback": "Accurate reflection shows you are listening and understand.",
            "maps_competencies": ["A6", "B6"],
            "maps_principles": ["reflecting_back"],
            "next_node": "deeper_explore"
          },
          {
            "id": "c5",
            "response": "What specifically has changed with the workload?",
            "rapport_impact": 0,
            "tone_shift": 0.0,
            "techniques": ["closed_question"],
            "feedback": "Closed question stops the flow of sharing.",
            "maps_competencies": ["B6"],
            "maps_principles": ["open_better_than_closed"],
            "next_node": "brief_response"
          }
        ]
      },
      "agenda_free": {
        "text": "Yeah, I did not really want to have this conversation. I have too much going on already.",
        "choices": [
          {
            "id": "c6",
            "response": "You did not want to come and yet you are here. That takes something.",
            "rapport_impact": 2,
            "tone_shift": 0.15,
            "techniques": ["complex_reflection", "affirmation", "acknowledging_autonomy"],
            "feedback": "Notices the contradiction and affirms their effort. Builds alliance.",
            "maps_competencies": ["A2", "A6", "A5"],
            "maps_principles": ["affirming_effort"],
            "next_node": "engagement"
          },
          {
            "id": "c7",
            "response": "I appreciate you taking the time. Maybe we can make this useful for you.",
            "rapport_impact": 1,
            "tone_shift": 0.05,
            "techniques": ["affirmation", "customer_focused"],
            "feedback": "Good affirmation but does not dig deeper.",
            "maps_competencies": ["A6"],
            "maps_principles": ["customer_determines_utility"],
            "next_node": "cautious_engagement"
          }
        ]
      },
      "defensive_response": {
        "text": "Look, I know I have not been performing at my best but I do not need someone reporting back to my manager.",
        "choices": [
          {
            "id": "c8",
            "response": "This is your time. What we talk about stays here.",
            "rapport_impact": 1,
            "tone_shift": 0.05,
            "techniques": ["empathic_acknowledgment", "emphasizing_autonomy"],
            "feedback": "Attempts to establish confidentiality but they may not believe yet.",
            "maps_competencies": ["A6", "A3"],
            "maps_principles": ["confidentiality"],
            "next_node": "skeptical"
          }
        ]
      },
      "deeper_explore": {
        "text": "Yeah, I mean I have been doing this job for years and suddenly everything feels different. The clients are more complex.",
        "choices": [
          {
            "id": "c9",
            "response": "You have experience and now things feel different. Tell me more about that.",
            "rapport_impact": 2,
            "tone_shift": 0.1,
            "techniques": ["open_question", "facilitative_listening"],
            "feedback": "Good invitation to explore. Acknowledges their experience.",
            "maps_competencies": ["B6", "A6"],
            "maps_principles": ["explore_their_perspective"],
            "next_node": "rapport_established"
          }
        ]
      },
      "rapport_established": {
        "text": "I appreciate you actually listening. Maybe this could be helpful after all.",
        "choices": [
          {
            "id": "c10",
            "response": "I am glad you are finding it useful. Let us continue when you are ready.",
            "rapport_impact": 2,
            "tone_shift": 0.1,
            "techniques": ["affirmation", "supporting_self_efficacy", "empowering"],
            "feedback": "Good closure. They feel heard and have choice about next steps.",
            "maps_competencies": ["A5", "A6", "A1"],
            "maps_principles": ["self_determination"],
            "next_node": "complete"
          }
        ]
      }
    },
    "choice_points": 10,
    "completion_node": "rapport_established"
  }'::jsonb,
  '{
    "target_competencies": ["A6", "B6"],
    "maps_framework": {
      "section": "A. Personal qualities and attributes",
      "subsection": "A6: Rapport building",
      "description": "Rapport building: ability to empathise with a customers\' situation and gauging their current level of confidence",
      "page_reference": "Page 558-565"
    },
    "dimensions": {
      "interview_flow": {"weight": 0.3, "description": "Smooth progression through conversation"},
      "facilitative_adherence": {"weight": 0.4, "description": "Use of empowering, non-directive skills"},
      "engagement": {"weight": 0.3, "description": "Person engagement and depth"}
    },
    "success_threshold": 0.6
  }'::jsonb,
  'internal',  -- module_type: internal-facing (colleague support)
  '{
    "framework_name": "MaPS Money Guidance Competency Framework",
    "framework_version": "September 2022",
    "competencies": ["A6: Rapport building", "B6: Communication", "A3: Impartiality"],
    "tier_relevance": "Tier 1-2",
    "key_principles": [
      "Empathise with the person\'s situation",
      "Gauge their current level of confidence",
      "Build trust and rapport",
      "Work with their pace, not yours"
    ],
    "external_reference": "https://www.moneyandpensionsservice.org.uk/money-guidance-competency-framework"
  }'::jsonb
) ON CONFLICT (code) DO NOTHING;

-- ============================================
-- Module 2: Probing Questions
-- Focus: Asking questions to understand customer/colleague needs
-- Type: EXTERNAL - Customer-facing scenarios
-- ============================================
INSERT INTO mi_practice_modules (code, title, mi_focus_area, difficulty, estimated_minutes,
                                learning_objective, scenario_context, persona_config, 
                                dialogue_structure, maps_rubric, module_type, maps_framework_alignment)
VALUES (
  'maps-probing-questions-001',
  'Probing Questions Practice',
  'probing_questions',
  'beginner',
  5,
  'Practice asking probing questions that invite the customer to share their story and help identify their own issues and goals (MaPS 1.2.1, 1.2.3).',
  'A customer is seeking debt advice and has shared that they have been avoiding opening their letters. You want to understand their perspective.',
  '{
    "name": "Marcus",
    "background": "Customer seeking debt advice",
    "role": "customer",
    "personality": {
      "defensiveness": 0.4,
      "openness": 0.5,
      "verbal_frequency": "moderate"
    },
    "tone_spectrum": {
      "start": 0.35,
      "end": 0.75,
      "start_description": "anxious, ashamed",
      "end_description": "relieved, engaged"
    }
  }'::jsonb,
  '{
    "start_node": "situation_setup",
    "nodes": {
      "situation_setup": {
        "text": "I got another letter from the debt recovery people yesterday. I have not opened it.",
        "choices": [
          {
            "id": "q1",
            "response": "Tell me about that.",
            "rapport_impact": 2,
            "tone_shift": 0.1,
            "techniques": ["open_question", "facilitative_listening"],
            "feedback": "Good open question that invites the customer to share.",
            "maps_competencies": ["B6", "A6"],
            "maps_principles": ["open_invitation"],
            "next_node": "meeting_details"
          },
          {
            "id": "q2",
            "response": "How much do you owe?",
            "rapport_impact": -1,
            "tone_shift": -0.05,
            "techniques": ["closed_question", "transactional"],
            "feedback": "Closed question puts focus on numbers rather than their experience.",
            "maps_competencies": ["B6"],
            "maps_principles": ["explore_before_facts"],
            "next_node": "limited_response"
          },
          {
            "id": "q3",
            "response": "Have you opened any of the previous letters?",
            "rapport_impact": 0,
            "tone_shift": 0.0,
            "techniques": ["closed_question", "factual"],
            "feedback": "This is specific but still closed. Customer can only give brief answer.",
            "maps_competencies": ["B6"],
            "maps_principles": ["open_better_than_closed"],
            "next_node": "brief_response"
          }
        ]
      },
      "meeting_details": {
        "text": "Well, I know it is only going to get worse. The anxiety is really getting to me. I lie awake thinking about it.",
        "choices": [
          {
            "id": "q4",
            "response": "What goes through your mind when you are lying awake?",
            "rapport_impact": 2,
            "tone_shift": 0.1,
            "techniques": ["probing_question", "exploring_barriers"],
            "feedback": "Excellent probing question that explores internal experience.",
            "maps_competencies": ["B6", "A6", "A2"],
            "maps_principles": ["explore_motivations"],
            "next_node": "internal_experience"
          },
          {
            "id": "q5",
            "response": "How long has this been going on?",
            "rapport_impact": 0,
            "tone_shift": 0.0,
            "techniques": ["closed_question", "factual"],
            "feedback": "Shift to timeline rather than exploring the experience.",
            "maps_competencies": ["B6"],
            "maps_principles": ["explore_meaning_not_timeline"],
            "next_node": "timeline_answer"
          }
        ]
      },
      "internal_experience": {
        "text": "Honestly? I feel like such a failure. I always thought I would be more in control of things by now.",
        "choices": [
          {
            "id": "q6",
            "response": "You feel like a failure and things have not turned out the way you expected.",
            "rapport_impact": 2,
            "tone_shift": 0.15,
            "techniques": ["reflection", "helping_identify_issues"],
            "feedback": "Accurate reflection shows understanding and helps customer articulate feelings.",
            "maps_competencies": ["A6", "B6", "1.2.3"],
            "maps_principles": ["help_identify_their_issues"],
            "next_node": "deeper_exploration"
          },
          {
            "id": "q7",
            "response": "A lot of people feel like this when they have debt. It is more common than you think.",
            "rapport_impact": -1,
            "tone_shift": -0.1,
            "techniques": ["generalization", "reassurance"],
            "feedback": "Normalization can shut down customer exploration.",
            "maps_competencies": ["A6"],
            "maps_principles": ["avoid_normalizing"],
            "next_node": "closed_down"
          }
        ]
      },
      "deeper_exploration": {
        "text": "Yeah, and the thing is, I actually have a good job now. I do not know why I am still struggling.",
        "choices": [
          {
            "id": "q8",
            "response": "You have a good job but you are still struggling with debt. How does that make sense to you?",
            "rapport_impact": 3,
            "tone_shift": 0.15,
            "techniques": ["probing_discrepancy", "helping_identify_goals"],
            "feedback": "Excellent exploration that invites customer insight into their own situation.",
            "maps_competencies": ["B6", "A6", "1.2.3"],
            "maps_principles": ["explore_their_discrepancy"],
            "next_node": "insight"
          }
        ]
      },
      "insight": {
        "text": "I guess... I keep spending to maintain a lifestyle I cannot afford. And then I feel worse about myself.",
        "choices": [
          {
            "id": "q9",
            "response": "Spending to maintain a lifestyle that is beyond your means, and then feeling worse about yourself.",
            "rapport_impact": 2,
            "tone_shift": 0.1,
            "techniques": ["complex_reflection", "supporting_self_awareness"],
            "feedback": "Good reflection that supports customer self-awareness.",
            "maps_competencies": ["A2", "A6", "B6"],
            "maps_principles": ["support_self_awareness"],
            "next_node": "module_complete"
          }
        ]
      }
    },
    "choice_points": 9,
    "completion_node": "insight"
  }'::jsonb,
  '{
    "target_competencies": ["B6", "A6", "A2"],
    "maps_framework": {
      "section": "Domain 1: Knowing your Customer",
      "subsection": "1.2.1: Probing questions",
      "description": "Ask detailed and probing questions, listening carefully to understand customers\' own awareness of their need",
      "page_reference": "Page 852-857"
    },
    "dimensions": {
      "interview_flow": {"weight": 0.25, "description": "Smooth progression"},
      "facilitative_adherence": {"weight": 0.5, "description": "Probing questions and empowering style"},
      "customer_engagement": {"weight": 0.25, "description": "Customer depth of sharing"}
    },
    "success_threshold": 0.65
  }'::jsonb,
  'external',  -- module_type: external-facing (customer)
  '{
    "framework_name": "MaPS Money Guidance Competency Framework",
    "framework_version": "September 2022",
    "competencies": ["1.2.1: Probing questions", "1.2.3: Help identify goals and priorities", "B6: Communication"],
    "tier_relevance": "Tier 2",
    "key_principles": [
      "Ask detailed and probing questions",
      "Listen carefully to understand their awareness",
      "Help customers identify their own issues and goals",
      "Explore options, their pros and cons"
    ],
    "domain_reference": "Domain 2: Debt",
    "external_reference": "https://www.moneyandpensionsservice.org.uk/money-guidance-competency-framework"
  }'::jsonb
) ON CONFLICT (code) DO NOTHING;

-- ============================================
-- Module 3: Reflections
-- Focus: Showing understanding and helping articulate
-- Type: BOTH - applicable to both customers and colleagues
-- ============================================
INSERT INTO mi_practice_modules (code, title, mi_focus_area, difficulty, estimated_minutes,
                                learning_objective, scenario_context, persona_config, 
                                dialogue_structure, maps_rubric, module_type, maps_framework_alignment)
VALUES (
  'maps-reflections-001',
  'Reflections Practice',
  "customer_understanding",
  'beginner',
  5,
  'Practice using reflections to show understanding and help customers/colleagues articulate their own issues and priorities (MaPS 1.2.3).',
  'Someone is sharing about a difficult decision and how confused they feel. Practice reflecting what you hear.',
  '{
    "name": "Elena",
    "background": "Person trying to make a difficult decision",
    "role": "customer",
    "personality": {
      "defensiveness": 0.3,
      "openness": 0.5,
      "verbal_frequency": "moderate"
    },
    "tone_spectrum": {
      "start": 0.4,
      "end": 0.8,
      "start_description": "confused, overwhelmed",
      "end_description": "confident, clear"
    }
  }'::jsonb,
  '{
    "start_node": "story_start",
    "nodes": {
      "story_start": {
        "text": "I have been putting off making a decision about something important. There are so many options and I just do not know what to do.",
        "choices": [
          {
            "id": "r1",
            "response": "There are many options and you are feeling unsure about which direction to take.",
            "rapport_impact": 2,
            "tone_shift": 0.1,
            "techniques": ["reflection", "empathic_understanding"],
            "feedback": "Simple reflection of content.",
            "maps_competencies": ["A6", "B6"],
            "maps_principles": ["reflecting_back"],
            "next_node": "emotion_sharing"
          },
          {
            "id": "r2",
            "response": "That sounds overwhelming.",
            "rapport_impact": 1,
            "tone_shift": 0.05,
            "techniques": ["reflection", "acknowledging_emotion"],
            "feedback": "Reflection with emotion acknowledgment. Validates feeling.",
            "maps_competencies": ["A6", "A2"],
            "maps_principles": ["acknowledge_emotion"],
            "next_node": "emotion_sharing"
          },
          {
            "id": "r3",
            "response": "This can be complicated. What questions do you have?",
            "rapport_impact": -1,
            "tone_shift": -0.05,
            "techniques": ["transactional", "problem_solving"],
            "feedback": "Jumps to problem-solving mode rather than exploring experience.",
            "maps_competencies": ["B6"],
            "maps_principles": ["explore_before_solving"],
            "next_node": "content_only"
          }
        ]
      },
      "emotion_sharing": {
        "text": "Yeah, and honestly I feel really bad about it. I always thought I would handle things better.",
        "choices": [
          {
            "id": "r4",
            "response": "You are already feeling guilty and this connects to something important from your past.",
            "rapport_impact": 3,
            "tone_shift": 0.15,
            "techniques": ["complex_reflection", "exploring_motivations"],
            "feedback": "Excellent complex reflection. Captures the guilt and the personal meaning.",
            "maps_competencies": ["A2", "A6", "1.2.3"],
            "maps_principles": ["explore_meaning"],
            "next_node": "deeper_sharing"
          },
          {
            "id": "r5",
            "response": "It sounds like you feel guilty.",
            "rapport_impact": 1,
            "tone_shift": 0.05,
            "techniques": ["reflection", "simple_acknowledgment"],
            "feedback": "Simple reflection of emotion. Accurate but could go deeper.",
            "maps_competencies": ["A6"],
            "maps_principles": ["surface_reflection"],
            "next_node": "acknowledgment"
          }
        ]
      },
      "deeper_sharing": {
        "text": "Exactly. I know I should be grateful I even have options. A lot of people do not.",
        "choices": [
          {
            "id": "r6",
            "response": "You feel like you should be grateful, so it is hard to give yourself permission to feel stuck about this.",
            "rapport_impact": 3,
            "tone_shift": 0.15,
            "techniques": ["complex_reflection", "acknowledging_dilemma"],
            "feedback": "Complex reflection that captures the internal conflict.",
            "maps_competencies": ["A2", "A6", "1.2.3"],
            "maps_principles": ["reflect_the_dilemma"],
            "next_node": "validation"
          },
          {
            "id": "r7",
            "response": "That sounds really hard.",
            "rapport_impact": 1,
            "tone_shift": 0.05,
            "techniques": ["simple_reflection", "sympathy"],
            "feedback": "Simple validation. Misses opportunity to reflect deeper meaning.",
            "maps_competencies": ["A6"],
            "maps_principles": ["surface_validation"],
            "next_node": "continues_sharing"
          }
        ]
      },
      "validation": {
        "text": "Yeah... and the thing is, I actually want to make good choices. I just do not know where to start.",
        "choices": [
          {
            "id": "r8",
            "response": "You want to make good choices and you are feeling stuck about where to begin.",
            "rapport_impact": 2,
            "tone_shift": 0.1,
            "techniques": ["complex_reflection", "supporting_autonomy"],
            "feedback": "Good reflection that captures both the motivation and the barrier.",
            "maps_competencies": ["A5", "A6", "1.2.3"],
            "maps_principles": ["reflect_motivation_and_barrier"],
            "next_node": "reflection_complete"
          }
        ]
      }
    },
    "choice_points": 8,
    "completion_node": "validation"
  }'::jsonb,
  '{
    "target_competencies": ["A6", "A2", "A5"],
    "maps_framework": {
      "section": "Domain 1: Knowing your Customer",
      "subsection": "1.2.3: Help identify goals and priorities",
      "description": "Help customers to identify their own issues, goals and priorities",
      "page_reference": "Page 860-861"
    },
    "dimensions": {
      "interview_flow": {"weight": 0.25, "description": "Smooth progression"},
      "facilitative_adherence": {"weight": 0.5, "description": "Quality and depth of reflections"},
      "engagement": {"weight": 0.25, "description": "Person depth and emotional sharing"}
    },
    "success_threshold": 0.65
  }'::jsonb,
  'both',  -- module_type: both external and internal
  '{
    "framework_name": "MaPS Money Guidance Competency Framework",
    "framework_version": "September 2022",
    "competencies": ["1.2.3: Help identify goals and priorities", "A6: Rapport building", "A2: Self-awareness"],
    "tier_relevance": "Tier 2",
    "key_principles": [
      "Help people identify their own issues",
      "Help people identify their own goals",
      "Help people identify their own priorities",
      "Facilitate them to act on their own behalf"
    ],
    "domain_reference": "Domain 1: Knowing your Customer",
    "external_reference": "https://www.moneyandpensionsservice.org.uk/money-guidance-competency-framework"
  }'::jsonb
) ON CONFLICT (code) DO NOTHING;

-- ============================================
-- Module 4: Working with Reluctance
-- Focus: Non-directive approach with skeptics
-- Type: BOTH - applicable to both customers and colleagues
-- ============================================
INSERT INTO mi_practice_modules (code, title, mi_focus_area, difficulty, estimated_minutes,
                                learning_objective, scenario_context, persona_config, 
                                dialogue_structure, maps_rubric, module_type, maps_framework_alignment)
VALUES (
  'maps-non-directive-001',
  'Working with Reluctance',
  "working_with_resistance",
  'intermediate',
  7,
  'Practice recognizing and working with reluctance without becoming directive or argument (MaPS A3 Impartiality, A4 Diplomacy).',
  'Someone is expressing skepticism about whether they can actually change. They are testing whether you will be directive.',
  '{
    "name": "David",
    "background": "Person with persistent challenges",
    "role": "customer",
    "personality": {
      "defensiveness": 0.6,
      "openness": 0.3,
      "verbal_frequency": "direct"
    },
    "tone_spectrum": {
      "start": 0.25,
      "end": 0.65,
      "start_description": "defensive, direct, skeptical",
      "end_description": "open, reflective, engaged"
    }
  }'::jsonb,
  '{
    "start_node": "resistance_intro",
    "nodes": {
      "resistance_intro": {
        "text": "Look, I appreciate you meeting with me but I am not sure what the point is. I have heard all this before.",
        "choices": [
          {
            "id": "res1",
            "response": "You have heard it all before and you are skeptical this will be different.",
            "rapport_impact": 2,
            "tone_shift": 0.1,
            "techniques": ["reflection", "non_directive", "impartial"],
            "feedback": "Good reflection that does not take sides or try to convince.",
            "maps_competencies": ["A3", "A6", "A4"],
            "maps_principles": ["acknowledge_skepticism"],
            "next_node": "skepticism_continues"
          },
          {
            "id": "res2",
            "response": "This time will be different. We have some new approaches.",
            "rapport_impact": -2,
            "tone_shift": -0.15,
            "techniques": ["reassurance", "argumentative"],
            "feedback": "This directly contradicts their experience. Triggers more resistance.",
            "maps_competencies": ["A3"],
            "maps_principles": ["avoid_contradicting"],
            "next_node": "resistance_increases"
          },
          {
            "id": "res3",
            "response": "What have you heard before?",
            "rapport_impact": 0,
            "tone_shift": 0.0,
            "techniques": ["open_question", "neutral"],
            "feedback": "Open question is neutral but does not address the resistance.",
            "maps_competencies": ["B6"],
            "maps_principles": ["neutral_inquiry"],
            "next_node": "past_experiences"
          }
        ]
      },
      "skepticism_continues": {
        "text": "Yeah, I mean everyone keeps telling me to do things differently. But I have tried and it never works.",
        "choices": [
          {
            "id": "res4",
            "response": "You have tried different approaches and they have not worked out for you.",
            "rapport_impact": 2,
            "tone_shift": 0.1,
            "techniques": ["reflection", "empowering_not_directing"],
            "feedback": "Good reflection that validates their perspective. Does not direct.",
            "maps_competencies": ["A6", "A3", "A5"],
            "maps_principles": ["validate_experience"],
            "next_node": "defending_position"
          },
          {
            "id": "res5",
            "response": "But the approach matters.",
            "rapport_impact": -2,
            "tone_shift": -0.2,
            "techniques": ["argument", "directive"],
            "feedback": "Direct statement. Will trigger defensive response.",
            "maps_competencies": ["A3", "A4"],
            "maps_principles": ["avoid_argument"],
            "next_node": "defensive_response"
          }
        ]
      },
      "past_experiences": {
        "text": "Well, I have had people tell me what to do differently without understanding my situation.",
        "choices": [
          {
            "id": "res6",
            "response": "Those approaches did not really work for you.",
            "rapport_impact": 2,
            "tone_shift": 0.1,
            "techniques": ["reflection", "impartial"],
            "feedback": "Simple reflection that acknowledges their experience.",
            "maps_competencies": ["A3", "A6"],
            "maps_principles": ["acknowledge_history"],
            "next_node": "exploring_approach"
          },
          {
            "id": "res7",
            "response": "Maybe you just were not ready to change then.",
            "rapport_impact": -1,
            "tone_shift": -0.1,
            "techniques": ["blaming_customer", "non_impartial"],
            "feedback": "Implicitly blames them. Not collaborative.",
            "maps_competencies": ["A3", "A4"],
            "maps_principles": ["avoid_blaming"],
            "next_node": "more_resistance"
          }
        ]
      },
      "exploring_approach": {
        "text": "Right. It felt like they were just telling me what to do differently without understanding my situation.",
        "choices": [
          {
            "id": "res8",
            "response": "So what would be different this time?",
            "rapport_impact": 1,
            "tone_shift": 0.05,
            "techniques": ["open_question", "collaborative"],
            "feedback": "Invites collaboration but does not address the concern directly.",
            "maps_competencies": ["B6", "A5"],
            "maps_principles": ["explore_together"],
            "next_node": "curiosity"
          },
          {
            "id": "res9",
            "response": "I am not here to tell you what to do. I want to understand your situation first.",
            "rapport_impact": 3,
            "tone_shift": 0.2,
            "techniques": ["simple_reflection", "non_directive", "collaborative"],
            "feedback": "Excellent. Emphasizes collaboration and autonomy. Builds alliance.",
            "maps_competencies": ["A3", "A5", "A6", "1.2.9"],
            "maps_principles": ["not_directing"],
            "next_node": "engagement"
          }
        ]
      },
      "engagement": {
        "text": "Okay... that is different. What do you want to understand?",
        "choices": [
          {
            "id": "res10",
            "response": "Tell me about a time when you did manage things well. What was different about that?",
            "rapport_impact": 2,
            "tone_shift": 0.15,
            "techniques": ["probing_question", "building_on_strengths", "empowering"],
            "feedback": "Excellent shift to exploring exceptions. Builds on their strengths.",
            "maps_competencies": ["A5", "A6", "1.2.3"],
            "maps_principles": ["build_on_strengths"],
            "next_node": "resistance_reduced"
          }
        ]
      }
    },
    "choice_points": 10,
    "completion_node": "engagement"
  }'::jsonb,
  '{
    "target_competencies": ["A3", "A4", "A5", "A6"],
    "maps_framework": {
      "section": "A. Personal qualities and attributes",
      "subsection": "A3: Impartiality, A4: Diplomacy",
      "description": "A3: Be objective, not allowing themselves to be influenced by personal feelings or opinions; A4: Sensitive and skilful in managing relations with others",
      "page_reference": "Pages 533-543"
    },
    "dimensions": {
      "interview_flow": {"weight": 0.25, "description": "Smooth progression"},
      "facilitative_adherence": {"weight": 0.5, "description": "Not directing, working with their pace"},
      "engagement": {"weight": 0.25, "description": "Person openness and exploration"}
    },
    "success_threshold": 0.7
  }'::jsonb,
  'both',  -- module_type: both external and internal
  '{
    "framework_name": "MaPS Money Guidance Competency Framework",
    "framework_version": "September 2022",
    "competencies": ["A3: Impartiality", "A4: Diplomacy", "A5: Flexibility", "A6: Rapport building"],
    "tier_relevance": "Tier 2",
    "key_principles": [
      "Be objective, not influenced by personal feelings",
      "Empathetic and sensitive to their wishes",
      "Avoid arguments and confrontation",
      "Flow with resistance rather than opposing it"
    ],
    "external_reference": "https://www.moneyandpensionsservice.org.uk/money-guidance-competency-framework"
  }'::jsonb
) ON CONFLICT (code) DO NOTHING;

-- ============================================
-- Module 5: Colleague Support - Workload
-- Focus: Supporting colleagues with workload stress
-- Type: INTERNAL - Colleague-facing only
-- ============================================
INSERT INTO mi_practice_modules (code, title, mi_focus_area, difficulty, estimated_minutes,
                                learning_objective, scenario_context, persona_config, 
                                dialogue_structure, maps_rubric, module_type, maps_framework_alignment)
VALUES (
  'maps-colleague-workload-001',
  'Supporting Colleagues with Workload',
  "colleague_support",
  'beginner',
  5,
  'Practice supporting colleagues experiencing workload stress using a non-directive, empowering approach (MaPS A6, A4).',
  'A colleague has been struggling with increased workload. They have become withdrawn and seem overwhelmed.',
  '{
    "name": "James",
    "background": "Colleague in the debt advice team, struggling with caseload",
    "role": "colleague",
    "personality": {
      "defensiveness": 0.4,
      "openness": 0.5,
      "verbal_frequency": "reduced"
    },
    "tone_spectrum": {
      "start": 0.3,
      "end": 0.7,
      "start_description": "withdrawn, overwhelmed, quiet",
      "end_description": "engaged, sharing, hopeful"
    }
  }'::jsonb,
  '{
    "start_node": "initial_contact",
    "nodes": {
      "initial_contact": {
        "text": "Hi. Look, I know I have not been myself lately. The caseload has just been so heavy.",
        "choices": [
          {
            "id": "cw1",
            "response": "I have noticed and I am here if you want to talk about it.",
            "rapport_impact": 2,
            "tone_shift": 0.1,
            "techniques": ["empathic_acknowledgment", "open_invitation"],
            "feedback": "Good - notices the change and offers support without pressure.",
            "maps_competencies": ["A6", "A2"],
            "maps_principles": ["acknowledge_state"],
            "next_node": "sharing_starts"
          },
          {
            "id": "cw2",
            "response": "Yes, I am concerned about you. You seem really stressed.",
            "rapport_impact": 0,
            "tone_shift": 0.0,
            "techniques": ["observation", "concern"],
            "feedback": "Expressing concern but from a manager-like perspective.",
            "maps_competencies": ["A6"],
            "maps_principles": ["supportive_not_managing"],
            "next_node": "defensive_response"
          },
          {
            "id": "cw3",
            "response": "Have you thought about speaking to your manager about the caseload?",
            "rapport_impact": -1,
            "tone_shift": -0.1,
            "techniques": ["advice", "directive"],
            "feedback": "Jumps to solutions before understanding the situation.",
            "maps_competencies": ["A4"],
            "maps_principles": ["explore_before_solve"],
            "next_node": "dismissive_response"
          }
        ]
      },
      "sharing_starts": {
        "text": "Thanks. It is just... I do not want to seem like I cannot cope. But some days I feel completely overwhelmed.",
        "choices": [
          {
            "id": "cw4",
            "response": "You do not want to appear unable to cope, but the overwhelm is real.",
            "rapport_impact": 2,
            "tone_shift": 0.15,
            "techniques": ["complex_reflection", "empathic_listening"],
            "feedback": "Excellent reflection that captures both the concern and the reality.",
            "maps_competencies": ["A6", "A2", "A4"],
            "maps_principles": ["reflect_the_dilemma"],
            "next_node": "deeper_sharing"
          },
          {
            "id": "cw5",
            "response": "That is understandable. Have you tried any coping strategies?",
            "rapport_impact": 0,
            "tone_shift": 0.0,
            "techniques": ["advice", "question"],
            "feedback": "Moves toward solutions before fully exploring.",
            "maps_competencies": ["A6"],
            "maps_principles": ["explore_before_solve"],
            "next_node": "surface_response"
          }
        ]
      },
      "deeper_sharing": {
        "text": "Yeah, exactly. And the thing is, I do not even know where to start with getting back on top of things.",
        "choices": [
          {
            "id": "cw6",
            "response": "You want to get back on top of things but you are not sure where to begin.",
            "rapport_impact": 2,
            "tone_shift": 0.1,
            "techniques": ["reflection", "supporting_autonomy"],
            "feedback": "Acknowledges their desire to improve without directing how.",
            "maps_competencies": ["A6", "A5"],
            "maps_principles": ["acknowledge_motivation"],
            "next_node": "exploring_possibilities"
          },
          {
            "id": "cw7",
            "response": "What if we looked at your caseload together?",
            "rapport_impact": 1,
            "tone_shift": 0.05,
            "techniques": ["practical_help", "collaborative"],
            "feedback": "Offers practical help but might still feel directive.",
            "maps_competencies": ["A5", "A4"],
            "maps_principles": ["collaborative_not_directive"],
            "next_node": "cautious_acceptance"
          }
        ]
      },
      "exploring_possibilities": {
        "text": "Yeah... maybe I could start by just organizing my tasks differently?",
        "choices": [
          {
            "id": "cw8",
            "response": "Organizing your tasks differently - that is something you are considering.",
            "rapport_impact": 2,
            "tone_shift": 0.1,
            "techniques": ["affirmation", "supporting_self_determination"],
            "feedback": "Affirms their idea rather than suggesting alternatives.",
            "maps_competencies": ["A5", "A6", "A1"],
            "maps_principles": ["their_idea_better"],
            "next_node": "empowered_response"
          }
        ]
      },
      "empowered_response": {
        "text": "Yeah, I think that might help. And maybe... I should talk to my manager about my concerns?",
        "choices": [
          {
            "id": "cw9",
            "response": "You are identifying some steps you want to take. That is your decision.",
            "rapport_impact": 2,
            "tone_shift": 0.15,
            "techniques": ["affirmation", "emphasizing_autonomy"],
            "feedback": "Excellent - affirms their decision-making without directing.",
            "maps_competencies": ["A5", "A6", "A3"],
            "maps_principles": ["support_autonomy"],
            "next_node": "module_complete"
          }
        ]
      }
    },
    "choice_points": 9,
    "completion_node": "empowered_response"
  }'::jsonb,
  '{
    "target_competencies": ["A4", "A5", "A6", "B6"],
    "maps_framework": {
      "section": "B. Transferable skills and C. Self-management",
      "subsection": "B7: Working with others, C1: Self-management",
      "description": "Supporting colleagues through difficult periods while respecting their autonomy",
      "page_reference": "Pages 617-622, 656-663"
    },
    "dimensions": {
      "interview_flow": {"weight": 0.3, "description": "Smooth progression"},
      "supportive_adherence": {"weight": 0.4, "description": "Non-directive, empowering support"},
      "colleague_engagement": {"weight": 0.3, "description": "Colleague openness and problem-solving"}
    },
    "success_threshold": 0.65
  }'::jsonb,
  'internal',  -- module_type: internal-facing (colleague support)
  '{
    "framework_name": "MaPS Money Guidance Competency Framework",
    "framework_version": "September 2022",
    "competencies": ["B7: Working with others", "C1: Self-management", "A4: Diplomacy", "A5: Flexibility"],
    "tier_relevance": "All Tiers",
    "key_principles": [
      "Support colleagues without directing them",
      "Help them identify their own solutions",
      "Acknowledge their emotions and concerns",
      "Respect their autonomy in decision-making"
    ],
    "internal_focus": true,
    "external_reference": "https://www.moneyandpensionsservice.org.uk/money-guidance-competency-framework"
  }'::jsonb
) ON CONFLICT (code) DO NOTHING;

-- Verify modules with their types and MaPS alignment
SELECT 
  code, 
  title, 
  module_type,
  difficulty,
  estimated_minutes,
  maps_rubric->'target_competencies' as target_competencies,
  maps_framework_alignment->>'framework_name' as framework,
  maps_framework_alignment->>'tier_relevance' as tier
FROM mi_practice_modules
ORDER BY module_type, difficulty;
