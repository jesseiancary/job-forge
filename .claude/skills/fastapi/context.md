# FastAPI Skill Context

Auto-loaded when working on Python backend API development.

## Framework Overview

**FastAPI** is a modern Python web framework for building APIs with automatic OpenAPI documentation, Pydantic validation, and async support.

## Project Structure (Future)

```
apps/api/
├── app/
│   ├── main.py              # FastAPI app initialization
│   ├── config.py            # Environment variables with Pydantic Settings
│   ├── database.py          # MongoDB + Beanie initialization
│   ├── models/              # Beanie document models
│   │   ├── user.py
│   │   ├── resume_variant.py
│   │   └── application.py
│   ├── schemas/             # Pydantic request/response schemas
│   │   ├── user.py
│   │   └── resume.py
│   ├── routers/             # FastAPI routers (endpoints)
│   │   ├── users.py
│   │   ├── resumes.py
│   │   └── applications.py
│   ├── services/            # Business logic
│   │   ├── llm_service.py
│   │   ├── latex_service.py
│   │   └── pdf_service.py
│   ├── middleware/          # Custom middleware
│   │   └── auth.py
│   └── utils/
│       ├── errors.py        # Custom exceptions
│       └── validators.py
├── tests/
│   ├── conftest.py          # Pytest fixtures
│   ├── test_users.py
│   └── test_resumes.py
├── templates/               # Jinja2 LaTeX templates
│   └── resume.tex.jinja2
└── requirements.txt
```

## Core Patterns

### 1. Application Setup

```python
# app/main.py
from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from contextlib import asynccontextmanager

from app.database import init_db, close_db
from app.routers import users, resumes, applications

@asynccontextmanager
async def lifespan(app: FastAPI):
    # Startup: Initialize database
    await init_db()
    yield
    # Shutdown: Close database connection
    await close_db()

app = FastAPI(
    title="Job-Forge API",
    version="1.0.0",
    lifespan=lifespan
)

# CORS middleware
app.add_middleware(
    CORSMiddleware,
    allow_origins=["http://localhost:5173"],  # Vite dev server
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Register routers
app.include_router(users.router, prefix="/api/v1/users", tags=["users"])
app.include_router(resumes.router, prefix="/api/v1/resumes", tags=["resumes"])
app.include_router(applications.router, prefix="/api/v1/applications", tags=["applications"])

@app.get("/health")
async def health_check():
    return {"status": "healthy"}
```

### 2. Pydantic Models (Schemas)

```python
# app/schemas/resume.py
from pydantic import BaseModel, Field
from typing import List
from datetime import datetime

class ExperienceBullet(BaseModel):
    text: str = Field(..., min_length=10, max_length=500)
    order: int = Field(..., ge=0)

class ExperienceEntry(BaseModel):
    company: str = Field(..., min_length=1, max_length=100)
    title: str
    location: str
    dates: str  # e.g., "Jan 2020 – Present"
    bullets: List[ExperienceBullet]

class ResumeVariantCreate(BaseModel):
    name: str = Field(..., min_length=1, max_length=50)
    summary: str = Field(..., min_length=50, max_length=1000)
    experience: List[ExperienceEntry]
    # ... education, skills, etc.

class ResumeVariantResponse(BaseModel):
    id: str
    user_id: str
    name: str
    summary: str
    experience: List[ExperienceEntry]
    created_at: datetime
    updated_at: datetime

    class Config:
        from_attributes = True  # Formerly orm_mode in Pydantic v1
```

### 3. Beanie Document Models

```python
# app/models/resume_variant.py
from beanie import Document
from pydantic import Field
from datetime import datetime
from typing import List

class ResumeVariant(Document):
    user_id: str = Field(..., index=True)
    name: str
    summary: str
    experience: List[dict]  # Embedded experience entries
    education: List[dict]
    skills: dict
    latex_source: str | None = None  # Generated LaTeX (cached)
    created_at: datetime = Field(default_factory=datetime.utcnow)
    updated_at: datetime = Field(default_factory=datetime.utcnow)

    class Settings:
        name = "resume_variants"
        indexes = [
            "user_id",
            [("user_id", 1), ("name", 1)],  # Compound index
        ]
```

### 4. Route Handlers

