-- Migration: Add missing points_earned columns for schema/app alignment
-- Date: 2026-02-26

DO $$
BEGIN
    -- user_progress.points_earned
    IF NOT EXISTS (
        SELECT 1
        FROM information_schema.columns
        WHERE table_schema = 'public'
          AND table_name = 'user_progress'
          AND column_name = 'points_earned'
    ) THEN
        ALTER TABLE public.user_progress
            ADD COLUMN points_earned INTEGER NOT NULL DEFAULT 0;

        RAISE NOTICE 'Added user_progress.points_earned';
    ELSE
        RAISE NOTICE 'user_progress.points_earned already exists';
    END IF;

    -- dialogue_attempts.points_earned
    IF NOT EXISTS (
        SELECT 1
        FROM information_schema.columns
        WHERE table_schema = 'public'
          AND table_name = 'dialogue_attempts'
          AND column_name = 'points_earned'
    ) THEN
        ALTER TABLE public.dialogue_attempts
            ADD COLUMN points_earned INTEGER NOT NULL DEFAULT 0;

        RAISE NOTICE 'Added dialogue_attempts.points_earned';
    ELSE
        RAISE NOTICE 'dialogue_attempts.points_earned already exists';
    END IF;
END $$;

COMMENT ON COLUMN public.user_progress.points_earned
    IS 'Cumulative points earned by the user in this module run';

COMMENT ON COLUMN public.dialogue_attempts.points_earned
    IS 'Points earned for this specific dialogue attempt';

