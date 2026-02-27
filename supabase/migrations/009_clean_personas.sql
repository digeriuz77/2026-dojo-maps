-- ============================================
-- Clean up personas table for Supabase fetching
-- ============================================

-- 1. Add dialect column if it doesn't exist
ALTER TABLE personas ADD COLUMN IF NOT EXISTS dialect TEXT DEFAULT 'RP';

-- 2. Add voice column if it doesn't exist  
ALTER TABLE personas ADD COLUMN IF NOT EXISTS voice TEXT DEFAULT 'neutral';

-- 3. Convert ambivalence_points from string to JSONB
-- Simple approach: try to cast, fallback to empty array
UPDATE personas 
SET ambivalence_points = 
    CASE 
        WHEN ambivalence_points::text ~ '^\[.*\]$' THEN ambivalence_points::jsonb
        WHEN ambivalence_points::text IS NOT NULL AND ambivalence_points::text != '' THEN 
            ('["' || replace(replace(replace(ambivalence_points::text, '"', '\"'), '[', ''), ']', '') || '"]')::jsonb
        ELSE '[]'::jsonb
    END
WHERE ambivalence_points IS NOT NULL;

-- 4. Convert motivation_points from string to JSONB
UPDATE personas 
SET motivation_points = 
    CASE 
        WHEN motivation_points::text ~ '^\[.*\]$' THEN motivation_points::jsonb
        WHEN motivation_points::text IS NOT NULL AND motivation_points::text != '' THEN 
            ('["' || replace(replace(replace(motivation_points::text, '"', '\"'), '[', ''), ']', '') || '"]')::jsonb
        ELSE '[]'::jsonb
    END
WHERE motivation_points IS NOT NULL;

-- 5. Clean up core_identity - remove leading/trailing literal quotes if present
UPDATE personas 
SET core_identity = 
    CASE 
        WHEN core_identity LIKE '''%''' THEN trim(both '''' from core_identity)
        WHEN core_identity LIKE '"%"' THEN trim(both '"' from core_identity)
        ELSE core_identity
    END
WHERE core_identity IS NOT NULL;

-- 6. Clean up behavior_guidelines
UPDATE personas 
SET behavior_guidelines = 
    CASE 
        WHEN behavior_guidelines LIKE '''%''' THEN trim(both '''' from behavior_guidelines)
        WHEN behavior_guidelines LIKE '"%"' THEN trim(both '"' from behavior_guidelines)
        ELSE behavior_guidelines
    END
WHERE behavior_guidelines IS NOT NULL;

-- 7. Clean up opening_message
UPDATE personas 
SET opening_message = 
    CASE 
        WHEN opening_message LIKE '''%''' THEN trim(both '''' from opening_message)
        WHEN opening_message LIKE '"%"' THEN trim(both '"' from opening_message)
        ELSE opening_message
    END
WHERE opening_message IS NOT NULL;

-- 8. Set dialect values for existing personas based on their characteristics
UPDATE personas SET dialect = 'west_country' WHERE key_name = 'punctuality';
UPDATE personas SET dialect = 'RP' WHERE key_name = 'impartiality';
UPDATE personas SET dialect = 'northern' WHERE key_name = 'kpi_conversation';
UPDATE personas SET dialect = 'RP' WHERE key_name = 'post_acquisition_change';

-- 9. Set voice values
UPDATE personas SET voice = 'sardonic' WHERE key_name = 'punctuality';
UPDATE personas SET voice = 'warm_thinking' WHERE key_name = 'kpi_conversation';
UPDATE personas SET voice = 'formal_reflective' WHERE key_name = 'impartiality';
UPDATE personas SET voice = 'measured' WHERE key_name = 'post_acquisition_change';

-- 10. Grant permissions
GRANT ALL ON personas TO authenticated, anon, service_role;

-- Note: Run this in Supabase SQL Editor
