#!/bin/bash
set -e

# Security Check Hook - Pre-commit validation for critical security issues
# Enforces OWASP Top 10 2025 critical vulnerabilities (A01, A02, A03)
# Exit code 0 = pass, non-zero = block commit

echo "🔐 Running security checks..."

SECURITY_ERRORS=0
SECURITY_WARNINGS=0

# Colors for output
RED='\033[0;31m'
YELLOW='\033[1;33m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

# Get list of staged Python files
STAGED_PY_FILES=$(git diff --cached --name-only --diff-filter=ACM | grep -E '\.py$' || true)

# Get list of staged TypeScript/JavaScript files (frontend)
STAGED_TS_FILES=$(git diff --cached --name-only --diff-filter=ACM | grep -E '\.(ts|tsx|js|jsx)$' || true)

if [ -z "$STAGED_PY_FILES" ] && [ -z "$STAGED_TS_FILES" ]; then
  echo "✅ No Python/TypeScript/JavaScript files to check"
  exit 0
fi

echo "Checking $(echo "$STAGED_PY_FILES $STAGED_TS_FILES" | wc -w) file(s)..."

# =============================================================================
# A01: Broken Access Control - CRITICAL (BLOCK)
# =============================================================================

echo ""
echo "🔴 A01: Checking for Broken Access Control vulnerabilities..."

# Check 1: User isolation - Missing user_id filter in queries (Python/Beanie)
if [ -n "$STAGED_PY_FILES" ]; then
  echo "  → Checking for missing user_id filter in Beanie queries..."
  MISSING_USER_FILTER=$(echo "$STAGED_PY_FILES" | xargs grep -nH '\.find\|\.find_one\|\.find_many' 2>/dev/null | grep -v 'user_id\|userId\|# no-user-check' || true)
  if [ -n "$MISSING_USER_FILTER" ]; then
    echo -e "${YELLOW}    ⚠️  WARNING: Beanie queries without user_id filter${NC}"
    echo "       Review these queries for user isolation (Phase 2):"
    echo "$MISSING_USER_FILTER" | head -5 | while read -r line; do
      echo "       $line"
    done
    echo "       → Add '# no-user-check' comment if intentional (e.g., Phase 1 MVP)"
    SECURITY_WARNINGS=$((SECURITY_WARNINGS + 1))
  fi
fi

# Check 2: Client-provided user_id (Python/FastAPI)
if [ -n "$STAGED_PY_FILES" ]; then
  echo "  → Checking for client-provided user_id..."
  CLIENT_USER_ID=$(echo "$STAGED_PY_FILES" | xargs grep -nH 'user_id.*request\.body\|user_id.*request\.query_params\|user_id.*request\.path_params' 2>/dev/null || true)
  if [ -n "$CLIENT_USER_ID" ]; then
    echo -e "${RED}    ❌ CRITICAL: Client-provided user_id detected${NC}"
    echo "$CLIENT_USER_ID" | while read -r line; do
      echo "       $line"
    done
    echo "       → Use current_user.id from JWT dependency instead"
    SECURITY_ERRORS=$((SECURITY_ERRORS + 1))
  fi
fi

# Check 3: Missing authentication dependency on routes (Python/FastAPI)
if [ -n "$STAGED_PY_FILES" ]; then
  echo "  → Checking for unprotected FastAPI routes..."
  UNPROTECTED_ROUTES=$(echo "$STAGED_PY_FILES" | xargs grep -nH '@router\.\(get\|post\|put\|patch\|delete\)' 2>/dev/null | grep -v 'Depends(get_current_user)\|# public-route' || true)
  if [ -n "$UNPROTECTED_ROUTES" ]; then
    echo -e "${YELLOW}    ⚠️  WARNING: Potential unprotected routes found${NC}"
    echo "       Review these routes to ensure they should be public (Phase 1 MVP may skip auth):"
    echo "$UNPROTECTED_ROUTES" | head -5 | while read -r line; do
      echo "       $line"
    done
    echo "       → Add '# public-route' comment if intentional"
    SECURITY_WARNINGS=$((SECURITY_WARNINGS + 1))
  fi
