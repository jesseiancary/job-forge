# FastAPI API Conventions

## URL Structure

Base path: `/api/v1`

Format: `/resource` or `/resource/{id}`

Examples:
- `GET /api/v1/resumes` - List all resume variants
- `POST /api/v1/resumes` - Create new resume variant
- `GET /api/v1/resumes/{variant_id}` - Get specific variant
- `PATCH /api/v1/resumes/{variant_id}` - Update variant
- `DELETE /api/v1/resumes/{variant_id}` - Delete variant
- `POST /api/v1/applications` - Create job application

## HTTP Methods

- `GET` - Retrieve resources (idempotent, cacheable)
- `POST` - Create new resources
- `PATCH` - Partial update
- `PUT` - Full replacement (rarely used)
- `DELETE` - Remove resources (idempotent)

## Status Codes

- `200 OK` - Successful GET/PATCH
- `201 Created` - Successful POST (include resource in body)
- `204 No Content` - Successful DELETE (no body)
- `400 Bad Request` - Validation error (Pydantic)
- `401 Unauthorized` - Missing or invalid authentication
- `403 Forbidden` - Authenticated but insufficient permissions (Phase 2+)
- `404 Not Found` - Resource doesn't exist
- `409 Conflict` - Duplicate resource (e.g., resume name already exists)
- `422 Unprocessable Entity` - Pydantic validation error (auto-generated)
- `500 Internal Server Error` - Unexpected error (never expose internals)

## Request/Response Models

**Always use Pydantic models** for type safety and automatic validation.

```python
from pydantic import BaseModel, Field
from typing import List

# Request model (for POST/PATCH)
class ResumeVariantCreate(BaseModel):
    name: str = Field(..., min_length=1, max_length=50)
    summary: str = Field(..., min_length=50, max_length=1000)
    experience: List[dict]

# Response model (what API returns)
class ResumeVariantResponse(BaseModel):
    id: str
    user_id: str
    name: str
    summary: str
    created_at: datetime
    updated_at: datetime

    class Config:
        from_attributes = True  # Allows conversion from Beanie documents
```

## Route Handlers

```python
from fastapi import APIRouter, HTTPException, status, Depends

router = APIRouter(prefix="/api/v1/resumes", tags=["resumes"])

@router.post("/", response_model=ResumeVariantResponse, status_code=status.HTTP_201_CREATED)
async def create_resume_variant(
    resume: ResumeVariantCreate,
    current_user: dict = Depends(get_current_user)
) -> ResumeVariantResponse:
    # Validation handled automatically by Pydantic
    variant = ResumeVariant(user_id=current_user["id"], **resume.dict())
    await variant.insert()
    return ResumeVariantResponse(**variant.dict())

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
    return variant

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
    return None  # 204 No Content
```

## Error Handling

### Standard Error Response Format

```json
{
  "detail": "Resume variant not found"
}
```

FastAPI auto-generates this for HTTPException.

### Custom Error Responses

```python
from fastapi import HTTPException, status

# Simple error
raise HTTPException(
    status_code=status.HTTP_404_NOT_FOUND,
    detail="Resume variant not found"
)

# Error with additional context
raise HTTPException(
    status_code=status.HTTP_409_CONFLICT,
    detail="A resume variant with this name already exists",
    headers={"X-Error-Code": "DUPLICATE_NAME"}
)
```

### Global Exception Handler

```python
from fastapi import Request
from fastapi.responses import JSONResponse

@app.exception_handler(Exception)
async def global_exception_handler(request: Request, exc: Exception):
    # Log error with context
    logger.error(f"Unhandled exception: {exc}", exc_info=True)

    # Return generic error (don't leak internals)
    return JSONResponse(
        status_code=500,
        content={"detail": "Internal server error"}
    )
```

## Validation

Pydantic automatically validates:
- Required fields
- Type constraints
- Field validators

```python
from pydantic import BaseModel, Field, validator

class ResumeVariantCreate(BaseModel):
    name: str = Field(..., min_length=1, max_length=50)
    summary: str = Field(..., min_length=50)

    @validator('name')
    def name_must_be_alphanumeric(cls, v):
        if not v.replace('-', '').replace('_', '').isalnum():
            raise ValueError('Name must be alphanumeric (hyphens/underscores allowed)')
        return v.lower()
```

