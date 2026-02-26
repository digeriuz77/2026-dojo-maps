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
    The supabase Python client v2+ handles both legacy and new API key formats automatically.

    Returns:
        Client: Initialized Supabase client
    """
    # Clear proxy environment variables that might conflict with supabase client
    for proxy_var in [
        "HTTP_PROXY", "HTTPS_PROXY", "http_proxy", "https_proxy",
        "ALL_PROXY", "all_proxy", "NO_PROXY", "no_proxy",
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

    Returns:
        Client: Initialized Supabase admin client
    """
    # Clear proxy environment variables that might conflict with supabase client
    for proxy_var in [
        "HTTP_PROXY", "HTTPS_PROXY", "http_proxy", "https_proxy",
        "ALL_PROXY", "all_proxy", "NO_PROXY", "no_proxy",
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
        # Simple query to test connection
        result = client.table("learning_modules").select("id").limit(1).execute()
        return {
            "status": "healthy",
            "service": "supabase",
            "message": "Connected successfully",
            "data_count": len(result.data) if result.data else 0
        }
    except Exception as e:
        logger.error(f"Supabase connection test failed: {e}")
        return {
            "status": "unhealthy",
            "service": "supabase",
            "error": str(e)
        }


# Add httpx client wrapper for authenticated requests
class AuthenticatedSupabaseClient:
    """
    Wrapper around Supabase client that uses JWT token for authentication.
    This bypasses the Supabase Python client's auth handling and uses httpx
    directly with the JWT token, which properly passes RLS policies.
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
        """Return a table reference for querying."""
        return _AuthenticatedTableProxy(self.base_url, self.headers, table_name)


class _AuthenticatedTableProxy:
    """Proxy for table operations using httpx directly."""

    def __init__(self, base_url: str, headers: Dict[str, str], table_name: str):
        self.base_url = base_url
        self.headers = headers
        self.table_name = table_name
        self._select_columns = "*"
        self._filters = []

    def select(self, columns: str = "*"):
        self._select_columns = columns
        return self

    def eq(self, column: str, value: Any):
        self._filters.append({"column": column, "operator": "eq", "value": value})
        return self

    def execute(self):
        """Execute the query."""
        import httpx
        url = f"{self.base_url}/rest/v1/{self.table_name}?select={self._select_columns}"
        
        # Add filters
        for f in self._filters:
            if f["operator"] == "eq":
                url += f"&{f['column']}=eq.{f['value']}"
        
        with httpx.Client() as client:
            response = client.get(url, headers=self.headers)
            response.raise_for_status()
            return _SupabaseResult(response.json())

    def insert(self, data: Dict[str, Any]):
        """Insert a row."""
        import httpx
        url = f"{self.base_url}/rest/v1/{self.table_name}"
        
        headers = {**self.headers, "Prefer": "return=representation"}
        with httpx.Client() as client:
            response = client.post(url, json=data, headers=headers)
            response.raise_for_status()
            return _SupabaseResult(response.json())

    def update(self, data: Dict[str, Any]):
        """Update rows."""
        import httpx
        url = f"{self.base_url}/rest/v1/{self.table_name}"
        
        # Add filters to URL
        first = True
        for f in self._filters:
            char = '?' if first else '&'
            if f["operator"] == "eq":
                url += f"{char}{f['column']}=eq.{f['value']}"
                first = False
        
        headers = {**self.headers, "Prefer": "return=representation"}
        with httpx.Client() as client:
            response = client.patch(url, json=data, headers=headers)
            response.raise_for_status()
            return _SupabaseResult(response.json())

    def delete(self):
        """Delete rows."""
        import httpx
        url = f"{self.base_url}/rest/v1/{self.table_name}"
        
        # Add filters to URL
        first = True
        for f in self._filters:
            char = '?' if first else '&'
            if f["operator"] == "eq":
                url += f"{char}{f['column']}=eq.{f['value']}"
                first = False
        
        headers = {**self.headers, "Prefer": "return=representation"}
        with httpx.Client() as client:
            response = client.delete(url, headers=headers)
            response.raise_for_status()
            return _SupabaseResult(response.json() or [])


class _SupabaseResult:
    """Wrapper for Supabase query results."""

    def __init__(self, data: Any):
        self.data = data


def get_authenticated_client(jwt_token: str) -> AuthenticatedSupabaseClient:
    """
    Get a Supabase client with a specific JWT token for authenticated requests.

    This bypasses the Supabase Python client's auth handling and uses httpx
    directly with the JWT token, which properly passes RLS policies.

    Args:
        jwt_token: The JWT token from the authenticated user

    Returns:
        AuthenticatedSupabaseClient: Client configured with the JWT token
    """
    return AuthenticatedSupabaseClient(jwt_token)
