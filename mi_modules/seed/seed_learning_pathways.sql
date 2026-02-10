-- supabase/seed/seed_learning_pathways.sql
-- MAPS Learning Pathways Configuration
--
-- Usage:
--   supabase db execute --file supabase/seed/seed_learning_pathways.sql
-- Or paste into Supabase SQL Editor

-- ============================================
-- INSERT LEARNING PATHWAYS
-- ============================================

INSERT INTO mi_learning_pathways (id, pathway_data)
VALUES (
    'pathway_foundational',
    '{"id": "pathway_foundational", "name": "Foundational MI Skills", "description": "Core motivational interviewing skills that apply universally across customer and colleague contexts. Start here for new learners.", "target_audience": "All practitioners", "estimated_total_minutes": 85, "modules": [{"module_code": "shared-collaborative-climate-007", "order": 1, "title": "Collaborative Climate - Partnership & Autonomy", "focus": "Establishing partnership, honoring autonomy, collaborative approach", "estimated_minutes": 10}, {"module_code": "shared-simple-reflections-001", "order": 2, "title": "Simple Reflections - Core Skill Practice", "focus": "Basic reflective listening, capturing what was said", "estimated_minutes": 10}, {"module_code": "shared-open-questions-002", "order": 3, "title": "Open-Ended Questions - Building Rapport", "focus": "Asking questions that invite exploration rather than yes/no", "estimated_minutes": 12}, {"module_code": "shared-affirmations-004", "order": 4, "title": "Affirmations - Recognizing Strengths", "focus": "Noticing and acknowledging strengths, effort, and positive qualities", "estimated_minutes": 10}, {"module_code": "shared-complex-reflections-003", "order": 5, "title": "Complex & Double-Sided Reflections - Exploring Ambivalence", "focus": "Adding meaning, emotion, and capturing both sides of ambivalence", "estimated_minutes": 15}, {"module_code": "shared-summarizing-005", "order": 6, "title": "Summarizing - Linking and Transitioning", "focus": "Pulling together key points, linking themes, smooth transitions", "estimated_minutes": 12}, {"module_code": "shared-confidence-scaling-008", "order": 7, "title": "Confidence Scaling - Assessment Practice", "focus": "Using scales to assess readiness and explore what increases/decreases confidence", "estimated_minutes": 10}, {"module_code": "shared-change-talk-006", "order": 8, "title": "Recognizing & Evoking Change Talk", "focus": "Recognizing different types of change talk and using reflections to evoke more", "estimated_minutes": 15}], "learning_outcomes": ["Establish collaborative partnerships with customers and colleagues", "Use reflective listening to demonstrate understanding", "Ask open-ended questions that invite exploration", "Recognize and affirm strengths and effort", "Navigate ambivalence without taking sides", "Summarize key points and link themes together", "Assess readiness using confidence scaling", "Recognize and evoke change talk"], "maps_competencies": ["A3", "A6", "B6"], "tier_relevance": "All Tiers"}'::jsonb
) ON CONFLICT (id) DO UPDATE SET
    pathway_data = EXCLUDED.pathway_data,
    updated_at = NOW();

INSERT INTO mi_learning_pathways (id, pathway_data)
VALUES (
    'pathway_intermediate',
    '{"id": "pathway_intermediate", "name": "Intermediate MI Applications", "description": "Intermediate skills for facilitating decision-making and supporting autonomous choices. Builds on foundational skills.", "prerequisites": ["pathway_foundational"], "target_audience": "Practitioners with basic MI experience", "estimated_total_minutes": 60, "modules": [{"module_code": "shared-decisional-balance-009", "order": 1, "title": "Decisional Balance - Exploring Pros and Cons", "focus": "Exploring both sides of ambivalence systematically", "estimated_minutes": 12}, {"module_code": "shared-elicit-provide-elicit-010", "order": 2, "title": "Elicit-Provide-Elicit - Information Exchange", "focus": "Sharing information collaboratively with permission", "estimated_minutes": 12}, {"module_code": "shared-planning-011", "order": 3, "title": "Planning - Developing Change Plans", "focus": "Supporting people to develop their own change plans", "estimated_minutes": 15}, {"module_code": "shared-anticipatory-coping-012", "order": 4, "title": "Anticipatory Coping - Preparing for Challenges", "focus": "Helping people anticipate obstacles and develop coping strategies", "estimated_minutes": 12}, {"module_code": "shared-collaborative-climate-007", "order": 5, "title": "Collaborative Climate - Reinforcement", "focus": "Reinforcing partnership and autonomy throughout interactions", "estimated_minutes": 10}], "learning_outcomes": ["Facilitate decisional balance exercises", "Share information using Elicit-Provide-Elicit", "Support autonomous change planning", "Help people anticipate and prepare for challenges", "Maintain collaborative climate throughout all interactions"], "maps_competencies": ["A3", "A5", "A6", "B6"], "tier_relevance": "All Tiers"}'::jsonb
) ON CONFLICT (id) DO UPDATE SET
    pathway_data = EXCLUDED.pathway_data,
    updated_at = NOW();