## Authentication (Phase 2)

```python
from fastapi import Depends
from fastapi.security import HTTPBearer, HTTPAuthorizationCredentials
import jwt

security = HTTPBearer()

async def get_current_user(
    credentials: HTTPAuthorizationCredentials = Depends(security)
) -> dict:
    token = credentials.credentials

    try:
        payload = jwt.decode(token, SECRET_KEY, algorithms=["HS256"])
        return {"id": payload["sub"]}
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

# Usage
@router.get("/resumes")
async def list_resumes(current_user: dict = Depends(get_current_user)):
    pass
```

## Pagination

For listing endpoints, use cursor-based pagination:

```python
from typing import List, Optional

@router.get("/", response_model=List[ResumeVariantResponse])
async def list_resume_variants(
    skip: int = 0,
    limit: int = 20,
    current_user: dict = Depends(get_current_user)
):
    variants = await ResumeVariant.find(
        ResumeVariant.user_id == current_user["id"]
    ).skip(skip).limit(limit).to_list()

    return variants
```

## CORS

```python
from fastapi.middleware.cors import CORSMiddleware

app.add_middleware(
    CORSMiddleware,
    allow_origins=[
        "http://localhost:5173",  # Vite dev server
        "https://job-forge.vercel.app",  # Production frontend
    ],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)
```

## File Uploads

```python
from fastapi import File, UploadFile

@router.post("/upload-signature")
async def upload_signature(
    file: UploadFile = File(...),
    current_user: dict = Depends(get_current_user)
):
    # Validate file type
    if file.content_type not in ["image/png", "image/jpeg"]:
        raise HTTPException(
            status_code=400,
            detail="Only PNG/JPEG files allowed"
        )

    # Read and process file
    contents = await file.read()

    # Save to S3 or local storage
    # ...

    return {"filename": file.filename, "size": len(contents)}
```

## Background Tasks

```python
from fastapi import BackgroundTasks

async def send_notification(email: str, message: str):
    # Send email notification
    pass

@router.post("/applications")
async def create_application(
    data: ApplicationCreate,
    background_tasks: BackgroundTasks,
    current_user: dict = Depends(get_current_user)
):
    # Create application
    app = await Application.create(...)

    # Send notification in background
    background_tasks.add_task(send_notification, current_user["email"], "Application created")

    return app
```

## Testing

```python
import pytest
from httpx import AsyncClient
from app.main import app

@pytest.mark.asyncio
async def test_create_resume_variant():
    async with AsyncClient(app=app, base_url="http://test") as client:
        response = await client.post(
            "/api/v1/resumes",
            json={"name": "test", "summary": "..." * 20},
            headers={"Authorization": "Bearer test-token"}
        )

        assert response.status_code == 201
        data = response.json()
        assert data["name"] == "test"
```

## API Documentation

FastAPI auto-generates OpenAPI docs at:
- `/docs` - Swagger UI (interactive)
- `/redoc` - ReDoc (alternative UI)

Customize with docstrings:

```python
@router.post(
    "/",
    response_model=ResumeVariantResponse,
    status_code=201,
    summary="Create resume variant",
    description="Create a new resume variant with structured JSON content"
)
async def create_resume_variant(resume: ResumeVariantCreate):
    """
    Create a new resume variant.

    - **name**: Unique name for this variant (e.g., "full-stack")
    - **summary**: Professional summary (50-1000 chars)
    - **experience**: Array of job experience entries
    """
    pass
```

## Best Practices

1. **Use dependency injection** for auth, DB connections, services
2. **Define response models** for type safety and auto-docs
3. **Validate all inputs** with Pydantic
4. **Use async/await** consistently
5. **Handle errors gracefully** with appropriate status codes
6. **Don't expose stack traces** in production
7. **Use background tasks** for slow operations (email, PDF generation)
8. **Test all endpoints** with pytest + httpx
