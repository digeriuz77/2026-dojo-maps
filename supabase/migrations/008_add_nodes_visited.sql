-- Migration: Add nodes_visited column to user_progress
-- This tracks all nodes visited (not just correctly completed ones)
-- for more accurate progress tracking

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
UPDATE public.user_progress
SET nodes_visited = nodes_completed
WHERE nodes_visited IS NULL OR nodes_visited = '{}'::text[];

-- Add comment
COMMENT ON COLUMN public.user_progress.nodes_visited IS 'Array of node IDs that have been visited (for progress tracking), separate from nodes_completed (correct answers only)';
