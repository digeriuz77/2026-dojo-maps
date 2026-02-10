-- seed_profiles.sql
-- Seed user profiles for MAPS MI Training Platform
-- Prerequisite: Users must exist in auth.users first

-- Option 1: Insert profiles by email lookup (recommended)
INSERT INTO profiles (id, email, role)
SELECT
    au.id,
    au.email,
    CASE
        WHEN au.email = 'admin@mapspractice.org' THEN 'FULL'
        WHEN au.email = 'demo@mapspractice.org' THEN 'CONTROL'
        ELSE 'CONTROL'  -- Default to CONTROL for safety
    END as role
FROM auth.users au
WHERE au.email IN ('admin@mapspractice.org', 'demo@mapspractice.org')
ON CONFLICT (id) DO UPDATE SET
    email = EXCLUDED.email,
    role = EXCLUDED.role,
    updated_at = NOW();

-- Option 2: Manual insert (if you know the exact UUIDs)
-- Uncomment and modify the IDs to match your actual auth.users entries:
/*
INSERT INTO profiles (id, email, role)
VALUES
    ('73f08f90-6b02-42b9-a1dd-5b4a7c854f07', 'admin@mapspractice.org', 'FULL'),
    ('01c5046d-3854-46af-8fe6-012c893171c0', 'demo@mapspractice.org', 'CONTROL')
ON CONFLICT (id) DO NOTHING;
*/

-- Verify the insert
SELECT
    p.id,
    p.email,
    p.role,
    p.created_at,
    au.created_at as auth_user_created_at
FROM profiles p
JOIN auth.users au ON p.id = au.id
ORDER BY p.created_at DESC;
