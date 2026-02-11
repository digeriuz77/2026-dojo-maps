#!/usr/bin/env python3
"""
Test Module Flow - End-to-End Testing
Tests the complete module interaction flow to verify fixes
"""

import os
import sys
import requests
from dotenv import load_dotenv
from supabase import create_client

# Load environment variables
load_dotenv()

# Configuration
API_BASE_URL = os.getenv("API_BASE_URL", "http://localhost:8000")
SUPABASE_URL = os.getenv("SUPABASE_URL")
SUPABASE_KEY = os.getenv("SUPABASE_SECRET_KEY") or os.getenv("SUPABASE_SERVICE_ROLE_KEY") or os.getenv("SUPABASE_KEY")

def get_test_user_token():
    """Get a test user JWT token"""
    # You'll need to provide a test user's credentials
    email = os.getenv("TEST_USER_EMAIL")
    password = os.getenv("TEST_USER_PASSWORD")
    
    if not email or not password:
        print("⚠️  TEST_USER_EMAIL and TEST_USER_PASSWORD not set")
        print("   Please set these in your .env file or provide them manually")
        return None
    
    # Login via Supabase
    supabase = create_client(SUPABASE_URL, SUPABASE_KEY)
    try:
        auth_response = supabase.auth.sign_in_with_password({
            "email": email,
            "password": password
        })
        return auth_response.session.access_token
    except Exception as e:
        print(f"❌ Failed to authenticate test user: {e}")
        return None


def test_list_modules(token):
    """Test: List all modules"""
    print("\n📋 Test 1: List Modules")
    print("-" * 60)
    
    headers = {"Authorization": f"Bearer {token}"}
    response = requests.get(f"{API_BASE_URL}/api/v1/modules", headers=headers)
    
    if response.status_code == 200:
        data = response.json()
        modules = data.get("modules", [])
        print(f"✅ Success: Found {len(modules)} modules")
        
        if modules:
            print(f"   First module: {modules[0].get('title')}")
            return modules[0].get("id")
        else:
            print("⚠️  No modules found - you may need to import modules")
            return None
    else:
        print(f"❌ Failed: {response.status_code}")
        print(f"   Error: {response.text}")
        return None


def test_get_module(token, module_id):
    """Test: Get specific module details"""
    print("\n📖 Test 2: Get Module Details")
    print("-" * 60)
    
    headers = {"Authorization": f"Bearer {token}"}
    response = requests.get(f"{API_BASE_URL}/api/v1/modules/{module_id}", headers=headers)
    
    if response.status_code == 200:
        data = response.json()
        print(f"✅ Success: Retrieved module '{data.get('title')}'")
        print(f"   Status: {data.get('user_status', 'not_started')}")
        print(f"   Points: {data.get('user_points_earned', 0)}")
        return True
    else:
        print(f"❌ Failed: {response.status_code}")
        print(f"   Error: {response.text}")
        return False


def test_start_module(token, module_id):
    """Test: Start a module"""
    print("\n🚀 Test 3: Start Module")
    print("-" * 60)
    
    headers = {"Authorization": f"Bearer {token}"}
    response = requests.post(f"{API_BASE_URL}/api/v1/modules/{module_id}/start", headers=headers)
    
    if response.status_code in [200, 201]:
        data = response.json()
        print(f"✅ Success: {data.get('message')}")
        print(f"   Progress ID: {data.get('progress_id')}")
        print(f"   Current Node: {data.get('current_node_id')}")
        return data.get('current_node_id')
    else:
        print(f"❌ Failed: {response.status_code}")
        print(f"   Error: {response.text}")
        return None


def test_get_dialogue_node(token, module_id, node_id):
    """Test: Get dialogue node"""
    print("\n💬 Test 4: Get Dialogue Node")
    print("-" * 60)
    
    headers = {"Authorization": f"Bearer {token}"}
    response = requests.get(
        f"{API_BASE_URL}/api/v1/dialogue/module/{module_id}/node/{node_id}",
        headers=headers
    )
    
    if response.status_code == 200:
        data = response.json()
        node = data.get('node', {})
        print(f"✅ Success: Retrieved node {node_id}")
        print(f"   Patient: {node.get('patient_statement', '')[:60]}...")
        print(f"   Choices: {len(node.get('practitioner_choices', []))}")
        print(f"   Progress: {data.get('current_node_number')}/{data.get('total_nodes')}")
        return node.get('practitioner_choices', [])
    else:
        print(f"❌ Failed: {response.status_code}")
        print(f"   Error: {response.text}")
        
        # Check if it's the "Module not started" error
        if "Module not started" in response.text:
            print("\n⚠️  This is the 'Module not started' error!")
            print("   This suggests the progress record wasn't created properly")
        
        return None


