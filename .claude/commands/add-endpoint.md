# Add Endpoint Command

Scaffold a new REST API endpoint with all required files (FastAPI + Beanie).

## Steps

1. **Create router file** in `backend/app/routers/<resource>.py`
2. **Create Pydantic schemas** in `backend/app/schemas/<resource>.py`
3. **Create Beanie model** in `backend/app/models/<resource>.py` (if new collection)
4. **Create test file** in `backend/tests/test_<resource>.py`
5. **Register router** in `backend/app/main.py`

**Note:** For GraphQL endpoints, see `.claude/commands/add-graphql-resolver.md`

## Template Structure

### Router File (`backend/app/routers/<resource>.py`)

```python
from fastapi import APIRouter, Depends, HTTPException, status
from typing import List
from app.schemas.<resource> import <Resource>Response, <Resource>Create, <Resource>Update
from app.models.<resource> import <Resource>
from app.dependencies import get_current_user

router = APIRouter(prefix="/api/v1/<resources>", tags=["<resources>"])

@router.get("/", response_model=List[<Resource>Response])
async def list_<resources>(
    skip: int = 0,
    limit: int = 20,
    current_user: dict = Depends(get_current_user)
):
    """List all <resources> for the current user (Phase 2: filter by user_id)."""
    <resources> = await <Resource>.find(
        <Resource>.user_id == current_user["id"]
    ).sort([("created_at", -1)]).skip(skip).limit(limit).to_list()

    return <resources>

@router.get("/{<resource>_id}", response_model=<Resource>Response)
async def get_<resource>(
    <resource>_id: str,
    current_user: dict = Depends(get_current_user)
):
    """Get a specific <resource> by ID."""
    <resource> = await <Resource>.get(<resource>_id)

    # Return 404 if doesn't exist OR doesn't belong to user (Phase 2)
    if not <resource> or <resource>.user_id != current_user["id"]:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="<Resource> not found"
        )

    return <resource>

@router.post("/", response_model=<Resource>Response, status_code=status.HTTP_201_CREATED)
async def create_<resource>(
    <resource>: <Resource>Create,
    current_user: dict = Depends(get_current_user)
):
    """Create a new <resource>."""
    new_<resource> = <Resource>(
        user_id=current_user["id"],
        **<resource>.dict()
    )
    await new_<resource>.insert()

    return new_<resource>

@router.patch("/{<resource>_id}", response_model=<Resource>Response)
async def update_<resource>(
    <resource>_id: str,
    updates: <Resource>Update,
    current_user: dict = Depends(get_current_user)
):
    """Update a <resource>."""
    <resource> = await <Resource>.get(<resource>_id)

    if not <resource> or <resource>.user_id != current_user["id"]:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Not found")

    # Apply updates
    for field, value in updates.dict(exclude_unset=True).items():
        setattr(<resource>, field, value)

    <resource>.updated_at = datetime.utcnow()
    await <resource>.save()

    return <resource>

@router.delete("/{<resource>_id}", status_code=status.HTTP_204_NO_CONTENT)
async def delete_<resource>(
    <resource>_id: str,
    current_user: dict = Depends(get_current_user)
):
    """Delete a <resource>."""
    <resource> = await <Resource>.get(<resource>_id)

    if not <resource> or <resource>.user_id != current_user["id"]:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Not found")

    await <resource>.delete()
    return None  # 204 No Content
```

### Pydantic Schemas (`backend/app/schemas/<resource>.py`)

```python
from pydantic import BaseModel, Field
from typing import Optional
from datetime import datetime

class <Resource>Base(BaseModel):
    """Base schema for <resource>."""
    name: str = Field(..., min_length=1, max_length=100)
    description: Optional[str] = None

class <Resource>Create(<Resource>Base):
    """Schema for creating a <resource>."""
    pass

class <Resource>Update(BaseModel):
    """Schema for updating a <resource> (all fields optional)."""
    name: Optional[str] = Field(None, min_length=1, max_length=100)
    description: Optional[str] = None

class <Resource>Response(<Resource>Base):
    """Schema for <resource> response."""
    id: str
    user_id: str
    created_at: datetime
    updated_at: datetime

    class Config:
        from_attributes = True  # Pydantic v2 (was orm_mode in v1)
```

