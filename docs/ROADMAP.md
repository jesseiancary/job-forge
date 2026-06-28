# Job-Forge Web Application Roadmap

## Project Vision

Transform the Claude Code-based job application workflow into a modern web application with database-backed storage, direct LLM integration, and cloud-based file management. Start with single-user MVP, evolve to multi-tenant SaaS.

---

## Technology Stack

### Frontend
- **Framework**: React 18 + TypeScript
- **Build Tool**: Vite
- **Styling**: Tailwind CSS
- **State Management**: Redux Toolkit
- **API Clients**:
  - **Apollo Client** (GraphQL queries/mutations for resume editor)
  - **Axios** (REST endpoints for auth, file uploads)
- **Drag & Drop**: react-beautiful-dnd (bullet reordering)
- **PDF Viewer**: react-pdf or iframe (live preview pane)
- **Form Handling**: React Hook Form + Zod validation
- **Debouncing**: lodash.debounce (auto-save on edit)

### Backend
- **Framework**: FastAPI (Python async web framework)
- **API**: Hybrid REST + GraphQL
  - REST routes for simple operations (auth, file uploads, admin)
  - **Strawberry GraphQL** for complex UI (resume editing, applications)
- **Database**: MongoDB Atlas (managed) with Motor (async driver) + Beanie (ODM)
- **Validation**: Pydantic (data models, request/response validation)
- **LLM Integration**: Anthropic Claude API (with provider abstraction for future OpenAI support)
- **PDF Generation**: XeLaTeX (subprocess)
- **Template Engine**: Jinja2 (structured data → LaTeX rendering)
- **LaTeX Parser**: Custom regex-based parser (LaTeX → structured data)
- **File Storage**: AWS S3
- **Hosting**: Fly.io (Docker-based deployment with auto-SSL)

### Infrastructure
- **Development**: Docker Compose (local dev: frontend, backend, MongoDB, Mongo Express)
- **Production Hosting**:
  - Frontend: **Vercel** (free tier, auto-SSL, global CDN)
  - Backend: **Fly.io** (Docker deployment, auto-SSL, auto-scaling)
  - Database: **MongoDB Atlas** (M0 free tier or M2 $9/month)
  - Storage: **AWS S3** (object storage for signatures and PDFs)
- **Database UI**: Mongo Express (local dev only)

---

## Architecture Decisions

### Data Storage Strategy
- **User-specific data** → MongoDB Atlas (personal info, resume variants, applications, custom prompts)
- **Global/shared data** → Files in `/apps/api/prompts` directory (resume-customization.md, cover-letter-generation.md, etc.)
- **Resume structure** → MongoDB Atlas (structured JSON: bullets, jobs, summary)
- **LaTeX artifacts** → MongoDB Atlas (generated from structure + template, cached)
- **Binary files** → AWS S3 buckets (organized per user: `/{userId}/signatures/`, `/{userId}/pdfs/`)

### LLM Integration Architecture
- **Provider abstraction layer**: `LLMProvider` interface → `ClaudeProvider`, `OpenAIProvider` (future)
- **Prompt construction**: Read global prompt files + user-specific context from DB
- **Context pipeline**: Personal info + structured resume data (JSON) + job description + global guidelines → system prompt
- **LLM operates on structure**: LLM receives/returns JSON, not LaTeX (cleaner prompts, safer validation)

### Resume Variant Management (Structured Data Approach)
- **Source of truth**: Structured data (JSON) stored in MongoDB
  - Professional summary (string)
  - Experience (array of jobs → array of bullets per job)
  - Education (array)
  - Skills (array)
- **Editing**: Two-pane UI (left: structured editor, right: live PDF preview)
  - Left pane: Drag-drop bullets, inline text editing, add/delete bullets
  - Right pane: Auto-updating PDF preview (debounced 500ms)
- **Rendering pipeline**: Structured data → Jinja2 template → LaTeX → xelatex → PDF
- **LLM modifications**: LLM modifies JSON structure (reorders bullets, updates text)
- **LaTeX templates**: Stored separately, users can swap templates without losing content

### API Design (Hybrid REST + GraphQL)
- **Pattern**: Hybrid approach - REST for simple operations, GraphQL for complex UI
  - **REST**: Auth, file uploads, admin operations, health checks (FastAPI routes)
  - **GraphQL**: Resume editing, applications, complex queries (Strawberry GraphQL)
- **Documentation**:
  - REST: Auto-generated OpenAPI/Swagger docs (FastAPI built-in)
  - GraphQL: Auto-generated schema documentation (GraphQL Playground)
- **Validation**: Pydantic models for both REST and GraphQL
- **Error handling**: Standardized error responses with HTTP status codes
- **Type Safety**: Auto-generated TypeScript types from GraphQL schema

---

## Phase 1: MVP (Single-User, Core Functionality)

### Milestone 1.1: Project Setup & Infrastructure (Week 1)
**Goal**: Get development environment running with hot-reload

- [ ] Initialize monorepo structure (`/apps/web`, `/apps/api`, `/docker`)
- [ ] Create `docker-compose.yml` with 4 services:
  - Frontend (Vite dev server, port 5173)
  - Backend (FastAPI with auto-reload, port 8000)
  - MongoDB (port 27017)
  - Mongo Express (port 8081, dev only)
- [ ] Frontend: Initialize Vite + React + TypeScript + Tailwind + Redux Toolkit
- [ ] Backend: Initialize FastAPI + Motor + Beanie + Pydantic
- [ ] Configure volume mounts for hot-reload (apps/web `/src`, apps/api `/app`)
- [ ] Setup environment variables (`.env` files for local dev)
- [ ] Create basic "Hello World" endpoints and UI
- [ ] Verify hot-reload works for both frontend and backend

**Deliverable**: `docker-compose up` starts all services with working hot-reload

---

### Milestone 1.2: Database Models & Schemas (Week 1-2)
**Goal**: Define MongoDB collections and Pydantic schemas for structured resume data