fi

# =============================================================================
# A02: Security Misconfiguration - CRITICAL (BLOCK)
# =============================================================================

echo ""
echo "🔴 A02: Checking for Security Misconfiguration..."

# Check 1: Stack traces in error responses (Python)
if [ -n "$STAGED_PY_FILES" ]; then
  echo "  → Checking for stack trace leakage in Python..."
  STACK_TRACE_LEAK=$(echo "$STAGED_PY_FILES" | xargs grep -nH 'traceback\|exc_info=True' 2>/dev/null | grep 'JSONResponse\|detail=' | grep -v 'logger\|log' || true)
  if [ -n "$STACK_TRACE_LEAK" ]; then
    echo -e "${RED}    ❌ CRITICAL: Stack trace leakage in response${NC}"
    echo "$STACK_TRACE_LEAK" | while read -r line; do
      echo "       $line"
    done
    echo "       → Log errors server-side, return sanitized errors to client"
    SECURITY_ERRORS=$((SECURITY_ERRORS + 1))
  fi
fi

# Check 2: Hardcoded secrets (Python)
if [ -n "$STAGED_PY_FILES" ]; then
  echo "  → Checking for hardcoded secrets in Python..."
  HARDCODED_SECRETS=$(echo "$STAGED_PY_FILES" | xargs grep -nHiE '(password|secret|api_key|apikey|token|jwt_secret|mongodb_url)\s*=\s*["\047][^"\047]{8,}' 2>/dev/null | grep -v 'settings\.\|os\.getenv\|PASSWORD_MIN\|SECRET_KEY_ALGORITHM' || true)
  if [ -n "$HARDCODED_SECRETS" ]; then
    echo -e "${RED}    ❌ CRITICAL: Hardcoded secrets detected${NC}"
    echo "$HARDCODED_SECRETS" | while read -r line; do
      echo "       $line"
    done
    echo "       → Use settings from environment variables (Pydantic BaseSettings)"
    SECURITY_ERRORS=$((SECURITY_ERRORS + 1))
  fi
fi

# Check 3: Missing CORS configuration (Python/FastAPI)
if [ -n "$STAGED_PY_FILES" ]; then
  echo "  → Checking for CORS middleware..."
  if echo "$STAGED_PY_FILES" | grep -q 'main\.py\|app\.py'; then
    CORS_MISSING=$(echo "$STAGED_PY_FILES" | xargs grep -L "from fastapi.middleware.cors import CORSMiddleware\|CORSMiddleware" 2>/dev/null | grep -E 'main\.py|app\.py' || true)
    if [ -n "$CORS_MISSING" ]; then
      echo -e "${YELLOW}    ⚠️  WARNING: CORSMiddleware not configured in FastAPI app${NC}"
      echo "       Add CORS middleware to prevent unauthorized cross-origin requests"
      SECURITY_WARNINGS=$((SECURITY_WARNINGS + 1))
    fi
  fi
fi

# =============================================================================
# A03: Software Supply Chain Failures - CRITICAL (WARN)
# =============================================================================

echo ""
echo "🔴 A03: Checking for Software Supply Chain Failures..."

# Check 1: Dependencies with known vulnerabilities (Python)
if [ -n "$STAGED_PY_FILES" ] && [ -f "backend/requirements.txt" ]; then
  echo "  → Running pip-audit (if installed)..."
  if command -v pip-audit &> /dev/null; then
    cd backend
    AUDIT_OUTPUT=$(pip-audit --desc 2>&1 || true)
    if echo "$AUDIT_OUTPUT" | grep -q "Found.*vulnerabilit"; then
      echo -e "${YELLOW}    ⚠️  WARNING: Vulnerabilities found in Python dependencies${NC}"
      echo "       Run: pip-audit"
      echo "       Run: pip install --upgrade <package> (to fix)"
      SECURITY_WARNINGS=$((SECURITY_WARNINGS + 1))
    fi
    cd ..
  else
    echo -e "${YELLOW}    ⚠️  WARNING: pip-audit not installed, skipping dependency audit${NC}"
    echo "       Install with: pip install pip-audit"
  fi
