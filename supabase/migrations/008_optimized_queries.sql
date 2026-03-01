-- ============================================
-- Optimized Query Functions (v008)
-- Reduces egress and API calls for admin/leaderboard endpoints
-- ============================================
--
-- SAFETY: This file ONLY creates/drops FUNCTIONS (stored SQL queries).
-- It does NOT drop, modify, or delete any TABLES or DATA.
--
-- DROP FUNCTION removes a stored function (like a reusable query).
-- DROP TABLE would remove data - we don't use that here.
--

-- Drop existing functions if they exist (required to update signatures)
-- NOTE: This ONLY drops functions, NOT tables!
DROP FUNCTION IF EXISTS get_module_stats();
DROP FUNCTION IF EXISTS get_average_progress();
DROP FUNCTION IF EXISTS get_user_rank(UUID);
DROP FUNCTION IF EXISTS get_leaderboard(INT, INT);

-- 1. Get module stats with a single query (replaces N+1 pattern)
CREATE OR REPLACE FUNCTION get_module_stats()
RETURNS TABLE (
    module_id UUID,
    module_title TEXT,
    total_enrolled BIGINT,
    completed_count BIGINT,
    in_progress_count BIGINT
) AS $$
BEGIN
    RETURN QUERY
    SELECT
        m.id as module_id,
        m.title::TEXT as module_title,
        COUNT(p.id)::BIGINT as total_enrolled,
        COUNT(CASE WHEN p.status = 'completed' THEN 1 END)::BIGINT as completed_count,
        COUNT(CASE WHEN p.status = 'in_progress' THEN 1 END)::BIGINT as in_progress_count
    FROM learning_modules m
    LEFT JOIN user_progress p ON m.id = p.module_id
    WHERE m.is_published = true
    GROUP BY m.id, m.title
    ORDER BY m.display_order;
END;
$$ LANGUAGE plpgsql;

-- 2. Get average progress (replaces full table scan)
CREATE OR REPLACE FUNCTION get_average_progress()
RETURNS TABLE (
    average_progress FLOAT,
    total_users BIGINT
) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        COALESCE(
            AVG(
                CASE 
                    WHEN array_length(p.nodes_completed, 1) > 0 
                    THEN array_length(p.nodes_completed, 1) * 10 
                    ELSE 0 
                END
            ),
            0
        )::FLOAT as average_progress,
        COUNT(DISTINCT p.user_id)::BIGINT as total_users
    FROM user_progress p;
END;
$$ LANGUAGE plpgsql;

-- 3. Get user rank in leaderboard (replaces Python-side counting)
CREATE OR REPLACE FUNCTION get_user_rank(p_user_id UUID)
RETURNS TABLE (
    rank BIGINT,
    total_users BIGINT
) AS $$
DECLARE
    v_user_modules INT;
    v_rank BIGINT;
    v_total BIGINT;
BEGIN
    -- Get user's modules_completed
    SELECT COALESCE(up.modules_completed, 0) INTO v_user_modules
    FROM user_profiles up
    WHERE up.user_id = p_user_id;

    -- Get total count
    SELECT COUNT(*)::BIGINT INTO v_total
    FROM user_profiles up;

    -- Calculate rank: count of users with more modules completed + 1
    SELECT COUNT(*)::BIGINT + 1 INTO v_rank
    FROM user_profiles up
    WHERE up.modules_completed > v_user_modules;

    RETURN QUERY SELECT v_rank, v_total;
END;
$$ LANGUAGE plpgsql;

-- 4. Get leaderboard with pagination (optimized, single query)
-- Returns: rank, user_id, display_name, modules_completed, created_at
CREATE OR REPLACE FUNCTION get_leaderboard(p_skip INT, p_limit INT)
RETURNS TABLE (
    rank BIGINT,
    user_id UUID,
    display_name TEXT,
    modules_completed INT,
    created_at TIMESTAMPTZ
) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        ROW_NUMBER() OVER (ORDER BY up.modules_completed DESC, up.created_at ASC)::BIGINT as rank,
        up.user_id,
        COALESCE(up.display_name, 'Anonymous')::TEXT as display_name,
        up.modules_completed,
        up.created_at
    FROM user_profiles up
    ORDER BY up.modules_completed DESC, up.created_at ASC
    LIMIT p_limit OFFSET p_skip;
END;
$$ LANGUAGE plpgsql;

-- 5. Get recent activity for dashboard chart (last 7 days)
CREATE OR REPLACE FUNCTION get_recent_activity(p_days INT DEFAULT 7)
RETURNS TABLE (
    activity_date DATE,
    new_users BIGINT,
    modules_completed BIGINT,
    practice_sessions BIGINT
) AS $$
BEGIN
    RETURN QUERY
    WITH date_series AS (
        SELECT generate_series(
            CURRENT_DATE - (p_days - 1),
            CURRENT_DATE,
            '1 day'::INTERVAL
        )::DATE AS activity_date
    ),
    new_users_daily AS (
        SELECT
            DATE(u.created_at) AS activity_date,
            COUNT(*)::BIGINT AS count
        FROM users u
        WHERE u.created_at >= CURRENT_DATE - (p_days - 1)
        GROUP BY DATE(u.created_at)
    ),
    modules_completed_daily AS (
        SELECT
            DATE(up.completed_at) AS activity_date,
            COUNT(*)::BIGINT AS count
        FROM user_progress up
        WHERE up.completed_at >= CURRENT_DATE - (p_days - 1)
          AND up.status = 'completed'
        GROUP BY DATE(up.completed_at)
    ),
    practice_sessions_daily AS (
        SELECT
            DATE(ca.created_at) AS activity_date,
            COUNT(*)::BIGINT AS count
        FROM conversation_analyses ca
        WHERE ca.created_at >= CURRENT_DATE - (p_days - 1)
        GROUP BY DATE(ca.created_at)
    )
    SELECT
        ds.activity_date,
        COALESCE(nu.count, 0)::BIGINT AS new_users,
        COALESCE(mc.count, 0)::BIGINT AS modules_completed,
        COALESCE(ps.count, 0)::BIGINT AS practice_sessions
    FROM date_series ds
    LEFT JOIN new_users_daily nu ON ds.activity_date = nu.activity_date
    LEFT JOIN modules_completed_daily mc ON ds.activity_date = mc.activity_date
    LEFT JOIN practice_sessions_daily ps ON ds.activity_date = ps.activity_date
    ORDER BY ds.activity_date;
END;
$$ LANGUAGE plpgsql;

-- ============================================
-- Grant execute permissions to authenticated users
-- ============================================

-- Grant execute on the new functions
GRANT EXECUTE ON FUNCTION get_module_stats() TO authenticated, anon, service_role;
GRANT EXECUTE ON FUNCTION get_average_progress() TO authenticated, anon, service_role;
GRANT EXECUTE ON FUNCTION get_user_rank(UUID) TO authenticated, anon, service_role;
GRANT EXECUTE ON FUNCTION get_leaderboard(INT, INT) TO authenticated, anon, service_role;
GRANT EXECUTE ON FUNCTION get_recent_activity(INT) TO authenticated, anon, service_role;

-- Note: These functions should be run via Supabase SQL Editor or as part of deployment
-- They optimize query patterns to reduce egress and API calls significantly
--
-- SAFETY CONFIRMATION: This migration ONLY creates SQL functions (read-only queries).
-- No tables are created, modified, or deleted. No data is affected.