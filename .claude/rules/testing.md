# Testing Conventions (pytest + httpx)

## Test Philosophy

- **Integration tests first** on the API — test through the HTTP layer using httpx AsyncClient.
- **Don't mock the database** — use a real test MongoDB instance (separate from dev).
- **Test behavior, not implementation** — avoid testing private functions directly.
- **Coverage threshold:** 80% on `backend/app/`.

## Test Organization

- **Separate tests directory**: `backend/tests/test_<resource>.py` separate from `backend/app/`.
- **One test class per endpoint** (e.g., `TestListResumes`, `TestCreateResume`).
- **Group related tests** with test classes.

## Test Naming

Use descriptive test names that explain the scenario and expected outcome:

```python
class TestLogin:
    """Test POST /api/v1/auth/login endpoint."""

    @pytest.mark.asyncio
    async def test_returns_200_and_tokens_when_credentials_valid(self):
        """Test successful login with valid credentials."""
        # ...

    @pytest.mark.asyncio
    async def test_returns_401_when_password_wrong(self):
        """Test login fails with wrong password."""
        # ...

    @pytest.mark.asyncio
    async def test_returns_422_when_email_missing(self):
        """Test validation error when email is missing."""
        # ...
```

## Database Setup

Each test file should:

1. **Clear the database** before each test using a `conftest.py` fixture.
2. **Use isolated test data** — don't rely on data from other tests.
3. **Clean up** after tests (automatic with fixtures).

Example (`backend/tests/conftest.py`):

```python
import pytest
from motor.motor_asyncio import AsyncIOMotorClient
from beanie import init_beanie
from app.models.resume import ResumeVariant
from app.models.application import Application
from app.config import settings
import jwt
from datetime import datetime, timedelta

@pytest.fixture(scope="session")
async def db_client():
    """Create MongoDB client for test database."""
    client = AsyncIOMotorClient(settings.TEST_MONGODB_URL)
    yield client
    client.close()

@pytest.fixture(autouse=True)
async def clear_database(db_client):
    """Clear all collections before each test."""
    db = db_client[settings.TEST_DATABASE_NAME]
    await init_beanie(database=db, document_models=[ResumeVariant, Application])

    # Clear all collections
    for collection in await db.list_collection_names():
        await db[collection].delete_many({})

    yield  # Run test

    # Cleanup after test (optional, autouse=True clears before next test)
    for collection in await db.list_collection_names():
        await db[collection].delete_many({})

def get_test_user_token(user_id: str = "user_123", email: str = "test@example.com") -> str:
    """Generate JWT token for testing."""
    payload = {
        "user_id": user_id,
        "email": email,
        "exp": datetime.utcnow() + timedelta(hours=1)
    }
    return jwt.encode(payload, settings.SECRET_KEY, algorithm="HS256")
```

Example test:

```python
import pytest
from httpx import AsyncClient
from app.main import app
from app.models.resume import ResumeVariant
from tests.conftest import get_test_user_token

@pytest.mark.asyncio
async def test_login_success():
    """Test successful login."""
    # Create test user
    user = await User(email="test@example.com", password_hash="hashed").insert()

    async with AsyncClient(app=app, base_url="http://test") as client:
        response = await client.post("/api/v1/auth/login", json={
            "email": "test@example.com",
            "password": "password123"
        })

    assert response.status_code == 200
    assert "access_token" in response.json()
```

## API Integration Tests

- **Use httpx AsyncClient** to make HTTP requests to the FastAPI app.
- **Test all status codes** — 200, 201, 400, 401, 404, 409, 422, etc.
- **Assert response shape** — check that the response matches the expected structure.
- **Test edge cases** — expired tokens, missing fields, invalid IDs, etc.

Example:

