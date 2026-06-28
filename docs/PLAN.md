# Job-Forge Web Application - Project Plan

## Executive Summary

Transform the current Claude Code-based job application workflow into a modern, database-backed web application with:

- **Single-page React frontend** (TypeScript, Tailwind, Redux)
- **FastAPI backend** (Python async, learning-focused stack)
- **MongoDB database** (user data, resumes, applications)
- **Direct LLM integration** (Claude API, with abstraction for future providers)
- **Cloud file storage** (AWS S3 for signatures and PDFs)
- **Docker containerization** (hot-reload dev environment + backend deployment)

**Goal**: Replace `/new` slash command workflow with intuitive web UI while maintaining LLM-powered resume tailoring and cover letter generation.

---

## Architecture Overview

```
┌─────────────────────────────────────────────────────────────┐
│                      USER INTERFACE                         │
│  React + TypeScript + Tailwind + Redux                     │
│  - Manage personal info & signature                         │
│  - Two-pane resume editor (drag-drop bullets + live PDF)    │
│  - Generate job applications (form → LLM → review)          │
│  - View/download PDFs                                       │
└─────────────────────────────────────────────────────────────┘
                              ▼
               Hybrid API (REST + GraphQL via FastAPI)
                              ▼
┌─────────────────────────────────────────────────────────────┐
│                     BACKEND SERVICES                        │
│  FastAPI + Motor + Beanie (async MongoDB ODM)               │
│                                                             │
│  ┌───────────┐ ┌──────────────┐ ┌─────────────┐ ┌────────┐│
│  │ LLM API   │ │ LaTeX Parser │ │ LaTeX       │ │ S3     ││
│  │ Claude/   │ │ .tex → JSON  │ │ Renderer    │ │ Client ││
│  │ OpenAI    │ │ (regex)      │ │ JSON → .tex │ │        ││
│  │ (JSON I/O)│ │              │ │ (Jinja2)    │ │        ││
│  └───────────┘ └──────────────┘ └─────────────┘ └────────┘│
│                                       ▼                      │
│                                 ┌──────────────┐            │
│                                 │ PDF Compiler │            │
│                                 │  (xelatex)   │            │
│                                 └──────────────┘            │
└─────────────────────────────────────────────────────────────┘
        ▼                    ▼                     ▼
┌──────────────┐   ┌──────────────────┐   ┌─────────────────┐
│   MongoDB    │   │  Global Prompts  │   │  AWS S3 Bucket  │
│   Atlas      │   │  (filesystem)    │   │  /{userId}/...  │
│  - users     │   │  - resume-custom │   │  - signatures/  │
│  - personal  │   │  - cover-letter  │   │  - pdfs/        │
│  - variants  │   │  - job-helper.md │   └─────────────────┘
│    (JSON)    │   │                  │
│  - templates │   └──────────────────┘
│  - apps      │
└──────────────┘
```

---

## Key Design Decisions

### 1. **Data Storage Strategy**

| Data Type | Storage Location | Rationale |
|-----------|-----------------|-----------|
| User-specific data (personal info, resume variants, applications) | **MongoDB Atlas** | Dynamic, user-scoped, easy to query |
| Global prompts (resume-customization.md, etc.) | **Files** (`/apps/api/prompts/`) | Shared across users, version-controlled |
| Binary files (signatures, PDFs) | **AWS S3** | Scalable, CDN-ready, per-user isolation |
| **Resume structure** | **MongoDB Atlas** (as JSON) | Drag-drop bullets, LLM-friendly, multi-format export |
| **LaTeX artifacts** | **MongoDB Atlas** (generated from structure) | Cached, regenerated on content changes |

### 2. **Resume Variant Management: Structured Data Approach**

**Chosen approach**: Store structured data (JSON) as source of truth, render to LaTeX via Jinja2 templates, edit via two-pane UI.

**Why structured data?**
- ✅ **Two-pane UI requirement**: Left pane needs drag-drop bullets (requires array structure)
- ✅ **Real-time preview**: Structure → LaTeX → PDF pipeline on every edit (500ms debounce)
- ✅ **LLM-friendly**: Cleaner prompts (JSON in, JSON out), safer validation
- ✅ **Future features**: Multi-format export (Markdown, DOCX), analytics, template swapping
- ✅ **User-friendly**: Inline text editing, drag-drop reordering, no LaTeX knowledge required

**Trade-offs accepted**:
- ❌ 1-2 weeks upfront to build parser + Jinja2 templates
- ❌ Some LaTeX → JSON parsing complexity (90% automated, 10% manual review)
- ✅ **But**: Results in much better product for two-pane editor UI

