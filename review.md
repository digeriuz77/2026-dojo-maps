# MAPS Learning Platform — App Review

**Repository:** `digeriuz77/2026-dojo-maps`
**Review Date:** 2026-02-13
**Reviewer:** Automated Code Review

---

## 1. Overview

The MAPS Learning Platform is a web application designed to help MaPS (Money and Pensions Service) staff build foundational **Motivational Interviewing (MI)** coaching skills through simulated conversations. Users navigate branching dialogue trees representing realistic workplace scenarios, receive immediate feedback on their technique choices, and track progress through a gamified learning system with points, levels, and leaderboards.

**Target Audience:** MaPS staff and practitioners who need to develop facilitative coaching and MI skills for client-facing roles (financial guidance, debt counseling, pension exploration, etc.).

**Purpose:** Training and skill-building tool — a structured e-learning platform with AI-powered free practice sessions.

---

## 2. Tech Stack

| Layer | Technology |
|-------|-----------|
| **Backend Framework** | FastAPI (Python 3.11+) |
| **Database** | PostgreSQL via Supabase (BaaS) |
| **Authentication** | Supabase Auth with JWT tokens |
| **Frontend (Legacy)** | Vanilla JavaScript SPA with Jinja2 templates |
| **Frontend (New)** | Next.js 14 + React 18 + TypeScript + Tailwind CSS |
| **AI/Chat Practice** | OpenAI API (gpt-4.1-mini) via httpx |
| **Deployment** | Docker / Railway |
| **ORM/DB Access** | Supabase Python client + raw httpx REST calls |
| **Validation** | Pydantic v2 + pydantic-settings |
| **Testing** | pytest with unittest.mock |

**Observations:**
- The project has **two frontend implementations** — a vanilla JS SPA (`static/js/app.js` + `templates/`) and a Next.js app (`frontend/`). This creates confusion about which is the canonical frontend.
- No ORM is used; all database access goes through Supabase's REST API, which is appropriate for this architecture but means no migration tooling beyond raw SQL files.
- The `requirements.txt` includes `passlib[bcrypt]` but authentication is fully delegated to Supabase Auth, making it unused.

---

## 3. Project Structure

```
├── app/                    # FastAPI backend
│   ├── main.py             # Application entry point
│   ├── config.py           # Pydantic settings
│   ├── core/               # Auth & Supabase clients
│   ├── models/             # Pydantic models
│   ├── api/v1/             # API routers (9 modules)
│   ├── services/           # Business logic
│   └── db/migrations/      # Single migration file
├── frontend/               # Next.js frontend (separate app)
├── static/                 # Legacy vanilla JS frontend
├── templates/              # Jinja2 HTML templates
├── mi_modules/             # Learning content (JSON + SQL seeds)
├── supabase/               # Supabase migrations & edge functions
├── tests/                  # pytest test suite
├── scripts/                # Utility scripts
└── docs/                   # Schema documentation
```

**Assessment: 5/10**

- **Positive:** Clear separation of API routers, models, and services. The `api/v1/` versioning is good practice.
- **Negative:** Significant structural confusion:
  - Two competing frontends (`static/` + `templates/` vs `frontend/`) with no documentation on which to use.
  - Multiple overlapping SQL schema files: `supabase_schema.sql`, `supabase_setup.sql`, `docs/schema.sql`, `supabase/migrations/`, `app/db/migrations/`, `fix_user_progress_schema.sql`, `supabase_auth_fix.sql`, `supabase_auth_fix_v2.sql`.
  - Shell scripts at root level (`QUICKFIX_MODULES.sh`, `QUICKSTART_GUIDE.sh`, `import_modules_via_api.sh`) add clutter.
  - An HTML file inside services (`app/services/landing.html`) is misplaced.
  - `accounts/` directory with only `__init__.py` appears to be a leftover.

---

## 4. Code Quality

**Assessment: 6/10**