### Beanie Model (`backend/app/models/<resource>.py`)

```python
from beanie import Document, Indexed
from pydantic import Field
from typing import Optional
from datetime import datetime

class <Resource>(Document):
    """<Resource> document model."""
    user_id: Indexed(str)  # Phase 2: filter by user_id
    name: Indexed(str)
    description: Optional[str] = None
    created_at: datetime = Field(default_factory=datetime.utcnow)
    updated_at: datetime = Field(default_factory=datetime.utcnow)

    class Settings:
        name = "<resources>"
        indexes = [
            [("user_id", 1), ("created_at", -1)],  # Phase 2: list user's <resources>
        ]
```

### Test File (`backend/tests/test_<resource>.py`)

```python
import pytest
from httpx import AsyncClient
from app.main import app
from app.models.<resource> import <Resource>
from tests.conftest import get_test_user_token

@pytest.mark.asyncio
async def test_list_<resources>_401_when_not_authenticated():
    """Test that unauthenticated requests return 401."""
    async with AsyncClient(app=app, base_url="http://test") as client:
        response = await client.get("/api/v1/<resources>")

    assert response.status_code == 401

@pytest.mark.asyncio
async def test_list_<resources>_200_when_authenticated():
    """Test that authenticated requests return 200 with list of <resources>."""
    token = get_test_user_token(user_id="user_123")

    # Seed test data
    await <Resource>(
        user_id="user_123",
        name="Test <Resource>",
        description="Test description"
    ).insert()

    async with AsyncClient(app=app, base_url="http://test") as client:
        response = await client.get(
            "/api/v1/<resources>",
            headers={"Authorization": f"Bearer {token}"}
        )

    assert response.status_code == 200
    assert isinstance(response.json(), list)
    assert len(response.json()) == 1
    assert response.json()[0]["name"] == "Test <Resource>"

@pytest.mark.asyncio
async def test_get_<resource>_404_when_not_found():
    """Test that getting a non-existent <resource> returns 404."""
    token = get_test_user_token(user_id="user_123")

    async with AsyncClient(app=app, base_url="http://test") as client:
        response = await client.get(
            "/api/v1/<resources>/nonexistent_id",
            headers={"Authorization": f"Bearer {token}"}
        )

    assert response.status_code == 404

@pytest.mark.asyncio
async def test_get_<resource>_404_when_not_owned_by_user():
    """Test that getting another user's <resource> returns 404 (user isolation)."""
    # Create <resource> owned by user_456
    <resource> = await <Resource>(
        user_id="user_456",
        name="Other User's <Resource>"
    ).insert()

    # Try to access as user_123
    token = get_test_user_token(user_id="user_123")

    async with AsyncClient(app=app, base_url="http://test") as client:
        response = await client.get(
            f"/api/v1/<resources>/{<resource>.id}",
            headers={"Authorization": f"Bearer {token}"}
        )

    assert response.status_code == 404  # Don't leak existence

@pytest.mark.asyncio
async def test_create_<resource>_201():
    """Test creating a <resource>."""
    token = get_test_user_token(user_id="user_123")

    async with AsyncClient(app=app, base_url="http://test") as client:
        response = await client.post(
            "/api/v1/<resources>",
            headers={"Authorization": f"Bearer {token}"},
            json={"name": "New <Resource>", "description": "Test"}
        )

    assert response.status_code == 201
    assert response.json()["name"] == "New <Resource>"
    assert response.json()["user_id"] == "user_123"

@pytest.mark.asyncio
async def test_update_<resource>_200():
    """Test updating a <resource>."""
    token = get_test_user_token(user_id="user_123")

    # Create <resource>
    <resource> = await <Resource>(
        user_id="user_123",
        name="Original Name"
    ).insert()

    async with AsyncClient(app=app, base_url="http://test") as client:
        response = await client.patch(
            f"/api/v1/<resources>/{<resource>.id}",
            headers={"Authorization": f"Bearer {token}"},
            json={"name": "Updated Name"}
        )

    assert response.status_code == 200
    assert response.json()["name"] == "Updated Name"

@pytest.mark.asyncio
async def test_delete_<resource>_204():
    """Test deleting a <resource>."""
    token = get_test_user_token(user_id="user_123")

    # Create <resource>
    <resource> = await <Resource>(
        user_id="user_123",
        name="To Delete"
    ).insert()

    async with AsyncClient(app=app, base_url="http://test") as client:
        response = await client.delete(
            f"/api/v1/<resources>/{<resource>.id}",
            headers={"Authorization": f"Bearer {token}"}
        )

    assert response.status_code == 204

    # Verify deleted
    deleted = await <Resource>.get(<resource>.id)
    assert deleted is None
```