INSERT INTO mi_learning_pathways (id, pathway_data)
VALUES (
    'pathway_customer_tier1',
    '{"id": "pathway_customer_tier1", "name": "Customer-Facing: Tier 1 Initial Engagement", "description": "Skills for initial customer interactions, building rapport, and understanding customer needs. Focus on Domains 1, 2, and 5.", "prerequisites": ["pathway_foundational"], "target_audience": "Tier 1 Money Guidance Practitioners", "estimated_total_minutes": 48, "modules": [{"module_code": "customer-debt-initial-001", "order": 1, "title": "Debt Advice: Initial Engagement", "focus": "Domain 2 - Building rapport with customers seeking debt advice, reducing shame", "estimated_minutes": 12}, {"module_code": "customer-financial-anxiety-003", "order": 2, "title": "Supporting Financial Anxiety", "focus": "Domain 1 - Supporting anxious customers with empathy and validation", "estimated_minutes": 12}, {"module_code": "customer-savings-goals-004", "order": 3, "title": "Savings Goal Setting", "focus": "Domain 5 - Facilitating savings goal exploration using evoking", "estimated_minutes": 12}, {"module_code": "customer-budgeting-002", "order": 4, "title": "Budget Planning with Impartial Guidance", "focus": "Domain 5 - Facilitative coaching approach to budget discussions", "estimated_minutes": 12}], "learning_outcomes": ["Build rapport with customers seeking debt advice", "Support customers experiencing financial anxiety", "Facilitate savings goal exploration", "Guide budget discussions using impartial facilitation", "Apply MI skills across Domains 1, 2, and 5"], "maps_competencies": ["A1", "A3", "A5", "A6", "B6"], "tier_relevance": "Tier 1", "maps_domains": ["Domain 1: Knowing Customer", "Domain 2: Debt", "Domain 5: Budgeting"]}'::jsonb
) ON CONFLICT (id) DO UPDATE SET
    pathway_data = EXCLUDED.pathway_data,
    updated_at = NOW();

INSERT INTO mi_learning_pathways (id, pathway_data)
VALUES (
    'pathway_customer_tier2',
    '{"id": "pathway_customer_tier2", "name": "Customer-Facing: Tier 2 Complex Guidance", "description": "Skills for complex customer scenarios including pensions and longer-term planning. Focus on Domain 11.", "prerequisites": ["pathway_customer_tier1", "pathway_intermediate"], "target_audience": "Tier 2 Money Guidance Practitioners", "estimated_total_minutes": 24, "modules": [{"module_code": "customer-pensions-exploration-005", "order": 1, "title": "Pensions Exploration: Future Planning Discussion", "focus": "Domain 11 - Facilitating pensions exploration with impartial guidance", "estimated_minutes": 12}, {"module_code": "shared-decisional-balance-009", "order": 2, "title": "Decisional Balance for Complex Decisions", "focus": "Applying decisional balance to complex financial decisions", "estimated_minutes": 12}], "learning_outcomes": ["Facilitate pensions exploration conversations", "Apply impartial guidance to complex financial topics", "Use decisional balance for complex decisions", "Support customer decision-making in Domain 11"], "maps_competencies": ["A3", "A5", "A6", "B6"], "tier_relevance": "Tier 2", "maps_domains": ["Domain 11: Pensions"]}'::jsonb
) ON CONFLICT (id) DO UPDATE SET
    pathway_data = EXCLUDED.pathway_data,
    updated_at = NOW();

