# MongoDB + Beanie ODM Skill Context

Auto-loaded when working on database models, queries, or migrations.

## Stack

- **MongoDB Atlas** - Cloud-hosted MongoDB (M0 free tier for MVP)
- **Motor** - Async MongoDB driver for Python
- **Beanie** - ODM (Object-Document Mapper) built on Motor + Pydantic

## Database Initialization

```python
# app/database.py
from beanie import init_beanie
from motor.motor_asyncio import AsyncIOMotorClient

from app.config import settings
from app.models.user import User
from app.models.resume_variant import ResumeVariant
from app.models.application import Application

async def init_db():
    client = AsyncIOMotorClient(settings.MONGODB_URL)
    database = client[settings.DB_NAME]

    await init_beanie(
        database=database,
        document_models=[User, ResumeVariant, Application]
    )

async def close_db():
    # Beanie handles cleanup automatically
    pass
```

## Document Models

```python
# app/models/resume_variant.py
from beanie import Document
from pydantic import Field
from datetime import datetime
from typing import List, Dict

class ResumeVariant(Document):
    user_id: str = Field(..., index=True)
    name: str = Field(..., min_length=1, max_length=50)
    summary: str
    experience: List[Dict]  # JSON structure (drag-drop bullets)
    education: List[Dict]
    skills: Dict
    latex_source: str | None = None  # Generated LaTeX (cached)
    created_at: datetime = Field(default_factory=datetime.utcnow)
    updated_at: datetime = Field(default_factory=datetime.utcnow)

    class Settings:
        name = "resume_variants"
        indexes = [
            "user_id",
            [("user_id", 1), ("name", 1)],  # Compound index for uniqueness
        ]
```

## Query Patterns

### Find All (with Pagination)

```python
# Find all resume variants for a user
variants = await ResumeVariant.find(
    ResumeVariant.user_id == user_id
).skip(skip).limit(limit).to_list()
```

### Find One

```python
# Find specific resume variant
variant = await ResumeVariant.find_one(
    ResumeVariant.user_id == user_id,
    ResumeVariant.name == "full-stack"
)

# By ID
variant = await ResumeVariant.get(variant_id)
```

### Create

```python
# Create new document
variant = ResumeVariant(
    user_id=user_id,
    name="full-stack",
    summary="...",
    experience=[...],
    education=[...],
    skills={...}
)
await variant.insert()
```

### Update

```python
# Update specific fields
variant = await ResumeVariant.get(variant_id)
variant.summary = "Updated summary"
variant.updated_at = datetime.utcnow()
await variant.save()

# Or use update query
await ResumeVariant.find_one(
    ResumeVariant.id == variant_id
).update({
    "$set": {"summary": "Updated summary", "updated_at": datetime.utcnow()}
})
```

### Delete

```python
variant = await ResumeVariant.get(variant_id)
await variant.delete()

# Or delete by query
await ResumeVariant.find_one(ResumeVariant.id == variant_id).delete()
```

### Aggregation

```python
# Count resumes per user
pipeline = [
    {"$group": {"_id": "$user_id", "count": {"$sum": 1}}}
]
results = await ResumeVariant.aggregate(pipeline).to_list()
```

## Indexing Strategy

### Single Field Index
```python
class Settings:
    indexes = [
        "user_id",  # Index for fast user lookups
        "created_at",  # Index for sorting
    ]
```

### Compound Index
```python
class Settings:
    indexes = [
        [("user_id", 1), ("name", 1)],  # Enforce unique name per user
    ]
```

### Text Index (for Search)
```python
class Settings:
    indexes = [
        [("summary", "text"), ("experience", "text")]  # Full-text search
    ]
```

## Best Practices

1. **Always use async** - Motor/Beanie are fully async
2. **Index frequently queried fields** - `user_id`, `created_at`, etc.
3. **Embed vs. Reference** - Embed related data (experience, education) rather than separate collections for MVP
4. **Validation** - Use Pydantic Field validators for complex validation
5. **No raw PyMongo** - Use Beanie ODM for type safety
6. **Transactions** - Use sessions for multi-document operations (Phase 2+)

## Common Commands

```python
# Create index manually (if not auto-created)
await ResumeVariant.get_motor_collection().create_index("user_id")

# Drop all data (testing)
await ResumeVariant.delete_all()

# Count documents
count = await ResumeVariant.count()
```

## Testing

```python
@pytest.fixture(scope="function")
async def db():
    # Setup test database
    client = AsyncIOMotorClient("mongodb://localhost:27017")
    await init_beanie(client.test_db, document_models=[ResumeVariant])

    yield

    # Cleanup
    await ResumeVariant.delete_all()
    client.close()
```

## References

- [Beanie Documentation](https://beanie-odm.dev/)
- [Motor Documentation](https://motor.readthedocs.io/)
- [MongoDB Atlas](https://www.mongodb.com/atlas)