fi

# Check 2: Unsafe eval or exec usage (Python)
if [ -n "$STAGED_PY_FILES" ]; then
  echo "  → Checking for eval()/exec() usage in Python..."
  EVAL_USAGE=$(echo "$STAGED_PY_FILES" | xargs grep -nH '\beval\s*(\|\bexec\s*(' 2>/dev/null || true)
  if [ -n "$EVAL_USAGE" ]; then
    echo -e "${RED}    ❌ CRITICAL: eval() or exec() detected${NC}"
    echo "$EVAL_USAGE" | while read -r line; do
      echo "       $line"
    done
    echo "       → Avoid eval() and exec() - potential code injection"
    SECURITY_ERRORS=$((SECURITY_ERRORS + 1))
  fi
fi

# =============================================================================
# A04: Cryptographic Failures - MODERATE (WARN)
# =============================================================================

echo ""
echo "🟡 A04: Checking for Cryptographic Failures..."

# Check 1: Weak random number generation (Python)
if [ -n "$STAGED_PY_FILES" ]; then
  echo "  → Checking for weak random number generation in Python..."
  WEAK_RANDOM=$(echo "$STAGED_PY_FILES" | xargs grep -nH 'random\.random\|random\.randint' 2>/dev/null | grep -iE 'token|key|secret|id|nonce' || true)
  if [ -n "$WEAK_RANDOM" ]; then
    echo -e "${YELLOW}    ⚠️  WARNING: random.random() used for security-sensitive values${NC}"
    echo "$WEAK_RANDOM" | head -3 | while read -r line; do
      echo "       $line"
    done
    echo "       → Use secrets.token_urlsafe() or secrets.token_hex() for tokens/keys"
    SECURITY_WARNINGS=$((SECURITY_WARNINGS + 1))
  fi
fi

# Check 2: Weak hashing algorithms (Python)
if [ -n "$STAGED_PY_FILES" ]; then
  echo "  → Checking for weak hashing algorithms in Python..."
  WEAK_HASH=$(echo "$STAGED_PY_FILES" | xargs grep -nH "hashlib\.md5\|hashlib\.sha1" 2>/dev/null || true)
  if [ -n "$WEAK_HASH" ]; then
    echo -e "${YELLOW}    ⚠️  WARNING: Weak hashing algorithm detected (MD5/SHA1)${NC}"
    echo "$WEAK_HASH" | while read -r line; do
      echo "       $line"
    done
    echo "       → Use hashlib.sha256 or passlib/bcrypt for password hashing"
    SECURITY_WARNINGS=$((SECURITY_WARNINGS + 1))
  fi
fi

# Check 3: Passwords in logs (Python)
if [ -n "$STAGED_PY_FILES" ]; then
  echo "  → Checking for password logging in Python..."
  PASSWORD_LOGGING=$(echo "$STAGED_PY_FILES" | xargs grep -nHiE 'log.*password|print.*password' 2>/dev/null | grep -v 'PASSWORD_MIN\|password_hash\|password_reset_token' || true)
  if [ -n "$PASSWORD_LOGGING" ]; then
    echo -e "${YELLOW}    ⚠️  WARNING: Password may be logged${NC}"
    echo "$PASSWORD_LOGGING" | while read -r line; do
      echo "       $line"
    done
    echo "       → Never log passwords or sensitive data"
    SECURITY_WARNINGS=$((SECURITY_WARNINGS + 1))
  fi
fi

# =============================================================================
# A05: Injection - MODERATE (WARN)
# =============================================================================