**Two-Pane Editor Design**:
```
┌──────────────────────────────┬──────────────────────────────┐
│  LEFT: Structured Editor     │  RIGHT: Live PDF Preview     │
├──────────────────────────────┼──────────────────────────────┤
│ Professional Summary         │  ┌────────────────────────┐  │
│ ┌──────────────────────────┐ │  │                        │  │
│ │ [editable textarea]      │ │  │   YOUR NAME            │  │
│ └──────────────────────────┘ │  │   Professional Summary │  │
│                              │  │                        │  │
│ Experience                   │  │   Employment History   │  │
│ ┌──────────────────────────┐ │  │   • Bullet 1           │  │
│ │ ⋮ Drag to reorder        │ │  │   • Bullet 2           │  │
│ │ • [edit] Bullet text 1   │ │  │   • Bullet 3           │  │
│ │ • [edit] Bullet text 2   │ │  │                        │  │
│ │ [+ Add bullet]           │ │  │   Education            │  │
│ └──────────────────────────┘ │  │   ...                  │  │
│                              │  └────────────────────────┘  │
│ [Saving... / Saved ✓]       │  Auto-updates (500ms delay)  │
└──────────────────────────────┴──────────────────────────────┘
```

### 3. **LLM Integration: Provider Abstraction**

**Architecture**:
```python
# base.py
class LLMProvider(ABC):
    @abstractmethod
    async def generate(self, system: str, user: str, **kwargs) -> str:
        pass

# claude.py
class ClaudeProvider(LLMProvider):
    async def generate(self, system: str, user: str, **kwargs) -> str:
        # Call Anthropic API
        pass

# factory.py
def get_llm_provider(provider: str = "claude") -> LLMProvider:
    if provider == "claude":
        return ClaudeProvider()
    elif provider == "openai":
        return OpenAIProvider()  # Future
```

**Benefits**:
- Easy to swap providers (env var: `LLM_PROVIDER=openai`)
- Can add cost tracking per provider
- Future: User-selectable provider (Claude vs GPT-4 per request)

### 4. **API Design: Hybrid REST + GraphQL**

**Chosen**: **Hybrid approach** - REST for simple operations, GraphQL for complex UI

**REST Endpoints** (FastAPI routes):
- Auth (login, logout, register) - Phase 2
- File uploads (signature PNG) - multipart/form-data
- Admin operations (migration script)
- Health checks
- Personal info CRUD

**GraphQL** (Strawberry GraphQL):
- Resume editing (queries + mutations)
- Application creation
- Cover letter generation
- Complex queries with precise data fetching

**Why Hybrid?**
- ✅ **Resume value**: Learn GraphQL (modern, in-demand skill)
- ✅ **Best tool for each job**: REST for file uploads (native multipart), GraphQL for complex UI
- ✅ **Faster MVP**: Don't fight with graphql-upload, use FastAPI's UploadFile
- ✅ **Industry standard**: Shopify, GitHub, Stripe all use hybrid approach
- ✅ **Two-pane editor benefits**: Optimistic mutations, auto-generated TS types, efficient queries

### 5. **Structured Editing UI**

**Chosen**: Two-pane layout with react-beautiful-dnd for drag-drop

**Component Strategy**: Compose simple, focused components
- Professional Summary → Native `<textarea>`
- Job Fields (Company, Title, Dates, Location) → Native `<input>` elements
- **Bullets → react-beautiful-dnd** for drag-drop + native `<input>` for editing text
- Education → Same as Job Fields
- Skills → Native `<textarea>` (comma-separated) for MVP

**Key Libraries**:
```bash
npm install react-beautiful-dnd @types/react-beautiful-dnd
npm install lodash.debounce
npm install react-pdf  # or use iframe for PDF preview
```

**Why this approach?**
- Drag-drop bullets requires structured data (arrays)
- react-beautiful-dnd handles mobile, accessibility, animations out-of-box
- Native HTML inputs for everything else (simple, fast, no dependencies)
- Live preview requires fast Structure → LaTeX → PDF pipeline
- No LaTeX knowledge required for users

---

## Phase 1: MVP Milestones (10 Weeks)

### Week 1: Infrastructure
- [ ] Docker Compose with 4 containers (frontend, backend, MongoDB, Mongo Express)
- [ ] Hot-reload for frontend (Vite HMR) and backend (FastAPI `--reload`)
- [ ] Basic "Hello World" endpoints + UI

