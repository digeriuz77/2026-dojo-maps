"""
MI Learning Platform - FastAPI Main Application
"""

import asyncio
import logging
import os
from contextlib import asynccontextmanager
from pathlib import Path
from typing import Any, Dict

from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from fastapi.responses import JSONResponse, Response
from fastapi import Request
from fastapi.staticfiles import StaticFiles
from fastapi.templating import Jinja2Templates
from slowapi import Limiter, _rate_limit_exceeded_handler
from slowapi.util import get_remote_address
from slowapi.errors import RateLimitExceeded

# Configure logging first
logging.basicConfig(
    level=logging.INFO, format="%(asctime)s - %(name)s - %(levelname)s - %(message)s"
)
logger = logging.getLogger(__name__)

# Import settings with error handling
try:
    from app.config import settings
except Exception as e:
    logger.error(f"Failed to load settings: {e}")

    # Create minimal settings for startup
    class MinimalSettings:
        APP_NAME = "MI Learning Platform"
        APP_VERSION = "1.0.0"

    settings = MinimalSettings()

# Import routers
try:
    from app.api.v1 import (
        auth,
        modules,
        dialogue,
        progress,
        leaderboard,
        chat_practice,
        admin,
        feedback,
        report_export,
    )

    ROUTERS_LOADED = True
except Exception as e:
    logger.error(f"Failed to load routers: {e}")
    ROUTERS_LOADED = False


# Lifespan context manager (replaces deprecated @app.on_event("startup"))
@asynccontextmanager
async def lifespan(app: FastAPI):
    """Application lifespan: startup and shutdown logic."""
    app_name = getattr(settings, "APP_NAME", "MI Learning Platform")
    app_version = getattr(settings, "APP_VERSION", "1.0.0")
    logger.info(f"🚀 {app_name} v{app_version} started")
    logger.info(f"Routers loaded: {ROUTERS_LOADED}")
    # Start periodic session cleanup background task
    cleanup_task = asyncio.create_task(_periodic_session_cleanup())
    yield
    # Shutdown: cancel background tasks
    cleanup_task.cancel()
    try:
        await cleanup_task
    except asyncio.CancelledError:
        pass
    logger.info(f"🛑 {app_name} shutting down")


# Create FastAPI app
app = FastAPI(
    title=getattr(settings, "APP_NAME", "MI Learning Platform"),
    version=getattr(settings, "APP_VERSION", "1.0.0"),
    description="MI Learning Platform API",
    lifespan=lifespan,
)

# P1-7: Rate limiting to prevent brute-force and abuse
# Default: 60 requests/minute per IP. Auth endpoints have stricter limits.
limiter = Limiter(key_func=get_remote_address, default_limits=["60/minute"])
app.state.limiter = limiter
app.add_exception_handler(RateLimitExceeded, _rate_limit_exceeded_handler)

# SECURITY: Configure CORS with specific origins only.
# Do not use allow_origins=["*"] with allow_credentials=True as it allows
# any site to make authenticated cross-origin requests.
_cors_origins = getattr(settings, "CORS_ORIGINS", [])
app.add_middleware(
    CORSMiddleware,
    allow_origins=_cors_origins,
    allow_credentials=bool(_cors_origins and _cors_origins != ["*"]),
    allow_methods=["*"],
    allow_headers=["*"],
)


# SECURITY: Add security headers to all responses
# These headers protect against common attacks without breaking app functionality
@app.middleware("http")
async def add_security_headers(request: Request, call_next):
    """Add security headers to protect against common web vulnerabilities."""
    response = await call_next(request)

    # Prevent MIME type sniffing attacks
    response.headers["X-Content-Type-Options"] = "nosniff"

    # Prevent clickjacking attacks
    response.headers["X-Frame-Options"] = "DENY"

    # Enable XSS filter in browsers (legacy but still useful)
    response.headers["X-XSS-Protection"] = "1; mode=block"

    # Control referrer information
    response.headers["Referrer-Policy"] = "strict-origin-when-cross-origin"

    # Permissions Policy (formerly Feature Policy)
    # Only allow features the app actually needs
    response.headers["Permissions-Policy"] = (
        "accelerometer=(), camera=(), geolocation=(), gyroscope=(), magnetometer=(), microphone=(), payment=(), usb=()"
    )

    return response


