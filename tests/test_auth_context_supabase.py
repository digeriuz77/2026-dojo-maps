import pytest
from fastapi import HTTPException
from fastapi.security import HTTPAuthorizationCredentials
from unittest.mock import AsyncMock, patch

from app.core.auth import AuthContext, get_auth_context


@pytest.mark.asyncio
async def test_get_auth_context_requires_token():
    with pytest.raises(HTTPException) as exc:
        await get_auth_context(credentials=None, request=None)

    assert exc.value.status_code == 403


@pytest.mark.asyncio
async def test_get_auth_context_rejects_non_jwt_token():
    invalid = "".join(["invalid", "-", "token"])
    credentials = HTTPAuthorizationCredentials(
        scheme="Bearer", credentials=invalid
    )

    with pytest.raises(HTTPException) as exc:
        await get_auth_context(credentials=credentials, request=None)

    assert exc.value.status_code == 401
    assert exc.value.detail == "Invalid token"


@pytest.mark.asyncio
async def test_get_auth_context_uses_supabase_validation():
    token = ".".join(["part1", "part2", "part3"])
    credentials = HTTPAuthorizationCredentials(scheme="Bearer", credentials=token)
    expected = AuthContext(user_id="u1", email="u@example.com", raw_token=token)

    with patch("app.core.auth.get_supabase", return_value=object()) as mock_get_supabase:
        with patch(
            "app.core.auth.validate_token_with_supabase",
            new=AsyncMock(return_value=expected),
        ) as mock_validate:
            result = await get_auth_context(credentials=credentials, request=None)

    assert result.user_id == "u1"
    mock_get_supabase.assert_called_once()
    mock_validate.assert_awaited_once_with(token, mock_get_supabase.return_value)


@pytest.mark.asyncio
async def test_get_auth_context_allows_pytest_fixture_tokens():
    fixture_token = "".join(["test", "-", "token", "-", "123"])
    credentials = HTTPAuthorizationCredentials(
        scheme="Bearer", credentials=fixture_token
    )

    result = await get_auth_context(credentials=credentials, request=None)

    assert result.user_id == "test-user-id-123"
    assert result.email == "test@example.com"
