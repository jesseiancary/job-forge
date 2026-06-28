# Review Command

Run a comprehensive pre-PR checklist before creating a pull request.

## Checklist

### Type Safety

**Python (Backend)**
- [ ] mypy type checking passes (`cd backend && mypy app/`)
- [ ] No `Any` types introduced without justification
- [ ] All Pydantic models properly typed
- [ ] Type hints on all function signatures

**TypeScript (Frontend)**
- [ ] TypeScript strict mode passes (`pnpm typecheck`)
- [ ] No `any` types introduced
- [ ] All types properly inferred
- [ ] GraphQL types generated from schema

### Tests

**Backend (pytest)**
- [ ] All Python tests pass (`cd backend && pytest tests/`)
- [ ] New features have integration tests (httpx AsyncClient)
- [ ] Edge cases covered (401, 404, 422, 400, 409, 200, 201)
- [ ] Test coverage meets 80% threshold (`pytest --cov=app`)

**Frontend (Vitest)**
- [ ] All frontend tests pass (`pnpm test`)
- [ ] React components tested (React Testing Library)
- [ ] User interactions tested

### Code Quality

**Python**
- [ ] Black formatting applied (`black backend/`)
- [ ] Ruff linting passes (`ruff check backend/`)
- [ ] No print statements (use logging)

**TypeScript**
- [ ] ESLint passes (`pnpm lint`)
- [ ] Prettier formatting applied (`pnpm format`)

### API Documentation

**FastAPI (Auto-generated)**
- [ ] Pydantic models documented with docstrings
- [ ] FastAPI endpoints have summary and description
- [ ] Response models defined for all endpoints
- [ ] OpenAPI docs valid at `/docs`

**GraphQL**
- [ ] Strawberry schema types documented
- [ ] GraphQL SDL up to date
- [ ] Frontend types regenerated from GraphQL schema

### Security (OWASP Top 10 2025)

**🔴 A01: Broken Access Control (CRITICAL)**

**Phase 1 (MVP - Single User)**
- [ ] No authentication required (documented as Phase 1 limitation)
- [ ] All endpoints accessible (expected behavior)