### Week 1-2: Database & Models (Structured Data)
- [ ] Define MongoDB collections with structured resume schema
  - `resume_variants` with `content` (JSON), `latex_source` (generated), `template_id`
  - `latex_templates` collection
  - `applications`, `personal_info`, `users`, `llm_conversations`
- [ ] Create Beanie Document models + Pydantic schemas
- [ ] Setup indexes and constraints

### Week 2: Personal Info Management
- [ ] Backend: CRUD endpoints for personal info
- [ ] Backend: S3 integration (signed URLs for signature upload)
- [ ] Frontend: Personal info form + signature upload

### Week 3-4: LaTeX Parser & Template Engine
- [ ] Backend: Build LaTeX → JSON parser (regex-based)
  - Extract bullets, jobs, education, summary
  - Clean LaTeX formatting (`\textbf{}` → `**text**`)
  - Test on all existing `.tex` files (90%+ success rate)
- [ ] Backend: Build Jinja2 template engine (JSON → LaTeX)
  - Convert `resumes/sample/resume.tex` to Jinja2 template
  - Escape/unescape filters (`**text**` ↔ `\textbf{text}`)
- [ ] Backend: LaTeX → PDF compilation (xelatex subprocess)
- [ ] Test round-trip: LaTeX → Parse → Render → Should match

### Week 4: Global Prompts System
- [ ] Copy `.claude/prompts/*.md` → `/apps/api/prompts/`
- [ ] Backend: `PromptLoader` utility (loads and caches prompts)
- [ ] Frontend: Read-only prompts viewer

### Week 5-6: Two-Pane Resume Editor
- [ ] Backend: Resume variant API (CRUD with structured content)
  - `PUT /api/resume-variants/:id/content` - Save + regenerate LaTeX
  - `POST /api/resume-variants/:id/preview` - Generate PDF (no S3 upload)
- [ ] Frontend: Two-column layout (structured editor + PDF preview)
  - Left pane: Summary textarea, drag-drop bullets, inline editing
  - Right pane: PDF viewer (iframe or react-pdf)
  - Auto-save with 500ms debounce
  - Loading states, error handling
- [ ] Frontend: Variants list (table/cards with Edit/Delete/Download)

### Week 7: Migration Script
- [ ] Parse all existing `.tex` files to structured JSON
- [ ] Import to database with generated LaTeX
- [ ] Upload PDFs to S3
- [ ] Migrate personal info and signature
- [ ] Handle parse failures (manual review list)

### Week 8: LLM Integration (Structured Data)
- [ ] Backend: Abstract `LLMProvider` interface (returns JSON)
- [ ] Backend: `ClaudeProvider` implementation
- [ ] Backend: `PromptBuilder` for structured data (JSON → LLM → JSON)
- [ ] Test endpoint: Send resume JSON, get tailored JSON

### Week 9-10: Application Creation Workflow
- [ ] Backend: `POST /api/applications` (structured data pipeline)
  - Load resume variant (JSON)
  - Call LLM to tailor (JSON → JSON)
  - Render to LaTeX, compile to PDF
  - Generate cover letter (text-based)
- [ ] Frontend: Application form (company, JD, variant selector)
- [ ] Frontend: Review/approve step
- [ ] Frontend: Applications list + detail views
- [ ] Cover letter feedback loop (regenerate with user feedback)

**Deliverable**: Production-ready single-user web app with two-pane editor

---

## Phase 2: Multi-User (Weeks 9-12)

### Week 9-10: Authentication
- [ ] JWT-based auth (register, login, logout, refresh tokens)
- [ ] Password hashing (bcrypt via `passlib`)
- [ ] Protected routes (middleware: `get_current_user()`)
- [ ] Frontend: Login/register pages, token storage, auto-refresh

### Week 11: User Isolation
- [ ] Enforce `user_id` filtering on all endpoints
- [ ] Integration tests for data isolation
- [ ] S3 bucket policies (per-user folders)

### Week 12: User Settings
- [ ] Custom prompt overrides (per-user, stored in DB)
- [ ] Editable job-helper context (skills, experience)
- [ ] User preferences (default variant, auto-generate cover letters)
- [ ] Export data (download all applications as ZIP)

**Deliverable**: Secure multi-tenant SaaS

---

## Phase 3: Advanced Features (Future)

- [ ] **Analytics**: Track application status, success rates, keyword trends
- [ ] **Job scraping**: Browser extension to auto-fill JDs from LinkedIn/Indeed
- [ ] **Structured editing**: Parse LaTeX → JSON → WYSIWYG editor
- [ ] **Alternative formats**: Export as Markdown, HTML, DOCX
- [ ] **Collaboration**: Share applications, comments, version history
- [ ] **OpenAI provider**: Add GPT-4 support alongside Claude
- [ ] **Email integration**: Send applications via email, track opens