```python
import pytest
from httpx import AsyncClient
from app.main import app
from tests.conftest import get_test_user_token
from app.models.resume import ResumeVariant

class TestListResumes:
    """Test GET /api/v1/resumes endpoint."""

    @pytest.mark.asyncio
    async def test_returns_401_when_not_authenticated(self):
        """Test that unauthenticated requests return 401."""
        async with AsyncClient(app=app, base_url="http://test") as client:
            response = await client.get("/api/v1/resumes")

        assert response.status_code == 401
        assert response.json()["detail"] == "Not authenticated"

    @pytest.mark.asyncio
    async def test_returns_404_when_accessing_other_users_resource(self):
        """Test user isolation - cannot access other user's resources."""
        # Create resource for user_456
        other_variant = await ResumeVariant(
            user_id="user_456",
            name="Other User's Resume"
        ).insert()

        # Try to access as user_123
        token = get_test_user_token(user_id="user_123")
        async with AsyncClient(app=app, base_url="http://test") as client:
            response = await client.get(
                f"/api/v1/resumes/{other_variant.id}",
                headers={"Authorization": f"Bearer {token}"}
            )

        # Should return 404 (don't leak existence)
        assert response.status_code == 404

    @pytest.mark.asyncio
    async def test_returns_200_and_resumes_list_when_authenticated(self):
        """Test successful listing of user's resumes."""
        token = get_test_user_token(user_id="user_123")

        # Create test variant
        await ResumeVariant(
            user_id="user_123",
            name="FinTech Resume"
        ).insert()

        async with AsyncClient(app=app, base_url="http://test") as client:
            response = await client.get(
                "/api/v1/resumes",
                headers={"Authorization": f"Bearer {token}"}
            )

        assert response.status_code == 200
        assert isinstance(response.json(), list)
        assert len(response.json()) == 1
        assert response.json()[0]["user_id"] == "user_123"
```

## Frontend Tests

- **Use React Testing Library** — test components as users interact with them (same as before).
- **No implementation details** — don't test state or props directly.
- **User-centric queries** — use `getByRole`, `getByLabelText`, etc.
- **Test interactions** — clicks, form submissions, navigation.
- **Use Vitest** for frontend tests (not pytest).

## Test Data Factories (Python)

- **Create reusable factories** for generating test data.
- **Use sensible defaults** — allow overrides when needed.
- **Keep factories simple** — don't add business logic.

Example (`backend/tests/factories.py`):

```python
from app.models.resume import ResumeVariant, Experience
from datetime import datetime
from typing import Optional

async def create_test_variant(
    user_id: str = "user_123",
    name: str = "Test Resume",
    **overrides
) -> ResumeVariant:
    """Factory for creating test resume variants."""
    variant = ResumeVariant(
        user_id=user_id,
        name=name,
        **overrides
    )
    await variant.insert()
    return variant

async def create_test_experience(
    company: str = "Test Corp",
    title: str = "Software Engineer",
    **overrides
) -> Experience:
    """Factory for creating test experience entries."""
    return Experience(
        company=company,
        title=title,
        dates="2020 - 2023",
        location="San Francisco, CA",
        bullets=["Built things", "Improved stuff"],
        **overrides
    )
```

## What NOT to Test

- **Third-party libraries** — trust that FastAPI, Beanie, etc., work correctly.
- **Type correctness** — mypy handles this at type-check time.
- **Implementation details** — private functions, internal state.

## Running Tests

```bash
# Run all backend tests
pytest backend/tests/ -v

# Run tests in watch mode (pytest-watch)
ptw backend/tests/

# Run tests with coverage
pytest backend/tests/ --cov=app --cov-report=term-missing --cov-report=html

# Run specific test file
pytest backend/tests/test_resumes.py -v

# Run specific test class
pytest backend/tests/test_resumes.py::TestListResumes -v

# Run specific test method
pytest backend/tests/test_resumes.py::TestListResumes::test_returns_401 -v
```

## User Isolation Test Patterns (Phase 2)

### User Isolation Tests

Use these patterns for every user-scoped endpoint:

