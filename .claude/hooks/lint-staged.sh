#!/bin/bash
# Pre-commit hook: Run Ruff and Black on staged Python files, ESLint/Prettier on TypeScript

set -e

echo "Running lint-staged..."

# =============================================================================
# Python files (backend)
# =============================================================================

STAGED_PY_FILES=$(git diff --cached --name-only --diff-filter=ACM | grep -E '\.py$' || true)

if [ -n "$STAGED_PY_FILES" ]; then
  echo "📝 Formatting Python files with Black..."
  if command -v black &> /dev/null; then
    black $STAGED_PY_FILES || {
      echo "❌ Black formatting failed"
      exit 1
    }
  else
    echo "⚠️  Black not installed - skipping Python formatting"
  fi

  echo "🔎 Linting Python files with Ruff..."
  if command -v ruff &> /dev/null; then
    ruff check $STAGED_PY_FILES --fix || {
      echo "❌ Ruff linting errors found"
      exit 1
    }
  else
    echo "⚠️  Ruff not installed - skipping Python linting"
  fi

  # Re-add formatted files
  git add $STAGED_PY_FILES
  echo "✅ Python lint and format passed"
fi

# =============================================================================
# TypeScript files (frontend)
# =============================================================================

STAGED_TS_FILES=$(git diff --cached --name-only --diff-filter=ACM | grep -E '\.tsx?$' || true)

if [ -n "$STAGED_TS_FILES" ]; then
  echo "Linting TypeScript files..."
  if command -v pnpm &> /dev/null; then
    pnpm eslint $STAGED_TS_FILES --fix || {
      echo "❌ ESLint errors found"
      exit 1
    }

    echo "Formatting TypeScript files..."
    pnpm prettier --write $STAGED_TS_FILES || {
      echo "❌ Prettier formatting failed"
      exit 1
    }
  else
    echo "⚠️  pnpm not installed - skipping TypeScript linting"
  fi

  # Re-add formatted files
  git add $STAGED_TS_FILES
  echo "✅ TypeScript lint and format passed"
fi

if [ -z "$STAGED_PY_FILES" ] && [ -z "$STAGED_TS_FILES" ]; then
  echo "No Python or TypeScript files staged, skipping lint"
fi

echo "✅ All lint and format checks passed"
exit 0