---

## Technology Stack Reference

### Frontend
| Purpose | Technology | Why |
|---------|-----------|-----|
| Framework | React 18 + TypeScript | Type safety, modern hooks, large ecosystem |
| Build tool | Vite | Fast HMR, modern bundler, simpler than Webpack |
| Styling | Tailwind CSS | Utility-first, fast prototyping, responsive design |
| State management | Redux Toolkit | Scalable state, DevTools, familiar from your experience |
| Drag & Drop | react-beautiful-dnd | Smooth animations, accessible, mobile-friendly |
| Forms | React Hook Form + Zod | Performance, type-safe validation |
| PDF Viewer | iframe or react-pdf | Simple embedding, works with blob URLs |
| HTTP client | Axios | Familiar, interceptors for auth |

### Backend
| Purpose | Technology | Why |
|---------|-----------|-----|
| Framework | FastAPI | Modern, async, auto-docs, easy to learn Python with |
| Database | MongoDB + Motor + Beanie | Async, familiar (Mongoose-like), flexible schema |
| Validation | Pydantic | Type-safe models, auto-validation, integrates with FastAPI |
| Template engine | Jinja2 | Structured data → LaTeX rendering, custom filters |
| LaTeX parser | Custom regex module | Parse `.tex` → JSON for migration |
| LLM client | `anthropic` Python SDK | Official Claude API client |
| File storage | `boto3` (AWS S3) | Cloud-native, scalable, industry standard |
| PDF generation | XeLaTeX (subprocess) | Same as current system, Calibri font support |

### Infrastructure
| Purpose | Technology | Why |
|---------|-----------|-----|
| Development | Docker + Docker Compose | Reproducible local environment, hot-reload |
| Frontend hosting | Vercel | Free tier, auto-SSL, global CDN, zero config |
| Backend hosting | Fly.io | Docker-based, auto-SSL, simple deployment |
| Database | MongoDB Atlas | Managed, free tier (M0), auto-backups |
| Dev tools | Mongo Express | Web UI for MongoDB (local dev only) |

---

## Development Workflow

### Local Development
```bash
# Start all services (Docker Compose)
docker-compose up

# Services running locally:
# - Frontend: http://localhost:5173 (Vite dev server with HMR)
# - Backend: http://localhost:8000 (FastAPI with auto-reload)
# - MongoDB: mongodb://localhost:27017 (local instance)
# - Mongo Express: http://localhost:8081 (DB browser UI)

# Hot-reload enabled for rapid development:
# - Edit /apps/web/src/*.tsx → Browser auto-refreshes
# - Edit /apps/api/app/*.py → FastAPI auto-reloads
```

### Production Deployment (Cloud-Native)

**Architecture**: Managed services, no servers to maintain, auto-scaling

**Frontend (Vercel)**:
```bash
cd frontend
npm run build
vercel deploy --prod
# Result: https://job-forge.vercel.app (auto-SSL, global CDN)
```

**Backend (Fly.io)**:
```bash
cd backend
fly launch              # Creates Dockerfile and fly.toml
fly deploy              # Pushes Docker image, deploys container
fly secrets set MONGODB_URL=... ANTHROPIC_API_KEY=... S3_BUCKET=...
# Result: https://job-forge-api.fly.dev (auto-SSL, auto-scaling)
```