```python
# app/routers/resumes.py
from fastapi import APIRouter, HTTPException, Depends, status
from typing import List

from app.models.resume_variant import ResumeVariant
from app.schemas.resume import ResumeVariantCreate, ResumeVariantResponse
from app.middleware.auth import get_current_user

router = APIRouter()

@router.post("/", response_model=ResumeVariantResponse, status_code=status.HTTP_201_CREATED)
async def create_resume_variant(
    resume: ResumeVariantCreate,
    current_user: dict = Depends(get_current_user)
):
    # Create new resume variant
    resume_doc = ResumeVariant(
        user_id=current_user["id"],
        name=resume.name,
        summary=resume.summary,
        experience=[exp.dict() for exp in resume.experience],
        # ...
    )
    await resume_doc.insert()

    return ResumeVariantResponse(**resume_doc.dict())

@router.get("/", response_model=List[ResumeVariantResponse])
async def list_resume_variants(current_user: dict = Depends(get_current_user)):
    variants = await ResumeVariant.find(
        ResumeVariant.user_id == current_user["id"]
    ).to_list()

    return [ResumeVariantResponse(**v.dict()) for v in variants]

@router.get("/{variant_id}", response_model=ResumeVariantResponse)
async def get_resume_variant(
    variant_id: str,
    current_user: dict = Depends(get_current_user)
):
    variant = await ResumeVariant.get(variant_id)

    if not variant or variant.user_id != current_user["id"]:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Resume variant not found"
        )

    return ResumeVariantResponse(**variant.dict())

@router.patch("/{variant_id}", response_model=ResumeVariantResponse)
async def update_resume_variant(
    variant_id: str,
    updates: dict,
    current_user: dict = Depends(get_current_user)
):
    variant = await ResumeVariant.get(variant_id)

    if not variant or variant.user_id != current_user["id"]:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Resume variant not found"
        )

    # Update fields
    for field, value in updates.items():
        setattr(variant, field, value)

    variant.updated_at = datetime.utcnow()
    await variant.save()

    return ResumeVariantResponse(**variant.dict())

@router.delete("/{variant_id}", status_code=status.HTTP_204_NO_CONTENT)
async def delete_resume_variant(
    variant_id: str,
    current_user: dict = Depends(get_current_user)
):
    variant = await ResumeVariant.get(variant_id)

    if not variant or variant.user_id != current_user["id"]:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Resume variant not found"
        )

    await variant.delete()
    return None
```

### 5. Dependency Injection (Auth)

```python
# app/middleware/auth.py
from fastapi import Depends, HTTPException, status
from fastapi.security import HTTPBearer, HTTPAuthorizationCredentials
import jwt

from app.config import settings

security = HTTPBearer()

async def get_current_user(
    credentials: HTTPAuthorizationCredentials = Depends(security)
) -> dict:
    token = credentials.credentials

    try:
        payload = jwt.decode(token, settings.JWT_SECRET, algorithms=["HS256"])
        user_id = payload.get("sub")

        if user_id is None:
            raise HTTPException(
                status_code=status.HTTP_401_UNAUTHORIZED,
                detail="Invalid token"
            )

        return {"id": user_id}

    except jwt.ExpiredSignatureError:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Token expired"
        )
    except jwt.JWTError:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Invalid token"
        )
```

### 6. Error Handling

```python
# app/utils/errors.py
from fastapi import HTTPException, status

class AppError(HTTPException):
    def __init__(self, message: str, status_code: int = 400):
        super().__init__(status_code=status_code, detail=message)

class NotFoundError(AppError):
    def __init__(self, resource: str):
        super().__init__(f"{resource} not found", status_code=status.HTTP_404_NOT_FOUND)

class UnauthorizedError(AppError):
    def __init__(self, message: str = "Unauthorized"):
        super().__init__(message, status_code=status.HTTP_401_UNAUTHORIZED)

class ValidationError(AppError):
    def __init__(self, message: str):
        super().__init__(message, status_code=status.HTTP_400_BAD_REQUEST)
```

## Testing with Pytest

```python
# tests/test_resumes.py
import pytest
from httpx import AsyncClient
from app.main import app

@pytest.fixture
async def client():
    async with AsyncClient(app=app, base_url="http://test") as ac:
        yield ac

@pytest.fixture
async def auth_token(client):
    # Create test user and return JWT token
    response = await client.post("/api/v1/auth/register", json={
        "email": "test@example.com",
        "password": "testpass123"
    })
    return response.json()["access_token"]

@pytest.mark.asyncio
async def test_create_resume_variant(client, auth_token):
    headers = {"Authorization": f"Bearer {auth_token}"}

    response = await client.post("/api/v1/resumes/", headers=headers, json={
        "name": "full-stack",
        "summary": "Test summary...",
        "experience": [...]
    })

    assert response.status_code == 201
    data = response.json()
    assert data["name"] == "full-stack"

@pytest.mark.asyncio
async def test_list_resume_variants(client, auth_token):
    headers = {"Authorization": f"Bearer {auth_token}"}

    response = await client.get("/api/v1/resumes/", headers=headers)

    assert response.status_code == 200
    assert isinstance(response.json(), list)
```

## Best Practices

1. **Use type hints everywhere** - FastAPI auto-generates docs from types
2. **Pydantic for validation** - Leverage Field() constraints
3. **Async all the way** - Route handlers, DB queries, external API calls
4. **Dependency injection** - Use Depends() for auth, DB connections, services
5. **Response models** - Define explicit response schemas for type safety
6. **Error handling** - Use HTTPException with proper status codes
7. **Testing** - Write async tests with pytest-asyncio

## Common Commands

```bash
# Run development server (auto-reload)
uvicorn app.main:app --reload --host 0.0.0.0 --port 8000

# Run tests
pytest tests/ -v

# Run tests with coverage
pytest tests/ --cov=app --cov-report=html

# Type checking
mypy app/

# Linting
ruff check app/

# Format code
black app/
```

## References

- [FastAPI Documentation](https://fastapi.tiangolo.com/)
- [Pydantic v2 Documentation](https://docs.pydantic.dev/)
- [Pytest-asyncio](https://pytest-asyncio.readthedocs.io/)