### Positives
- Consistent use of **docstrings** across API endpoints and services.
- Good use of **Pydantic models** for request/response validation.
- **Type hints** are used throughout the Python codebase.
- Logging is well-implemented with structured messages and appropriate log levels.
- Error handling in `app/main.py` is defensive with graceful fallbacks.

### Concerns
- **Dead code in `app/api/v1/modules.py`** (lines 233–258): Unreachable code after a `return` statement in `start_module()`. This is a clear bug — the duplicate block will never execute.
- **Legacy compatibility code** in `app/core/auth.py` returns a hardcoded "demo user" (`demo-user-123`) when authentication fails in `get_current_user_legacy()`. This is a **security risk** if any endpoint still uses this function.
- **In-memory session storage** in `app/services/chat_service.py` (`SESSIONS` dict) means all chat sessions are lost on server restart and won't work with multiple server instances.
- **Repeated proxy cleanup code** in `app/core/supabase.py` — the same proxy environment variable clearing logic is duplicated 4 times across functions.
- The `AuthenticatedTableQuery` class in `app/core/supabase.py` reimplements a subset of the Supabase client using raw httpx, creating a maintenance burden and potential inconsistencies.
- Inconsistent error handling patterns — some endpoints catch broad `Exception`, others use specific exception types.

---

## 5. Functionality

### Key Features
- ✅ **User Registration & Authentication** — Full Supabase Auth integration with email/password
- ✅ **12 Structured Learning Modules** — Comprehensive MI curriculum with dialogue trees
- ✅ **Interactive Dialogue System** — Branching conversations with technique feedback
- ✅ **Gamification** — Points, levels (1–10), leaderboard, completion tracking
- ✅ **AI Chat Practice** — Free-form MI practice with OpenAI-powered personas
- ✅ **Conversation Analysis** — Post-session analysis of MI technique usage
- ✅ **Admin Dashboard** — User management and statistics
- ✅ **Report Export** — Data export capabilities
- ✅ **Password Reset Flow** — Email-based password recovery

### Gaps
- **No module restart cleanup for dialogue_attempts** — When restarting a module, `user_progress` is reset but associated `dialogue_attempts` records are not cleaned up.
- **Token refresh is incomplete** — The `/auth/refresh` endpoint just returns the same token if valid; it doesn't actually use Supabase refresh tokens.
- **No rate limiting** on any endpoints, including authentication.
- **No pagination** on module listing or leaderboard endpoints.
- **Chat sessions are ephemeral** — No persistence of practice conversations to the database (only in-memory).

---

## 6. UI/UX

**Assessment: 6/10**

### Next.js Frontend (`frontend/`)
- Clean, modern design using **Tailwind CSS** with a custom color palette (navy, teal, coral, gold).
- Responsive grid layouts for dashboard cards.
- Proper loading states and auth-guarded routes.
- Uses `@supabase/supabase-js` for client-side auth.

### Legacy Frontend (`static/` + `templates/`)
- Vanilla JavaScript SPA with client-side routing.
- Custom CSS with a professional look.
- Functional but less maintainable than the Next.js version.

### Concerns
- **Two frontends create confusion** — It's unclear which one is deployed or recommended.
- **No accessibility (a11y) attributes** observed — missing ARIA labels, roles, and keyboard navigation support.
- **Silent error handling** in the dashboard (`catch(() => null)`) means users get no feedback when API calls fail.
- **No empty states** for leaderboard or modules when data is unavailable.

---

## 7. Security

**Assessment: 4/10 — Needs Attention**

### Critical Issues
1. **CORS allows all origins** — `allow_origins=["*"]` in production is a security risk. The config supports specific origins but defaults to wildcard.
2. **Legacy auth returns demo user on failure** — `get_current_user_legacy()` silently authenticates as `demo-user-123` when tokens are invalid. If any endpoint uses this dependency, it's a complete auth bypass.
3. **Error messages expose internal details** — The global exception handler returns `str(exc)` and `type(exc).__name__`, which can leak stack traces and internal implementation details.
4. **Supabase credentials logged** — `get_supabase()` logs partial URL and key presence at INFO level, which could appear in production logs.