#### Collections
1. **`users`** (future-proofing for multi-user)
   ```python
   {
     _id: ObjectId,
     email: str,
     full_name: str,
     created_at: datetime,
     updated_at: datetime
   }
   ```

2. **`personal_info`** (one per user)
   ```python
   {
     _id: ObjectId,
     user_id: ObjectId,
     name: str,
     title: str,
     city: str,
     state: str,
     phone: str,
     email: str,
     linkedin_url: str,
     github_url: str,
     signature_s3_key: str,  # S3 path to signature.png
     updated_at: datetime
   }
   ```

3. **`resume_variants`** (structured data as source of truth)
   ```python
   {
     _id: ObjectId,
     user_id: ObjectId,
     name: str,  # "full-stack-fintech", "backend-healthtech"
     description: str,  # "FinTech/Payment resume for backend roles"

     # STRUCTURED CONTENT (Source of Truth)
     content: {
       professional_summary: str,
       experience: [
         {
           company: str,
           title: str,
           dates: str,
           location: str,
           bullets: [str]  # Array of bullet points (drag-drop reorderable)
         }
       ],
       education: [
         {
           school: str,
           degree: str,
           graduation_date: str,
           location: str,
           description: str
         }
       ],
       skills: [str]  # Array of skills/technologies
     },

     # GENERATED ARTIFACTS (Cached, regenerated from content)
     latex_source: str,  # Generated via Jinja2 template
     pdf_s3_key: Optional[str],  # Last compiled PDF

     # TEMPLATE REFERENCE
     template_id: ObjectId,  # Which LaTeX template to use for rendering

     created_at: datetime,
     updated_at: datetime,
     last_compiled_at: Optional[datetime]
   }
   ```

4. **`latex_templates`** (LaTeX templates with Jinja2 placeholders)
   ```python
   {
     _id: ObjectId,
     name: str,  # "modern-two-column", "classic-serif"
     description: str,
     template_source: str,  # LaTeX with {{ content.professional_summary }} etc.
     is_default: bool,
     created_at: datetime,
     updated_at: datetime
   }
   ```

5. **`applications`**
   ```python
   {
     _id: ObjectId,
     user_id: ObjectId,
     company_name: str,
     company_slug: str,  # "tech-corp"
     job_title: str,
     job_description: str,  # Full JD text
     resume_variant_id: ObjectId,  # Which variant was used

     # Tailored resume (structured data, modified by LLM)
     resume_content: {
       # Same structure as resume_variants.content
       # LLM reorders bullets, updates text based on JD
     },
     resume_latex: str,  # Generated from resume_content
     resume_pdf_s3_key: str,  # S3 path to generated PDF

     # Cover letter
     cover_letter_latex: str,  # Generated cover letter .tex
     cover_letter_pdf_s3_key: str,  # S3 path
     cover_letter_approved: bool,

     status: str,  # "draft", "ready", "applied"
     created_at: datetime,
     updated_at: datetime
   }
   ```

6. **`llm_conversations`** (for cover letter feedback loop)
   ```python
   {
     _id: ObjectId,
     application_id: ObjectId,
     user_id: ObjectId,
     messages: [
       {
         role: str,  # "user" | "assistant" | "system"
         content: str,
         timestamp: datetime
       }
     ],
     created_at: datetime,
     updated_at: datetime
   }
   ```

- [ ] Create Beanie Document models for all collections
- [ ] Create Pydantic schemas for API requests/responses
- [ ] Setup database initialization script (indexes, constraints)

**Deliverable**: Database models defined, API can create/read documents

---

### Milestone 1.3: Personal Info Management (Week 2)
**Goal**: Users can edit personal info and upload signature

**API Type**: REST (simple CRUD + multipart file upload)

#### Backend Tasks (REST Endpoints)
- [ ] `POST /api/personal-info` - Create/update personal info
- [ ] `GET /api/personal-info` - Retrieve current user's info
- [ ] `POST /api/personal-info/signature` - Upload signature PNG (multipart/form-data)
  - Use FastAPI's `UploadFile` for multipart handling
  - Upload to S3 directly from backend
  - Update `signature_s3_key` in DB
  - Return S3 URL
- [ ] `GET /api/personal-info/signature` - Get signed download URL
- [ ] `DELETE /api/personal-info/signature` - Delete signature from S3

#### Frontend Tasks (using Axios for REST)
- [ ] Create `PersonalInfoForm` component (React Hook Form + Zod)
- [ ] Fields: name, title, city, state, phone, email, LinkedIn, GitHub
- [ ] Signature upload with preview (drag-drop or file picker)
  - Use `FormData` for multipart upload
  - Axios POST to `/api/personal-info/signature`
- [ ] Display current signature if exists
- [ ] Save button → dispatch Redux action → Axios call

#### S3 Setup
- [ ] Create S3 bucket (or GCS bucket)
- [ ] Setup bucket policy (private, signed URLs only)
- [ ] Configure CORS for client-side uploads
- [ ] Environment variables for bucket name, region, credentials

**Deliverable**: User can edit personal info and upload signature via web UI

---

### Milestone 1.4: LaTeX Parser & Template Engine (Week 3-4)
**Goal**: Build parser to convert existing .tex files to structured data, and renderer to convert back

#### Backend Tasks: LaTeX Parser
- [ ] Create `parsers/latex_parser.py` module:
  - [ ] `parse_resume(latex_source: str) -> ResumeContent`
  - [ ] Extract professional summary (regex: `\\begin{entryrow}{\\bfseries\\large Professional Summary}...`)
  - [ ] Extract experience sections (regex: `\\jobmeta{...}` + bullets)
  - [ ] Extract bullets from `\item` tags within `\begin{resumeitems}...\end{resumeitems}`
  - [ ] Extract education sections (regex: `\\edumeta{...}`)
  - [ ] Extract skills section
  - [ ] `clean_latex(text: str) -> str` - Convert LaTeX formatting to Markdown
    - `\textbf{MongoDB}` → `**MongoDB**`
    - `\textit{text}` → `*text*`
    - `\$` → `$`, `\%` → `%`, `$\sim$` → `~`
  - [ ] Handle multi-line bullets (remove line breaks within items)
  - [ ] Error handling (log parse errors, allow partial parsing)