## User Isolation (Phase 2)

When adding user-scoped endpoints:

1. **Get user_id from JWT (never request body):**
   ```python
   current_user: dict = Depends(get_current_user)
   user_id = current_user["id"]
   ```

2. **Filter all queries by user_id:**
   ```python
   <resources> = await <Resource>.find(
       <Resource>.user_id == current_user["id"]
   ).to_list()
   ```

3. **Return 404 for non-existent OR unauthorized access:**
   ```python
   if not <resource> or <resource>.user_id != current_user["id"]:
       raise HTTPException(status_code=404, detail="Not found")
   # Don't return 403 - don't leak existence of other users' data
   ```

4. **Never trust user_id from request body:**
   ```python
   # ❌ BAD - user_id from request body (CRITICAL BUG)
   @router.post("/")
   async def create(data: dict):
       <resource> = <Resource>(user_id=data["user_id"])  # Client can pass ANY user_id!

   # ✅ GOOD - user_id from JWT
   @router.post("/")
   async def create(
       data: <Resource>Create,
       current_user: dict = Depends(get_current_user)
   ):
       <resource> = <Resource>(user_id=current_user["id"], **data.dict())
   ```

## Example Edge Case Handling

```python
# Example: Prevent deleting last resume variant
@router.delete("/{variant_id}", status_code=status.HTTP_204_NO_CONTENT)
async def delete_resume_variant(
    variant_id: str,
    current_user: dict = Depends(get_current_user)
):
    """Delete a resume variant."""
    variant = await ResumeVariant.get(variant_id)

    if not variant or variant.user_id != current_user["id"]:
        raise HTTPException(status_code=404, detail="Not found")

    # Edge case: Prevent deleting last variant
    variant_count = await ResumeVariant.find(
        ResumeVariant.user_id == current_user["id"]
    ).count()

    if variant_count == 1:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Cannot delete last resume variant"
        )

    # Check if variant is used by any applications
    applications = await Application.find(
        Application.resume_variant_id == variant_id
    ).to_list()

    if applications:
        raise HTTPException(
            status_code=status.HTTP_409_CONFLICT,
            detail=f"Cannot delete variant used by {len(applications)} application(s)"
        )

    await variant.delete()
    return None
```

## Checklist

- [ ] Router file created (`backend/app/routers/<resource>.py`)
- [ ] Pydantic schemas created (`backend/app/schemas/<resource>.py`)
- [ ] Beanie model created (`backend/app/models/<resource>.py`) if new collection
- [ ] Test file created (`backend/tests/test_<resource>.py`) with 401, 404 cases
- [ ] Router registered in `backend/app/main.py`
- [ ] Tests pass (`pytest backend/tests/test_<resource>.py`)
- [ ] User isolation verified (uses `current_user["id"]` from JWT)
- [ ] Edge cases handled (if applicable)
- [ ] FastAPI auto-generated OpenAPI docs updated (visit `/docs`)
