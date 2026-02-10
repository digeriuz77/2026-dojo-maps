-- seed_learning_paths.sql
-- Seed learning paths for MAPS Training Platform
-- Organized by MaPS competency areas and difficulty progression
--
-- MaPS Framework Alignment:
-- - Tier 1: Factual information and signposting
-- - Tier 2: Exploring needs, setting out options, coaching for capability
-- - Tier 3: Specialist areas of bespoke information
--
-- Key MaPS Concepts Used:
-- - Facilitation over instruction (Domain 1.2.9)
-- - Empowering customers to act on their own behalf
-- - Helping customers identify their own issues, goals and priorities
-- - Impartial, non-directive approach

-- ============================================
-- Learning Path: Foundation Skills (Beginner)
-- Focus: Core facilitative coaching skills
-- ============================================
INSERT INTO mi_learning_paths (code, title, description, target_audience, 
                               estimated_duration_hours, difficulty_level,
                               prerequisites, path_structure, 
                               maps_competencies_covered, key_learning_outcomes)
VALUES (
  'maps-coaching-foundations',
  'Facilitative Coaching Foundations',
  'Master the core coaching skills needed for effective money guidance conversations. This path covers building rapport, asking probing questions, and using reflections to support customers in exploring their own financial situation.',
  'New practitioners in money guidance, debt advice, or pension support roles',
  2.5,
  'beginner',
  NULL::jsonb,
  '{
    "stages": [
      {
        "stage": 1,
        "title": "Building Rapport",
        "modules": ["maps-rapport-001"],
        "description": "Learn to establish trust and create a safe space for financial discussions (MaPS A6)",
        "estimated_minutes": 30,
        "maps_reference": "A6: Rapport building"
      },
      {
        "stage": 2,
        "title": "Probing Questions",
        "modules": ["maps-probing-questions-001"],
        "description": "Practice asking questions that help customers articulate their own awareness (MaPS 1.2.1, 1.2.3)",
        "estimated_minutes": 30,
        "maps_reference": "Domain 1: Knowing your Customer"
      },
      {
        "stage": 3,
        "title": "Reflections and Understanding",
        "modules": ["maps-reflections-001"],
        "description": "Develop reflective listening skills to show understanding",
        "estimated_minutes": 30,
        "maps_reference": "A6: Empathy, A2: Self-awareness"
      },
      {
        "stage": 4,
        "title": "Working with Reluctance",
        "modules": ["maps-non-directive-001"],
        "description": "Learn to work with customer reluctance without being directive (MaPS A3, A4)",
        "estimated_minutes": 45,
        "maps_reference": "A3: Impartiality, A4: Diplomacy"
      }
    ],
    "progression": "sequential",
    "completion_bonus": {
      "badge": "Facilitative Coaching Foundation",
      "certificate": true
    },
    "maps_tier": "Tier 1-2"
  }'::jsonb,
  '{
    "maps_competencies": ["A3", "A4", "A5", "A6", "B6", "A2"],
    "maps_framework": {
      "section": "6.1 Foundation skills and behaviours",
      "description": "Personal qualities, transferable skills, and self-management"
    },
    "domains": ["knowing_customer", "communication"],
    "tier_focus": "Tier 1"
  }'::jsonb,
  ARRAY[
    'Demonstrate rapport-building techniques appropriate for financial conversations',
    'Ask probing questions that invite customers to share their own awareness',
    'Use reflections to show understanding and help customers articulate their situation',
    'Work with customer reluctance without being directive or argumentative',
    'Apply facilitative coaching within MaPS service boundaries'
  ]
) ON CONFLICT (code) DO NOTHING;

-- ============================================
-- Learning Path: Debt Advice Specialization
-- Focus: Coaching for debt conversations
-- ============================================
INSERT INTO mi_learning_paths (code, title, description, target_audience, 
                               estimated_duration_hours, difficulty_level,
                               prerequisites, path_structure, 
                               maps_competencies_covered, key_learning_outcomes)
