"""
Supabase client for database and authentication operations
Following the supabase-hello-world pattern
"""

import os
import logging
from typing import Optional, Dict, Any, List
from supabase import create_client, Client
from supabase._sync.client import Client as SyncClient
from app.config import settings

import httpx

# Clear proxy environment variables that might conflict with supabase client
for proxy_var in ["HTTP_PROXY", "HTTPS_PROXY", "http_proxy", "https_proxy"]:
    if proxy_var in os.environ:
        del os.environ[proxy_var]

logger = logging.getLogger(__name__)

_supabase_client: Optional[Client] = None
_supabase_admin_client: Optional[Client] = None


def get_supabase() -> Client:
    """
    Get a Supabase client with anon key permissions.

    Used for client-side operations like user sign up and sign in.

    Returns:
        Client: Initialized Supabase client
    """
    # Clear proxy environment variables that might conflict with supabase client
    # This is done here to ensure it happens on each request in case they're set later
    for proxy_var in [
        "HTTP_PROXY",
        "HTTPS_PROXY",
        "http_proxy",
        "https_proxy",
        "ALL_PROXY",
        "all_proxy",
        "NO_PROXY",
        "no_proxy",
    ]:
        os.environ.pop(proxy_var, None)

    global _supabase_client
    if _supabase_client is None:
        logger.info("Initializing Supabase client with anon key")
        logger.info(f"Supabase URL: {settings.SUPABASE_URL[:30]}...")
        logger.info(f"Supabase Key present: {bool(settings.SUPABASE_KEY)}")
        _supabase_client = create_client(settings.SUPABASE_URL, settings.SUPABASE_KEY)
        logger.info("Supabase client initialized successfully")
    return _supabase_client


def get_supabase_admin() -> Client:
    """
    Get a Supabase client with secret key permissions.

    Used for administrative operations that bypass RLS policies.
    With new key format, this uses sb_secret_xxx for elevated access.

    Returns:
        Client: Initialized Supabase admin client
    """
    # Clear proxy environment variables that might conflict with supabase client
    for proxy_var in [
        "HTTP_PROXY",
        "HTTPS_PROXY",
        "http_proxy",
        "https_proxy",
        "ALL_PROXY",
        "all_proxy",
        "NO_PROXY",
        "no_proxy",
    ]:
        os.environ.pop(proxy_var, None)

    global _supabase_admin_client
    if _supabase_admin_client is None:
        logger.info("Initializing Supabase admin client with secret key")
        _supabase_admin_client = create_client(
            settings.SUPABASE_URL, settings.SUPABASE_SECRET_KEY
        )
        logger.info("Supabase admin client initialized successfully")
    return _supabase_admin_client


async def test_connection() -> Dict[str, Any]:
    """
    Test Supabase connection with a simple query.

    Returns:
        Dict with test results
    """
    try:
        client = get_supabase()

        # Test 1: Check if we can query the auth users table (via auth API)
        logger.info("Testing Supabase connection...")

        # Test 2: Try a simple table query
        response = client.table("learning_modules").select("count").execute()

        logger.info(f"Connection test successful. Modules count: {response.data}")

        return {
            "status": "success",
            "message": "Successfully connected to Supabase",
            "supabase_url": settings.SUPABASE_URL[:30] + "...",
            "modules_count": len(response.data) if response.data else 0,
            "config_present": {
                "supabase_url": bool(settings.SUPABASE_URL),
                "supabase_key": bool(settings.SUPABASE_KEY),
                "secret_key": bool(settings.SUPABASE_SECRET_KEY),
                "jwt_secret": bool(settings.SUPABASE_JWT_SECRET),
            },
        }
    except Exception as e:
        logger.error(f"Connection test failed: {e}")
        return {
            "status": "error",
            "message": str(e),
            "supabase_url": settings.SUPABASE_URL[:30] + "..."
            if settings.SUPABASE_URL
            else "None",
            "config_present": {
                "supabase_url": bool(settings.SUPABASE_URL),
                "supabase_key": bool(settings.SUPABASE_KEY),
                "secret_key": bool(settings.SUPABASE_SECRET_KEY),
                "jwt_secret": bool(settings.SUPABASE_JWT_SECRET),
            },
        }


def get_authenticated_supabase(jwt_token: str) -> Client:
    """
    Get a Supabase client with a specific JWT token for authenticated requests.

    This client will use the provided JWT for RLS policies, allowing operations
    that require the user's auth context (like inserting user_progress records).

    Args:
        jwt_token: The JWT token from the authenticated user

    Returns:
        Client: Initialized Supabase client with the provided JWT
    """
    for proxy_var in [
        "HTTP_PROXY",
        "HTTPS_PROXY",
        "http_proxy",
        "https_proxy",
        "ALL_PROXY",
        "all_proxy",
        "NO_PROXY",
        "no_proxy",
    ]:
        os.environ.pop(proxy_var, None)

    client = create_client(settings.SUPABASE_URL, settings.SUPABASE_KEY)
    client.auth.set_session(jwt_token, "")
    return client