def test_submit_choice(token, module_id, node_id, choice):
    """Test: Submit a dialogue choice"""
    print("\n✍️  Test 5: Submit Choice")
    print("-" * 60)
    
    headers = {
        "Authorization": f"Bearer {token}",
        "Content-Type": "application/json"
    }
    
    payload = {
        "module_id": module_id,
        "node_id": node_id,
        "choice_id": "choice_0",  # First choice
        "choice_text": choice.get('text', ''),
        "technique": choice.get('technique', '')
    }
    
    response = requests.post(
        f"{API_BASE_URL}/api/v1/dialogue/submit",
        headers=headers,
        json=payload
    )
    
    if response.status_code == 200:
        data = response.json()
        print(f"✅ Success: Choice submitted")
        print(f"   Correct: {data.get('is_correct')}")
        print(f"   Points: {data.get('points_earned')}")
        print(f"   Next Node: {data.get('next_node_id')}")
        return data.get('next_node_id')
    else:
        print(f"❌ Failed: {response.status_code}")
        print(f"   Error: {response.text}")
        return None


def test_progress_tracking(token):
    """Test: Get user progress"""
    print("\n📊 Test 6: Check Progress Tracking")
    print("-" * 60)
    
    headers = {"Authorization": f"Bearer {token}"}
    response = requests.get(f"{API_BASE_URL}/api/v1/progress", headers=headers)
    
    if response.status_code == 200:
        data = response.json()
        print(f"✅ Success: Retrieved progress")
        print(f"   Total Points: {data.get('total_points')}")
        print(f"   Level: {data.get('level')}")
        print(f"   Modules Completed: {data.get('modules_completed')}")
        print(f"   Progress Records: {len(data.get('progress', []))}")
        return True
    else:
        print(f"❌ Failed: {response.status_code}")
        print(f"   Error: {response.text}")
        return False


def verify_database_schema():
    """Verify the database schema has nodes_visited column"""
    print("\n🔍 Verifying Database Schema")
    print("-" * 60)
    
    try:
        supabase = create_client(SUPABASE_URL, SUPABASE_KEY)
        
        # Try to query with nodes_visited
        result = supabase.table("user_progress").select("id, nodes_visited, nodes_completed").limit(1).execute()
        print("✅ nodes_visited column exists in user_progress table")
        return True
    except Exception as e:
        error_msg = str(e)
        if "nodes_visited" in error_msg and "could not find" in error_msg.lower():
            print("❌ nodes_visited column is MISSING!")
            print("   Please run: fix_user_progress_schema.sql in Supabase SQL Editor")
            return False
        else:
            print(f"⚠️  Error checking schema: {e}")
            return False


def main():
    """Run all tests"""
    print("="*60)
    print("MI Learning Platform - Module Flow Test")
    print("="*60)
    
    # Verify schema first
    if not verify_database_schema():
        print("\n❌ Database schema issue detected. Please fix before testing.")
        print("   Run: fix_user_progress_schema.sql in Supabase SQL Editor")
        sys.exit(1)
    
    # Get test user token
    print("\n🔐 Authenticating Test User")
    print("-" * 60)
    token = get_test_user_token()
    
    if not token:
        print("\n⚠️  Cannot proceed without authentication")
        print("   Set TEST_USER_EMAIL and TEST_USER_PASSWORD in .env")
        sys.exit(1)
    
    print("✅ Authenticated successfully")
    
    # Run tests
    module_id = test_list_modules(token)
    if not module_id:
        print("\n❌ Cannot continue without modules")
        sys.exit(1)
    
    test_get_module(token, module_id)
    
    node_id = test_start_module(token, module_id)
    if not node_id:
        print("\n❌ Failed to start module")
        sys.exit(1)
    
    choices = test_get_dialogue_node(token, module_id, node_id)
    if not choices:
        print("\n❌ Failed to get dialogue node")
        sys.exit(1)
    
    if choices:
        next_node = test_submit_choice(token, module_id, node_id, choices[0])
    
    test_progress_tracking(token)
    
    print("\n" + "="*60)
    print("✅ All tests completed!")
    print("="*60)


if __name__ == "__main__":
    main()