- [ ] Test parser on all existing `.tex` files in `resumes/*/resume.tex`
- [ ] Aim for 90%+ success rate, log failures for manual review

#### Backend Tasks: LaTeX Renderer (Jinja2 Templates)
- [ ] Create `templates/` directory for LaTeX templates
- [ ] Convert existing `resumes/sample/resume.tex` to Jinja2 template:
  - [ ] Replace hardcoded professional summary with `{{ content.professional_summary }}`
  - [ ] Replace experience sections with `{% for job in content.experience %}` loops
  - [ ] Replace bullet lists with `{% for bullet in job.bullets %}` loops
  - [ ] Replace education with `{% for edu in content.education %}` loops
  - [ ] Replace skills with `{% for skill in content.skills %}` loops
- [ ] Create `renderers/latex_renderer.py`:
  - [ ] `render_latex(content: ResumeContent, template_id: ObjectId) -> str`
  - [ ] Load Jinja2 template from database
  - [ ] Render template with content dict
  - [ ] Custom Jinja2 filter: `escape_latex(text: str)` - Convert Markdown back to LaTeX
    - `**text**` → `\textbf{text}`
    - `*text*` → `\textit{text}`
    - `$` → `\$`, `%` → `\%`, `&` → `\&`
  - [ ] Return rendered LaTeX string
- [ ] Test round-trip: Original LaTeX → Parse → Render → Should closely match original

#### Backend Tasks: LaTeX Compilation
- [ ] Install XeLaTeX + Calibri font in backend Docker image
- [ ] Create `services/pdf_compiler.py`:
  - [ ] `compile_latex(latex_source: str) -> bytes`
  - [ ] Write `.tex` to temp file (use `tempfile` module)
  - [ ] Run `xelatex` subprocess with timeout (60s max)
  - [ ] Read output PDF as bytes
  - [ ] Clean up temp files (`.tex`, `.aux`, `.log`, `.pdf`)
  - [ ] Handle compilation errors (parse xelatex log, return error message)
  - [ ] Return PDF bytes or raise exception

#### Backend Tasks: Template Management
- [ ] Create `LaTeXTemplate` Beanie model (from schema in Milestone 1.2)
- [ ] Seed database with default template (converted from `resumes/sample/resume.tex`)
- [ ] `GET /api/latex-templates` - List all templates
- [ ] `GET /api/latex-templates/:id` - Get single template source

#### Test & Validation
- [ ] Unit tests for parser (`test_latex_parser.py`)
  - Test extracting bullets, jobs, education
  - Test clean_latex() conversions
  - Test edge cases (empty sections, special characters)
- [ ] Unit tests for renderer (`test_latex_renderer.py`)
  - Test template rendering
  - Test escape_latex() conversions
- [ ] Integration test: Parse all existing resumes, render, compile to PDF
- [ ] Manual review: Compare original PDFs vs. parsed→rendered PDFs (should look identical)

**Deliverable**: Parser and renderer working, can convert existing .tex files to structured data and back

---

### Milestone 1.5: GraphQL Setup (Week 5)
**Goal**: Setup Strawberry GraphQL + Apollo Client before building two-pane editor

**API Type**: GraphQL (complex queries, optimistic updates for resume editing)

#### Backend Tasks: Install & Configure Strawberry GraphQL
- [ ] Install dependencies:
  - `pip install strawberry-graphql[fastapi]`
  - `pip install strawberry-graphql[debug-server]` (GraphQL Playground)
- [ ] Create `/apps/api/graphql/` module:
  - `schema.py` - Main schema definition
  - `types.py` - GraphQL types (ResumeVariant, Experience, Education, etc.)
  - `queries.py` - Query resolvers
  - `mutations.py` - Mutation resolvers
- [ ] Mount GraphQL endpoint in FastAPI:
  ```python
  from strawberry.fastapi import GraphQLRouter
  graphql_app = GraphQLRouter(schema)
  app.include_router(graphql_app, prefix="/graphql")
  ```
- [ ] Define GraphQL types matching Pydantic/Beanie models:
  ```python
  @strawberry.type
  class Experience:
      id: str
      company: str
      title: str
      dates: str
      location: str
      bullets: List[str]

  @strawberry.type
  class ResumeContent:
      professional_summary: str
      experience: List[Experience]
      education: List[Education]
      skills: List[str]
  ```
- [ ] Implement basic queries:
  - `resumeVariant(id: ID!) -> ResumeVariant`
  - `resumeVariants() -> List[ResumeVariant]`
- [ ] Implement basic mutations:
  - `updateSummary(variantId: ID!, text: String!) -> ResumeVariant`
  - `updateBullet(variantId: ID!, jobId: ID!, index: Int!, text: String!) -> Experience`
- [ ] Test GraphQL Playground at `/graphql` (interactive schema explorer)

#### Frontend Tasks: Install & Configure Apollo Client
- [ ] Install dependencies:
  - `npm install @apollo/client graphql`
  - `npm install @graphql-codegen/cli @graphql-codegen/typescript` (optional: auto-generate types)
- [ ] Create Apollo Client instance (`src/apollo/client.ts`):
  ```tsx
  import { ApolloClient, InMemoryCache, HttpLink } from '@apollo/client';

  export const client = new ApolloClient({
    link: new HttpLink({ uri: 'http://localhost:8000/graphql' }),
    cache: new InMemoryCache(),
  });
  ```
