-- ============================================
-- USER ROLES MIGRATION
-- Run this in Supabase SQL Editor to add role-based access
-- ============================================

-- 1. Add role column to users table (if not exists)
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.columns
        WHERE table_schema = 'public' 
        AND table_name = 'users' 
        AND column_name = 'role'
    ) THEN
        ALTER TABLE public.users ADD COLUMN role text DEFAULT 'user' 
        CHECK (role IN ('user', 'admin', 'moderator'));
        RAISE NOTICE 'Added role column to users table';
    ELSE
        RAISE NOTICE 'Role column already exists in users table';
    END IF;
END $$;

-- 2. Add is_active column for banning users (if not exists)
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.columns
        WHERE table_schema = 'public' 
        AND table_name = 'users' 
        AND column_name = 'is_active'
    ) THEN
        ALTER TABLE public.users ADD COLUMN is_active boolean DEFAULT true;
        RAISE NOTICE 'Added is_active column to users table';
    ELSE
        RAISE NOTICE 'is_active column already exists in users table';
    END IF;
END $$;

-- 3. Create helper function to check if user is admin
CREATE OR REPLACE FUNCTION public.is_admin(user_id uuid)
RETURNS boolean AS $$
BEGIN
    RETURN EXISTS (
        SELECT 1 FROM public.users
        WHERE id = user_id AND role = 'admin'
    );
END;
$$ LANGUAGE plpgsql STABLE SECURITY DEFINER;

COMMENT ON FUNCTION public.is_admin IS 'Checks if a user has admin role';

-- 4. Create function to promote user to admin (run this manually)
-- Usage: SELECT promote_to_admin('user-email@example.com');
CREATE OR REPLACE FUNCTION public.promote_to_admin(user_email text)
RETURNS json AS $$
DECLARE
    target_id uuid;
    result json;
BEGIN
    -- Get user ID from email
    SELECT id INTO target_id FROM public.users WHERE email = user_email;
    
    IF target_id IS NULL THEN
        RETURN json_build_object(
            'success', false,
            'message', 'User not found with email: ' || user_email
        );
    END IF;
    
    -- Update role to admin
    UPDATE public.users 
    SET role = 'admin' 
    WHERE id = target_id;
    
    RETURN json_build_object(
        'success', true,
        'message', 'User promoted to admin',
        'user_id', target_id,
        'email', user_email
    );
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

COMMENT ON FUNCTION public.promote_to_admin IS 'Promotes a user to admin role by email';

-- 5. Create function to demote admin to user
CREATE OR REPLACE FUNCTION public.demote_from_admin(user_email text)
RETURNS json AS $$
DECLARE
    target_id uuid;
    result json;
BEGIN
    SELECT id INTO target_id FROM public.users WHERE email = user_email;
    
    IF target_id IS NULL THEN
        RETURN json_build_object(
            'success', false,
            'message', 'User not found with email: ' || user_email
        );
    END IF;
    
    UPDATE public.users 
    SET role = 'user' 
    WHERE id = target_id;
    
    RETURN json_build_object(
        'success', true,
        'message', 'Admin demoted to user',
        'user_id', target_id,
        'email', user_email
    );
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

COMMENT ON FUNCTION public.demote_from_admin IS 'Demotes an admin to user role by email';

-- ============================================
-- INSTRUCTIONS
-- ============================================
-- 
-- To promote a user to admin, run ONE of these commands in SQL Editor:
--
-- Option A: Using the helper function
-- SELECT promote_to_admin('your-email@example.com');
--
-- Option B: Direct update
-- UPDATE public.users SET role = 'admin' WHERE email = 'your-email@example.com';
--
-- To verify admin users:
-- SELECT id, email, role, is_active FROM public.users WHERE role = 'admin';
--
-- To check all users and their roles:
-- SELECT id, email, role, is_active FROM public.users ORDER BY created_at DESC;
--
-- ============================================
