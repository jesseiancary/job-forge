# Security Rules

Always-active security rules based on OWASP Top 10 2025. These rules are enforced during all development activities.

## Enforcement Levels

- **🔴 CRITICAL (Block)**: A01, A02, A03 - Must be fixed before commit
- **🟡 MODERATE (Warn)**: A04, A05, A07 - Strong warnings, review required
- **🔵 ADVISORY**: A06, A08, A09, A10 - Recommendations, optional fixes

---

## 🔴 A01: Broken Access Control (CRITICAL)

### User Data Isolation (Phase 1 MVP)

**ALWAYS filter by `user_id` from authenticated user (JWT token)**

❌ Trust `user_id` from request body/query params
✅ Get `user_id` from `current_user` (via FastAPI Depends)

```python
# BAD - client can pass any user_id
@router.get("/resumes")
async def list_resumes(user_id: str):
    return await ResumeVariant.find(ResumeVariant.user_id == user_id).to_list()

# GOOD - user_id from authenticated token
@router.get("/resumes")
async def list_resumes(current_user: dict = Depends(get_current_user)):
    return await ResumeVariant.find(
        ResumeVariant.user_id == current_user["id"]
    ).to_list()
```

### Checklist for Every Protected Endpoint

- [ ] Route protected with `Depends(get_current_user)`
- [ ] `user_id` sourced from `current_user["id"]` (NEVER from request)
- [ ] MongoDB queries filtered by `user_id` for all user-scoped resources
- [ ] Horizontal privilege escalation prevented (user A cannot access user B's data)
- [ ] 404 returned for resources that don't exist OR don't belong to user

### Multi-Tenant RBAC (Phase 2+ - Future)

When adding organization/team features:

- [ ] `organizationId` sourced from JWT/middleware (never from client)
- [ ] Role requirements enforced
- [ ] Cross-tenant access returns 404
- [ ] RBAC edge cases handled (owner protection, last owner, etc.)

---

## 🔴 A02: Security Misconfiguration (CRITICAL)

### Error Response Sanitization

**NEVER expose in API responses:**

- Python stack traces (development only, sanitized in production)
- Internal file paths
- MongoDB query details
- Environment variables
- Secret values (API keys, JWT secrets, etc.)

**ALWAYS use HTTPException with generic messages:**

```python
from fastapi import HTTPException, status

# GOOD - user-friendly error
raise HTTPException(
    status_code=status.HTTP_404_NOT_FOUND,
    detail="Resume variant not found"
)

# BAD - exposes internals
raise HTTPException(
    status_code=500,
    detail=f"MongoDB error: {str(e)}"  # Leaks DB details!
)
```

### Global Exception Handler

```python
@app.exception_handler(Exception)
async def global_exception_handler(request: Request, exc: Exception):
    logger.error(f"Unhandled exception: {exc}", exc_info=True)
    return JSONResponse(
        status_code=500,
        content={"detail": "Internal server error"}  # Generic message
    )
```

### Environment Variable Validation

```python
from pydantic_settings import BaseSettings

class Settings(BaseSettings):
    MONGODB_URL: str
    JWT_SECRET: str
    ANTHROPIC_API_KEY: str

    class Config:
        env_file = ".env"

# Fails fast if env vars missing
settings = Settings()
```

### Security Headers (Phase 2+)

When adding frontend:

- [ ] CORS restricted to specific origins (not `*`)
- [ ] Content-Security-Policy configured
- [ ] Secure cookies (httpOnly, secure, sameSite)

---

## 🔴 A03: Software Supply Chain Failures (CRITICAL)

### Dependency Management

- [ ] Run `pip-audit` or `safety check` before commits
- [ ] Review all dependency updates (don't auto-merge Dependabot PRs)
- [ ] Pin exact versions in `requirements.txt` or use `poetry.lock`
- [ ] Audit licenses (no GPL/AGPL without legal review)

```bash
# Check for vulnerabilities
pip-audit

# Or use safety
safety check
```

### Package Installation

❌ `pip install <package>` without review
✅ Review package on PyPI, check downloads/stars, review GitHub, then install

---

## 🟡 A04: Cryptographic Failures (MODERATE)

### Password Storage

✅ Use `passlib` with bcrypt (work factor ≥ 12)
❌ Plain text, MD5, SHA-1, SHA-256 (no salt)

### Token Security

✅ SHA-256 hashing for invitation tokens and API keys
✅ Random token generation (crypto.randomBytes, not Math.random)
✅ Single-use enforcement (mark as used after consumption)

### JWT Best Practices

- Access token: 15 minutes expiry
- Refresh token: 7 days expiry, httpOnly cookie
- Strong secret (≥ 32 bytes entropy)

**Detailed crypto patterns in `.claude/skills/security/owasp-top10.md`**

---

## 🟡 A05: Injection (MODERATE)

### SQL Injection Prevention

✅ Beanie ODM (parameterized queries)
❌ `raw Motor queries with user input()` (only use if absolutely necessary, document why)

### XSS Prevention

**Frontend:**

- ✅ React's default escaping (text content)
- ❌ `dangerouslySetInnerHTML` without DOMPurify

**Backend:**

- ✅ Zod validation on all inputs
- ✅ Sanitize user-generated content before storage

---

## 🟡 A07: Authentication Failures (MODERATE)

### Password Requirements

- Minimum 12 characters (enforced via Zod)
- No password complexity requirements (NIST 800-63B)
- No password expiration

### Rate Limiting

- [ ] Login endpoint: 5 attempts per 15 minutes per IP
- [ ] Registration endpoint: 10 attempts per hour per IP
- [ ] Password reset: 3 attempts per hour per email

### Session Management

- [ ] Refresh token rotation on use
- [ ] Logout invalidates refresh token
- [ ] No long-lived sessions without rotation

---

## 🔵 A06: Insecure Design (ADVISORY)

### Threat Modeling

For sensitive flows (auth, payments, admin actions):

- What can go wrong?
- How would an attacker abuse this?
- What's the worst-case scenario?

**Use `/security-audit` command or `security-auditor` agent for deep analysis**

---

## 🔵 A08-A10: Additional Advisories

### A08: Software and Data Integrity Failures

- [ ] Validate API responses before processing
- [ ] Webhook signature verification (Stripe, GitHub, etc.)
- [ ] CSRF protection on state-changing operations

### A09: Security Logging and Monitoring Failures

- [ ] Log authentication failures
- [ ] Log authorization failures (403)
- [ ] Log critical actions (role changes, owner transfer)
- [ ] Never log sensitive data (passwords, tokens, PII)

### A10: Server-Side Request Forgery (SSRF)

- [ ] Validate webhook URLs before making requests
- [ ] Whitelist allowed domains for external requests
- [ ] No user-controlled redirect targets

---

## General Security Principles

1. **Defense in Depth** — Multiple layers (auth middleware + RBAC + query filters)
2. **Fail Securely** — Default to deny access, not grant
3. **Least Privilege** — Grant minimum permissions needed
4. **Don't Trust Client** — Validate everything from requests
5. **Security by Design** — Consider security from first line of code

---

## Security Review Checklist

Before every commit:

- [ ] No sensitive data logged (passwords, tokens, PII)
- [ ] All inputs validated with Zod
- [ ] Auth middleware on protected routes
- [ ] Tenant isolation enforced (`req.tenantId` used)
- [ ] RBAC enforced with `requireRole()`
- [ ] Error responses sanitized (no stack traces)
- [ ] Security headers configured (helmet)
- [ ] Dependencies audited (`pnpm audit`)
- [ ] Tests cover 401, 403, 404 cases
- [ ] No hardcoded secrets in code

---

## Tools and Resources

- **Command**: `/security-audit` — Comprehensive OWASP Top 10 2025 audit
- **Agent**: `security-auditor` — Specialized security analysis and threat modeling
- **Hook**: `.claude/hooks/security-check.sh` — Pre-commit automated security checks
- **Skill**: `.claude/skills/security/owasp-top10.md` — Detailed guidance, patterns, and examples

---

**Last Updated:** 2026-06-11
**Version:** Streamlined from 820 lines to ~200 lines (detailed examples moved to skills)