### Moderate Issues
5. **No rate limiting** — Authentication endpoints are vulnerable to brute-force attacks.
6. **JWT secret can be empty** — `SUPABASE_JWT_SECRET: str = ""` allows the app to start without a JWT secret, potentially weakening token validation.
7. **Service role key in docker-compose** — `SUPABASE_SERVICE_ROLE_KEY` is passed as an environment variable in `docker-compose.yml`, which is fine for development but should be documented as unsafe for production.
8. **No CSRF protection** — Cookie-based token storage (`request.cookies.get("access_token")`) without CSRF tokens.
9. **No input sanitization** beyond Pydantic validation — SQL injection is mitigated by Supabase's REST API, but there's no XSS protection for user-generated content.

---

## 8. Performance

**Assessment: 6/10**

### Positives
- Supabase client instances are **cached as singletons** (`_supabase_client`, `_supabase_admin_client`).
- Chat service implements **conversation summarization** to reduce token usage for long sessions.
- Docker image uses `python:3.11-slim` for smaller image size.

### Concerns
- **No caching layer** — Every module listing, leaderboard query, and progress check hits Supabase directly. Adding Redis or in-memory caching for frequently-read data (modules, leaderboard) would improve response times.
- **Synchronous httpx calls** in `AuthenticatedTableQuery` — Uses `httpx.Client()` (sync) inside what should be async endpoints, blocking the event loop.
- **New httpx client per request** — `AuthenticatedTableQuery.execute()` creates a new `httpx.Client()` for every database operation instead of reusing a connection pool.
- **No database connection pooling** — Supabase REST API handles this server-side, but the custom httpx client doesn't benefit from connection reuse.
- **In-memory session storage** won't scale horizontally — multiple server instances won't share chat sessions.
- **`@app.on_event("startup")` is deprecated** in newer FastAPI versions; should use lifespan context manager.

---

## 9. Documentation

**Assessment: 7/10**

### Positives
- **Comprehensive README** with clear setup instructions, API endpoint table, environment variable documentation, gamification rules, and deployment guides.
- **`.env.example`** is well-documented with explanations of each variable and the new vs. legacy key formats.
- **`SUPABASE_SETUP_GUIDE.md`** provides additional database setup guidance.
- **Inline docstrings** on most functions and classes.
- **API auto-documentation** via FastAPI's built-in `/docs` (Swagger UI).

### Gaps
- **No architecture decision records (ADRs)** explaining the dual-frontend situation or the custom httpx client.
- **`designchoice.txt`** exists but wasn't reviewed — should be in Markdown format.
- **No contributing guide** or code style documentation.
- **README project structure is outdated** — doesn't reflect the `frontend/` directory, admin endpoints, chat practice, or many other current files.
- **No API versioning strategy** documented beyond the `/api/v1/` prefix.

---

## 10. Testing

**Assessment: 3/10 — Significant Gap**

### What Exists
- **3 test files**: `test_scoring_service.py`, `test_api_auth.py`, `test_api_modules.py`
- **`conftest.py`** with well-structured fixtures (mock Supabase client, sample data).
- `test_scoring_service.py` has **8 thorough unit tests** covering edge cases.
- `test_api_auth.py` tests registration, login, and validation scenarios with proper mocking.

### What's Missing
- **No tests for critical paths**: dialogue submission, progress tracking, chat practice, admin endpoints, leaderboard, feedback, report export.
- **No integration tests** — all tests mock Supabase, so actual database interactions are never tested.
- **No end-to-end tests** for the frontend(s).
- **No CI/CD pipeline** configuration (no GitHub Actions, no `.github/` directory).
- **`test_module_flow.py`** exists at root level but appears to be a manual test script, not part of the pytest suite.
- **No test coverage reporting** configured.
- Estimated coverage: **< 15%** of backend code.

---

## 11. Strengths