VALUES (
  'maps-debt-coaching',
  'Facilitative Coaching for Debt Advice',
  'Develop advanced coaching skills specifically for debt advice scenarios. Learn to navigate the emotional complexity of debt while supporting customers to identify their own path forward.',
  'Debt advice practitioners, money helpers, and consumer finance supporters',
  3.5,
  'intermediate',
  '{"required": ["maps-coaching-foundations"], "recommended": ["debt_domain_knowledge"]}'::jsonb,
  '{
    "stages": [
      {
        "stage": 1,
        "title": "Opening Debt Conversations",
        "modules": ["maps-rapport-001"],
        "description": "Establish safety when discussing sensitive debt topics",
        "estimated_minutes": 30,
        "maps_reference": "A6: Rapport building"
      },
      {
        "stage": 2,
        "title": "Exploring Financial Avoidance",
        "modules": ["maps-probing-questions-001"],
        "description": "Help customers articulate why they have avoided dealing with debt",
        "estimated_minutes": 30,
        "maps_reference": "1.2.1: Probing questions"
      },
      {
        "stage": 3,
        "title": "Reflecting Emotions and Meaning",
        "modules": ["maps-reflections-001"],
        "description": "Address shame and emotional barriers to financial action",
        "estimated_minutes": 30,
        "maps_reference": "A6: Empathy, 1.2.3: Help identify issues"
      },
      {
        "stage": 4,
        "title": "Handling Financial Skepticism",
        "modules": ["maps-non-directive-001"],
        "description": "Work with customers who doubt change is possible",
        "estimated_minutes": 45,
        "maps_reference": "A3: Impartiality"
      },
      {
        "stage": 5,
        "title": "Supporting Customer Autonomy",
        "modules": ["maps-empowering-001"],
        "description": "Help customers identify their own goals and priorities",
        "estimated_minutes": 45,
        "maps_reference": "1.2.3: Help customers identify their own issues"
      },
      {
        "stage": 6,
        "title": "Debt Scenario Practice",
        "modules": ["maps-scenario-debt-001"],
        "description": "Apply all skills in a realistic debt advice scenario",
        "estimated_minutes": 60,
        "maps_reference": "Domain 2: Debt"
      }
    ],
    "progression": "sequential",
    "completion_bonus": {
      "badge": "Debt Advice Coaching Specialist",
      "certificate": true,
      "specialization": "Debt"
    },
    "maps_tier": "Tier 1-2"
  }'::jsonb,
  '{
    "maps_competencies": ["A3", "A4", "A5", "A6", "B6", "A1", "A2", "B2"],
    "maps_framework": {
      "section": "Domain 2: Debt",
      "description": "Tier 1-2 debt guidance within regulated boundaries"
    },
    "domains": ["debt", "knowing_customer", "communication"],
    "tier_focus": "Tier 1-2"
  }'::jsonb,
  ARRAY[
    'Navigate emotional barriers to debt discussions with compassion',
    'Support customers in exploring their relationship with debt',
    'Use coaching techniques within regulated debt guidance boundaries',
    'Help customers identify their own motivation for financial action',
    'Work effectively with customers who feel stuck or hopeless about debt'
  ]
) ON CONFLICT (code) DO NOTHING;

-- ============================================
-- Learning Path: Pensions Guidance
-- Focus: Coaching for pension decisions
-- ============================================
INSERT INTO mi_learning_paths (code, title, description, target_audience, 
                               estimated_duration_hours, difficulty_level,
                               prerequisites, path_structure, 
                               maps_competencies_covered, key_learning_outcomes)
