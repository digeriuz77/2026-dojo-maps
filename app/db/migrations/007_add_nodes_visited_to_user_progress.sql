-- Migration: Add nodes_visited column to user_progress
-- Date: 2026-02-26
-- Description: Adds nodes_visited array column for tracking all visited dialogue nodes

DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM information_schema.columns
        WHERE table_schema = 'public'
          AND table_name = 'user_progress'
          AND column_name = 'nodes_visited'
    ) THEN
        ALTER TABLE public.user_progress
            ADD COLUMN nodes_visited TEXT[] NOT NULL DEFAULT '{}'::text[];

        RAISE NOTICE 'Added nodes_visited column to user_progress';
    ELSE
        RAISE NOTICE 'nodes_visited column already exists on user_progress';
    END IF;
END $$;

COMMENT ON COLUMN public.user_progress.nodes_visited
    IS 'Ordered list of dialogue node IDs visited by the user during module progression';
