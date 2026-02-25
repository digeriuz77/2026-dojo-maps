"""
Supabase client for database and authentication operations
Following the supabase-hello-world pattern
"""

import os
import logging
from typing import Optional, Dict, Any, List
from supabase import create_client, Client
from supabase import Client
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
        logger.info("Initializing Supabase admin client with service role key")
        _supabase_admin_client = create_client(
            settings.SUPABASE_URL, settings.SUPABASE_SERVICE_ROLE_KEY
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
                "secret_key": bool(settings.SUPABASE_SERVICE_ROLE_KEY),
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
                "secret_key": bool(settings.SUPABASE_SERVICE_ROLE_KEY),
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

    # Use private method to set headers directly
    try:
        headers = {"Authorization": f"Bearer {jwt_token}"}
        client._headers.update(headers)
    except AttributeError:
        pass

    return client


class AuthenticatedSupabaseClient:
    """
    A lightweight authenticated Supabase client using httpx directly.
    Used for operations that require RLS with user authentication.
    """

    def __init__(self, jwt_token: str):
        self.jwt_token = jwt_token
        self.base_url = settings.SUPABASE_URL.rstrip("/")
        self.headers = {
            "Authorization": f"Bearer {jwt_token}",
            "apikey": settings.SUPABASE_KEY,
            "Content-Type": "application/json",
        }

    def table(self, table_name: str):
        """Return a query builder for the specified table."""
        return AuthenticatedTableQuery(self.base_url, table_name, self.headers)


class AuthenticatedTableQuery:
    """Authenticated table query builder using httpx."""

    def __init__(self, base_url: str, table_name: str, headers: dict):
        self.base_url = base_url
        self.table_name = table_name
        self.headers = headers
        self._select = "*"
        self._filters = []
        self._body = None

    def select(self, columns: str):
        """Set columns to select."""
        self._select = columns
        return self

    def eq(self, column: str, value: str):
        """Add equality filter."""
        self._filters.append(f"{column}=eq.{value}")
        return self

    def execute(self):
        """Execute the query."""
        import httpx

        url = f"{self.base_url}/rest/v1/{self.table_name}?select={self._select}"
        if self._filters:
            url += "&" + "&".join(self._filters)

        with httpx.Client() as client:
            response = client.get(url, headers=self.headers)
            response.raise_for_status()
            return type("Response", (), {"data": response.json()})()

    def insert(self, data: dict):
        """Insert data into table."""
        self._body = data
        return self

    def insert_execute(self):
        """Execute the insert."""
        import httpx

        url = f"{self.base_url}/rest/v1/{self.table_name}"
        with httpx.Client() as client:
            response = client.post(url, json=self._body, headers=self.headers)
            response.raise_for_status()
            # Handle empty 204 response or return the created record
            if response.status_code == 204 or not response.text:
                # Return the inserted data with default values for missing fields
                return type("Response", (), {"data": [{"id": None, **self._body}]})()
            try:
                data = response.json()
                if isinstance(data, list):
                    return type("Response", (), {"data": data})()
                elif isinstance(data, dict):
                    return type("Response", (), {"data": [data]})()
                else:
                    return type(
                        "Response", (), {"data": [{"id": None, **self._body}]}
                    )()
            except Exception:
                return type("Response", (), {"data": [{"id": None, **self._body}]})()


def get_authenticated_client(jwt_token: str) -> AuthenticatedSupabaseClient:
    """
    Get an authenticated Supabase client using httpx directly.

    This bypasses the Supabase Python client's auth handling and uses httpx
    directly with the JWT token, which properly passes RLS policies.

    Args:
        jwt_token: The JWT token from the authenticated user

    Returns:
        AuthenticatedSupabaseClient: Client with authenticated REST access
    """
    return AuthenticatedSupabaseClient(jwt_token)
