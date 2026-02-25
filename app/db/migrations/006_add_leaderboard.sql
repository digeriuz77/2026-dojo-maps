-- Migration: Add leaderboard table
-- Date: 2026-02-26
-- Description: Creates leaderboard table for user ranking snapshots

CREATE TABLE IF NOT EXISTS public.leaderboard (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL,
    display_name TEXT NULL,
    modules_completed INTEGER NOT NULL DEFAULT 0,
    total_points INTEGER NOT NULL DEFAULT 0,
    rank INTEGER NULL,
    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),
    CONSTRAINT leaderboard_user_id_key UNIQUE (user_id),
    CONSTRAINT leaderboard_user_id_fkey
        FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE,
    CONSTRAINT leaderboard_modules_completed_check CHECK (modules_completed >= 0),
    CONSTRAINT leaderboard_total_points_check CHECK (total_points >= 0),
    CONSTRAINT leaderboard_rank_check CHECK (rank IS NULL OR rank > 0)
);

CREATE INDEX IF NOT EXISTS idx_leaderboard_total_points
    ON public.leaderboard USING btree (total_points DESC);

CREATE INDEX IF NOT EXISTS idx_leaderboard_modules_completed
    ON public.leaderboard USING btree (modules_completed DESC);

CREATE INDEX IF NOT EXISTS idx_leaderboard_rank
    ON public.leaderboard USING btree (rank);

DO $$
BEGIN
    IF EXISTS (
        SELECT 1
        FROM pg_proc
        WHERE proname = 'update_updated_at_column'
    ) THEN
        IF NOT EXISTS (
            SELECT 1
            FROM pg_trigger
            WHERE tgname = 'update_leaderboard_updated_at'
        ) THEN
            CREATE TRIGGER update_leaderboard_updated_at
                BEFORE UPDATE ON public.leaderboard
                FOR EACH ROW
                EXECUTE FUNCTION update_updated_at_column();
        END IF;
    END IF;
END $$;

ALTER TABLE public.leaderboard ENABLE ROW LEVEL SECURITY;

DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM pg_policies
        WHERE schemaname = 'public'
          AND tablename = 'leaderboard'
          AND policyname = 'Authenticated users can view leaderboard'
    ) THEN
        CREATE POLICY "Authenticated users can view leaderboard"
            ON public.leaderboard
            FOR SELECT
            TO authenticated
            USING (TRUE);
    END IF;

    IF NOT EXISTS (
        SELECT 1 FROM pg_policies
        WHERE schemaname = 'public'
          AND tablename = 'leaderboard'
          AND policyname = 'Users can insert own leaderboard row'
    ) THEN
        CREATE POLICY "Users can insert own leaderboard row"
            ON public.leaderboard
            FOR INSERT
            TO authenticated
            WITH CHECK (auth.uid() = user_id);
    END IF;

    IF NOT EXISTS (
        SELECT 1 FROM pg_policies
        WHERE schemaname = 'public'
          AND tablename = 'leaderboard'
          AND policyname = 'Users can update own leaderboard row'
    ) THEN
        CREATE POLICY "Users can update own leaderboard row"
            ON public.leaderboard
            FOR UPDATE
            TO authenticated
            USING (auth.uid() = user_id)
            WITH CHECK (auth.uid() = user_id);
    END IF;

    IF NOT EXISTS (
        SELECT 1 FROM pg_policies
        WHERE schemaname = 'public'
          AND tablename = 'leaderboard'
          AND policyname = 'Users can delete own leaderboard row'
    ) THEN
        CREATE POLICY "Users can delete own leaderboard row"
            ON public.leaderboard
            FOR DELETE
            TO authenticated
            USING (auth.uid() = user_id);
    END IF;
END $$;
