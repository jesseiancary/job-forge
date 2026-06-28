#!/bin/bash
# Pre-commit hook for Python backend code quality checks

set -e

echo "🔍 Running pre-commit checks..."

# Check if backend directory exists
if [ ! -d "backend" ]; then
    echo "⚠️  No backend/ directory found - skipping Python checks"
    exit 0
fi

cd backend

# 1. Format with Black
echo "📝 Formatting with Black..."
if command -v black &> /dev/null; then
    black app/ tests/ --check --quiet || {
        echo "❌ Black formatting issues found. Run: black backend/"
        exit 1
    }
    echo "✓ Black formatting OK"
else
    echo "⚠️  Black not installed - skipping formatting check"
fi

# 2. Lint with Ruff
echo "🔎 Linting with Ruff..."
if command -v ruff &> /dev/null; then
    ruff check app/ tests/ || {
        echo "❌ Ruff linting errors found. Run: ruff check backend/ --fix"
        exit 1
    }
    echo "✓ Ruff linting OK"
else
    echo "⚠️  Ruff not installed - skipping linting"
fi

# 3. Type check with mypy
echo "🔍 Type checking with mypy..."
if command -v mypy &> /dev/null; then
    mypy app/ --ignore-missing-imports || {
        echo "❌ mypy type errors found"
        exit 1
    }
    echo "✓ mypy type checking OK"
else
    echo "⚠️  mypy not installed - skipping type checking"
fi

# 4. Run tests
echo "🧪 Running tests..."
if command -v pytest &> /dev/null; then
    pytest tests/ -q --tb=short || {
        echo "❌ Tests failed"
        exit 1
    }
    echo "✓ All tests passed"
else
    echo "⚠️  pytest not installed - skipping tests"
fi

cd ..

echo "✅ All pre-commit checks passed!"
