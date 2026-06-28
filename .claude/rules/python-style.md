# Python Code Style Rules

## Formatting Tools

- **Black** - Opinionated code formatter (88 char line length)
- **Ruff** - Fast Python linter (replaces Flake8, isort, pyupgrade)
- **mypy** - Static type checker

## PEP 8 Compliance

Follow [PEP 8](https://peps.python.org/pep-0008/) with these specifics:

### Naming Conventions

- **Functions/variables**: `snake_case`
- **Classes**: `PascalCase`
- **Constants**: `SCREAMING_SNAKE_CASE`
- **Private methods**: `_leading_underscore`
- **Modules**: `lowercase_with_underscores.py`

```python
# Good
class UserService:
    MAX_RETRIES = 3

    def get_user_by_email(self, email: str) -> User | None:
        pass

    def _validate_email(self, email: str) -> bool:
        pass

# Bad
class userService:
    maxRetries = 3

    def getUserByEmail(self, Email: str):
        pass
```

### Type Hints

**ALWAYS use type hints** for function signatures and class attributes.

```python
# Good
from typing import List, Dict, Optional

def parse_resume(file_path: str) -> Dict[str, any]:
    pass

async def get_user(user_id: str) -> User | None:
    pass

class ResumeVariant:
    name: str
    summary: str
    experience: List[Dict]

# Bad - no type hints
def parse_resume(file_path):
    pass

async def get_user(user_id):
    pass
```

### Imports

Use **Ruff** to automatically sort imports:

```python
# Standard library
import os
import sys
from datetime import datetime
from typing import List, Dict

# Third-party
from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
from beanie import Document

# Local
from app.models.user import User
from app.services.llm_service import LLMService
```

### Docstrings

Use **Google-style docstrings**:

```python
def render_resume_to_latex(resume_data: dict, template: str = "default") -> str:
    """Render resume JSON to LaTeX using Jinja2 template.

    Args:
        resume_data: Dictionary containing resume structure (summary, experience, etc.)
        template: Name of the Jinja2 template to use (default: "default")

    Returns:
        LaTeX source code as string

    Raises:
        TemplateNotFoundError: If the specified template doesn't exist
        ValidationError: If resume_data is missing required fields
    """
    pass
```

### Line Length

- **88 characters** (Black default)
- Break long lines with parentheses (not backslashes)

```python
# Good
result = some_function(
    arg1="value1",
    arg2="value2",
    arg3="value3"
)

# Bad - backslash continuation
result = some_function(arg1="value1", \
                       arg2="value2")
```

### String Formatting

- **f-strings** for interpolation
- **str.format()** for complex formatting
- **Avoid `%` formatting**

```python
# Good
name = "Jesse"
message = f"Hello, {name}!"

# Acceptable for complex cases
template = "User {user.name} created {count} resumes"
message = template.format(user=user, count=count)

# Bad
message = "Hello, %s!" % name
```

## Async/Await

- **Always use `async`/`await`** for I/O operations (DB, HTTP, file system)
- **Never block the event loop** with synchronous I/O

```python
# Good - async all the way
async def create_resume_variant(data: dict) -> ResumeVariant:
    variant = ResumeVariant(**data)
    await variant.insert()
    return variant

# Bad - blocking DB call in async function
async def create_resume_variant(data: dict):
    variant = ResumeVariant(**data)
    variant.insert()  # Missing await - will fail!
    return variant
```

## Error Handling

- **Use specific exceptions** (not bare `except:`)
- **Raise custom exceptions** for domain errors
- **Log errors with context**

```python
# Good
from app.utils.errors import NotFoundError

async def get_resume_variant(variant_id: str) -> ResumeVariant:
    variant = await ResumeVariant.get(variant_id)
    if not variant:
        raise NotFoundError(f"Resume variant {variant_id} not found")
    return variant

# Bad - bare except
try:
    result = some_operation()
except:  # Bad - catches everything including KeyboardInterrupt
    pass
```

## Comments

- **Write self-documenting code** (descriptive names > comments)
- **Use comments sparingly** - explain "why", not "what"
- **Keep comments up to date** (outdated comments are worse than none)

```python
# Good - comment explains "why"
# Cache LaTeX source to avoid re-rendering on every request
resume_variant.latex_source = rendered_latex

# Bad - comment explains "what" (obvious)
# Set the latex source
resume_variant.latex_source = rendered_latex
```

## Code Organization

### File Structure

```python
# 1. Docstring
"""Module for resume variant CRUD operations."""

# 2. Imports (sorted by Ruff)
import os
from typing import List

from fastapi import APIRouter
from pydantic import BaseModel

from app.models.resume_variant import ResumeVariant

# 3. Constants
MAX_VARIANTS_PER_USER = 50

# 4. Classes/functions
class ResumeService:
    pass

async def get_resume_variants() -> List[ResumeVariant]:
    pass
```

### Function Length

- **Keep functions small** (<50 lines)
- **Extract helper functions** when logic becomes complex
- **One level of abstraction** per function

## Ruff Configuration

```toml
# pyproject.toml
[tool.ruff]
line-length = 88
select = [
    "E",   # pycodestyle errors
    "W",   # pycodestyle warnings
    "F",   # pyflakes
    "I",   # isort
    "N",   # pep8-naming
    "UP",  # pyupgrade
    "B",   # flake8-bugbear
    "C4",  # flake8-comprehensions
]
ignore = [
    "E501",  # Line too long (handled by Black)
]

[tool.ruff.isort]
known-first-party = ["app"]
```

## Black Configuration

```toml
# pyproject.toml
[tool.black]
line-length = 88
target-version = ["py311"]
```

## mypy Configuration

```toml
# pyproject.toml
[tool.mypy]
python_version = "3.11"
warn_return_any = true
warn_unused_configs = true
disallow_untyped_defs = true
```

## Pre-commit Hook

Run formatters/linters automatically:

```bash
# .claude/hooks/pre-commit.sh
#!/bin/bash

# Format with Black
black apps/api/

# Lint with Ruff
ruff check apps/api/ --fix

# Type check with mypy
mypy apps/api/

# Run tests
pytest apps/api/tests/
```

## Commands

```bash
# Format code
black apps/api/

# Check formatting (CI)
black apps/api/ --check

# Lint
ruff check apps/api/

# Auto-fix linting issues
ruff check apps/api/ --fix

# Type check
mypy apps/api/

# Run all checks
black apps/api/ && ruff check apps/api/ && mypy apps/api/ && pytest
```

## Anti-Patterns to Avoid

### Don't use mutable default arguments

```python
# Bad
def add_bullet(bullets: List[str] = []) -> List[str]:
    bullets.append("New bullet")
    return bullets

# Good
def add_bullet(bullets: List[str] | None = None) -> List[str]:
    if bullets is None:
        bullets = []
    bullets.append("New bullet")
    return bullets
```

### Don't ignore type errors

```python
# Bad
result = some_function()  # type: ignore

# Good - fix the actual type issue
result: str = some_function()
```

### Don't catch Exception too broadly

```python
# Bad
try:
    result = await db_operation()
except Exception:
    return None  # Hides bugs!

# Good
from pymongo.errors import ConnectionFailure

try:
    result = await db_operation()
except ConnectionFailure as e:
    logger.error(f"DB connection failed: {e}")
    raise
```

## Testing Style

```python
import pytest

# Use descriptive test names
def test_resume_variant_creation_with_valid_data():
    pass

# Use fixtures for setup
@pytest.fixture
async def sample_resume_data():
    return {
        "name": "full-stack",
        "summary": "Test summary",
        "experience": []
    }

# Use parametrize for multiple cases
@pytest.mark.parametrize("invalid_email", [
    "notanemail",
    "@example.com",
    "test@",
])
async def test_email_validation_rejects_invalid_emails(invalid_email):
    pass
```