echo ""
echo "🟡 A05: Checking for Injection vulnerabilities..."

# Check 1: Raw MongoDB queries (Python/Motor)
if [ -n "$STAGED_PY_FILES" ]; then
  echo "  → Checking for unsafe MongoDB queries in Python..."
  RAW_MONGO_UNSAFE=$(echo "$STAGED_PY_FILES" | xargs grep -nH 'db\.\w\+\.find(\|collection\.find(' 2>/dev/null | grep -v 'ResumeVariant\.find\|Application\.find\|User\.find' || true)
  if [ -n "$RAW_MONGO_UNSAFE" ]; then
    echo -e "${YELLOW}    ⚠️  WARNING: Raw MongoDB query detected${NC}"
    echo "$RAW_MONGO_UNSAFE" | while read -r line; do
      echo "       $line"
    done
    echo "       → Use Beanie ODM methods for type safety and query validation"
    SECURITY_WARNINGS=$((SECURITY_WARNINGS + 1))
  fi
fi

# Check 2: dangerouslySetInnerHTML in React (TypeScript)
if [ -n "$STAGED_TS_FILES" ]; then
  echo "  → Checking for XSS vulnerabilities in React..."
  DANGEROUS_HTML=$(echo "$STAGED_TS_FILES" | xargs grep -nH 'dangerouslySetInnerHTML' 2>/dev/null || true)
  if [ -n "$DANGEROUS_HTML" ]; then
    echo -e "${YELLOW}    ⚠️  WARNING: dangerouslySetInnerHTML detected${NC}"
    echo "$DANGEROUS_HTML" | while read -r line; do
      echo "       $line"
    done
    echo "       → Ensure HTML is sanitized with DOMPurify before rendering"
    SECURITY_WARNINGS=$((SECURITY_WARNINGS + 1))
  fi
fi

# Check 3: Command execution with user input (Python)
if [ -n "$STAGED_PY_FILES" ]; then
  echo "  → Checking for command injection risks in Python..."
  COMMAND_INJECTION=$(echo "$STAGED_PY_FILES" | xargs grep -nH 'os\.system\|subprocess\.call\|subprocess\.run' 2>/dev/null | grep -v 'shell=False\|check=True' || true)
  if [ -n "$COMMAND_INJECTION" ]; then
    echo -e "${YELLOW}    ⚠️  WARNING: Command execution detected${NC}"
    echo "$COMMAND_INJECTION" | while read -r line; do
      echo "       $line"
    done
    echo "       → Use subprocess with shell=False and validate all inputs"
    SECURITY_WARNINGS=$((SECURITY_WARNINGS + 1))
  fi
fi

# =============================================================================
# Summary
# =============================================================================

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "Security Check Summary"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

if [ $SECURITY_ERRORS -gt 0 ]; then
  echo -e "${RED}❌ CRITICAL ERRORS: $SECURITY_ERRORS${NC}"
  echo "   → These MUST be fixed before committing"
fi

if [ $SECURITY_WARNINGS -gt 0 ]; then
  echo -e "${YELLOW}⚠️  WARNINGS: $SECURITY_WARNINGS${NC}"
  echo "   → Review these issues (not blocking)"
fi

if [ $SECURITY_ERRORS -eq 0 ] && [ $SECURITY_WARNINGS -eq 0 ]; then
  echo -e "${GREEN}✅ No security issues detected${NC}"
fi

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# Exit with error if critical issues found
if [ $SECURITY_ERRORS -gt 0 ]; then
  echo -e "${RED}🚫 Commit blocked due to critical security issues${NC}"
  echo "   Fix the errors above and try again."
  echo ""
  exit 1
fi

if [ $SECURITY_WARNINGS -gt 0 ]; then
  echo -e "${YELLOW}⚠️  Commit allowed with warnings${NC}"
  echo "   Consider addressing warnings before pushing."
  echo ""
fi

echo -e "${GREEN}✅ Security check passed${NC}"
exit 0
