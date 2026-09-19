# 🌿 Darukaa.Earth

**A full-stack geospatial data analytics platform for managing and visualizing carbon and biodiversity projects.**

> Built for the Darukaa.Earth Full-Stack Developer Hackathon.

---

## Features

- 🔐 **JWT Authentication** — Register, login, logout, protected routes
- 📁 **Project Management** — Create/edit/delete Carbon & Biodiversity projects
- 📍 **Site Management** — Add geographical sites with drawn polygon boundaries
- 🗺️ **Interactive Mapbox Map** — View all project sites with polygon overlays
- ✏️ **Polygon Drawing** — Draw site boundaries directly on the map
- 🌍 **PostGIS Storage** — Geographic data stored using PostGIS GEOMETRY
- 📈 **Analytics & Charts** — Historical carbon/biodiversity/vegetation metrics (Chart.js)
- ⚙️ **CI/CD** — GitHub Actions (lint + build + test on every push)
- 🧹 **Code Quality** — ESLint, Prettier, Ruff, Husky pre-commit hooks

---

## Architecture

```
React (TypeScript + Vite)
       ↓
  Axios API Service
       ↓
  FastAPI (Python)
       ↓
  SQLAlchemy + GeoAlchemy2
       ↓
  PostgreSQL + PostGIS
```

---

## Database Schema

```
USERS ──< PROJECTS ──< SITES ──< SITE_METRICS
```

| Table | Key Fields |
|---|---|
| `users` | id (UUID), name, email, password_hash |
| `projects` | id, name, project_type, status, start_date, end_date, created_by → users.id |
| `sites` | id, project_id → projects.id, name, area_hectares, latitude, longitude, location (GEOMETRY POLYGON 4326) |
| `site_metrics` | id, site_id → sites.id, measurement_date, carbon_value, biodiversity_score, vegetation_index, project_progress |

---

## Local Development Setup

### Prerequisites

- Node.js ≥ 20
- Python ≥ 3.11
- PostgreSQL ≥ 14 with [PostGIS](https://postgis.net/) extension
- Git

---

### 1. Clone the repository

```bash
git clone https://github.com/YOUR_USERNAME/darukaa-earth.git
cd darukaa-earth
```

### 2. Configure environment variables

**Backend:**
```bash
cp backend/.env.example backend/.env
# Edit backend/.env — set DATABASE_URL, JWT_SECRET
```

**Frontend:**
```bash
cp frontend/.env.example frontend/.env
# Edit frontend/.env — set VITE_MAPBOX_TOKEN
```

### 3. Create the PostgreSQL database

```sql
CREATE DATABASE darukaa_earth;
\c darukaa_earth
CREATE EXTENSION postgis;
```

### 4. Install backend dependencies & run migrations

```bash
cd backend
python -m venv .venv
# Windows:
.venv\Scripts\activate
# macOS/Linux:
source .venv/bin/activate

pip install -r requirements.txt
alembic upgrade head
```

### 5. Seed demo data (optional)

```bash
python scripts/seed.py
```

### 6. Start the backend

```bash
uvicorn app.main:app --reload --port 8000
```

API docs: http://localhost:8000/docs

### 7. Install frontend dependencies

```bash
cd frontend
npm install
```

### 8. Start the frontend

```bash
npm run dev
```

App: http://localhost:5173

---

## API Endpoints

| Method | Endpoint | Description |
|---|---|---|
| POST | `/api/auth/register` | Register new user |
| POST | `/api/auth/login` | Login, returns JWT |
| GET | `/api/auth/me` | Current user info |
| GET | `/api/projects` | List all projects |
| POST | `/api/projects` | Create project |
| GET | `/api/projects/{id}` | Get project |
| PUT | `/api/projects/{id}` | Update project |
| DELETE | `/api/projects/{id}` | Delete project |
| GET | `/api/projects/{id}/sites` | List sites for project |
| POST | `/api/projects/{id}/sites` | Add site (with polygon) |
| GET | `/api/sites/{id}` | Get site |
| PUT | `/api/sites/{id}` | Update site |
| DELETE | `/api/sites/{id}` | Delete site |
| GET | `/api/sites/{id}/analytics` | Historical metrics |
| POST | `/api/sites/{id}/analytics` | Add metric record |
| GET | `/api/health` | Service health check |

---

## Code Quality

```bash
# Frontend
cd frontend
npm run lint          # ESLint
npm run format:check  # Prettier check
npm run format        # Prettier fix

# Backend
cd backend
ruff check .          # Lint
ruff format .         # Format
pytest -v             # Tests
```

---

## CI/CD

GitHub Actions runs on every push and pull request to `main` / `develop`:

1. **Frontend job** — `npm ci` → ESLint → Prettier check → `npm run build`
2. **Backend job** — `pip install` → `ruff check` → `ruff format --check` → `pytest`

---

## Deployment

| Layer | Platform | Notes |
|---|---|---|
| Frontend | Vercel | Set `VITE_API_URL` and `VITE_MAPBOX_TOKEN` in project settings |
| Backend | Render | Set all backend env vars; use Render's managed PostgreSQL |
| Database | Render / Neon / Supabase | Enable PostGIS extension |

---

## Demo Credentials

After running `python scripts/seed.py`:

| Field | Value |
|---|---|
| Email | `demo@darukaa.earth` |
| Password | `demo1234` |

> ⚠️ Demo data is synthetic and clearly labelled as such. It is not real environmental data.

---

## Project Structure

```
darukaa-earth/
├── frontend/
│   ├── src/
│   │   ├── components/     # Shared UI components
│   │   ├── context/        # React context (Auth)
│   │   ├── pages/          # Route-level page components
│   │   ├── services/       # Axios API service layer
│   │   ├── styles/         # Global CSS + design tokens
│   │   └── types/          # Shared TypeScript types
│   ├── .eslintrc.cjs
│   ├── .prettierrc
│   ├── vite.config.ts
│   └── package.json
│
├── backend/
│   ├── app/
│   │   ├── api/            # FastAPI routers
│   │   ├── core/           # Config + security utilities
│   │   ├── database/       # SQLAlchemy session + Base
│   │   ├── models/         # ORM models (PostGIS geometry)
│   │   ├── schemas/        # Pydantic request/response schemas
│   │   ├── services/       # Business logic layer
│   │   └── repositories/   # Data access layer
│   ├── alembic/            # Database migrations
│   ├── tests/              # Pytest test suite
│   ├── scripts/            # seed.py
│   ├── requirements.txt
│   └── pyproject.toml      # Ruff config
│
├── .github/workflows/ci.yml
├── .husky/pre-commit
├── package.json            # Root — Husky + lint-staged only
└── README.md
```