- [ ] Wrap app with ApolloProvider:
  ```tsx
  import { ApolloProvider } from '@apollo/client';
  <ApolloProvider client={client}>
    <App />
  </ApolloProvider>
  ```
- [ ] Create first GraphQL query (`src/graphql/queries.ts`):
  ```tsx
  import { gql } from '@apollo/client';

  export const GET_RESUME_VARIANTS = gql`
    query GetResumeVariants {
      resumeVariants {
        id
        name
        description
      }
    }
  `;
  ```
- [ ] Test query in a component:
  ```tsx
  import { useQuery } from '@apollo/client';
  const { data, loading } = useQuery(GET_RESUME_VARIANTS);
  ```

#### Testing
- [ ] Test GraphQL endpoint with curl or Postman
- [ ] Test GraphQL Playground (browser UI at `/graphql`)
- [ ] Test Apollo Client query from frontend
- [ ] Verify auto-completion in GraphQL Playground (schema introspection)

**Deliverable**: GraphQL endpoint working, Apollo Client fetching data, ready for two-pane editor

---

### Milestone 1.6: Two-Pane Resume Editor (Week 6)
**Goal**: Build the structured resume editor with live PDF preview using GraphQL

**API Type**: GraphQL (queries + mutations for resume editing)

#### Backend Tasks: GraphQL Mutations for Editing
- [ ] Implement drag-drop mutation:
  - `reorderBullets(variantId: ID!, jobId: ID!, bullets: List[String]!) -> Experience`
- [ ] Implement CRUD mutations:
  - `addBullet(variantId: ID!, jobId: ID!, text: String!) -> Experience`
  - `deleteBullet(variantId: ID!, jobId: ID!, index: Int!) -> Experience`
  - `addExperience(variantId: ID!, company: String!, ...) -> Experience`
  - `deleteExperience(variantId: ID!, jobId: ID!) -> ResumeVariant`
- [ ] Add PDF preview mutation:
  - `generatePreview(variantId: ID!) -> String` (returns base64-encoded PDF or S3 URL)
- [ ] Each mutation should:
  - Update database (structured content)
  - Regenerate `latex_source` via Jinja2 renderer
  - Return updated data (for Apollo cache update)

#### Frontend Tasks: Two-Pane Editor
- [ ] Install dependencies:
  - `react-beautiful-dnd` (drag-drop bullets)
  - `@types/react-beautiful-dnd` (TypeScript types)
  - `lodash.debounce` (auto-save debouncing)
  - `react-pdf` or use `<iframe>` for PDF preview
- [ ] Create `ResumeEditorPage` component:
  - Two-column layout (left: editor, right: preview)
  - Responsive: stack vertically on mobile
- [ ] **Left Pane: Structured Editor** (composed of simple, focused components)
  - [ ] Professional Summary section:
    - Simple `<textarea>` with character count
    - Auto-resize height (CSS or auto-grow library)
  - [ ] Experience section (list of jobs):
    - [ ] Each job: Company, Title, Dates, Location (native `<input>` elements)
    - [ ] Bullets list for each job (react-beautiful-dnd):
      - `<DragDropContext>` wrapper for entire bullets list
      - `<Droppable>` container for bullets
      - `<Draggable>` for each bullet item
      - Inline editing (simple `<input>` or `<textarea>` per bullet)
      - Drag handle icon (⋮) with `{...provided.dragHandleProps}`
      - Delete button (×)
      - "Add bullet" button
    - [ ] "Add job" button
    - [ ] Delete job button (with confirmation)
  - [ ] Education section:
    - List of schools (add/edit/delete)
    - Fields: School, Degree, Date, Location, Description (native inputs)
  - [ ] Skills section:
    - MVP: Comma-separated `<textarea>`
    - Post-MVP: Tag input library (react-tag-input or react-tagsinput)
- [ ] **Right Pane: Live PDF Preview**
  - [ ] PDF viewer (iframe or react-pdf component)
  - [ ] Loading spinner while compiling
  - [ ] Error display if compilation fails (show LaTeX log)
  - [ ] "Refresh" button (manual re-compile)
  - [ ] "Download PDF" button
- [ ] **GraphQL Integration for Editing**
  - [ ] Create mutation hooks:
    ```tsx
    const [updateBullet] = useMutation(UPDATE_BULLET, {
      optimisticResponse: { ... } // Instant UI update
    });
    const [reorderBullets] = useMutation(REORDER_BULLETS);
    ```
  - [ ] Debounce mutations (500ms delay before firing)
  - [ ] Optimistic updates (update Apollo cache immediately, rollback on error)
- [ ] **Auto-save & Debouncing**
  - [ ] Debounce all edits (500ms)
  - [ ] On debounce trigger:
    - Fire GraphQL mutation (updateBullet, updateSummary, etc.)
    - Apollo cache automatically updates
    - Trigger `generatePreview` mutation
    - Update PDF viewer with new PDF URL
  - [ ] Show "Saving..." indicator during mutations
  - [ ] Show "Saved ✓" confirmation (from Apollo `loading` state)
- [ ] **Drag & Drop Bullets**
  - [ ] Use `<DragDropContext>`, `<Droppable>`, `<Draggable>` from react-beautiful-dnd
  - [ ] On drag end: Fire `reorderBullets` mutation
  - [ ] Optimistic update (reorder locally, sync with server)
- [ ] **State Management**
  - [ ] Apollo Client cache (stores GraphQL query results)
  - [ ] Redux for local UI state (saving indicators, modals, etc.)
  - [ ] No duplicate state (Apollo cache is source of truth for resume data)

#### Frontend Tasks: Resume Variants List
- [ ] Resume variants list view (table or cards)
  - Columns: Name, Description, Last Updated, Actions
  - Actions: Edit, Delete, Download PDF
- [ ] "New Variant" button → opens editor with empty content
- [ ] Delete confirmation modal

**Deliverable**: User can edit resume structure via two-pane UI, see live PDF preview, drag-drop bullets

