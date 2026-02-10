-- ============================================================================
-- MAPS MI Learning Platform - Supabase Database Setup
-- Based on Supabase_Context.txt (verified working schema)
-- Run this in your Supabase SQL Editor
-- ============================================================================

-- ============================================================================
-- SECTION 1: FUNCTIONS (must be created before triggers)
-- ============================================================================

-- Function to update timestamp columns
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Function to update user score from dialogue attempts
CREATE OR REPLACE FUNCTION update_user_score_trigger()
RETURNS TRIGGER AS $$
DECLARE
    new_total_points INTEGER;
    new_modules_completed INTEGER;
BEGIN
    -- Calculate total points from dialogue attempts
    SELECT COALESCE(SUM(points_earned), 0)
    INTO new_total_points
    FROM dialogue_attempts
    WHERE user_id = COALESCE(NEW.user_id, OLD.user_id);

    -- Count completed modules
    SELECT COUNT(DISTINCT module_id)
    INTO new_modules_completed
    FROM user_progress
    WHERE user_id = COALESCE(NEW.user_id, OLD.user_id)
    AND status = 'completed';

    -- Update user_score table
    UPDATE user_score SET
        total_points = new_total_points,
        modules_completed = new_modules_completed,
        last_updated = NOW()
    WHERE user_id = COALESCE(NEW.user_id, OLD.user_id);

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Function to update user analytics when analysis is created
CREATE OR REPLACE FUNCTION trigger_update_user_analytics()
RETURNS TRIGGER AS $$
BEGIN
    UPDATE user_profiles SET
        change_talk_evoked = change_talk_evoked + CASE WHEN NEW.change_talk_evoked THEN 1 ELSE 0 END,
        last_active_at = NOW()
    WHERE user_id = NEW.user_id;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- ============================================================================
-- SECTION 2: TABLES
-- ============================================================================

-- Users table (extends Supabase auth.users)
CREATE TABLE public.users (
    id uuid NOT NULL,
    email text NOT NULL,
    display_name text NULL,
    created_at timestamp with time zone NULL DEFAULT NOW(),
    CONSTRAINT users_pkey PRIMARY KEY (id),
    CONSTRAINT users_id_fkey FOREIGN KEY (id) REFERENCES auth.users(id) ON DELETE CASCADE
);

-- Learning Modules table
CREATE TABLE public.learning_modules (
    id uuid NOT NULL DEFAULT gen_random_uuid(),
    module_number integer NOT NULL,
    title character varying(255) NOT NULL,
    slug character varying(255) NOT NULL,
    learning_objective text NOT NULL,
    technique_focus character varying(100) NOT NULL,
    stage_of_change character varying(50) NOT NULL,
    mi_process character varying(50) NULL,
    description text NOT NULL,
    dialogue_content jsonb NOT NULL DEFAULT '{}'::jsonb,
    points integer NULL DEFAULT 500,
    display_order integer NULL DEFAULT 0,
    is_published boolean NULL DEFAULT TRUE,
    created_at timestamp with time zone NULL DEFAULT NOW(),
    updated_at timestamp with time zone NULL DEFAULT NOW(),
    CONSTRAINT learning_modules_pkey PRIMARY KEY (id),
    CONSTRAINT learning_modules_module_number_key UNIQUE (module_number),
    CONSTRAINT learning_modules_slug_key UNIQUE (slug)
);

-- User Progress tracking
CREATE TABLE public.user_progress (
    id uuid NOT NULL DEFAULT gen_random_uuid(),
    user_id uuid NOT NULL,
    module_id uuid NOT NULL,
    status character varying(20) NULL DEFAULT 'not_started',
    current_node_id character varying(50) NULL DEFAULT 'node_1',
    nodes_completed text[] NULL DEFAULT '{}'::text[],
    points_earned integer NULL DEFAULT 0,
    completion_score integer NULL DEFAULT 0,
    techniques_demonstrated jsonb NULL DEFAULT '{}'::jsonb,
    started_at timestamp with time zone NULL DEFAULT NOW(),
    completed_at timestamp with time zone NULL,
    updated_at timestamp with time zone NULL DEFAULT NOW(),
    CONSTRAINT user_progress_pkey PRIMARY KEY (id),
    CONSTRAINT user_progress_user_id_module_id_key UNIQUE (user_id, module_id),
    CONSTRAINT user_progress_module_id_fkey FOREIGN KEY (module_id) REFERENCES learning_modules(id) ON DELETE CASCADE,
    CONSTRAINT user_progress_user_id_fkey FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    CONSTRAINT user_progress_status_check CHECK (
        status IN ('not_started', 'in_progress', 'completed')
    )
);