# SECURITY: Global exception handler - do not leak internal error details to clients.
# Full error is logged server-side for debugging.
@app.exception_handler(Exception)
async def global_exception_handler(request: Request, exc: Exception):
    """Catch all exceptions - log details server-side, return generic message to client."""
    logger.error(f"Error on {request.url.path}: {exc}", exc_info=True)
    return JSONResponse(
        status_code=500, content={"error": "An internal server error occurred."}
    )


# Include API routers
if ROUTERS_LOADED:
    app.include_router(auth.router, prefix="/api/v1/auth", tags=["Authentication"])
    app.include_router(modules.router, prefix="/api/v1/modules", tags=["Modules"])
    app.include_router(dialogue.router, prefix="/api/v1/dialogue", tags=["Dialogue"])
    app.include_router(progress.router, prefix="/api/v1/progress", tags=["Progress"])
    app.include_router(
        leaderboard.router, prefix="/api/v1/leaderboard", tags=["Leaderboard"]
    )
    app.include_router(chat_practice.router, prefix="/api/v1", tags=["Chat Practice"])
    app.include_router(admin.router, prefix="/api/v1/admin", tags=["Admin"])
    app.include_router(feedback.router, prefix="/api/v1", tags=["Feedback"])
    app.include_router(report_export.router, prefix="/api/v1", tags=["Export"])

# Mount static files
static_dir = Path(__file__).parent.parent / "static"
if static_dir.exists():
    app.mount("/static", StaticFiles(directory=str(static_dir)), name="static")

# Setup templates
templates = None
templates_dir = Path(__file__).parent.parent / "templates"
if templates_dir.exists():
    templates = Jinja2Templates(directory=str(templates_dir))


@app.get("/")
async def root(request: Request):
    """Root endpoint - serve the frontend HTML"""
    if templates:
        return templates.TemplateResponse(
            "index.html",
            {
                "request": request,
                "supabase_url": getattr(settings, "SUPABASE_URL", ""),
                "supabase_anon_key": getattr(settings, "SUPABASE_KEY", ""),
            },
        )
    # Fallback to JSON if templates not found
    return {
        "name": getattr(settings, "APP_NAME", "MI Learning Platform"),
        "version": getattr(settings, "APP_VERSION", "1.0.0"),
        "status": "running",
        "docs": "/docs",
    }


@app.get("/admin")
async def admin_dashboard(request: Request):
    """Admin dashboard endpoint - serve the admin HTML with Supabase config"""
    if templates:
        return templates.TemplateResponse(
            "admin.html",
            {
                "request": request,
                "supabase_url": getattr(settings, "SUPABASE_URL", ""),
                "supabase_anon_key": getattr(settings, "SUPABASE_KEY", ""),
            },
        )
    return {"error": "Templates not configured"}


@app.get("/reset-password")
async def reset_password_page(request: Request):
    """Password reset page - serves the SPA for password reset flow"""
    if templates:
        return templates.TemplateResponse(
            "index.html",
            {
                "request": request,
                "supabase_url": getattr(settings, "SUPABASE_URL", ""),
                "supabase_anon_key": getattr(settings, "SUPABASE_KEY", ""),
            },
        )
    return {"error": "Templates not configured"}


# SPA catch-all: serve index.html for all frontend routes so that direct
# navigation (bookmarks, shared links, page refresh) does not 404.
# API routes (/api/*), static files (/static/*), and specific pages above
# are matched first by FastAPI's route priority.
_SPA_ROUTES = [
    "/login",
    "/register",

    "/modules",
    "/modules/{module_id}",
    "/modules/{module_id}/dialogue",
    "/progress",
    "/leaderboard",
    "/chat-practice",
    "/chat-practice/session",
    "/chat-practice/results",
]


async def _serve_spa(request: Request):
    if templates:
        return templates.TemplateResponse(
            "index.html",
            {
                "request": request,
                "supabase_url": getattr(settings, "SUPABASE_URL", ""),
                "supabase_anon_key": getattr(settings, "SUPABASE_KEY", ""),
            },
        )
    return JSONResponse(status_code=404, content={"error": "Not found"})


for _spa_route in _SPA_ROUTES:
    app.add_api_route(_spa_route, _serve_spa, methods=["GET"], include_in_schema=False)


@app.get("/health")
async def health_check():
    """Basic liveness check for process health."""
    return {"status": "healthy"}


