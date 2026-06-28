# Claude Code Agents

Specialized agents for automated code review, design, and analysis tasks.

## Table of Contents

- [Job-Forge Core Agents](#job-forge-core-agents)
  - [python-backend-reviewer](#python-backend-reviewer)
  - [latex-specialist](#latex-specialist)
  - [migration-specialist](#migration-specialist)
  - [llm-integration-specialist](#llm-integration-specialist)
- [General-Purpose Agents](#general-purpose-agents)
  - [api-designer](#api-designer)
  - [code-reviewer](#code-reviewer)
  - [db-architect](#db-architect)
  - [error-handler](#error-handler)
  - [form-engineer](#form-engineer)
  - [graphql-client-specialist](#graphql-client-specialist)
  - [security-auditor](#security-auditor)
  - [tailwind-designer](#tailwind-designer)
  - [test-architect](#test-architect)
  - [ui-reviewer](#ui-reviewer)
- [How Agents Work](#how-agents-work)
- [Creating Custom Agents](#creating-custom-agents)

---

## Job-Forge Core Agents

These agents are tailored specifically to Job-Forge's Python + FastAPI + MongoDB + LaTeX stack.

### python-backend-reviewer

**Purpose**: Python + FastAPI + MongoDB code review

**Use when**:
- Reviewing backend API code
- Checking async/await patterns
- Validating Pydantic models
- Reviewing Beanie ODM queries
- Ensuring proper error handling

**Tools**: Read, Grep, Glob (read-only)

**Example**: After implementing a new API endpoint, use this agent to review for async best practices, validation, and security.

**Key focus areas**:
- User data isolation with `Depends(get_current_user)`
- Beanie query patterns (N+1 prevention, async/await)
- FastAPI error handling (HTTPException, Pydantic validation)
- Type hints and async consistency

---

### latex-specialist

**Purpose**: LaTeX parsing, template rendering, and PDF compilation

**Use when**:
- Parsing `.tex` files to JSON (migration)
- Designing Jinja2 LaTeX templates
- Debugging LaTeX compilation errors
- Fixing character escaping issues
- Building LaTeX → PDF pipeline

**Tools**: Read, Grep, Glob, Bash

**Example**: When building the resume variant migration script, use this agent to design regex patterns for parsing experience bullets from LaTeX files.

**Key focus areas**:
- LaTeX → JSON parsing with regex
- Jinja2 template design for resume/cover letter rendering
- XeLaTeX compilation (Calibri font support)
- Character escaping (non-breaking hyphens, special characters)

---

### migration-specialist

**Purpose**: LaTeX → JSON migration with 90%+ success rate automation

**Use when**:
- Building migration scripts (Week 7, Milestone 1.6)
- Designing LaTeX regex patterns for parsing
- Handling parse failures and edge cases
- Generating migration reports
- Testing round-trip accuracy (LaTeX → JSON → LaTeX → PDF)
- Recommending manual review workflows

**Tools**: Read, Grep, Glob, Bash

**Example**: When migrating all existing `.tex` files to structured JSON in MongoDB, use this agent to design regex patterns, handle multi-line bullets, and generate migration reports with 90%+ success rate.

**Key focus areas**:
- Regex-based LaTeX parsing (sections, bullets, metadata)
- Data transformation and validation
- Round-trip testing (LaTeX → JSON → LaTeX consistency)
- Migration reporting and manual review workflows

---

### llm-integration-specialist

**Purpose**: Claude API integration and structured data prompts (JSON → LLM → JSON)

**Use when**:
- Building LLM integration layer (Week 8, Milestone 1.8)
- Designing provider abstraction (Claude + OpenAI)
- Writing structured data prompts for resume tailoring
- Implementing retry logic and error handling
- Optimizing token usage and costs
- Adding multi-provider support

**Tools**: Read, Grep, Glob

**Example**: When implementing the resume tailoring feature, use this agent to design the provider abstraction layer, build structured JSON prompts, and implement cost tracking for Claude API calls.

**Key focus areas**:
- Structured data prompts (JSON input/output)
- Provider abstraction (Claude, OpenAI)
- Retry logic and error handling
- Token usage optimization and cost tracking

---

## General-Purpose Agents

These agents provide specialized expertise for common web application patterns and can be used across multiple projects.

### api-designer

**Purpose**: REST + GraphQL API design expert for hybrid architectures

**Use when**:
- Designing new REST endpoints or GraphQL queries/mutations
- Reviewing API structure (hybrid REST + GraphQL)
- Deciding REST vs GraphQL for a feature
- Ensuring user-scoped resource filtering
- Validating error handling patterns
- Planning pagination strategies

**Tools**: Read, Grep, Glob (read-only)

**Stack**: FastAPI + Strawberry GraphQL + MongoDB + Beanie

**Example**: When adding a new API endpoint, use this agent to decide whether REST or GraphQL is appropriate, design the endpoint structure, and ensure user-scoped data isolation.

**Key focus areas**:
- REST vs GraphQL decision matrix
- User-scoped URL structure (`/api/v1/{resource}`)
- HTTP status codes (401 vs 403, 404 vs 409)
- FastAPI route patterns and Strawberry resolvers
- Pagination strategies (offset-based for REST, cursor-based for GraphQL)

---

### code-reviewer

**Purpose**: Security and correctness focused code review

**Use when**:
- After significant code changes (proactive review)
- Reviewing code quality and security
- Ensuring adherence to project conventions
- Checking for OWASP Top 10 2025 vulnerabilities
- Validating test coverage

**Tools**: Read, Grep, Glob, Bash

**Stack**: Python + FastAPI + MongoDB (backend), React 19 + Apollo Client + Tailwind 4.3 (frontend)

**Example**: After implementing a new feature with multiple endpoints and UI components, use this agent to review for security issues, performance problems, and code style violations.

**Key focus areas**:
- OWASP Top 10 2025 security checks (A01-A03 critical)
- User data isolation (Broken Access Control)
- N+1 query patterns and performance
- Apollo Client cache management
- Tailwind 4.3 design token usage
- Accessibility (semantic HTML, ARIA attributes)

---

### db-architect

**Purpose**: Database schema design, indexing, and query optimization

**Use when**:
- Designing new document models
- Adding fields to existing documents
- Optimizing slow queries
- Investigating N+1 query problems
- Planning schema evolution (migrations)
- Reviewing indexing strategy
- Troubleshooting performance issues
- Ensuring user data isolation (Phase 2)
- Deciding embedded vs referenced documents

**Tools**: Read, Grep, Glob, Bash

**Stack**: MongoDB + Beanie ODM

**Example**: When designing the `ResumeVariant` document structure, use this agent to decide whether to embed `Experience` objects or reference them, plan indexes for common queries, and design migration scripts.

**Key focus areas**:
- Document design (embedded vs referenced)
- User-scoped data isolation (`user_id` filtering)
- Indexing strategy (compound indexes, unique constraints)
- Query optimization (N+1 prevention, aggregation pipelines)
- Schema evolution and backfill scripts

---

### error-handler

**Purpose**: Error handling and user-facing message expert

**Use when**:
- Designing error handling strategies
- Creating error codes
- Writing user-friendly error messages
- Reviewing error responses
- Troubleshooting error handling bugs
- Ensuring error sanitization
- Implementing global error handlers
- Validating security-conscious error responses

**Tools**: Read, Grep, Glob (read-only)

**Example**: When implementing a new API endpoint, use this agent to design appropriate error codes, write user-friendly messages, and ensure errors don't leak sensitive information.

**Key focus areas**:
- AppError patterns with machine-readable error codes
- FastAPI HTTPException and global error handlers
- User-friendly error messages (no stack traces, DB errors)
- Security-conscious sanitization (production vs development)
- Frontend error handling (Apollo Client, Axios interceptors)

---

### form-engineer

**Purpose**: Form patterns, validation, error handling, and multi-step flows

**Use when**:
- Designing new forms
- Implementing form validation
- Troubleshooting form UX issues
- Building multi-step flows
- Adding file upload functionality
- Ensuring form accessibility
- Optimizing form performance
- Reviewing form error handling

**Tools**: Read, Grep, Glob (read-only)

**Stack**: React 19 + Zod validation

**Example**: When building a multi-step job application form, use this agent to design validation schemas, implement accessible error messages, and ensure proper loading/success states.

**Key focus areas**:
- Controlled components with Zod validation
- Inline validation on blur (not just submit)
- Accessible error messages (aria-describedby, role="alert")
- Multi-step form state management
- File upload validation (type, size)
- Dynamic form fields (add/remove)

---

### graphql-client-specialist

**Purpose**: Apollo Client + Axios expert for hybrid REST/GraphQL patterns

**Use when**:
- Implementing data fetching (GraphQL or REST)
- Troubleshooting cache issues
- Optimizing query performance
- Designing cache strategies
- Implementing optimistic updates
- Handling user-scoped data patterns

**Tools**: Read, Grep, Glob (read-only)

**Stack**: Apollo Client + Axios + React 19

**Example**: When implementing drag-drop reordering for resume bullets, use this agent to design optimistic updates, cache normalization, and refetch strategies.

**Key focus areas**:
- GraphQL vs REST decision matrix
- Apollo Client cache normalization (automatic updates)
- Optimistic updates for better UX
- Cache updates after mutations (refetchQueries)
- Hybrid REST/GraphQL patterns (auth, file uploads via Axios)

---

### security-auditor

**Purpose**: Comprehensive OWASP Top 10 2025 vulnerability assessment

**Use when**:
- Conducting security reviews
- Investigating potential vulnerabilities
- Performing pre-release security audits
- Running automated security scans
- Threat modeling

**Tools**: Read, Grep, Glob, Bash

**Invoked via**: `/security-audit` command (proactive)

**Example**: Before deploying to production, use this agent to run automated scans (pip-audit, Bandit), review code for OWASP Top 10 violations, and generate a prioritized vulnerability report.

**Key focus areas**:
- Automated scanning (pip-audit, Bandit, pytest coverage)
- OWASP Top 10 2025 code review patterns
- Broken Access Control (A01) - user_id validation
- Security Misconfiguration (A02) - CORS, secrets, error handling
- Supply Chain Failures (A03) - dependency audit
- Threat modeling and remediation guidance

---

### tailwind-designer

**Purpose**: Tailwind CSS 4.x design system and styling expert

**Use when**:
- Building UI components
- Creating design systems
- Troubleshooting responsive layouts
- Ensuring consistent styling patterns
- Implementing dark mode
- Optimizing CSS performance

**Tools**: Read, Grep, Glob (read-only)

**Stack**: Tailwind CSS 4.x (CSS-first configuration with `@theme`)

**Example**: When building a reusable button component, use this agent to design variant classes, ensure accessible focus states, and follow Tailwind 4.x composition patterns.

**Key focus areas**:
- CSS-first configuration (`@theme` directive in `index.css`)
- Design tokens (colors, spacing, typography)
- Composition over configuration (primitives, not complex props)
- Mobile-first responsive design
- Accessibility (focus states, semantic colors, contrast)

---

### test-architect

**Purpose**: Integration testing and test strategy expert

**Use when**:
- Designing test suites
- Writing integration tests
- Reviewing test coverage
- Troubleshooting flaky tests
- Testing auth and user isolation
- Testing edge cases

**Tools**: Read, Grep, Glob, Bash

**Stack**: pytest + httpx (AsyncClient)

**Example**: When adding a new API endpoint, use this agent to write integration tests for 401 (auth), 404 (not found), 403 (user isolation), and success cases.

**Key focus areas**:
- Integration tests through HTTP layer (httpx AsyncClient)
- Test fixtures (conftest.py, DB cleanup)
- User isolation testing (401, 404 for other user's resources)
- Edge cases (token expiry, race conditions, validation errors)
- 80% coverage target on `apps/api/app/`

---

### ui-reviewer

**Purpose**: Frontend UX, accessibility, and performance review

**Use when**:
- Reviewing React components
- Investigating UI bugs
- Optimizing frontend performance
- Ensuring WCAG 2.1 AA accessibility compliance
- Reviewing component quality
- Improving user experience

**Tools**: Read, Grep, Glob (read-only)

**Stack**: React 19 + Apollo Client + Tailwind 4.3

**Example**: After building a new dashboard component, use this agent to review for accessibility issues, performance bottlenecks, and UX problems.

**Key focus areas**:
- Accessibility (WCAG 2.1 AA - semantic HTML, keyboard nav, ARIA)
- User experience (loading states, error handling, empty states)
- Performance (bundle size, re-renders, memoization)
- React anti-patterns (misusing hooks, wrong state management)
- Responsive design (mobile usability, touch targets)
- Security (XSS, dangerouslySetInnerHTML)

---

## How Agents Work

Agents are specialized AI workers that Claude Code delegates tasks to. They operate autonomously within their area of expertise.

**Automatic Invocation**: Claude Code automatically invokes agents when their expertise is needed based on the task at hand.

**Manual Invocation**: You can explicitly request an agent:

```
"Can you review this FastAPI code for security issues?"
→ Invokes python-backend-reviewer agent

"Help me parse this LaTeX resume to JSON"
→ Invokes latex-specialist agent

"Run a security audit on the codebase"
→ Invokes security-auditor agent
```

**Agent Discovery**: Agents are automatically discovered by reading `.md` files in `.claude/agents/` and parsing their frontmatter (`name`, `description`, `tools`).

---

## Creating Custom Agents

To add a new agent:

1. **Create a new `.md` file** in `.claude/agents/`:

   ```bash
   touch .claude/agents/my-agent.md
   ```

2. **Add frontmatter** with agent metadata:

   ```yaml
   ---
   name: my-agent
   description: What this agent does and when to use it
   model: sonnet
   tools: Read, Grep, Glob
   disallowedTools: Write, Edit, Bash
   color: blue
   ---
   ```

3. **Write agent instructions** in the body of the file:

   ```markdown
   # Purpose

   You are an expert in [domain]. Your role is to [task description].

   ## Key Areas of Expertise

   - Area 1
   - Area 2
   - Area 3

   ## When to Use This Agent

   - Use case 1
   - Use case 2
   ```

4. **Agents are automatically discovered** - no need to register them anywhere.

### Agent Design Principles

- **Focused expertise** - Each agent specializes in one domain
- **Read-only by default** - Most agents use Read, Grep, Glob (not Write/Edit)
- **Clear use cases** - Description should explain when to use the agent
- **Actionable output** - Agents should provide specific, implementable recommendations
- **Examples and patterns** - Include code examples and anti-patterns
- **Reference documentation** - Link to `.claude/rules/` and `.claude/skills/` for context

### Frontmatter Fields

- **`name`** (required): Kebab-case identifier (e.g., `my-agent`)
- **`description`** (required): When to use this agent (shown in agent list)
- **`model`** (optional): `sonnet` (default), `opus`, or `haiku`
- **`tools`** (optional): Comma-separated list (e.g., `Read, Grep, Glob`)
- **`disallowedTools`** (optional): Tools to block (e.g., `Write, Edit, Bash`)
- **`color`** (optional): UI color (e.g., `blue`, `red`, `green`)

---

## Agent Performance Tips

- **Use specific agents** - Prefer specialized agents (python-backend-reviewer) over generic ones (code-reviewer) for faster, more accurate results
- **Provide context** - When invoking agents, provide relevant file paths or describe the specific problem
- **Read agent output carefully** - Agents provide detailed recommendations with file:line references and code examples
- **Iterate** - After applying agent recommendations, re-run the agent to verify fixes

---

**Last Updated**: 2025-06-28