-- Dialogue Attempts
CREATE TABLE public.dialogue_attempts (
    id uuid NOT NULL DEFAULT gen_random_uuid(),
    user_id uuid NOT NULL,
    module_id uuid NOT NULL,
    progress_id uuid NULL,
    node_id character varying(50) NOT NULL,
    choice_id character varying(50) NOT NULL,
    choice_text text NOT NULL,
    technique character varying(100) NOT NULL,
    is_correct_technique boolean NOT NULL,
    feedback_text text NOT NULL,
    evoked_change_talk boolean NULL DEFAULT FALSE,
    points_earned integer NULL DEFAULT 0,
    created_at timestamp with time zone NULL DEFAULT NOW(),
    CONSTRAINT dialogue_attempts_pkey PRIMARY KEY (id),
    CONSTRAINT dialogue_attempts_module_id_fkey FOREIGN KEY (module_id) REFERENCES learning_modules(id) ON DELETE CASCADE,
    CONSTRAINT dialogue_attempts_progress_id_fkey FOREIGN KEY (progress_id) REFERENCES user_progress(id) ON DELETE CASCADE,
    CONSTRAINT dialogue_attempts_user_id_fkey FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- User Profiles (gamification)
CREATE TABLE public.user_profiles (
    id uuid NOT NULL DEFAULT gen_random_uuid(),
    user_id uuid NOT NULL,
    display_name character varying(100) NULL,
    total_points integer NULL DEFAULT 0,
    level integer NULL DEFAULT 1,
    modules_completed integer NULL DEFAULT 0,
    change_talk_evoked integer NULL DEFAULT 0,
    reflections_offered integer NULL DEFAULT 0,
    technique_mastery jsonb NULL DEFAULT '{}'::jsonb,
    created_at timestamp with time zone NULL DEFAULT NOW(),
    updated_at timestamp with time zone NULL DEFAULT NOW(),
    last_active_at timestamp with time zone NULL DEFAULT NOW(),
    CONSTRAINT user_profiles_pkey PRIMARY KEY (id),
    CONSTRAINT user_profiles_user_id_key UNIQUE (user_id),
    CONSTRAINT user_profiles_user_id_fkey FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- User Score (aggregate stats)
CREATE TABLE public.user_score (
    id uuid NOT NULL DEFAULT gen_random_uuid(),
    user_id uuid NULL,
    total_points integer NULL DEFAULT 0,
    modules_completed integer NULL DEFAULT 0,
    technique_mastery jsonb NULL DEFAULT '{}'::jsonb,
    change_talk_evoked integer NULL DEFAULT 0,
    reflections_offered integer NULL DEFAULT 0,
    summaries_created integer NULL DEFAULT 0,
    last_updated timestamp with time zone NULL DEFAULT NOW(),
    CONSTRAINT user_score_pkey PRIMARY KEY (id),
    CONSTRAINT user_score_user_id_key UNIQUE (user_id),
    CONSTRAINT user_score_user_id_fkey FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- Conversation Analyses (chat practice)
CREATE TABLE public.conversation_analyses (
    id uuid NOT NULL DEFAULT gen_random_uuid(),
    session_id text NOT NULL,
    conversation_id text NULL,
    user_id uuid NULL,
    persona_id text NULL,
    persona_name text NULL,
    overall_score numeric(3, 2) NULL,
    foundational_trust_safety numeric(3, 2) NULL,
    empathic_partnership_autonomy numeric(3, 2) NULL,
    empowerment_clarity numeric(3, 2) NULL,
    mi_spirit_score numeric(3, 2) NULL,
    partnership_demonstrated boolean NULL DEFAULT FALSE,
    acceptance_demonstrated boolean NULL DEFAULT FALSE,
    compassion_demonstrated boolean NULL DEFAULT FALSE,
    evocation_demonstrated boolean NULL DEFAULT FALSE,
    techniques_count jsonb NULL DEFAULT '{}'::jsonb,
    techniques_used jsonb NULL DEFAULT '[]'::jsonb,
    strengths jsonb NULL DEFAULT '[]'::jsonb,
    areas_for_improvement jsonb NULL DEFAULT '[]'::jsonb,
    client_movement text NULL,
    change_talk_evoked boolean NULL DEFAULT FALSE,
    transcript_summary text NULL,
    summary text NULL,
    key_moments jsonb NULL DEFAULT '[]'::jsonb,
    suggestions_for_next_time jsonb NULL DEFAULT '[]'::jsonb,
    transcript jsonb NULL DEFAULT '[]'::jsonb,
    total_turns integer NULL DEFAULT 0,
    created_at timestamp with time zone NULL DEFAULT NOW(),
    metadata jsonb NULL DEFAULT '{}'::jsonb,
    CONSTRAINT conversation_analyses_pkey PRIMARY KEY (id),
    CONSTRAINT conversation_analyses_user_id_fkey FOREIGN KEY (user_id) REFERENCES users(id),
    CONSTRAINT conversation_analyses_overall_score_check CHECK (overall_score BETWEEN 1 AND 5),
    CONSTRAINT conversation_analyses_mi_spirit_score_check CHECK (mi_spirit_score BETWEEN 1 AND 5),
    CONSTRAINT conversation_analyses_foundational_trust_safety_check CHECK (foundational_trust_safety BETWEEN 1 AND 5),
    CONSTRAINT conversation_analyses_empathic_partnership_autonomy_check CHECK (empathic_partnership_autonomy BETWEEN 1 AND 5),
    CONSTRAINT conversation_analyses_empowerment_clarity_check CHECK (empowerment_clarity BETWEEN 1 AND 5),
    CONSTRAINT conversation_analyses_client_movement_check CHECK (
        client_movement IN ('toward_change', 'stable', 'away_from_change')
    )
);

-- User Feedback
CREATE TABLE public.user_feedback (
    id uuid NOT NULL DEFAULT gen_random_uuid(),
    session_id text NOT NULL,
    conversation_id text NULL,
    persona_practiced text NULL,
    helpfulness_score integer NULL,
    what_was_helpful text NULL,
    improvement_suggestions text NULL,
    user_email text NULL,
    user_id uuid NULL,
    created_at timestamp with time zone NULL DEFAULT NOW(),
    metadata jsonb NULL DEFAULT '{}'::jsonb,
    CONSTRAINT user_feedback_pkey PRIMARY KEY (id),
    CONSTRAINT user_feedback_user_id_fkey FOREIGN KEY (user_id) REFERENCES users(id),
    CONSTRAINT user_feedback_helpfulness_score_check CHECK (
        helpfulness_score BETWEEN 0 AND 10
    )
);

-- ============================================================================
-- SECTION 3: INDEXES
-- ============================================================================

CREATE INDEX IF NOT EXISTS idx_learning_modules_published ON public.learning_modules USING btree (is_published, display_order);

CREATE INDEX IF NOT EXISTS idx_user_progress_user ON public.user_progress USING btree (user_id, status);
CREATE INDEX IF NOT EXISTS idx_user_progress_module ON public.user_progress USING btree (module_id, status);

CREATE INDEX IF NOT EXISTS idx_dialogue_attempts_user ON public.dialogue_attempts USING btree (user_id, created_at DESC);
CREATE INDEX IF NOT EXISTS idx_dialogue_attempts_progress ON public.dialogue_attempts USING btree (progress_id);

CREATE INDEX IF NOT EXISTS idx_user_profiles_points ON public.user_profiles USING btree (total_points DESC, level DESC);
CREATE INDEX IF NOT EXISTS idx_user_profiles_user_id ON public.user_profiles USING btree (user_id);

CREATE INDEX IF NOT EXISTS idx_conversation_analyses_user_id ON public.conversation_analyses USING btree (user_id);
CREATE INDEX IF NOT EXISTS idx_conversation_analyses_session_id ON public.conversation_analyses USING btree (session_id);
CREATE INDEX IF NOT EXISTS idx_conversation_analyses_persona_id ON public.conversation_analyses USING btree (persona_id);
CREATE INDEX IF NOT EXISTS idx_conversation_analyses_created_at ON public.conversation_analyses USING btree (created_at);

CREATE INDEX IF NOT EXISTS idx_user_feedback_user_id ON public.user_feedback USING btree (user_id);
CREATE INDEX IF NOT EXISTS idx_user_feedback_session_id ON public.user_feedback USING btree (session_id);
CREATE INDEX IF NOT EXISTS idx_user_feedback_created_at ON public.user_feedback USING btree (created_at);

-- ============================================================================
-- SECTION 4: TRIGGERS
-- ============================================================================

CREATE TRIGGER update_learning_modules_updated_at
    BEFORE UPDATE ON learning_modules
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_user_progress_updated_at
    BEFORE UPDATE ON user_progress
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_user_profiles_updated_at
    BEFORE UPDATE ON user_profiles
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER trigger_update_user_score
    AFTER INSERT OR DELETE OR UPDATE ON dialogue_attempts
    FOR EACH ROW
    EXECUTE FUNCTION update_user_score_trigger();

CREATE TRIGGER update_user_analytics_on_analysis
    AFTER INSERT ON conversation_analyses
    FOR EACH ROW
    EXECUTE FUNCTION trigger_update_user_analytics();

-- ============================================================================
-- SECTION 5: ROW LEVEL SECURITY (RLS) POLICIES
-- ============================================================================

ALTER TABLE users ENABLE ROW LEVEL SECURITY;
ALTER TABLE learning_modules ENABLE ROW LEVEL SECURITY;
ALTER TABLE user_progress ENABLE ROW LEVEL SECURITY;
ALTER TABLE dialogue_attempts ENABLE ROW LEVEL SECURITY;
ALTER TABLE user_profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE user_score ENABLE ROW LEVEL SECURITY;
ALTER TABLE conversation_analyses ENABLE ROW LEVEL SECURITY;
ALTER TABLE user_feedback ENABLE ROW LEVEL SECURITY;

-- Users policies
CREATE POLICY "Users can view own user record" ON users
    FOR SELECT USING (auth.uid() = id);

-- User profiles policies
CREATE POLICY "Users can insert own profile" ON user_profiles
    FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY "Users can update own profile" ON user_profiles
    FOR UPDATE USING (auth.uid() = user_id);
CREATE POLICY "Users can view own profile" ON user_profiles
    FOR SELECT USING (auth.uid() = user_id);

-- User progress policies
CREATE POLICY "Users can view own progress" ON user_progress
    FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY "Users can insert own progress" ON user_progress
    FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY "Users can update own progress" ON user_progress
    FOR UPDATE USING (auth.uid() = user_id);

-- Dialogue attempts policies
CREATE POLICY "Users can view own dialogue attempts" ON dialogue_attempts
    FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY "Users can insert own dialogue attempts" ON dialogue_attempts
    FOR INSERT WITH CHECK (auth.uid() = user_id);

-- User score policies
CREATE POLICY "Users can view own score" ON user_score
    FOR SELECT USING (auth.uid() = user_id);

-- Conversation analyses policies (allows anonymous for demo)
CREATE POLICY "Users can view own analyses" ON conversation_analyses
    FOR SELECT USING (auth.uid() = user_id OR user_id IS NULL);
CREATE POLICY "Users can insert own analyses" ON conversation_analyses
    FOR INSERT WITH CHECK (auth.uid() = user_id OR user_id IS NULL);

-- User feedback policies (public for anonymous feedback)
CREATE POLICY "Anyone can view user feedback" ON user_feedback
    FOR SELECT USING (TRUE);
CREATE POLICY "Anyone can insert user feedback" ON user_feedback
    FOR INSERT WITH CHECK (TRUE);

-- Learning modules - public read for published modules
CREATE POLICY "Published modules are viewable by everyone" ON learning_modules
    FOR SELECT USING (is_published = TRUE);

-- ============================================================================
-- SECTION 6: VERIFICATION
-- ============================================================================

-- Run this to verify setup:
-- SELECT table_name FROM information_schema.tables
-- WHERE table_schema = 'public'
-- AND table_name NOT LIKE 'pg_%'
-- ORDER BY table_name;