@app.get("/health/ready")
async def readiness_health_check():
    """Readiness check with database connectivity signal."""
    detailed = await _get_operational_health(detailed=False)
    supabase_check = detailed.get("checks", {}).get("supabase_connectivity", {"status": "error"})
    ready = supabase_check.get("status") == "ok"

    return {
        "status": "ready" if ready else "degraded",
        "checks": {
            "supabase_connectivity": supabase_check,
        },
    }


from fastapi.responses import FileResponse

@app.get("/favicon.ico", include_in_schema=False)
async def favicon():
    """Return the MAPS logo as the favicon."""
    favicon_path = Path(__file__).parent.parent / "static" / "images" / "maps-logo.svg"
    return FileResponse(favicon_path)


@app.get("/health/detailed")
async def detailed_health_check():
    """Detailed operational health check.

    SECURITY: Does not expose secrets or raw internal exception traces.
    """
    return await _get_operational_health(detailed=True)


async def _get_operational_health(detailed: bool = False) -> Dict[str, Any]:
    """Build operational health details for config + schema readiness."""
    from app.core.supabase import get_supabase, get_supabase_admin

    checks: Dict[str, Any] = {
        "config": {"status": "ok"},
        "supabase_connectivity": {"status": "ok"},
        "schema_contract": {"status": "ok"},
    }

    status_value = "healthy"

    # Config checks
    try:
        missing = []
        for key in ["SUPABASE_URL", "SUPABASE_KEY", "SUPABASE_SERVICE_ROLE_KEY"]:
            if not getattr(settings, key, ""):
                missing.append(key)

        if missing:
            checks["config"] = {"status": "error", "missing": missing}
            status_value = "degraded"
        elif detailed:
            checks["config"] = {
                "status": "ok",
                "supabase_url_configured": bool(getattr(settings, "SUPABASE_URL", "")),
                "anon_key_configured": bool(getattr(settings, "SUPABASE_KEY", "")),
                "service_role_configured": bool(getattr(settings, "SUPABASE_SERVICE_ROLE_KEY", "")),
            }
    except Exception:
        checks["config"] = {"status": "error"}
        status_value = "degraded"

    # Connectivity + contract checks (table/column presence inferred via select)
    try:
        anon_client = get_supabase()
        admin_client = get_supabase_admin()

        anon_client.table("learning_modules").select("id").limit(1).execute()
        checks["supabase_connectivity"] = {"status": "ok"}

        contract_checks = {
            "user_profiles": "user_id,modules_completed,last_active_at",
            "user_progress": "id,user_id,module_id,status,current_node_id,nodes_completed,started_at",
            "dialogue_attempts": "id,user_id,module_id,progress_id,node_id,choice_id,choice_text,technique,feedback_text",
        }

        missing_contracts = []
        for table_name, select_cols in contract_checks.items():
            try:
                admin_client.table(table_name).select(select_cols).limit(1).execute()
            except Exception:
                missing_contracts.append(table_name)

        if missing_contracts:
            checks["schema_contract"] = {"status": "error", "missing_or_mismatched": missing_contracts}
            status_value = "degraded"
        elif detailed:
            checks["schema_contract"] = {
                "status": "ok",
                "validated_tables": list(contract_checks.keys()),
            }
    except Exception:
        checks["supabase_connectivity"] = {"status": "error"}
        checks["schema_contract"] = {"status": "unknown"}
        status_value = "degraded"

    health_payload: Dict[str, Any] = {
        "status": status_value,
        "app": {
            "name": getattr(settings, "APP_NAME", "MI Learning Platform"),
            "version": getattr(settings, "APP_VERSION", "1.0.0"),
        },
        "checks": checks,
    }

    if detailed:
        health_payload["routers_loaded"] = ROUTERS_LOADED

    return health_payload


async def _periodic_session_cleanup():
    """Background task to clean up old chat sessions periodically (P2-27)."""
    while True:
        try:
            await asyncio.sleep(3600)  # Run every hour
            from app.services.chat_service import cleanup_old_sessions

            removed = cleanup_old_sessions(max_age_hours=24)
            if removed:
                logger.info(f"Cleaned up {removed} old chat sessions")
        except asyncio.CancelledError:
            break
        except Exception as e:
            logger.warning(f"Session cleanup error: {e}")


if __name__ == "__main__":
    import uvicorn

    uvicorn.run(app, host="0.0.0.0", port=8000)
