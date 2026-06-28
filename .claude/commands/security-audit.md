# Security Audit Command

Comprehensive security audit based on OWASP Top 10 2025 for Job-Forge (Python/FastAPI + React/Apollo Client).

## Usage

```
/security-audit
```

This command invokes the `security-auditor` agent to perform a thorough security review of the codebase, identifying vulnerabilities across all OWASP Top 10 2025 categories.

## What This Command Does

When you run `/security-audit`, it:

1. **Launches the security-auditor agent** with full read access to the codebase
2. **Runs automated scans** (pip-audit, bandit, security-check.sh hook)
3. **Performs manual code review** against OWASP Top 10 2025
4. **Generates a comprehensive report** with prioritized findings
5. **Provides specific remediation guidance** for each vulnerability

## Audit Scope

The security audit covers:

- **Backend** (`backend/app/`) - FastAPI, Beanie ODM, MongoDB
- **Frontend** (`frontend/src/`) - React 19, Apollo Client, Axios
- **LaTeX Templates** (`resumes/`, `applied/`) - LaTeX injection risks
- **Dependencies** (Python requirements, npm packages)
- **Configuration** (`.env`, Pydantic settings)
- **Infrastructure** (hooks, deployment configs)

## Quick Pre-Audit Checks

Before invoking the agent, run these automated tools:

```bash
# Python dependency audit
cd backend && pip-audit

# Python security linter
cd backend && bandit -r app/

# Security check hook
./.claude/hooks/security-check.sh

# Test coverage
cd backend && pytest tests/ --cov=app --cov-report=term-missing
```

## Expected Output

The security-auditor agent will provide a detailed report in this format:

### Executive Summary

-  Total issues found
- Severity breakdown (Critical/Moderate/Advisory)
- Overall security posture assessment

### Detailed Findings

For each vulnerability:

- **Category:** A0X: [Vulnerability Name]
- **Severity:** Critical/Moderate/Advisory
- **Location:** `file:line`
- **Description:** What's wrong
- **Impact:** Potential damage
- **Remediation:** Specific code changes needed
- **Test:** How to verify the fix

### Priority Ranking

1. **Critical issues** (fix immediately) - LaTeX injection, user isolation failures (Phase 2)
2. **Moderate issues** (fix within 1 week) - Weak crypto, missing rate limiting (Phase 2)
3. **Advisory items** (document and plan) - Logging gaps, threat modeling

## Phase-Specific Focus

### Phase 1 (MVP - Current)

**Primary Risks:**
- LaTeX command injection (CRITICAL)
- NoSQL injection
- Stack trace leakage
- Hardcoded secrets
- Dependency vulnerabilities

**Lower Priority (No Auth):**
- Access control (no authentication yet)
- Rate limiting (single user)
- Password hashing (no passwords)

### Phase 2 (Multi-User)

**New Risks:**
- User isolation failures
- IDOR vulnerabilities
- Authentication bypass
- Token leakage
- Cross-user data access

## Follow-Up Actions

After the audit:

1. **Triage findings** by severity
2. **Fix critical issues immediately** (LaTeX injection, secrets leakage)
3. **Create tickets for moderate issues** (1-week SLA)
4. **Document advisory items** for future sprints
5. **Update tests** to cover found vulnerabilities
6. **Re-run audit** to verify fixes
7. **Schedule next audit** (quarterly recommended)

## Continuous Security Monitoring

Add to CI/CD pipeline:

```yaml
# .github/workflows/security.yml
name: Security Audit
on: [push, pull_request]

jobs:
  python-security:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-python@v5
        with:
          python-version: '3.11'
      - run: pip install pip-audit bandit
      - run: pip-audit -r backend/requirements.txt
      - run: bandit -r backend/app/
      - run: ./.claude/hooks/security-check.sh
```

## Manual Code Review Guidance

If you prefer to audit manually (without the agent), follow the patterns in `.claude/agents/security-auditor.md`:

### Critical Checks (A01-A03)

```bash
# A01: Check for client-provided user_id (Phase 2)
grep -r "user_id.*request.body" backend/app/

# A01: Check for missing user isolation (Phase 2)
grep -r "\.find\|\.find_one" backend/app/ | grep -v "user_id" | grep -v "# no-user-check"

# A02: Check for stack trace leakage
grep -r "traceback\|exc_info=True" backend/app/ | grep "detail="

# A02: Check for hardcoded secrets
grep -ri "password.*=.*['\"]" backend/app/ | grep -v "settings\."

# A03: Check for eval/exec usage
grep -r "\\beval(\\|\\bexec(" backend/app/

# A05: Check for LaTeX injection risks
grep -r "xelatex\|pdflatex\|subprocess" backend/app/
```

### Moderate Checks (A04-A07)

```bash
# A04: Check for weak random
grep -r "random\.random\|random\.randint" backend/app/ | grep -i "token\|key"

# A04: Check for weak hashing
grep -r "hashlib\.md5\|hashlib\.sha1" backend/app/

# A05: Check for raw MongoDB queries
grep -r "db\.\|collection\." backend/app/ | grep -v "AsyncIOMotorClient"

# A05: Check for command injection
grep -r "os\.system\|subprocess" backend/app/ | grep -v "shell=False"

# A07: Check for token storage (frontend)
grep -r "localStorage.*token" frontend/src/
```

## Resources

- [.claude/agents/security-auditor.md](../agents/security-auditor.md) - Detailed OWASP Top 10 patterns
- [.claude/hooks/security-check.sh](../hooks/security-check.sh) - Automated security validation
- [.claude/rules/security.md](../rules/security.md) - Security rules reference (if exists)
- [OWASP Top 10 2025](https://owasp.org/www-project-top-ten/) - Official OWASP documentation

## Example Invocation

```bash
# In Claude Code, run:
/security-audit

# The agent will:
# 1. Run pip-audit and bandit
# 2. Execute security-check.sh hook
# 3. Review codebase against OWASP Top 10
# 4. Generate comprehensive report with findings
# 5. Provide remediation guidance
```

## Notes

- **Proactive usage**: Run before each release
- **Reactive usage**: Run after security incident or vulnerability report
- **Regular cadence**: Quarterly audits recommended
- **Scope**: Full codebase scan (backend + frontend + templates)
- **Output**: Detailed markdown report with actionable remediation steps
