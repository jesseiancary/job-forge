#!/bin/bash
# Test runner for Python backend with coverage reporting

set -e

# Check if backend directory exists
if [ ! -d "backend" ]; then
    echo "❌ No backend/ directory found"
    exit 1
fi

cd backend

# Check if pytest is installed
if ! command -v pytest &> /dev/null; then
    echo "❌ pytest not installed. Install with: pip install pytest pytest-asyncio pytest-cov"
    exit 1
fi

echo "🧪 Running tests with coverage..."
echo ""

# Run pytest with coverage
pytest tests/ \
    --cov=app \
    --cov-report=term-missing \
    --cov-report=html \
    -v \
    "$@"

echo ""
echo "✅ Tests complete!"
echo "📊 Coverage report generated: backend/htmlcov/index.html"
