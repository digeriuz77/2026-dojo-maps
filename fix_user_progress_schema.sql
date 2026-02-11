-- =====================================================
-- Fix user_progress table schema
-- Add nodes_visited column if missing
-- =====================================================
-- This migration ensures the user_progress table has all required columns
-- for proper module tracking and progress monitoring.
--
-- Run this in Supabase SQL Editor if you're getting errors about
-- "Could not find the 'nodes_visited' column"

-- Add nodes_visited column if it doesn't exist
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.columns 
        WHERE table_schema = 'public' 
        AND table_name = 'user_progress' 
        AND column_name = 'nodes_visited'
    ) THEN
        ALTER TABLE public.user_progress 
        ADD COLUMN nodes_visited text[] NULL DEFAULT '{}'::text[];
        
        RAISE NOTICE 'Added nodes_visited column to user_progress';
    ELSE
        RAISE NOTICE 'nodes_visited column already exists';
    END IF;
END $$;

-- Initialize nodes_visited from nodes_completed for existing records
-- This ensures backward compatibility with existing progress data
UPDATE public.user_progress
SET nodes_visited = COALESCE(nodes_completed, '{}'::text[])
WHERE nodes_visited IS NULL OR nodes_visited = '{}'::text[];

-- Add helpful comment
COMMENT ON COLUMN public.user_progress.nodes_visited IS 'Array of node IDs that have been visited (for progress tracking), separate from nodes_completed (correct answers only)';

-- Verify the column was added
DO $$
BEGIN
    IF EXISTS (
        SELECT 1 FROM information_schema.columns 
        WHERE table_schema = 'public' 
        AND table_name = 'user_progress' 
        AND column_name = 'nodes_visited'
    ) THEN
        RAISE NOTICE '✅ nodes_visited column is now present in user_progress table';
    ELSE
        RAISE EXCEPTION '❌ Failed to add nodes_visited column';
    END IF;
END $$;
