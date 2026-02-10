-- seed_all.sql
-- Master seed script for MAPS MI Training Platform
-- Run this script after all migrations have been applied
-- 
-- Execution order:
-- 1. seed_profiles.sql - User profiles and roles
-- 2. seed_scenarios.sql - Training scenarios
-- 3. seed_mi_modules.sql - MI practice modules
-- 4. seed_learning_paths.sql - Learning paths and curricula
-- 
-- To run individually, execute the specific seed file instead

-- Verify we are in a transaction
BEGIN;

-- ============================================
-- SECTION 1: Profiles and Users
-- ============================================
\i seed_profiles.sql

-- ============================================
-- SECTION 2: Scenarios
-- ============================================
\i seed_scenarios.sql

-- ============================================
-- SECTION 3: MI Practice Modules
-- ============================================
\i seed_mi_modules.sql

-- ============================================
-- SECTION 4: Learning Paths
-- ============================================
\i seed_learning_paths.sql

-- ============================================
-- SECTION 5: Verification
-- ============================================

-- Check counts
SELECT 'Profiles' as entity, count(*) as count FROM profiles
UNION ALL SELECT 'Scenarios', count(*) FROM scenarios
UNION ALL SELECT 'MI Modules', count(*) FROM mi_practice_modules
UNION ALL SELECT 'Learning Paths', count(*) FROM mi_learning_paths;

-- Check module distribution
SELECT mi_focus_area, difficulty, count(*) as module_count
FROM mi_practice_modules
GROUP BY mi_focus_area, difficulty
ORDER BY mi_focus_area, difficulty;

-- Check learning path distribution
SELECT code, title, difficulty_level, estimated_duration_hours
FROM mi_learning_paths
ORDER BY estimated_duration_hours;

COMMIT;

-- Summary output
DO $$
BEGIN
  RAISE NOTICE '============================================';
  RAISE NOTICE 'MAPS MI Training Platform - Seed Complete';
  RAISE NOTICE '============================================';
  RAISE NOTICE '';
  RAISE NOTICE 'Seed files executed:';
  RAISE NOTICE '  1. seed_profiles.sql - User profiles';
  RAISE NOTICE '  2. seed_scenarios.sql - Training scenarios';
  RAISE NOTICE '  3. seed_mi_modules.sql - MI practice modules';
  RAISE NOTICE '  4. seed_learning_paths.sql - Learning paths';
  RAISE NOTICE '';
  RAISE NOTICE 'Run the following to verify:';
  RAISE NOTICE '  SELECT * FROM mi_practice_modules;';
  RAISE NOTICE '  SELECT * FROM mi_learning_paths;';
END $$;
