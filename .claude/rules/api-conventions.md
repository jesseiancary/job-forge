# API Conventions (FastAPI + REST)

## URL Structure

Base path: `/api/v1`

Format: `noun-plural/{resource_id}/sub-resource`

Examples (Phase 1 - user-scoped):

- `GET /api/v1/resumes` - List all resume variants for current user
- `POST /api/v1/resumes` - Create new resume variant
- `GET /api/v1/resumes/{variant_id}` - Get specific variant
- `PATCH /api/v1/resumes/{variant_id}` - Update variant
- `DELETE /api/v1/resumes/{variant_id}` - Delete variant
- `GET /api/v1/applications` - List applications
- `POST /api/v1/applications` - Create application
- `GET /api/v1/personal-info` - Get personal info (singleton)

## HTTP Methods

- `GET` — retrieve resources (idempotent)
- `POST` — create new resources
- `PUT` — full resource replacement (not used in Job-Forge)
- `PATCH` — partial update (preferred for updates)
- `DELETE` — remove resources (idempotent)

## Status Codes

- `200` — success with body (GET, PATCH)
- `201` — resource created (POST, include Location header)
- `204` — success, no body (DELETE operations)
- `400` — business logic error (e.g., cannot delete last variant)
- `401` — unauthenticated (missing or invalid JWT token)
- `404` — resource not found (OR user lacks access - don't leak existence)
- `409` — conflict (duplicate name, variant in use, etc.)
- `422` — validation error (Pydantic, FastAPI default)
- `429` — rate limited
- `500` — unexpected server error (never expose internals)

## Error Response Format

FastAPI uses standard error response format:

**422 Validation Error (Pydantic):**

```json
{
  "detail": [
    {
      "loc": ["body", "name"],
      "msg": "ensure this value has at most 100 characters",
      "type": "value_error.any_str.max_length"
    }
  ]
}
```

**400/404/409 Business Logic Error (HTTPException):**

```json
{
  "detail": "Cannot delete last resume variant"
}
```

**Custom AppError (optional, for richer errors):**

```python
from fastapi import HTTPException

class AppError(HTTPException):
    def __init__(self, message: str, status_code: int, code: str):
        super().__init__(status_code=status_code, detail={
            "code": code,
            "message": message
        })

# Usage:
raise AppError("Variant is in use", 409, "VARIANT_IN_USE")
```

## Request Validation

- **All inputs are validated with Pydantic** models automatically by FastAPI.
- **Validation order:** Path params → Query params → Headers → Body
- **FastAPI returns 422** automatically for Pydantic validation failures.
- **Use Field() constraints** for validation rules (min_length, max_length, regex, etc.)

```python
from pydantic import BaseModel, Field

class ResumeCreate(BaseModel):
    name: str = Field(..., min_length=1, max_length=100)
    description: Optional[str] = Field(None, max_length=500)
```

## Pagination

Offset-based (Phase 1) using `?skip=` + `?limit=` query params.

- Default skip: 0
- Default limit: 20
- Max limit: 100
- Response: Direct array (simple)

```python
@router.get("/resumes", response_model=List[ResumeResponse])
async def list_resumes(
    skip: int = 0,
    limit: int = 20,
    current_user: dict = Depends(get_current_user)
):
    variants = await ResumeVariant.find(
        ResumeVariant.user_id == current_user["id"]
    ).sort([("created_at", -1)]).skip(skip).limit(limit).to_list()

    return variants
```

**Phase 3+:** Cursor-based pagination for larger datasets.

## Authentication (Phase 2)

- **JWT access tokens** for user sessions: `Authorization: Bearer <access_token>`
- **httpOnly cookies** for refresh tokens (not accessible to JavaScript)
- **Phase 1**: Single-user MVP (no auth required)

```python
from fastapi import Depends, HTTPException
from fastapi.security import HTTPBearer, HTTPAuthorizationCredentials
import jwt

security = HTTPBearer()

async def get_current_user(
    credentials: HTTPAuthorizationCredentials = Depends(security)
) -> dict:
    """Extract user from JWT token."""
    try:
        payload = jwt.decode(credentials.credentials, SECRET_KEY, algorithms=["HS256"])
        return {"id": payload["user_id"], "email": payload["email"]}
    except jwt.ExpiredSignatureError:
        raise HTTPException(status_code=401, detail="Token expired")
    except jwt.InvalidTokenError:
        raise HTTPException(status_code=401, detail="Invalid token")
```

## User Isolation (Phase 2)

- **CRITICAL:** `user_id` must ALWAYS be sourced from `current_user["id"]` (derived from JWT).
- **NEVER** trust the client to provide `user_id` in the request body or query params.
- **All Beanie queries** must filter by `user_id` to enforce user isolation.
- Cross-user access is a security bug, not a feature.

```python
# ❌ BAD - user_id from request body (CRITICAL SECURITY BUG!)
@router.post("/resumes")
async def create(data: dict):
    variant = ResumeVariant(user_id=data["user_id"])  # Client can pass ANY user_id!

# ✅ GOOD - user_id from JWT
@router.post("/resumes")
async def create(
    data: ResumeCreate,
    current_user: dict = Depends(get_current_user)
):
    variant = ResumeVariant(user_id=current_user["id"], **data.dict())
```

## Security Headers (A02: Security Misconfiguration)

**CRITICAL:** All HTTP responses MUST include security headers.

```python
from fastapi.middleware.trustedhost import TrustedHostMiddleware
from fastapi.middleware.cors import CORSMiddleware
from starlette.middleware.sessions import SessionMiddleware

app = FastAPI()

# CORS configuration
app.add_middleware(
    CORSMiddleware,
    allow_origins=["http://localhost:3000"],  # Frontend URL
    allow_credentials=True,
    allow_methods=["GET", "POST", "PATCH", "DELETE"],
    allow_headers=["Authorization", "Content-Type"],
)

# Trusted host middleware (prevents host header attacks)
app.add_middleware(
    TrustedHostMiddleware,
    allowed_hosts=["localhost", "*.yourdomain.com"]
)

# Custom security headers middleware
@app.middleware("http")
async def add_security_headers(request: Request, call_next):
    response = await call_next(request)
    response.headers["X-Frame-Options"] = "DENY"
    response.headers["X-Content-Type-Options"] = "nosniff"
    response.headers["X-XSS-Protection"] = "1; mode=block"
    response.headers["Strict-Transport-Security"] = "max-age=31536000; includeSubDomains"
    response.headers["Content-Security-Policy"] = "default-src 'self'"
    return response
```

**Required Headers:**

- `Content-Security-Policy` - XSS protection
- `Strict-Transport-Security` - Force HTTPS (production only)
- `X-Frame-Options: DENY` - Clickjacking protection
- `X-Content-Type-Options: nosniff` - MIME sniffing protection
- `X-XSS-Protection: 1; mode=block` - Browser XSS filter (legacy browsers)

## Response Format

- **Consistent naming:** use `snake_case` for JSON keys (Pydantic default, Python convention).
- **ISO 8601 timestamps:** always return dates in UTC (Pydantic handles automatically).
- **No null pollution:** use `Optional[]` types; Pydantic omits None by default with `exclude_none=True`.
- **Direct responses** for simple endpoints; envelope only for pagination metadata.
- **Security:** NEVER expose stack traces, DB errors, or internal paths in responses.

```python
# Pydantic configuration for consistent JSON output
class ResumeResponse(BaseModel):
    id: str
    user_id: str
    name: str
    created_at: datetime
    updated_at: datetime

    class Config:
        from_attributes = True  # Pydantic v2 (was orm_mode in v1)
        json_encoders = {
            datetime: lambda v: v.isoformat()  # ISO 8601 format
        }
```

## 404 vs 400 vs 409 Decision Matrix

When a resource is not found OR user lacks access, choose the status code carefully:

### Use 404 (hide existence from other users)

- Resource doesn't exist → **404**
- Resource exists but belongs to another user → **404** (don't leak existence!)
- Never use 403 for user isolation (Phase 2) - always return 404

```python
# ✅ GOOD - 404 for both not found AND unauthorized
if not variant or variant.user_id != current_user["id"]:
    raise HTTPException(status_code=404, detail="Variant not found")
```

### Use 400 (business logic violation)

- Cannot delete last resume variant → **400**
- Invalid operation (e.g., apply to same company twice) → **400**

### Use 409 (conflict)

- Duplicate name for same user → **409**
- Variant is in use by applications → **409**

### Decision Tree

```
Request comes in
    ↓
1. Is auth token valid? NO → 401 UNAUTHORIZED
    ↓ YES
2. Does resource exist? NO → 404 NOT_FOUND
    ↓ YES
3. Does resource belong to current user? NO → 404 NOT_FOUND (don't leak!)
    ↓ YES
4. Is operation valid? NO → 400 BAD_REQUEST or 409 CONFLICT
    ↓ YES
5. Process request → 200/201/204
```

**Rationale:** Use 404 when the user shouldn't even know if the resource exists (prevents information leakage about other users' data). Phase 1 has no RBAC, so we only use 401/404/400/409/422.

## PATCH Usage

PATCH is the standard for partial updates in Job-Forge:

- `PATCH /api/v1/resumes/{variant_id}` — update resume variant
- `PATCH /api/v1/personal-info` — update personal info

**Use PATCH (not PUT) because:**

- We're updating a subset of fields, not replacing the entire resource
- Client doesn't need to send all fields
- More forgiving for API evolution (adding fields doesn't break clients)
- RESTful semantics: PUT = full replacement, PATCH = partial update

```python
class ResumeUpdate(BaseModel):
    """All fields optional for PATCH."""
    name: Optional[str] = Field(None, min_length=1, max_length=100)
    description: Optional[str] = None

@router.patch("/{variant_id}")
async def update_variant(
    variant_id: str,
    updates: ResumeUpdate,
    current_user: dict = Depends(get_current_user)
):
    variant = await ResumeVariant.get(variant_id)
    if not variant or variant.user_id != current_user["id"]:
        raise HTTPException(status_code=404, detail="Not found")

    # Apply only provided fields
    for field, value in updates.dict(exclude_unset=True).items():
        setattr(variant, field, value)

    variant.updated_at = datetime.utcnow()
    await variant.save()
    return variant
```