---

### Milestone 1.6: Migration Script (Week 7)
**Goal**: Import all existing .tex files into database as structured data

#### Backend Tasks
- [ ] Create `scripts/migrate_resumes.py`:
  - [ ] Read all `.tex` files from `resumes/*/resume.tex`
  - [ ] For each file:
    - [ ] Parse LaTeX to structured content using parser from Milestone 1.4
    - [ ] Handle parse errors gracefully (log, mark for manual review)
    - [ ] Create `ResumeVariant` document in database
    - [ ] Set `template_id` to default template
    - [ ] Regenerate `latex_source` from parsed content (verify round-trip)
    - [ ] Optionally: Compile to PDF and upload to S3
  - [ ] Read all applications from `applied/*/`:
    - [ ] Parse company name from directory slug
    - [ ] Parse resume and cover letter .tex files
    - [ ] Create `Application` documents (mark as "applied" status)
  - [ ] Read `config/PERSONAL_INFO.md`:
    - [ ] Parse fields (name, email, phone, etc.)
    - [ ] Create `PersonalInfo` document
  - [ ] Upload `signature.png` to S3:
    - [ ] Read file as bytes
    - [ ] Upload to S3 bucket at `/{userId}/signatures/signature.png`
    - [ ] Update `PersonalInfo.signature_s3_key`
  - [ ] Generate migration report:
    - [ ] Total variants migrated
    - [ ] Total applications migrated
    - [ ] Parse failures (list files that need manual review)
    - [ ] Success rate percentage

#### Backend Tasks: Migration Endpoint
- [ ] `POST /api/admin/migrate` - Trigger migration (admin-only for MVP)
  - Runs migration script
  - Returns progress/results
  - Can be run multiple times (idempotent, skip already-migrated)

#### Frontend Tasks
- [ ] "Import Data" button in settings page
- [ ] Migration progress modal:
  - Show progress (X of Y files processed)
  - Show success/failure counts
  - Show list of failed files (for manual review)
- [ ] Success message: "Migrated X variants, Y applications"

#### Manual Cleanup
- [ ] Review failed parses (if any)
- [ ] Manually create variants for edge cases using the UI
- [ ] Verify all migrated resumes render correctly (spot-check PDFs)

**Deliverable**: All existing data migrated to database, structured editor ready to use

---

### Milestone 1.7: Global Prompts System (Week 4)
**Goal**: Backend loads global prompt files for LLM context

#### Backend Tasks
- [ ] Create `/apps/api/prompts/` directory
- [ ] Copy existing files from `.claude/prompts/`:
  - `resume-customization.md`
  - `cover-letter-generation.md`
  - `fintech-healthtech-positioning.md`
- [ ] Copy `.claude/skills/job-application-helper.md` → `/apps/api/prompts/`
- [ ] Create `PromptLoader` utility class:
  - `load_prompt(filename: str) -> str` (reads file, caches in memory)
  - `get_all_prompts() -> dict[str, str]` (returns all prompts as dict)
- [ ] `GET /api/prompts` - List available prompts (names only)
- [ ] `GET /api/prompts/:filename` - View prompt content (read-only for MVP)

#### Frontend Tasks
- [ ] "Prompts" page (read-only view for MVP)
- [ ] List all prompts with descriptions
- [ ] Click to view full content in modal or separate page
- [ ] Display as formatted Markdown (use `react-markdown`)

**Deliverable**: Global prompts loaded from files, viewable in UI

---

### Milestone 1.8: LLM Integration Layer (Week 8)
**Goal**: Abstracted LLM provider system working with structured data

#### Backend Tasks
- [ ] Create `llm/` module:
  - [ ] `base.py` - Abstract `LLMProvider` class:
    ```python
    class LLMProvider(ABC):
        @abstractmethod
        async def generate(self, system: str, user: str, **kwargs) -> dict:
            """Returns parsed JSON response"""
            pass
    ```
  - [ ] `claude.py` - `ClaudeProvider` implementation:
    - Uses Anthropic Python SDK (`anthropic` package)
    - Handles API key from env vars
    - Error handling (rate limits, invalid responses)
    - Parses JSON from Claude response
  - [ ] `factory.py` - `get_llm_provider(provider: str) -> LLMProvider`
- [ ] Install `anthropic` Python package
- [ ] Environment variables: `LLM_PROVIDER=claude`, `ANTHROPIC_API_KEY=...`

#### Backend Tasks: Prompt Builder (Structured Data)
- [ ] Create `services/prompt_builder.py`:
  - [ ] `build_resume_customization_prompt(job_description, resume_content, personal_info, global_prompts) -> (system, user)`
    - System prompt: Include global prompts (resume-customization.md)
    - User prompt: JSON representation of `resume_content` + job description
    - Ask LLM to return modified JSON (reordered bullets, updated text)
    - Example:
      ```
      Given this resume (JSON):
      {resume_content.dict()}

      Tailor it for this job description:
      {job_description}

      Return the modified resume as JSON with reordered bullets emphasizing relevant skills.
      ```
  - [ ] `build_cover_letter_prompt(job_description, company_name, personal_info, global_prompts) -> (system, user)`
    - System prompt: Include global prompts (cover-letter-generation.md, job-application-helper.md)
    - User prompt: Company name + JD + personal experience summary
    - Ask LLM to return cover letter body text (3-4 paragraphs)
- [ ] Response parsing: Validate LLM returns valid JSON for resume, text for cover letter
- [ ] Test endpoint: `POST /api/llm/test` - Send sample resume JSON, get tailored response

**Deliverable**: LLM integration working with structured data (JSON in, JSON out for resumes)

---

### Milestone 1.9: Application Creation Workflow (Week 9-10)
**Goal**: Single-form application wizard with LLM-powered resume tailoring

