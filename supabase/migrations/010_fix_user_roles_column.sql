-- ============================================
-- FIX USER ROLES COLUMN
-- Run this directly in Supabase SQL Editor
-- ============================================

-- First, let's check the current state of the users table
SELECT column_name, data_type, column_default 
FROM information_schema.columns 
WHERE table_schema = 'public' AND table_name = 'users';

-- Add role column directly (will fail if already exists, which is fine)
-- Using DO block to handle gracefully
DO $$
BEGIN
    -- Try to add the role column
    BEGIN
        ALTER TABLE public.users ADD COLUMN role text DEFAULT 'user' 
        CHECK (role IN ('user', 'admin', 'moderator'));
        RAISE NOTICE 'SUCCESS: Added role column to public.users table';
    EXCEPTION WHEN duplicate_column THEN
        RAISE NOTICE 'INFO: role column already exists in public.users table';
    END;
    
    -- Try to add the is_active column
    BEGIN
        ALTER TABLE public.users ADD COLUMN is_active boolean DEFAULT true;
        RAISE NOTICE 'SUCCESS: Added is_active column to public.users table';
    EXCEPTION WHEN duplicate_column THEN
        RAISE NOTICE 'INFO: is_active column already exists in public.users table';
    END;
END $$;

-- Verify the columns were added
SELECT column_name, data_type, column_default 
FROM information_schema.columns 
WHERE table_schema = 'public' AND table_name = 'users'
ORDER BY ordinal_position;

-- Show all users and their roles (should show role column now)
SELECT id, email, display_name, role, is_active 
FROM public.users;

-- ============================================
-- TO PROMOTE A USER TO ADMIN, RUN:
-- ============================================
-- UPDATE public.users SET role = 'admin' WHERE email = 'your-email@example.com';
--
-- Or use the helper function (if it exists):
-- SELECT promote_to_admin('your-email@example.com');
