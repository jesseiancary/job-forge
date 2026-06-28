# Test Endpoint Command

Generate a comprehensive test suite for a REST API endpoint with user isolation coverage (pytest + httpx).

## Usage

```
/test-endpoint resume_variants
/test-endpoint applications
/test-endpoint personal_info
```

## Test Coverage Template

Creates tests for:

- ✅ Authentication (401)
- ✅ Not found (404)
- ✅ Validation (422 - FastAPI default for Pydantic errors)
- ✅ Success cases (200/201/204)
- ✅ User isolation (Phase 2)
- ✅ Edge cases (400/409)

## Template: Full Test Suite

```python
import pytest
from httpx import AsyncClient
from app.main import app
from app.models.<resource> import <Resource>
from tests.conftest import get_test_user_token, clear_database

# File: backend/tests/test_<resource>.py

@pytest.fixture(autouse=True)
async def setup_and_teardown():
    """Clear database before each test."""
    await clear_database()
    yield
    await clear_database()

# Test data fixtures
@pytest.fixture
def user_123_token():
    """Generate token for user_123."""
    return get_test_user_token(user_id="user_123")

@pytest.fixture
def user_456_token():
    """Generate token for user_456 (for isolation tests)."""
    return get_test_user_token(user_id="user_456")

@pytest.fixture
async def sample_<resource>():
    """Create a sample <resource> for user_123."""
    <resource> = <Resource>(
        user_id="user_123",
        name="Test <Resource>",
        # ... other required fields
    )
    await <resource>.insert()
    return <resource>


# ============================================================================
# GET /api/v1/<resources> - List resources
# ============================================================================

class TestListResources:
    """Test GET /api/v1/<resources> endpoint."""

    @pytest.mark.asyncio
    async def test_returns_401_when_not_authenticated(self):
        """Test that unauthenticated requests return 401."""
        async with AsyncClient(app=app, base_url="http://test") as client:
            response = await client.get("/api/v1/<resources>")

        assert response.status_code == 401
        assert response.json()["detail"] == "Not authenticated"

    @pytest.mark.asyncio
    async def test_returns_200_and_empty_array_when_no_resources(self, user_123_token):
        """Test that listing returns empty array when no resources exist."""
        async with AsyncClient(app=app, base_url="http://test") as client:
            response = await client.get(
                "/api/v1/<resources>",
                headers={"Authorization": f"Bearer {user_123_token}"}
            )

        assert response.status_code == 200
        assert response.json() == []

    @pytest.mark.asyncio
    async def test_returns_200_and_resources_list(self, user_123_token, sample_<resource>):
        """Test that listing returns resources when they exist."""
        async with AsyncClient(app=app, base_url="http://test") as client:
            response = await client.get(
                "/api/v1/<resources>",
                headers={"Authorization": f"Bearer {user_123_token}"}
            )

        assert response.status_code == 200
        data = response.json()
        assert len(data) == 1
        assert data[0]["id"] == str(sample_<resource>.id)
        assert data[0]["name"] == "Test <Resource>"

    @pytest.mark.asyncio
    async def test_only_returns_current_users_resources(self, user_123_token):
        """Test user isolation - only returns current user's resources (Phase 2)."""
        # Create resource for user_123
        await <Resource>(user_id="user_123", name="User 123 Resource").insert()

        # Create resource for user_456 (should NOT be returned)
        await <Resource>(user_id="user_456", name="User 456 Resource").insert()

        async with AsyncClient(app=app, base_url="http://test") as client:
            response = await client.get(
                "/api/v1/<resources>",
                headers={"Authorization": f"Bearer {user_123_token}"}
            )

        assert response.status_code == 200
        data = response.json()
        assert len(data) == 1
        assert data[0]["user_id"] == "user_123"
        assert data[0]["name"] == "User 123 Resource"


# ============================================================================
# POST /api/v1/<resources> - Create resource
# ============================================================================

class TestCreateResource:
    """Test POST /api/v1/<resources> endpoint."""

    @pytest.mark.asyncio
    async def test_returns_401_when_not_authenticated(self):
        """Test that unauthenticated requests return 401."""
        async with AsyncClient(app=app, base_url="http://test") as client:
            response = await client.post(
                "/api/v1/<resources>",
                json={"name": "New Resource"}
            )

        assert response.status_code == 401

    @pytest.mark.asyncio
    async def test_returns_422_when_required_fields_missing(self, user_123_token):
        """Test Pydantic validation error for missing fields."""
        async with AsyncClient(app=app, base_url="http://test") as client:
            response = await client.post(
                "/api/v1/<resources>",
                headers={"Authorization": f"Bearer {user_123_token}"},
                json={}  # Missing required fields
            )

        assert response.status_code == 422  # FastAPI default for Pydantic validation
        assert "detail" in response.json()

    @pytest.mark.asyncio
    async def test_returns_422_when_field_format_invalid(self, user_123_token):
        """Test Pydantic validation error for invalid field format."""
        async with AsyncClient(app=app, base_url="http://test") as client:
            response = await client.post(
                "/api/v1/<resources>",
                headers={"Authorization": f"Bearer {user_123_token}"},
                json={"name": "x" * 200}  # Exceeds max_length=100
            )

        assert response.status_code == 422
        error = response.json()["detail"][0]
        assert error["loc"] == ["body", "name"]
        assert "ensure this value has at most" in error["msg"].lower()

    @pytest.mark.asyncio
    async def test_returns_201_and_creates_resource(self, user_123_token):
        """Test successful resource creation."""
        async with AsyncClient(app=app, base_url="http://test") as client:
            response = await client.post(
                "/api/v1/<resources>",
                headers={"Authorization": f"Bearer {user_123_token}"},
                json={"name": "New Resource", "description": "Test"}
            )

        assert response.status_code == 201
        data = response.json()
        assert data["name"] == "New Resource"
        assert data["description"] == "Test"
        assert data["user_id"] == "user_123"
        assert "id" in data
        assert "created_at" in data

        # Verify in database
        <resource> = await <Resource>.get(data["id"])
        assert <resource> is not None
        assert <resource>.user_id == "user_123"
        assert <resource>.name == "New Resource"


# ============================================================================
# GET /api/v1/<resources>/{id} - Get single resource
# ============================================================================

class TestGetResource:
    """Test GET /api/v1/<resources>/{id} endpoint."""

    @pytest.mark.asyncio
    async def test_returns_401_when_not_authenticated(self, sample_<resource>):
        """Test that unauthenticated requests return 401."""
        async with AsyncClient(app=app, base_url="http://test") as client:
            response = await client.get(f"/api/v1/<resources>/{sample_<resource>.id}")

        assert response.status_code == 401

    @pytest.mark.asyncio
    async def test_returns_404_when_resource_not_found(self, user_123_token):
        """Test that getting non-existent resource returns 404."""
        async with AsyncClient(app=app, base_url="http://test") as client:
            response = await client.get(
                "/api/v1/<resources>/nonexistent-id",
                headers={"Authorization": f"Bearer {user_123_token}"}
            )

        assert response.status_code == 404
        assert response.json()["detail"] == "<Resource> not found"

    @pytest.mark.asyncio
    async def test_returns_404_when_resource_belongs_to_other_user(self, user_123_token):
        """Test user isolation - returns 404 for other user's resource."""
        # Create resource for user_456
        other_<resource> = await <Resource>(
            user_id="user_456",
            name="Other User's Resource"
        ).insert()

        # Try to access as user_123
        async with AsyncClient(app=app, base_url="http://test") as client:
            response = await client.get(
                f"/api/v1/<resources>/{other_<resource>.id}",
                headers={"Authorization": f"Bearer {user_123_token}"}
            )

        # Should return 404 (don't leak existence)
        assert response.status_code == 404

    @pytest.mark.asyncio
    async def test_returns_200_and_resource(self, user_123_token, sample_<resource>):
        """Test successful resource retrieval."""
        async with AsyncClient(app=app, base_url="http://test") as client:
            response = await client.get(
                f"/api/v1/<resources>/{sample_<resource>.id}",
                headers={"Authorization": f"Bearer {user_123_token}"}
            )

        assert response.status_code == 200
        data = response.json()
        assert data["id"] == str(sample_<resource>.id)
        assert data["name"] == "Test <Resource>"
        assert data["user_id"] == "user_123"


# ============================================================================
# PATCH /api/v1/<resources>/{id} - Update resource
# ============================================================================

class TestUpdateResource:
    """Test PATCH /api/v1/<resources>/{id} endpoint."""

    @pytest.mark.asyncio
    async def test_returns_401_when_not_authenticated(self, sample_<resource>):
        """Test that unauthenticated requests return 401."""
        async with AsyncClient(app=app, base_url="http://test") as client:
            response = await client.patch(
                f"/api/v1/<resources>/{sample_<resource>.id}",
                json={"name": "Updated"}
            )

        assert response.status_code == 401

    @pytest.mark.asyncio
    async def test_returns_404_when_resource_not_found(self, user_123_token):
        """Test that updating non-existent resource returns 404."""
        async with AsyncClient(app=app, base_url="http://test") as client:
            response = await client.patch(
                "/api/v1/<resources>/nonexistent-id",
                headers={"Authorization": f"Bearer {user_123_token}"},
                json={"name": "Updated"}
            )

        assert response.status_code == 404

    @pytest.mark.asyncio
    async def test_returns_404_when_resource_belongs_to_other_user(self, user_123_token):
        """Test user isolation - cannot update other user's resource."""
        other_<resource> = await <Resource>(
            user_id="user_456",
            name="Other User's Resource"
        ).insert()

        async with AsyncClient(app=app, base_url="http://test") as client:
            response = await client.patch(
                f"/api/v1/<resources>/{other_<resource>.id}",
                headers={"Authorization": f"Bearer {user_123_token}"},
                json={"name": "Hacked!"}
            )

        assert response.status_code == 404

    @pytest.mark.asyncio
    async def test_returns_200_and_updates_resource(self, user_123_token, sample_<resource>):
        """Test successful resource update."""
        async with AsyncClient(app=app, base_url="http://test") as client:
            response = await client.patch(
                f"/api/v1/<resources>/{sample_<resource>.id}",
                headers={"Authorization": f"Bearer {user_123_token}"},
                json={"name": "Updated Name"}
            )

        assert response.status_code == 200
        data = response.json()
        assert data["name"] == "Updated Name"

        # Verify in database
        updated = await <Resource>.get(sample_<resource>.id)
        assert updated.name == "Updated Name"


# ============================================================================
# DELETE /api/v1/<resources>/{id} - Delete resource
# ============================================================================

class TestDeleteResource:
    """Test DELETE /api/v1/<resources>/{id} endpoint."""

    @pytest.mark.asyncio
    async def test_returns_401_when_not_authenticated(self, sample_<resource>):
        """Test that unauthenticated requests return 401."""
        async with AsyncClient(app=app, base_url="http://test") as client:
            response = await client.delete(f"/api/v1/<resources>/{sample_<resource>.id}")

        assert response.status_code == 401

    @pytest.mark.asyncio
    async def test_returns_404_when_resource_not_found(self, user_123_token):
        """Test that deleting non-existent resource returns 404."""
        async with AsyncClient(app=app, base_url="http://test") as client:
            response = await client.delete(
                "/api/v1/<resources>/nonexistent-id",
                headers={"Authorization": f"Bearer {user_123_token}"}
            )

        assert response.status_code == 404

    @pytest.mark.asyncio
    async def test_returns_404_when_resource_belongs_to_other_user(self, user_123_token):
        """Test user isolation - cannot delete other user's resource."""
        other_<resource> = await <Resource>(
            user_id="user_456",
            name="Other User's Resource"
        ).insert()

        async with AsyncClient(app=app, base_url="http://test") as client:
            response = await client.delete(
                f"/api/v1/<resources>/{other_<resource>.id}",
                headers={"Authorization": f"Bearer {user_123_token}"}
            )

        assert response.status_code == 404

    @pytest.mark.asyncio
    async def test_returns_204_and_deletes_resource(self, user_123_token, sample_<resource>):
        """Test successful resource deletion."""
        async with AsyncClient(app=app, base_url="http://test") as client:
            response = await client.delete(
                f"/api/v1/<resources>/{sample_<resource>.id}",
                headers={"Authorization": f"Bearer {user_123_token}"}
            )

        assert response.status_code == 204

        # Verify deletion
        deleted = await <Resource>.get(sample_<resource>.id)
        assert deleted is None


# ============================================================================
# Edge Case Tests (if applicable)
# ============================================================================

class TestEdgeCases:
    """Test edge cases and business logic constraints."""

    @pytest.mark.asyncio
    async def test_prevents_deleting_last_resume_variant(self, user_123_token):
        """Test that deleting the last variant returns 400."""
        # Create only one variant
        variant = await <Resource>(user_id="user_123", name="Last Variant").insert()

        async with AsyncClient(app=app, base_url="http://test") as client:
            response = await client.delete(
                f"/api/v1/<resources>/{variant.id}",
                headers={"Authorization": f"Bearer {user_123_token}"}
            )

        assert response.status_code == 400
        assert "Cannot delete last" in response.json()["detail"]

    @pytest.mark.asyncio
    async def test_prevents_deleting_variant_with_applications(self, user_123_token):
        """Test that deleting a variant used by applications returns 409."""
        # Create variant
        variant = await ResumeVariant(
            user_id="user_123",
            name="Used Variant"
        ).insert()

        # Create application using this variant
        await Application(
            user_id="user_123",
            company_name="Stripe",
            resume_variant_id=str(variant.id)
        ).insert()

        async with AsyncClient(app=app, base_url="http://test") as client:
            response = await client.delete(
                f"/api/v1/resume_variants/{variant.id}",
                headers={"Authorization": f"Bearer {user_123_token}"}
            )

        assert response.status_code == 409
        assert "used by" in response.json()["detail"]

    @pytest.mark.asyncio
    async def test_prevents_duplicate_names_per_user(self, user_123_token):
        """Test that duplicate names for same user return 409."""
        # Create first variant
        await <Resource>(user_id="user_123", name="Duplicate Name").insert()

        # Try to create second variant with same name
        async with AsyncClient(app=app, base_url="http://test") as client:
            response = await client.post(
                "/api/v1/<resources>",
                headers={"Authorization": f"Bearer {user_123_token}"},
                json={"name": "Duplicate Name"}
            )

        assert response.status_code == 409
        assert "already exists" in response.json()["detail"].lower()
```

## Running Tests

```bash
# Run all tests for this endpoint
pytest backend/tests/test_<resource>.py -v

# Run with coverage
pytest backend/tests/test_<resource>.py --cov=app.routers.<resource> --cov-report=term-missing

# Run specific test class
pytest backend/tests/test_<resource>.py::TestListResources -v

# Run specific test
pytest backend/tests/test_<resource>.py::TestListResources::test_returns_401_when_not_authenticated -v
```

## Checklist

- [ ] Test file created in `backend/tests/test_<resource>.py`
- [ ] All authentication tests pass (401 cases)
- [ ] All not found tests pass (404 cases)
- [ ] All validation tests pass (422 cases for Pydantic errors)
- [ ] All success tests pass (200/201/204 cases)
- [ ] User isolation tests pass (Phase 2)
- [ ] Edge case tests added (if applicable: 400/409)
- [ ] Tests run in CI/CD pipeline
- [ ] Coverage meets 80% threshold
- [ ] Fixtures use `conftest.py` helpers (get_test_user_token, clear_database)