#### Backend Tasks
- [ ] `POST /api/applications` - Create new application (all-in-one endpoint)
  - Request body: `{ company_name, job_title, job_description, resume_variant_id, generate_cover_letter: bool }`
  - Steps:
    1. Validate inputs
    2. Load resume variant structured content
    3. Load personal info
    4. Build resume customization prompt (structured data → LLM → structured data)
    5. Call LLM to get tailored resume content (JSON)
    6. Validate LLM response (Pydantic schema)
    7. Render tailored content → LaTeX via template
    8. Compile LaTeX → PDF → upload to S3
    9. If `generate_cover_letter = true`:
       - Build cover letter prompt
       - Call LLM to generate cover letter body text
       - Replace `COMPANY_NAME` and `BODY_TEXT` in template
       - Compile to PDF → upload to S3
    10. Save application to DB with structured resume content + LaTeX + PDF URLs
    11. Return application ID + PDF URLs
- [ ] `GET /api/applications` - List all applications
- [ ] `GET /api/applications/:id` - Get single application (includes LaTeX, PDFs)
- [ ] `PUT /api/applications/:id` - Update application (edit LaTeX manually)
- [ ] `DELETE /api/applications/:id` - Delete application

#### Frontend Tasks
- [ ] "New Application" page/modal:
  - **Step 1: Company & Job Info** (single form)
    - Company name (text input)
    - Job title (text input)
    - Job description (textarea, large)
    - Resume variant selector (dropdown)
    - "Generate cover letter?" (checkbox, default true)
    - "Generate Application" button
  - **Step 2: Loading State**
    - Show spinner + progress messages:
      - "Analyzing job description..."
      - "Tailoring resume..."
      - "Generating cover letter..."
      - "Compiling PDFs..."
  - **Step 3: Review & Approve**
    - Display tailored resume LaTeX (CodeMirror, read-only for now)
    - Display generated cover letter text (Markdown preview)
    - "Looks good, save" button → saves to DB
    - "Regenerate" button → calls LLM again with feedback (future)
- [ ] Applications list page:
  - Table: Company, Job Title, Status, Created Date, Actions
  - Actions: View, Edit, Download Resume PDF, Download Cover Letter PDF, Delete
- [ ] Application detail page:
  - Show all fields (company, JD, etc.)
  - Show compiled PDFs (embed or download links)
  - Edit LaTeX sources (CodeMirror editors)
  - Re-compile button (if user edits LaTeX manually)

**Deliverable**: User can create applications via web UI, LLM generates tailored materials

---

### Milestone 1.8: Cover Letter Feedback Loop (Week 6)
**Goal**: User can provide feedback on cover letter, LLM regenerates

