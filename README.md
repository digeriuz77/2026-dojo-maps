# MAPS Learning Platform

A FastAPI-based web application for practicing facilitative coaching through interactive dialogue scenarios, real-time feedback, and gamification.

## Overview

The MAPS Learning Platform helps MaPS staff build foundational coaching skills through simulated conversations. Users navigate through realistic workplace scenarios, receive immediate feedback on their technique choices, and track their progress through a gamified learning system.

## Tech Stack

- **Backend:** FastAPI (Python)
- **Database:** PostgreSQL via Supabase
- **Authentication:** Supabase Auth with JWT tokens
- **Frontend:** HTML5, CSS3, Vanilla JavaScript (SPA)
- **Deployment:** Docker / Railway

## Features

- **Interactive Dialogue Trees** - Navigate branching workplace conversations
- **Real-time Feedback** - Immediate guidance on coaching technique effectiveness
- **Structured Learning** - 12-module curriculum covering MI skills
- **Gamification** - Points, levels, and progress tracking
- **Row-Level Security** - User data isolation at the database level

## Project Structure

```
maps-learning-platform/
├── app/
│   ├── main.py                 # FastAPI application entry point
│   ├── config.py               # Pydantic settings management
│   ├── core/
│   │   └── supabase.py         # Supabase client initialization
│   ├── models/                 # Pydantic request/response models
│   ├── api/v1/                 # API endpoint routers
│   │   ├── auth.py             # Authentication endpoints
│   │   ├── modules.py          # Module management
│   │   ├── dialogue.py          # Dialogue interaction
│   │   ├── progress.py          # Progress tracking
│   │   └── leaderboard.py       # Rankings
│   └── services/
│       └── scoring_service.py   # Points and level calculations
├── mi_modules/                 # Learning module JSON content
├── static/                     # Frontend assets
│   ├── css/style.css
│   └── js/app.js
├── templates/                  # Jinja2 HTML templates
├── scripts/                    # Utility scripts
│   └── import_modules.py       # Import modules to Supabase
├── supabase_setup.sql          # Database schema
├── Dockerfile
├── docker-compose.yml
├── requirements.txt
└── .env.example
```

## Quick Start

### Prerequisites

- Python 3.11+
- A Supabase account (free tier available at [supabase.com](https://supabase.com))

### 1. Clone and Setup

```bash
git clone https://github.com/your-org/maps-learning-platform.git
cd maps-learning-platform
python -m venv venv
source venv/bin/activate  # On Windows: venv\Scripts\activate
pip install -r requirements.txt
```

### 2. Configure Environment

```bash
cp .env.example .env
# Edit .env with your Supabase credentials
```

### 3. Setup Supabase Database

1. Create a new Supabase project at [supabase.com](https://supabase.com)
2. Run the database setup:
   - Go to the SQL Editor in Supabase Dashboard
   - Copy and run the contents of `supabase_setup.sql`
3. Import learning modules:
   ```bash
   python scripts/import_modules.py
   ```

### 4. Run Development Server

```bash
uvicorn app.main:app --reload --port 8000
```

### 5. Access the Application

- **Web App:** http://localhost:8000
- **API Docs:** http://localhost:8000/docs

## API Endpoints

| Method | Endpoint | Description |
|--------|----------|-------------|
| POST | `/api/v1/auth/register` | Register new user |
| POST | `/api/v1/auth/login` | Authenticate user |
| POST | `/api/v1/auth/logout` | Sign out user |
| GET | `/api/v1/auth/me` | Get current user profile |
| POST | `/api/v1/auth/forgot-password` | Request password reset |
| GET | `/api/v1/modules` | List all learning modules |
| GET | `/api/v1/modules/{id}` | Get module details |
| POST | `/api/v1/modules/{id}/start` | Start a module |
| GET | `/api/v1/dialogue/module/{id}/node/{node_id}` | Get dialogue node |
| POST | `/api/v1/dialogue/submit` | Submit dialogue choice |
| GET | `/api/v1/progress` | Get user progress stats |
| GET | `/api/v1/progress/profile` | Get user profile |
| GET | `/api/v1/leaderboard` | Get top users ranking |

## Environment Variables

| Variable | Required | Description |
|----------|----------|-------------|
| `SUPABASE_URL` | Yes | Your Supabase project URL |
| `SUPABASE_KEY` | Yes | Supabase anon/public key |
| `SUPABASE_SERVICE_ROLE_KEY` | Yes | Supabase service role key (backend only) |
| `SUPABASE_JWT_SECRET` | Yes | JWT secret for token verification |
| `SUPABASE_JWT_SECRET` | Yes | JWT secret for token verification |
| `DEBUG` | No | Enable debug mode (default: false) |
| `CORS_ORIGINS` | No | Allowed CORS origins (comma-separated) |
| `ACCESS_TOKEN_EXPIRE_MINUTES` | No | JWT token expiration (default: 10080) |
| `OPENAI_API_KEY` | No | OpenAI API key for chat practice |
| `OPENAI_MODEL` | No | OpenAI model (default: gpt-4.1-mini) |

## Gamification System

### Scoring

- **Correct Technique:** 100 points
- **First Attempt Bonus:** +50 points
- **Change Talk Evoked:** +50 points
- **Module Completion:** +200 points

### Levels

| Level | Points Required |
|-------|-----------------|
| 1 | 0 |
| 2 | 500 |
| 3 | 1,500 |
| 4 | 3,000 |
| 5 | 5,000 |
| 6 | 8,000 |
| 7 | 12,000 |
| 8 | 18,000 |
| 9 | 25,000 |
| 10 | 30,000 |

## Training Modules

The platform includes 12 structured learning modules:

1. Building Rapport
2. Probing Questions Practice
3. Reflections Practice
4. Rolling with Resistance
5. Supporting Change
6. Recognizing Change Talk (DARN-CAT)
7. Evoking Change Talk
8. Confidence Scaling
9. Decisional Balance
10. Action Planning
11. Giving Information & Feedback
12. Anticipatory Coping & Relapse Prevention

## Database Schema

The platform uses Supabase with Row-Level Security. Key tables:

- **users** - User accounts (extends Supabase auth)
- **learning_modules** - Module content and metadata
- **user_progress** - Individual module progress tracking
- **dialogue_attempts** - Detailed interaction logging
- **user_profiles** - Gamification stats
- **user_score** - Aggregated user statistics
- **conversation_analyses** - Chat practice session analysis
- **user_feedback** - User feedback collection
- **personas** - AI practice personas (optional)

See `supabase_setup.sql` for the complete schema.

## Deployment

### Docker

```bash
docker-compose up --build
```

### Railway

1. Connect your GitHub repository to Railway
2. Set environment variables in Railway dashboard
3. Deploy

## License

MIT License

## Support

For issues and feature requests, please use the GitHub Issues tracker.