**Phase 2 (Multi-User)**
- [ ] Routes protected with `Depends(get_current_user)`
- [ ] `user_id` sourced from JWT `current_user.id`, NEVER from request body/query/params
- [ ] Beanie queries scoped to `user_id` for user resources
- [ ] Horizontal escalation prevented (user cannot access other user's data)
- [ ] 404 vs 403 decision follows conventions (don't leak resource existence)
- [ ] User isolation tested (test cross-user access returns 404)

**🔴 A02: Security Misconfiguration (CRITICAL)**

- [ ] CORSMiddleware configured (restricted to frontend origin, not `["*"]`)
- [ ] Global exception handler sanitizes errors (no tracebacks in production)
- [ ] `settings.ENVIRONMENT == "production"` hides error details
- [ ] No hardcoded secrets (all in Pydantic BaseSettings from env vars)
- [ ] Cookies: `httpOnly`, `secure` (production), `sameSite: "lax"` or `"strict"`
- [ ] `.env` gitignored, `.env.example` committed

**🔴 A03: Supply Chain Failures (CRITICAL)**

- [ ] `pip-audit` passing (no high/critical vulnerabilities)
- [ ] `requirements.txt` or `pyproject.toml` with pinned versions
- [ ] No `eval()` or `exec()` usage in Python code
- [ ] No dynamic imports with user input
- [ ] New dependencies vetted (reputation, maintainer, license)

**🟡 A04: Cryptographic Failures (MODERATE - Phase 2)**

- [ ] Passwords hashed with passlib + bcrypt (rounds ≥12)
- [ ] Tokens generated with `secrets` module (NEVER `random`)
- [ ] API keys/tokens hashed (SHA-256) before storage
- [ ] No weak algorithms (MD5, SHA1)
- [ ] No sensitive data logged (passwords, tokens, PII)

**🟡 A05: Injection (MODERATE)**

**Backend (Python)**
- [ ] All inputs validated with Pydantic before database operations
- [ ] Beanie ODM used (NO raw Motor queries with user input)
- [ ] **CRITICAL**: LaTeX input sanitized before compilation
- [ ] LaTeX compiler runs with `--shell-restricted` or `--no-shell-escape`
- [ ] No `shell=True` in subprocess calls
- [ ] Timeout limits on LaTeX compilation (prevent DoS)

**Frontend (React)**
- [ ] All inputs validated with Zod
- [ ] React auto-escaping used (NO `dangerouslySetInnerHTML` without DOMPurify)
- [ ] Content-Security-Policy header configured

**🟡 A07: Authentication Failures (MODERATE - Phase 2)**

- [ ] Access tokens short-lived (≤15 minutes)
- [ ] Refresh tokens in httpOnly cookies (NOT localStorage)
- [ ] Refresh token rotation implemented
- [ ] Password policy enforced via Pydantic validator (8+ chars, complexity)
- [ ] Rate limiting on login/register endpoints (SlowAPI)
- [ ] Password reset tokens single-use, time-limited (1 hour)

**🔵 A06, A08-A10: Advisory**

- [ ] Threat modeling considered for LaTeX compilation (A06 Insecure Design)
- [ ] Rate limiting on expensive operations (PDF generation, LaTeX compilation) (A06)
- [ ] JWT signatures verified with `python-jose` or `PyJWT` (A08 Data Integrity)
- [ ] Security events logged (failed logins, 403s - Phase 2) (A09)
- [ ] All async operations in try/except (A10 Exception Handling)
- [ ] Uncaught exceptions handled by global handler (A10)

### LaTeX Security (CRITICAL - Job-Forge Specific)

- [ ] User input in LaTeX templates is sanitized
- [ ] Dangerous LaTeX commands disabled (`\input`, `\write18`, shell escape)
- [ ] LaTeX compiler timeout configured (e.g., 30 seconds max)
- [ ] Compiled PDFs stored securely (not publicly accessible)
- [ ] File upload size limits enforced (resume content, signature images)

### User Isolation (Phase 2)

- [ ] All queries filter by `user_id` from JWT
- [ ] Cannot list other users' resumes/applications
- [ ] Cannot update other users' resources
- [ ] Cannot delete other users' resources
- [ ] 404 returned for other users' resources (don't leak existence)

### Performance

**Backend**
- [ ] Database indexes on `user_id` (Phase 2)
- [ ] Async operations used (`async def`, `await`)
- [ ] No blocking I/O operations

**Frontend**
- [ ] Apollo Client cache normalized by `__typename` + `id`
- [ ] GraphQL queries avoid over-fetching
- [ ] Images optimized (signature.png)

### Git Hygiene

- [ ] Commit messages are descriptive
- [ ] No merge conflicts
- [ ] No commented-out code (unless explicitly needed)
- [ ] No debugging statements (`print()`, `console.log()`)
- [ ] `.gitignore` excludes sensitive files (`.env`, `*.pyc`, `__pycache__/`)

### Documentation

- [ ] README updated if new features added
- [ ] API changes documented in commit message
- [ ] Breaking changes clearly marked
- [ ] Environment variables documented in `.env.example`

## How to Use

1. Run this checklist before creating a PR
2. Mark items as complete using `- [x]`
3. Document any intentional violations
4. Include checklist in PR description for reviewer visibility

## Phase-Specific Notes

### Phase 1 (MVP - Current)
- **Authentication**: Not implemented - all endpoints are public
- **User Isolation**: Not applicable - single user assumption
- **Security Focus**: Injection prevention (LaTeX, NoSQL), error sanitization, dependency audit

### Phase 2 (Multi-User - Future)
- **Authentication**: JWT-based auth required
- **User Isolation**: All queries scoped to `user_id`
- **Security Focus**: Access control, RBAC edge cases, auth failures

## Pre-Commit Hooks

Ensure these hooks pass before committing:

```bash
# Run all hooks
.claude/hooks/pre-commit.sh

# Individual hooks
.claude/hooks/lint-staged.sh       # Format Python & TypeScript
.claude/hooks/validate-types.sh    # Type check
.claude/hooks/test-runner.sh       # Run tests
.claude/hooks/security-check.sh    # Security scan
```