VALUES (
  'maps-pensions-coaching',
  'Facilitative Coaching for Pension Guidance',
  'Apply coaching skills to pension and retirement planning conversations. Support customers in making confident decisions about their financial future without being directive.',
  'Pension guidance practitioners, retirement planning supporters, MaPS pension team',
  3.0,
  'intermediate',
  '{"required": ["maps-coaching-foundations"], "recommended": ["pensions_domain_knowledge"]}'::jsonb,
  '{
    "stages": [
      {
        "stage": 1,
        "title": "Rapport for Sensitive Discussions",
        "modules": ["maps-rapport-001"],
        "description": "Build trust when discussing retirement finances",
        "estimated_minutes": 30,
        "maps_reference": "A6: Rapport building"
      },
      {
        "stage": 2,
        "title": "Exploring Pension Awareness",
        "modules": ["maps-probing-questions-001"],
        "description": "Understand customer awareness and concerns about pensions",
        "estimated_minutes": 30,
        "maps_reference": "1.2.1: Understand customers own awareness"
      },
      {
        "stage": 3,
        "title": "Reflecting Values and Goals",
        "modules": ["maps-reflections-001"],
        "description": "Connect pension decisions to customer values and life goals",
        "estimated_minutes": 30,
        "maps_reference": "1.2.3: Help identify goals and priorities"
      },
      {
        "stage": 4,
        "title": "Handling Pension Anxiety",
        "modules": ["maps-non-directive-001"],
        "description": "Work with customers overwhelmed by pension complexity",
        "estimated_minutes": 45,
        "maps_reference": "A5: Flexibility, A4: Diplomacy"
      },
      {
        "stage": 5,
        "title": "Supporting Pension Engagement",
        "modules": ["maps-empowering-001"],
        "description": "Help customers engage with pension decisions at their own pace",
        "estimated_minutes": 45,
        "maps_reference": "1.2.9: Facilitate customers to act on their own behalf"
      },
      {
        "stage": 6,
        "title": "Pension Scenario Practice",
        "modules": ["maps-scenario-pensions-001"],
        "description": "Apply skills in a pension decision-making scenario",
        "estimated_minutes": 60,
        "maps_reference": "Domain 11: Pensions"
      }
    ],
    "progression": "sequential",
    "completion_bonus": {
      "badge": "Pension Guidance Coaching Specialist",
      "certificate": true,
      "specialization": "Pensions"
    },
    "maps_tier": "Tier 1-2"
  }'::jsonb,
  '{
    "maps_competencies": ["A3", "A4", "A5", "A6", "B6", "A1", "A2", "A5", "B2"],
    "maps_framework": {
      "section": "Domain 11: Pensions",
      "description": "Tier 1-2 pension guidance within regulated boundaries"
    },
    "domains": ["pensions", "knowing_customer", "communication"],
    "tier_focus": "Tier 1-2"
  }'::jsonb,
  ARRAY[
    'Support customers in exploring pension options without being directive',
    'Connect retirement planning to customer values and life goals',
    'Address anxiety and overwhelm around pension decisions',
    'Help customers identify their own readiness for pension action',
    'Work within MaPS pension guidance boundaries'
  ]
) ON CONFLICT (code) DO NOTHING;

-- ============================================
-- Learning Path: Advanced Practitioner
-- Focus: Complex conversations and customer empowerment
-- ============================================
INSERT INTO mi_learning_paths (code, title, description, target_audience, 
                               estimated_duration_hours, difficulty_level,
                               prerequisites, path_structure, 
                               maps_competencies_covered, key_learning_outcomes)