#### Backend Tasks
- [ ] `POST /api/applications/:id/cover-letter/regenerate`
  - Request body: `{ feedback: str }` (user's comments)
  - Append feedback to conversation history
  - Build new prompt with conversation context
  - Call LLM to regenerate cover letter
  - Update `cover_letter_latex` in application
  - Re-compile to PDF
  - Return new cover letter text + PDF URL
- [ ] `GET /api/applications/:id/conversation` - Get full conversation history
- [ ] Store conversation in `llm_conversations` collection

#### Frontend Tasks
- [ ] Cover letter preview in application review step:
  - Show generated text
  - "I like it" button → save and continue
  - "Regenerate with feedback" → show textarea
    - User enters feedback ("Make it more technical", "Emphasize healthcare experience")
    - Submit → API call → show new version
    - Iterate until approved
- [ ] Conversation history view (expandable panel, shows all iterations)

**Deliverable**: User can give feedback and iterate on cover letter before approving

---

### Milestone 1.9: Migration & Data Import (Week 7)
**Goal**: Import existing resume variants and applications from file system

#### Backend Tasks
- [ ] Create migration script: `scripts/migrate_from_files.py`
  - Read all `.tex` files from `resumes/*/resume.tex`
  - Parse variant name from directory name
  - Create `resume_variants` documents
  - Read all applications from `applied/*/`
  - Parse company name, resume, cover letter
  - Create `applications` documents (mark as "applied" status)
  - Upload existing PDFs to S3 (if they exist)
- [ ] Personal info migration:
  - Read `config/PERSONAL_INFO.md`
  - Parse fields, create `personal_info` document
  - Upload `signature.png` to S3
- [ ] `POST /api/admin/migrate` - Trigger migration (admin endpoint)

#### Frontend Tasks
- [ ] "Import" button in settings (triggers migration endpoint)
- [ ] Show migration progress (how many variants/applications imported)

**Deliverable**: All existing data migrated to database and S3

---

### Milestone 1.10: Polish & UX Improvements (Week 8)
**Goal**: Improve UI/UX, error handling, edge cases

- [ ] Add loading spinners for all async operations
- [ ] Toast notifications for success/error (react-hot-toast or similar)
- [ ] Form validation with clear error messages
- [ ] Empty states (no resume variants yet, no applications yet)
- [ ] Responsive design (mobile-friendly Tailwind classes)
- [ ] Keyboard shortcuts (Ctrl+S to save, etc.)
- [ ] Dark mode support (optional, nice-to-have)
- [ ] Error boundaries (catch React errors gracefully)
- [ ] API error handling (network errors, 500s, etc.)
- [ ] Confirmation modals for destructive actions (delete variant/application)
- [ ] "Are you sure you want to leave?" prompt if unsaved changes
- [ ] LaTeX compilation error display (show xelatex logs)
- [ ] PDF viewer (embed PDFs in UI using `react-pdf` or iframe)
- [ ] Search/filter applications (by company, status, date)

**Deliverable**: Polished MVP ready for single-user production use

---

## Phase 2: Multi-User & Authentication (Post-MVP)

### Milestone 2.1: Authentication System (Week 9-10)
**Goal**: Add user registration, login, JWT-based auth

#### Backend Tasks
- [ ] Install `python-jose` (JWT), `passlib` (password hashing), `python-multipart`
- [ ] Add password field to `users` collection (hashed with bcrypt)
- [ ] `POST /api/auth/register` - Create new user account
- [ ] `POST /api/auth/login` - Login, return JWT access + refresh tokens
- [ ] `POST /api/auth/refresh` - Refresh access token
- [ ] `POST /api/auth/logout` - Invalidate tokens (blacklist or short expiry)
- [ ] Middleware: `get_current_user()` dependency for protected routes
- [ ] Update all endpoints to filter by `user_id` (current user only)

#### Frontend Tasks
- [ ] Login page (email + password)
- [ ] Registration page (name, email, password, confirm password)
- [ ] Store JWT in localStorage or httpOnly cookie
- [ ] Axios interceptor to attach `Authorization: Bearer <token>` header
- [ ] Handle 401 responses (redirect to login, refresh token logic)
- [ ] Logout button (clear tokens, redirect to login)
- [ ] Protected routes (redirect to login if not authenticated)

**Deliverable**: Multi-user system with secure authentication

---

### Milestone 2.2: User Isolation & Permissions (Week 11)
**Goal**: Ensure users can only access their own data

- [ ] Add `user_id` indexes to all collections
- [ ] Audit all API endpoints to enforce `user_id` filtering
- [ ] Write integration tests for user isolation (user A can't access user B's data)
- [ ] Admin role (future: view all users, impersonate, etc.)
- [ ] S3 bucket policies (each user's folder is private)

**Deliverable**: Secure multi-tenant data isolation

---

### Milestone 2.3: User Settings & Customization (Week 12)
**Goal**: Per-user settings, custom prompts (overrides)

#### Features
- [ ] User can create custom prompt overrides (stored in DB, override global files)
- [ ] User can edit job application helper context (their own skills/experience)
- [ ] User can manage multiple signature images (default + variants)
- [ ] User preferences (default resume variant, auto-generate cover letters, etc.)
- [ ] Export data (download all applications as ZIP)

**Deliverable**: Users can customize their experience

---

## Phase 3: Advanced Features (Future)

### Milestone 3.1: Resume Analytics & Insights
- [ ] Track application status (applied, interviewing, rejected, offer)
- [ ] Analytics dashboard (applications over time, success rate by company/role type)
- [ ] Keyword analysis (which skills appear in JDs you apply to)
- [ ] Suggest resume improvements based on trends

### Milestone 3.2: Job Description Scraping
- [ ] Browser extension or bookmarklet to scrape JD from job sites
- [ ] API endpoint to parse LinkedIn/Indeed/Greenhouse job pages
- [ ] Auto-fill company name, job title, description

### Milestone 3.3: Structured Resume Editing
- [ ] Parse LaTeX into structured JSON (bullets, dates, companies)
- [ ] WYSIWYG-like editor (drag-drop bullets, inline editing)
- [ ] Generate LaTeX from structured data (reverse of parsing)
- [ ] Templates (swap LaTeX templates while keeping content)

### Milestone 3.4: Alternative Formats
- [ ] Export resume as Markdown, HTML, DOCX (in addition to PDF)
- [ ] Generate LinkedIn profile summary from resume
- [ ] Generate plain-text version for ATS systems

### Milestone 3.5: Collaboration Features
- [ ] Share applications with mentors/friends for feedback
- [ ] Comments on resume bullets ("change this to emphasize X")
- [ ] Version history (track changes over time, revert)

### Milestone 3.6: LLM Provider Flexibility
- [ ] Add OpenAI provider implementation
- [ ] UI to select provider per request (Claude vs GPT-4)
- [ ] Cost tracking (estimate LLM API costs per application)
- [ ] Bring-your-own-key (users provide their own API keys)

### Milestone 3.7: Email Integration
- [ ] Send applications via email (attach resume + cover letter PDFs)
- [ ] Track email opens (if using email API like SendGrid)
- [ ] Follow-up reminders ("applied 2 weeks ago, no response")

---

## Technical Debt & Maintenance

### Code Quality
- [ ] Setup linters (ESLint for frontend, Black/Ruff for backend)
- [ ] Setup pre-commit hooks (format on commit)
- [ ] Write unit tests (pytest for backend, Vitest for frontend)
- [ ] Write E2E tests (Playwright or Cypress)
- [ ] CI/CD pipeline (GitHub Actions: lint, test, build Docker images)

### Documentation
- [ ] API documentation (FastAPI auto-generates, but add examples)
- [ ] Frontend component documentation (Storybook)
- [ ] Deployment guide (Docker Compose for prod, env var reference)
- [ ] Contributing guide (for future open-source release?)

### Performance
- [ ] Add Redis caching for expensive LLM calls (cache prompt → response)
- [ ] Optimize MongoDB queries (ensure indexes on `user_id`, `created_at`)
- [ ] Lazy-load LaTeX editors (code-split CodeMirror bundle)
- [ ] Compress API responses (gzip)
- [ ] CDN for static assets (if hosting frontend separately)

### Security
- [ ] Add rate limiting (prevent LLM API abuse)
- [ ] Add CSRF protection (for cookie-based auth)
- [ ] Audit dependencies for vulnerabilities (Dependabot)
- [ ] Setup HTTPS (Let's Encrypt, reverse proxy)
- [ ] Environment variable validation (fail fast if missing required vars)

---

## Deployment Strategy

### Cloud-Native Architecture (Chosen Approach)

**No servers to manage, no Nginx, auto-SSL, auto-scaling**

#### Development (Local)
```bash
docker-compose up
# Frontend: http://localhost:5173
# Backend: http://localhost:8000
# MongoDB: mongodb://localhost:27017
# Mongo Express: http://localhost:8081
```

#### Production Deployment

**Frontend (Vercel)**:
- Deploy: `vercel deploy --prod`
- Result: `https://job-forge.vercel.app`
- Features: Auto-SSL, global CDN, zero config
- Cost: **Free** (100 GB bandwidth/month)

**Backend (Fly.io)**:
- Deploy: `fly deploy` (uses Dockerfile)
- Result: `https://job-forge-api.fly.dev`
- Features: Auto-SSL, auto-scaling, zero downtime deploys
- Cost: **~$5-10/month** (1 shared vCPU, 256 MB RAM)

**Database (MongoDB Atlas)**:
- Setup: Create M0 cluster at mongodb.com/atlas
- Connection: `mongodb+srv://...`
- Features: Auto-backups, monitoring, free tier
- Cost: **Free** (M0 tier, 512 MB) or **$9/month** (M2 tier)

**Storage (AWS S3)**:
- Setup: Create bucket, configure IAM user
- Access: `boto3` SDK with signed URLs
- Cost: **~$1-5/month** (storage + requests)

**CORS Configuration**:
```python
# Required since frontend and backend are on different domains
app.add_middleware(
    CORSMiddleware,
    allow_origins=["http://localhost:5173", "https://job-forge.vercel.app"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)
```

**Total Monthly Cost**: **~$6-24/month**
- No Nginx setup
- No server maintenance
- No SSL certificate management
- Auto-scaling included

**Why Cloud-Native?**
- ✅ Zero server maintenance (no OS updates, no SSH)
- ✅ Auto-SSL (Vercel and Fly.io handle certificates)
- ✅ Auto-scaling (Fly.io scales based on traffic)
- ✅ Global CDN (Vercel serves from edge locations)
- ✅ Simpler deployment (git push → auto-deploy)
- ✅ Resume-worthy skills (modern cloud patterns)

---

## Success Metrics

### MVP Success (Phase 1)
- [ ] Create 10+ applications using the web UI
- [ ] All existing data migrated from file system
- [ ] No critical bugs for 2 weeks of daily use
- [ ] LaTeX compilation works 100% of the time
- [ ] LLM-generated cover letters require ≤2 iterations on average

### Post-MVP Success (Phase 2+)
- [ ] Support 10+ concurrent users
- [ ] Authentication has no security incidents
- [ ] User data isolation verified via penetration testing
- [ ] 90% uptime SLA
- [ ] API response time <500ms (p95)

---

## Decisions Made

1. ✅ **Deployment Strategy**: Cloud-native (Vercel + Fly.io + MongoDB Atlas + S3)
   - No Nginx required (managed platforms handle SSL and routing)
   - No VPS to maintain (serverless/managed services)
   - Auto-scaling built in

2. ✅ **S3 vs Google Cloud Storage**: AWS S3
   - Industry standard, better ecosystem
   - More familiar, better documentation
   - `boto3` library is excellent

3. ✅ **LaTeX Compilation**: Docker container (backend)
   - Simpler for MVP (no extra service)
   - Can move to cloud function later if needed

4. ✅ **Redis for caching**: Skip for MVP
   - Add in Phase 2 if LLM costs become issue
   - MongoDB can handle session storage initially

5. ✅ **Repository Structure**: Monorepo
   - Easier development (shared types, single deploy)
   - Both services in one repo: `/apps/web`, `/apps/api`

6. ✅ **Testing Strategy**: Integration + E2E
   - Integration tests for API endpoints (pytest)
   - E2E tests for critical flows (Playwright)
   - Unit tests for complex logic only

---

## Next Steps (Immediate Actions)

1. **Setup project structure**:
   ```
   job-forge/
   ├── apps/
   │   ├── web/           # Vite + React app
   │   └── api/           # FastAPI app
   ├── docker/            # Dockerfiles
   ├── docker-compose.yml
   ├── scripts/           # Migration scripts
   └── README.md
   ```

2. **Create Docker Compose file** with 4 services (frontend, backend, MongoDB, Mongo Express)

3. **Initialize frontend** (`npm create vite@latest apps/web -- --template react-ts`)

4. **Initialize backend** (`fastapi` project with `poetry` or `pip` in apps/api/)

5. **Setup Git branching strategy** (main, develop, feature branches)

6. **Create first issue/task**: "Milestone 1.1: Project Setup & Infrastructure"

---

## Appendix: Key Libraries & Tools

### Frontend
- `react` + `react-dom` - UI framework
- `vite` - Build tool
- `tailwindcss` - Styling
- `@reduxjs/toolkit` + `react-redux` - State management (local UI state)
- **`@apollo/client` + `graphql`** - GraphQL client (resume editing, applications)
- **`@graphql-codegen/cli`** - Auto-generate TypeScript types from GraphQL schema (optional)
- `react-beautiful-dnd` + `@types/react-beautiful-dnd` - Drag-drop bullet reordering
- `lodash.debounce` - Auto-save debouncing (500ms)
- `react-hook-form` + `zod` - Form handling + validation
- `axios` - HTTP client (REST endpoints: auth, file uploads)
- `react-hot-toast` - Notifications
- `react-markdown` - Markdown rendering
- `react-pdf` - PDF viewer (optional, can use `<iframe>` instead)

### Backend
- `fastapi` - Web framework
- **`strawberry-graphql[fastapi]`** - GraphQL library (resume editing, applications)
- `motor` - Async MongoDB driver
- `beanie` - MongoDB ODM (Mongoose-like for Python)
- `pydantic` - Data validation (REST + GraphQL)
- `jinja2` - Template engine (structured data → LaTeX rendering)
- `anthropic` - Claude API client (official SDK)
- `boto3` - AWS S3 client (official SDK)
- `python-jose` - JWT handling (Phase 2: auth)
- `passlib` - Password hashing (Phase 2: auth)
- `pytest` - Testing framework
- `httpx` - HTTP client for testing

### DevOps
- `docker` + `docker-compose` (local development)
- `vercel` CLI (frontend deployment)
- `flyctl` (Fly.io CLI for backend deployment)
- GitHub Actions (CI/CD, future)

---

**End of Roadmap**

_Last updated: 2026-06-27_
