#!/usr/bin/env python3
"""
Verify and fix Supabase schema for MI Learning Platform
Checks for missing columns and applies necessary migrations
"""

import os
import sys
from supabase import create_client, Client
from dotenv import load_dotenv

# Load environment variables
load_dotenv()

def get_supabase_client() -> Client:
    """Get Supabase client with admin privileges"""
    url = os.getenv("SUPABASE_URL")
    # Try different key names
    key = (
        os.getenv("SUPABASE_SECRET_KEY") or 
        os.getenv("SUPABASE_SERVICE_ROLE_KEY") or 
        os.getenv("SUPABASE_KEY")
    )
    
    if not url or not key:
        print("❌ Error: SUPABASE_URL and SUPABASE_SECRET_KEY (or SUPABASE_SERVICE_ROLE_KEY) must be set")
        print(f"   SUPABASE_URL: {'✓' if url else '✗'}")
        print(f"   SUPABASE_KEY: {'✓' if key else '✗'}")
        sys.exit(1)
    
    return create_client(url, key)


def check_table_exists(supabase: Client, table_name: str) -> bool:
    """Check if a table exists"""
    try:
        result = supabase.table(table_name).select("*").limit(1).execute()
        return True
    except Exception as e:
        if "relation" in str(e).lower() and "does not exist" in str(e).lower():
            return False
        # Table exists but might be empty or have RLS issues
        return True


def check_column_exists(supabase: Client, table_name: str, column_name: str) -> bool:
    """Check if a column exists in a table"""
    try:
        # Try to select the column
        result = supabase.table(table_name).select(column_name).limit(1).execute()
        return True
    except Exception as e:
        error_msg = str(e).lower()
        if "could not find" in error_msg or "does not exist" in error_msg:
            return False
        # Column might exist but query failed for other reasons
        return True


def add_nodes_visited_column(supabase: Client) -> bool:
    """Add nodes_visited column to user_progress table"""
    print("\n📝 Adding nodes_visited column to user_progress table...")
    
    sql = """
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
    SET nodes_visited = COALESCE(nodes_completed, '{}'::text[])
    WHERE nodes_visited IS NULL OR nodes_visited = '{}'::text[];

    -- Add comment
    COMMENT ON COLUMN public.user_progress.nodes_visited IS 'Array of node IDs that have been visited (for progress tracking), separate from nodes_completed (correct answers only)';
    """
    
    try:
        supabase.rpc('exec_sql', {'sql': sql}).execute()
        print("✅ Successfully added nodes_visited column")
        return True
    except Exception as e:
        # Try alternative method using postgrest
        print(f"⚠️  RPC method failed: {e}")
        print("   Please run the following SQL manually in Supabase SQL Editor:")
        print("\n" + "="*60)
        print(sql)
        print("="*60 + "\n")
        return False


def verify_schema(supabase: Client):
    """Verify the database schema"""
    print("🔍 Verifying Supabase database schema...\n")
    
    # Check required tables
    tables = [
        "user_profiles",
        "learning_modules", 
        "user_progress",
        "dialogue_attempts"
    ]
    
    print("📋 Checking tables:")
    all_tables_exist = True
    for table in tables:
        exists = check_table_exists(supabase, table)
        status = "✅" if exists else "❌"
        print(f"   {status} {table}")
        if not exists:
            all_tables_exist = False
    
    if not all_tables_exist:
        print("\n❌ Some required tables are missing!")
        print("   Please run the initial schema migration: app/db/migrations/001_init_schema.sql")
        return False
    
    # Check user_progress columns
    print("\n📋 Checking user_progress columns:")
    required_columns = [
        "id",
        "user_id",
        "module_id",
        "status",
        "current_node_id",
        "nodes_completed",
        "nodes_visited",  # This is the one that's likely missing
        "points_earned",
        "completion_score",
        "techniques_demonstrated"
    ]
    
    missing_columns = []
    for column in required_columns:
        exists = check_column_exists(supabase, "user_progress", column)
        status = "✅" if exists else "❌"
        print(f"   {status} {column}")
        if not exists:
            missing_columns.append(column)
    
    if missing_columns:
        print(f"\n⚠️  Missing columns: {', '.join(missing_columns)}")
        
        if "nodes_visited" in missing_columns:
            print("\n🔧 Attempting to fix nodes_visited column...")
            add_nodes_visited_column(supabase)
        
        return False
    
    print("\n✅ All required tables and columns exist!")
    return True


def test_progress_operations(supabase: Client):
    """Test basic progress operations"""
    print("\n🧪 Testing progress operations...")
    
    try:
        # Try to query user_progress with nodes_visited
        result = supabase.table("user_progress").select("id, nodes_visited, nodes_completed").limit(1).execute()
        print("✅ Can query user_progress with nodes_visited column")
        
        if result.data:
            print(f"   Sample record: {result.data[0]}")
        else:
            print("   (No progress records found - this is OK for a new database)")
        
        return True
    except Exception as e:
        print(f"❌ Error querying user_progress: {e}")
        return False


def main():
    """Main verification and fix routine"""
    print("="*60)
    print("MI Learning Platform - Schema Verification & Fix")
    print("="*60)
    
    try:
        supabase = get_supabase_client()
        print("✅ Connected to Supabase\n")
        
        # Verify schema
        schema_ok = verify_schema(supabase)
        
        # Test operations
        if schema_ok:
            test_progress_operations(supabase)
        
        print("\n" + "="*60)
        if schema_ok:
            print("✅ Schema verification complete - all checks passed!")
        else:
            print("⚠️  Schema verification complete - some issues found")
            print("   Please review the output above and apply fixes as needed")
        print("="*60)
        
    except Exception as e:
        print(f"\n❌ Error: {e}")
        sys.exit(1)


if __name__ == "__main__":
    main()