**Database (MongoDB Atlas)**:
- Sign up at [mongodb.com/atlas](https://mongodb.com/atlas)
- Create M0 free tier cluster (512 MB, sufficient for MVP)
- Whitelist Fly.io IPs or use `0.0.0.0/0` (with strong password)
- Get connection string: `mongodb+srv://<user>:<pass>@cluster.mongodb.net/job-forge`

**Storage (AWS S3)**:
- Create S3 bucket via AWS Console
- Configure CORS for frontend uploads
- Set bucket policy (private, signed URLs only)
- Create IAM user with S3 access, get API keys

**CORS Configuration** (required for separate frontend/backend domains):
```python
# apps/api/app/main.py
from fastapi.middleware.cors import CORSMiddleware

app.add_middleware(
    CORSMiddleware,
    allow_origins=[
        "http://localhost:5173",           # Local dev
        "https://job-forge.vercel.app",    # Production
    ],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)
```

**Custom Domains** (optional):
```
https://job-forge.com        → Vercel (configure in Vercel dashboard)
https://api.job-forge.com    → Fly.io (configure DNS CNAME)
```

**Cost Breakdown**:
- Vercel (Frontend): **Free** (100 GB bandwidth/month)
- Fly.io (Backend): **~$5-10/month** (1 shared vCPU, 256 MB RAM)
- MongoDB Atlas: **Free** (M0 tier) or **$9/month** (M2 if you need more)
- AWS S3: **~$1-5/month** (storage + requests)
- **Total**: **~$6-24/month** (no server maintenance, auto-scaling included)

**Why Cloud-Native (No Nginx/VPS)?**
- ✅ **No server maintenance**: No OS updates, security patches, or SSH access
- ✅ **Auto-SSL**: Vercel and Fly.io handle certificates automatically
- ✅ **Auto-scaling**: Fly.io scales based on traffic (pay per use)
- ✅ **Global CDN**: Vercel serves frontend from edge locations worldwide
- ✅ **Zero downtime deploys**: Both platforms support rolling updates
- ✅ **Simpler stack**: No Nginx config, no Let's Encrypt setup
- ✅ **Resume-worthy skills**: Modern cloud-native deployment patterns

---

## Success Criteria

### MVP Success (Phase 1)
- ✅ Create 10+ applications using web UI
- ✅ All existing data migrated from files
- ✅ LaTeX compilation 100% success rate
- ✅ LLM-generated cover letters require ≤2 iterations
- ✅ No critical bugs for 2 weeks

### Post-MVP Success (Phase 2+)
- ✅ Support 10+ concurrent users
- ✅ Zero security incidents (auth, data isolation)
- ✅ 90% uptime SLA
- ✅ API response time <500ms (p95)

---

## Open Questions & Next Actions

### Decisions Made
1. ✅ **Deployment strategy**: Cloud-native (Vercel + Fly.io + MongoDB Atlas + S3)
2. ✅ **S3 vs Google Cloud Storage**: AWS S3 (industry standard, better ecosystem)
3. ✅ **No Nginx required**: Managed platforms handle SSL and routing
4. ✅ **Redis for caching**: Skip for MVP, add in Phase 2 if needed
5. ✅ **Testing strategy**: Integration tests (pytest) + E2E for critical flows (Playwright)

### Immediate Next Steps
1. ✅ Create ROADMAP.md (detailed milestones) → **Done**
2. ✅ Create PLAN.md (this document) → **Done**
3. ⏭️ **Next**: Initialize project structure (Milestone 1.1)
   - Create `/apps/web`, `/apps/api`, `/docker` directories
   - Create `docker-compose.yml`
   - Initialize Vite + React app
   - Initialize FastAPI app
   - Get "Hello World" running in Docker

---

## Tradeoffs Discussion Summary

### Resume Variants: Why Structured Data?

| Approach | Pros | Cons | Verdict |
|----------|------|------|---------|
| Full LaTeX in DB | Easy migration, max flexibility, LLM handles LaTeX | Requires LaTeX knowledge, **no drag-drop bullets** | ❌ Doesn't support two-pane UI |
| **Structured JSON → LaTeX** | **Drag-drop bullets**, user-friendly, LLM-friendly (JSON), multi-format export | 1-2 weeks parser work, 90% auto-migration | ✅ **Chosen** (required for two-pane editor) |
| Hybrid (both) | Migration path, flexibility | Complexity, sync issues, duplication | ❌ Over-engineered for MVP |

**Decision Driver**: Your two-pane UI design **requires** structured data (arrays for drag-drop bullets). This made the choice clear.

### REST vs GraphQL?

| Approach | Pros | Cons | Verdict |
|----------|------|------|---------|
| **REST API** | Simple, FastAPI auto-docs, familiar | Some over-fetching | ✅ **Chosen for MVP** |
| GraphQL | Precise queries, great for complex UIs | Steeper learning curve, more setup | 🔄 Future if needed |

### Structured Editor UI?

| Option | Pros | Cons | Verdict |
|--------|------|------|---------|
| **Two-pane (structured + PDF preview)** | User-friendly, drag-drop, real-time feedback | Requires parser + renderer | ✅ **Chosen** (your UI design) |
| LaTeX editor (CodeMirror/Monaco) | Flexible, no parsing needed | Requires LaTeX knowledge, no drag-drop | ❌ Doesn't match UI vision |
| Form-based only (no PDF preview) | Simplest implementation | Poor UX (no live preview) | ❌ Not optimal |

---

**Ready to start building!** 🚀

See [ROADMAP.md](ROADMAP.md) for detailed week-by-week milestones.

_Last updated: 2026-06-27_