INSERT INTO mi_learning_pathways (id, pathway_data)
VALUES (
    'pathway_colleague_foundation',
    '{"id": "pathway_colleague_foundation", "name": "Colleague-Facing: Foundation Skills", "description": "Core skills for internal coaching and development conversations with colleagues.", "prerequisites": ["pathway_foundational"], "target_audience": "Team Leads, Managers, Senior Practitioners", "estimated_total_minutes": 36, "modules": [{"module_code": "colleague-career-development-002", "order": 1, "title": "Career Development: Coaching Conversation", "focus": "Facilitative coaching approach to career development discussions", "estimated_minutes": 12}, {"module_code": "colleague-performance-review-001", "order": 2, "title": "Performance Review: Reflective Practice", "focus": "Using reflective approach in performance discussions", "estimated_minutes": 12}, {"module_code": "colleague-skill-gap-003", "order": 3, "title": "Skill Gap Coaching: Development Support", "focus": "Coaching conversations about skill gaps while maintaining dignity", "estimated_minutes": 12}], "learning_outcomes": ["Facilitate career development conversations", "Use reflective approaches in performance reviews", "Coach colleagues on skill gaps while maintaining dignity", "Apply MI skills to internal workplace contexts"], "maps_competencies": ["A4", "A6", "B6", "C1", "C2"], "tier_relevance": "Tier 2-3", "context": "Internal Coaching and Development"}'::jsonb
) ON CONFLICT (id) DO UPDATE SET
    pathway_data = EXCLUDED.pathway_data,
    updated_at = NOW();

INSERT INTO mi_learning_pathways (id, pathway_data)
VALUES (
    'pathway_colleague_advanced',
    '{"id": "pathway_colleague_advanced", "name": "Colleague-Facing: Team Dynamics", "description": "Advanced skills for facilitating team dynamics and mediation.", "prerequisites": ["pathway_colleague_foundation", "pathway_intermediate"], "target_audience": "Team Leads, Managers, Senior Practitioners", "estimated_total_minutes": 15, "modules": [{"module_code": "colleague-team-dynamics-004", "order": 1, "title": "Team Dynamics: Mediation and Facilitation", "focus": "Facilitating team dynamics discussions while maintaining neutrality", "estimated_minutes": 15}], "learning_outcomes": ["Facilitate team dynamics discussions", "Maintain neutrality in conflict situations", "Use MI skills for team mediation", "Apply advanced MI to complex workplace dynamics"], "maps_competencies": ["A4", "A6", "B6", "C1"], "tier_relevance": "Tier 2-3", "context": "Team Mediation and Facilitation"}'::jsonb
) ON CONFLICT (id) DO UPDATE SET
    pathway_data = EXCLUDED.pathway_data,
    updated_at = NOW();

INSERT INTO mi_learning_pathways (id, pathway_data)
VALUES (
    'pathway_assessment',
    '{"id": "pathway_assessment", "name": "Assessment and Feedback Practice", "description": "Practice modules focusing on assessment skills and providing effective feedback on MI practice.", "prerequisites": ["pathway_foundational"], "target_audience": "Assessors, Trainers, Team Leads", "estimated_total_minutes": 37, "modules": [{"module_code": "shared-confidence-scaling-008", "order": 1, "title": "Confidence Scaling Assessment Practice", "focus": "Using scales to assess practitioner confidence and skill development", "estimated_minutes": 10}, {"module_code": "shared-change-talk-006", "order": 2, "title": "Recognizing Change Talk in Practice", "focus": "Assessing ability to recognize and evoke change talk", "estimated_minutes": 15}, {"module_code": "shared-anticipatory-coping-012", "order": 3, "title": "Anticipating Challenges in Practice", "focus": "Helping practitioners anticipate and prepare for practice challenges", "estimated_minutes": 12}], "learning_outcomes": ["Use scaling for assessment purposes", "Recognize and assess change talk in practice", "Support practitioners in anticipating practice challenges", "Provide effective feedback on MI skills"], "maps_competencies": ["A6", "B6", "C2"], "tier_relevance": "All Tiers (Assessment)"}'::jsonb
) ON CONFLICT (id) DO UPDATE SET
    pathway_data = EXCLUDED.pathway_data,
    updated_at = NOW();

-- ============================================
-- VERIFICATION QUERY
-- ============================================
-- Uncomment to verify insertion:
-- SELECT id, pathway_data->>'name' as name, pathway_data->>'target_audience' as audience
-- FROM mi_learning_pathways;