VALUES (
  'maps-advanced-coaching',
  'Advanced Facilitative Coaching for Complex Financial Conversations',
  'Master advanced coaching techniques for challenging situations including customers with complex needs, repeated patterns, and those resistant to change.',
  'Experienced practitioners, team leaders, and specialists in complex cases',
  5.0,
  'advanced',
  '{"required": ["maps-coaching-foundations"], "recommended": ["supervision_experience"]}'::jsonb,
  '{
    "stages": [
      {
        "stage": 1,
        "title": "Complex Reflections",
        "modules": ["maps-complex-reflections-001"],
        "description": "Develop sophisticated reflection skills for layered conversations",
        "estimated_minutes": 45,
        "maps_reference": "A2: Self-awareness, A6: Empathy"
      },
      {
        "stage": 2,
        "title": "Empowering Customer Autonomy",
        "modules": ["maps-empowering-001"],
        "description": "Master the art of supporting customers to identify their own solutions",
        "estimated_minutes": 45,
        "maps_reference": "1.2.9: Facilitate customers to act on their own behalf"
      },
      {
        "stage": 3,
        "title": "Working with Sustained Reluctance",
        "modules": ["maps-sustain-talk-001"],
        "description": "Work effectively with ongoing customer reluctance",
        "estimated_minutes": 45,
        "maps_reference": "A3: Impartiality, A4: Diplomacy"
      },
      {
        "stage": 4,
        "title": "OARS Integration",
        "modules": ["maps-oars-integration-001"],
        "description": "Seamlessly integrate Open questions, Affirmations, Reflections, Summaries",
        "estimated_minutes": 45,
        "maps_reference": "B6: Communication"
      },
      {
        "stage": 5,
        "title": "Complex Scenarios",
        "modules": ["maps-scenario-complex-001"],
        "description": "Apply all skills in multifaceted financial situations",
        "estimated_minutes": 90,
        "maps_reference": "All domains"
      },
      {
        "stage": 6,
        "title": "Coaching Colleagues",
        "modules": ["maps-supervision-001"],
        "description": "Use coaching principles when supporting other practitioners",
        "estimated_minutes": 45,
        "maps_reference": "C1: Self-management, C2: Improve practice"
      }
    ],
    "progression": "sequential",
    "completion_bonus": {
      "badge": "Advanced Facilitative Coaching Practitioner",
      "certificate": true,
      "eligibility": "Coaching Mentor Pathway"
    },
    "maps_tier": "Tier 2-3"
  }'::jsonb,
  '{
    "maps_competencies": ["A1", "A2", "A3", "A4", "A5", "A6", "B1", "B2", "B6", "C1", "C2"],
    "maps_framework": {
      "section": "6 Foundation and Tier descriptors",
      "description": "Tier 2: Exploring needs, setting out options, coaching to improve capability"
    },
    "domains": ["all"],
    "tier_focus": "Tier 2-3"
  }'::jsonb,
  ARRAY[
    'Use complex reflections to address multiple layers of customer concerns',
    'Effectively support customers in identifying their own solutions',
    'Navigate sustained reluctance without argument or confrontation',
    'Integrate all facilitative coaching skills fluidly in complex conversations',
    'Apply coaching principles when supporting other practitioners'
  ]
) ON CONFLICT (code) DO NOTHING;

-- ============================================
-- Learning Path: Colleague Support (Internal)
-- Focus: Coaching skills for MAPS staff support
-- ============================================
INSERT INTO mi_learning_paths (code, title, description, target_audience, 
                               estimated_duration_hours, difficulty_level,
                               prerequisites, path_structure, 
                               maps_competencies_covered, key_learning_outcomes)