```python
class TestUserIsolation:
    """Test user isolation for GET /api/v1/resumes endpoint."""

    @pytest.mark.asyncio
    async def test_returns_401_when_not_authenticated(self):
        """Test that unauthenticated requests return 401."""
        async with AsyncClient(app=app, base_url="http://test") as client:
            response = await client.get("/api/v1/resumes")

        assert response.status_code == 401
        assert response.json()["detail"] == "Not authenticated"

    @pytest.mark.asyncio
    async def test_returns_404_when_resource_not_found(self):
        """Test that accessing non-existent resource returns 404."""
        token = get_test_user_token(user_id="user_123")

        async with AsyncClient(app=app, base_url="http://test") as client:
            response = await client.get(
                "/api/v1/resumes/nonexistent-id",
                headers={"Authorization": f"Bearer {token}"}
            )

        assert response.status_code == 404
        assert "not found" in response.json()["detail"].lower()

    @pytest.mark.asyncio
    async def test_returns_404_when_accessing_other_users_resource(self):
        """Test user isolation - cannot access other user's resources."""
        # Create resource for user_456
        other_variant = await ResumeVariant(
            user_id="user_456",
            name="Other User's Resume"
        ).insert()

        # Try to access as user_123 (should return 404, not 403)
        token = get_test_user_token(user_id="user_123")
        async with AsyncClient(app=app, base_url="http://test") as client:
            response = await client.get(
                f"/api/v1/resumes/{other_variant.id}",
                headers={"Authorization": f"Bearer {token}"}
            )

        # Should return 404 (don't leak existence to other users)
        assert response.status_code == 404

    @pytest.mark.asyncio
    async def test_only_returns_current_users_resources(self):
        """Test that listing only returns current user's resources."""
        # Create resources for user_123
        await ResumeVariant(user_id="user_123", name="User 123 Resume 1").insert()
        await ResumeVariant(user_id="user_123", name="User 123 Resume 2").insert()

        # Create resources for user_456 (should NOT be returned)
        await ResumeVariant(user_id="user_456", name="User 456 Resume").insert()

        token = get_test_user_token(user_id="user_123")
        async with AsyncClient(app=app, base_url="http://test") as client:
            response = await client.get(
                "/api/v1/resumes",
                headers={"Authorization": f"Bearer {token}"}
            )

        assert response.status_code == 200
        data = response.json()
        assert len(data) == 2
        assert all(v["user_id"] == "user_123" for v in data)

    @pytest.mark.asyncio
    async def test_returns_200_when_user_authorized(self):
        """Test successful access to user's own resource."""
        token = get_test_user_token(user_id="user_123")

        # Create resource for user_123
        variant = await ResumeVariant(
            user_id="user_123",
            name="My Resume"
        ).insert()

        async with AsyncClient(app=app, base_url="http://test") as client:
            response = await client.get(
                f"/api/v1/resumes/{variant.id}",
                headers={"Authorization": f"Bearer {token}"}
            )

        assert response.status_code == 200
        assert response.json()["user_id"] == "user_123"
```

### Edge Case Tests

```python
class TestEdgeCases:
    """Test business logic edge cases."""

    @pytest.mark.asyncio
    async def test_prevents_deleting_last_resume_variant(self):
        """Test that deleting the last variant returns 400."""
        token = get_test_user_token(user_id="user_123")

        # Create only one variant
        variant = await ResumeVariant(user_id="user_123", name="Last Variant").insert()

        async with AsyncClient(app=app, base_url="http://test") as client:
            response = await client.delete(
                f"/api/v1/resumes/{variant.id}",
                headers={"Authorization": f"Bearer {token}"}
            )

        assert response.status_code == 400
        assert "Cannot delete last" in response.json()["detail"]

    @pytest.mark.asyncio
    async def test_prevents_deleting_variant_in_use(self):
        """Test that deleting a variant used by applications returns 409."""
        token = get_test_user_token(user_id="user_123")

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
                f"/api/v1/resumes/{variant.id}",
                headers={"Authorization": f"Bearer {token}"}
            )

        assert response.status_code == 409
        assert "used by" in response.json()["detail"]

    @pytest.mark.asyncio
    async def test_prevents_duplicate_names_per_user(self):
        """Test that duplicate names for same user return 409."""
        token = get_test_user_token(user_id="user_123")

        # Create first variant
        await ResumeVariant(user_id="user_123", name="Duplicate Name").insert()

        # Try to create second variant with same name
        async with AsyncClient(app=app, base_url="http://test") as client:
            response = await client.post(
                "/api/v1/resumes",
                headers={"Authorization": f"Bearer {token}"},
                json={"name": "Duplicate Name"}
            )

        assert response.status_code == 409
        assert "already exists" in response.json()["detail"].lower()
```
