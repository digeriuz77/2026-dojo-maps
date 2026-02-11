#!/bin/bash
# Quick Fix for Module Errors
# This script helps diagnose and fix module-related issues

set -e

echo "=========================================="
echo "MI Learning Platform - Module Quick Fix"
echo "=========================================="
echo ""

# Check if .env file exists
if [ ! -f .env ]; then
    echo "❌ Error: .env file not found"
    echo "   Please create .env from .env.example and configure Supabase credentials"
    exit 1
fi

# Load environment variables
source .env

# Check required environment variables
if [ -z "$SUPABASE_URL" ]; then
    echo "❌ Error: SUPABASE_URL not set in .env"
    exit 1
fi

if [ -z "$SUPABASE_SECRET_KEY" ] && [ -z "$SUPABASE_SERVICE_ROLE_KEY" ] && [ -z "$SUPABASE_KEY" ]; then
    echo "❌ Error: No Supabase key found in .env"
    echo "   Please set SUPABASE_SECRET_KEY or SUPABASE_SERVICE_ROLE_KEY"
    exit 1
fi

echo "✅ Environment variables loaded"
echo ""

# Step 1: Verify schema
echo "Step 1: Verifying database schema..."
echo "--------------------------------------"
python3 verify_and_fix_schema.py

if [ $? -ne 0 ]; then
    echo ""
    echo "⚠️  Schema verification failed or found issues"
    echo ""
    echo "To fix the schema, run this SQL in Supabase SQL Editor:"
    echo ""
    cat fix_user_progress_schema.sql
    echo ""
    echo "Or visit: $SUPABASE_URL/project/_/sql"
    echo ""
    read -p "Press Enter after you've run the SQL migration..."
    
    # Verify again
    echo ""
    echo "Verifying schema again..."
    python3 verify_and_fix_schema.py
fi

echo ""
echo "=========================================="
echo "✅ Quick fix complete!"
echo "=========================================="
echo ""
echo "Next steps:"
echo "1. Start your application: uvicorn app.main:app --reload"
echo "2. Test module functionality: python3 test_module_flow.py"
echo "3. Check admin dashboard for user progress data"
echo ""
echo "For detailed troubleshooting, see: FIX_MODULE_ERRORS.md"