VALUES (
  'maps-colleague-support',
  'Coaching for Supporting Colleagues',
  'Apply coaching skills when supporting colleagues experiencing workload stress, burnout, or financial difficulties. Build a supportive team culture.',
  'Team leaders, managers, HR supporters, and peer support workers within MaPS',
  1.5,
  'beginner',
  NULL::jsonb,
  '{
    "stages": [
      {
        "stage": 1,
        "title": "Understanding Colleague Stress",
        "modules": ["maps-rapport-001"],
        "description": "Build trust with colleagues experiencing work-related stress",
        "estimated_minutes": 20,
        "maps_reference": "A6: Rapport building"
      },
      {
        "stage": 2,
        "title": "Exploring Work Challenges",
        "modules": ["maps-probing-questions-001"],
        "description": "Help colleagues articulate their workload concerns",
        "estimated_minutes": 20,
        "maps_reference": "1.2.1: Probing questions"
      },
      {
        "stage": 3,
        "title": "Reflecting Colleague Experience",
        "modules": ["maps-reflections-001"],
        "description": "Show understanding of workplace stress and burnout",
        "estimated_minutes": 20,
        "maps_reference": "A6: Empathy"
      },
      {
        "stage": 4,
        "title": "Supportive Conversations",
        "modules": ["maps-colleague-scenario-001"],
        "description": "Practice supportive conversations with colleagues",
        "estimated_minutes": 30,
        "maps_reference": "A4: Diplomacy, B6: Communication"
      }
    ],
    "progression": "sequential",
    "completion_bonus": {
      "badge": "Colleague Support Practitioner",
      "certificate": true
    },
    "maps_tier": "All"
  }'::jsonb,
  '{
    "maps_competencies": ["A1", "A2", "A4", "A5", "A6", "B6", "C1"],
    "maps_framework": {
      "section": "B. Transferable skills",
      "description": "Communication and working with others"
    },
    "domains": ["communication", "team_support"],
    "tier_focus": "All"
  }'::jsonb,
  ARRAY[
    'Initiate supportive conversations with colleagues experiencing stress',
    'Listen non-judgmentally to colleague concerns about workload',
    'Use coaching techniques to help colleagues find their own solutions',
    'Recognize when colleagues may need formal support or resources',
    'Maintain appropriate boundaries while being supportive'
  ]
) ON CONFLICT (code) DO NOTHING;

-- ============================================
-- Path Prerequisites Table
-- ============================================
INSERT INTO mi_path_prerequisites (path_code, prerequisite_type, prerequisite_code, 
                                   prerequisite_name, description, is_required)
VALUES 
  ('maps-debt-coaching', 'path', 'maps-coaching-foundations', 'Facilitative Coaching Foundations', 
   'Completion of Foundation Skills path required', true),
  ('maps-pensions-coaching', 'path', 'maps-coaching-foundations', 'Facilitative Coaching Foundations', 
   'Completion of Foundation Skills path required', true),
  ('maps-advanced-coaching', 'path', 'maps-coaching-foundations', 'Facilitative Coaching Foundations', 
   'Foundation skills are prerequisite for advanced work', true),
  ('maps-advanced-coaching', 'path', 'maps-debt-coaching', 'Debt Advice Coaching Specialist', 
   'Debt specialization provides necessary practice context', false),
  ('maps-advanced-coaching', 'path', 'maps-pensions-coaching', 'Pension Guidance Coaching Specialist', 
   'Pensions specialization provides necessary practice context', false),
  ('maps-colleague-support', 'recommendation', 'maps-coaching-foundations', 'Facilitative Coaching Foundations', 
   'Foundation skills are recommended but not required', false)
ON CONFLICT (path_code, prerequisite_code) DO NOTHING;

-- ============================================
-- Competency Mapping Updates
-- Update mi_practice_modules with MaPS rubric mapping
-- ============================================
UPDATE mi_practice_modules
SET maps_rubric = maps_rubric || '{
  "maps_framework": {
    "section": "6.1 Foundation skills and behaviours",
    "description": "Facilitative coaching approach: helping customers identify their own issues, goals and priorities (Domain 1.2.3) and facilitating customers to act on their own behalf (1.2.9)",
    "key_principles": [
      "Facilitation over instruction",
      "Empowering customers to manage their own affairs",
      "Impartial, non-directive guidance",
      "Helping customers identify their own goals and priorities"
    ],
    "service_boundaries": "Guidance not Advice - non-regulated money guidance"
  }
}'::jsonb
WHERE code IN ('maps-rapport-001', 'maps-probing-questions-001', 'maps-reflections-001', 'maps-non-directive-001');

-- Verify learning paths
SELECT code, title, difficulty_level, estimated_duration_hours,
       (path_structure->>'stages')::int as stages_count,
       path_structure->'completion_bonus'->>'badge' as badge_name
FROM mi_learning_paths
ORDER BY estimated_duration_hours;
