-- Migration: Add chat_sessions table
-- Date: 2026-02-26
-- Description: Creates table for persisting chat practice sessions

CREATE TABLE IF NOT EXISTS public.chat_sessions (
    session_id TEXT PRIMARY KEY,
    user_id UUID NULL,
    persona_id TEXT NOT NULL,
    persona_data JSONB NOT NULL DEFAULT '{}'::jsonb,
    history JSONB NOT NULL DEFAULT '[]'::jsonb,
    turn INTEGER NOT NULL DEFAULT 0,
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    started_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),
    ended_at TIMESTAMP WITH TIME ZONE NULL,
    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),
    CONSTRAINT chat_sessions_user_id_fkey
        FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE,
    CONSTRAINT chat_sessions_turn_check CHECK (turn >= 0),
    CONSTRAINT chat_sessions_ended_after_started_check
        CHECK (ended_at IS NULL OR ended_at >= started_at)
);

CREATE INDEX IF NOT EXISTS idx_chat_sessions_user_id
    ON public.chat_sessions USING btree (user_id);

CREATE INDEX IF NOT EXISTS idx_chat_sessions_persona_id
    ON public.chat_sessions USING btree (persona_id);

CREATE INDEX IF NOT EXISTS idx_chat_sessions_is_active
    ON public.chat_sessions USING btree (is_active);

CREATE INDEX IF NOT EXISTS idx_chat_sessions_started_at
    ON public.chat_sessions USING btree (started_at);

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
            WHERE tgname = 'update_chat_sessions_updated_at'
        ) THEN
            CREATE TRIGGER update_chat_sessions_updated_at
                BEFORE UPDATE ON public.chat_sessions
                FOR EACH ROW
                EXECUTE FUNCTION update_updated_at_column();
        END IF;
    END IF;
END $$;

ALTER TABLE public.chat_sessions ENABLE ROW LEVEL SECURITY;

DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM pg_policies
        WHERE schemaname = 'public'
          AND tablename = 'chat_sessions'
          AND policyname = 'Users can view own chat sessions'
    ) THEN
        CREATE POLICY "Users can view own chat sessions"
            ON public.chat_sessions
            FOR SELECT
            TO authenticated
            USING (auth.uid() = user_id);
    END IF;

    IF NOT EXISTS (
        SELECT 1 FROM pg_policies
        WHERE schemaname = 'public'
          AND tablename = 'chat_sessions'
          AND policyname = 'Users can insert own chat sessions'
    ) THEN
        CREATE POLICY "Users can insert own chat sessions"
            ON public.chat_sessions
            FOR INSERT
            TO authenticated
            WITH CHECK (auth.uid() = user_id);
    END IF;

    IF NOT EXISTS (
        SELECT 1 FROM pg_policies
        WHERE schemaname = 'public'
          AND tablename = 'chat_sessions'
          AND policyname = 'Users can update own chat sessions'
    ) THEN
        CREATE POLICY "Users can update own chat sessions"
            ON public.chat_sessions
            FOR UPDATE
            TO authenticated
            USING (auth.uid() = user_id)
            WITH CHECK (auth.uid() = user_id);
    END IF;

    IF NOT EXISTS (
        SELECT 1 FROM pg_policies
        WHERE schemaname = 'public'
          AND tablename = 'chat_sessions'
          AND policyname = 'Users can delete own chat sessions'
    ) THEN
        CREATE POLICY "Users can delete own chat sessions"
            ON public.chat_sessions
            FOR DELETE
            TO authenticated
            USING (auth.uid() = user_id);
    END IF;
END $$;