1. **Well-designed domain model** — The MI training curriculum with 12 modules, dialogue trees, technique quality scoring, and gamification is thoughtfully designed and domain-appropriate.
2. **Robust authentication architecture** — Multi-layered auth with local JWT validation falling back to Supabase API validation, plus support for both legacy and new key formats.
3. **Comprehensive API surface** — 9 router modules covering auth, modules, dialogue, progress, leaderboard, chat practice, admin, feedback, and export.
4. **AI-powered practice sessions** — The persona system with detailed character profiles, stage-of-change modeling, and conversation summarization is sophisticated.
5. **Good README and environment documentation** — Clear setup instructions lower the barrier to entry for new developers.
6. **Defensive coding** — Graceful fallbacks when settings or routers fail to load, preventing hard crashes.
7. **Database-level security** — Row-Level Security (RLS) policies in Supabase provide defense-in-depth.
8. **Rich seed data** — Extensive SQL seed files for modules, scenarios, and learning paths.

---

## 12. Areas for Improvement

### High Priority
1. **Remove dead code** — Delete unreachable code in [`start_module()`](app/api/v1/modules.py:233) and the unused `accounts/` directory.
2. **Fix the legacy auth bypass** — Remove or secure [`get_current_user_legacy()`](app/core/auth.py:349) which returns a demo user on auth failure.
3. **Restrict CORS in production** — Change the default from `["*"]` to require explicit origin configuration.
4. **Stop exposing internal errors** — Sanitize the global exception handler to not return raw exception messages.
5. **Add rate limiting** — Implement rate limiting on auth endpoints at minimum (e.g., `slowapi`).

### Medium Priority
6. **Consolidate frontends** — Choose one frontend (likely Next.js) and remove the other, or clearly document the relationship.
7. **Consolidate schema files** — Merge the 6+ SQL schema/migration files into a single migration system.
8. **Add test coverage** — Target at least 60% coverage, prioritizing dialogue submission, progress tracking, and chat practice.
9. **Persist chat sessions** — Move from in-memory `SESSIONS` dict to database storage for horizontal scaling.
10. **Fix synchronous httpx calls** — Convert `AuthenticatedTableQuery` to use `httpx.AsyncClient` to avoid blocking the event loop.

### Low Priority
11. **Add caching** — Implement caching for module listings and leaderboard data.
12. **Add pagination** — Module listing and leaderboard endpoints should support pagination.
13. **Implement proper token refresh** — Use Supabase refresh tokens instead of returning the same token.
14. **Add accessibility attributes** — ARIA labels, keyboard navigation, and screen reader support.
15. **Set up CI/CD** — Add GitHub Actions for automated testing, linting, and deployment.
16. **Replace deprecated `on_event`** — Migrate to FastAPI's lifespan context manager.

---

## 13. Overall Rating

| Category | Score | Weight | Weighted |
|----------|-------|--------|----------|
| Overview & Purpose | 9/10 | 5% | 0.45 |
| Tech Stack | 7/10 | 10% | 0.70 |
| Project Structure | 5/10 | 10% | 0.50 |
| Code Quality | 6/10 | 15% | 0.90 |
| Functionality | 7/10 | 15% | 1.05 |
| UI/UX | 6/10 | 10% | 0.60 |
| Security | 4/10 | 15% | 0.60 |
| Performance | 6/10 | 5% | 0.30 |
| Documentation | 7/10 | 5% | 0.35 |
| Testing | 3/10 | 10% | 0.30 |
| **Overall** | | | **5.75/10** |

### Summary

The MAPS Learning Platform is a **well-conceived domain application** with a solid understanding of MI training pedagogy and a feature-rich API. The gamification system, AI-powered practice sessions, and structured curriculum demonstrate strong product thinking. However, the codebase suffers from **accumulated technical debt** — dual frontends, fragmented schema files, dead code, and critically low test coverage. The most urgent concerns are **security-related**: the wildcard CORS policy, the legacy auth bypass returning a demo user, and the exposure of internal error details. Addressing the high-priority items in Section 12 would significantly improve the application's production-readiness and maintainability.

**Verdict:** A promising training platform with strong domain design that needs security hardening, codebase cleanup, and significantly more test coverage before production deployment.
