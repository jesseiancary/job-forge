#!/bin/bash
# Pre-edit hook: Validate Python and TypeScript types before Claude makes changes

set -e

echo "Running type checks before edit..."

# =============================================================================
# Python type checking (mypy)
# =============================================================================

if [ -d "backend" ]; then
  echo "🔍 Checking Python types with mypy..."
  if command -v mypy &> /dev/null; then
    cd backend
    mypy app/ --ignore-missing-imports --no-error-summary 2>&1 || {
      echo "⚠️  Python type errors detected. Claude will proceed but may need to fix type issues."
    }
    cd ..
  else
    echo "⚠️  mypy not installed - skipping Python type check"
  fi
fi

# =============================================================================
# TypeScript type checking (tsc)
# =============================================================================

if [ -f "package.json" ]; then
  echo "🔍 Checking TypeScript types..."
  if command -v pnpm &> /dev/null; then
    pnpm typecheck --silent 2>&1 || {
      echo "⚠️  TypeScript type errors detected. Claude will proceed but may need to fix type issues."
    }
  else
    echo "⚠️  pnpm not installed - skipping TypeScript type check"
  fi
fi

echo "✅ Type checks complete"
exit 0  # Don't block edits, just warn
