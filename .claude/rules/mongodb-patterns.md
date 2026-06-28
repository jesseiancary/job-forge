# MongoDB + Beanie Patterns

## Document Design Principles

1. **Embed related data** - Store experience/education within resume document (no separate collections for MVP)
2. **Avoid deep nesting** - Max 2-3 levels deep
3. **Index frequently queried fields** - `user_id`, `created_at`, etc.
4. **Denormalize for reads** - Optimize for read performance over write normalization
5. **Use references sparingly** - Only for many-to-many relationships (Phase 2+)

## Document Structure

### Resume Variant Document

```python
from beanie import Document
from pydantic import Field
from datetime import datetime
from typing import List, Dict

class ResumeVariant(Document):
    # User ownership
    user_id: str = Field(..., index=True)

    # Resume metadata
    name: str = Field(..., min_length=1, max_length=50)
    summary: str

    # Embedded content (JSON structure)
    experience: List[Dict] = Field(default_factory=list)
    education: List[Dict] = Field(default_factory=list)
    skills: Dict = Field(default_factory=dict)

    # Cached LaTeX (regenerated on content change)
    latex_source: str | None = None

    # Timestamps
    created_at: datetime = Field(default_factory=datetime.utcnow)
    updated_at: datetime = Field(default_factory=datetime.utcnow)

    class Settings:
        name = "resume_variants"
        indexes = [
            "user_id",  # Single field index
            "created_at",  # For sorting
            [("user_id", 1), ("name", 1)],  # Compound index (unique per user)
        ]

    class Config:
        json_schema_extra = {
            "example": {
                "user_id": "user_123",
                "name": "full-stack",
                "summary": "17 years of experience...",
                "experience": [{
                    "company": "TechCorp",
                    "title": "Senior Engineer",
                    "bullets": [{"text": "Built system...", "order": 0}]
                }]
            }
        }
```

### Application Document

```python
class Application(Document):
    user_id: str = Field(..., index=True)
    company_name: str
    job_description: str
    resume_variant_id: str  # Reference to ResumeVariant
    resume_snapshot: Dict  # Snapshot of resume at application time
    cover_letter: str
    status: str = Field(default="draft")  # draft, submitted, archived
    created_at: datetime = Field(default_factory=datetime.utcnow)

    class Settings:
        name = "applications"
        indexes = [
            "user_id",
            [("user_id", 1), ("created_at", -1)],  # Sort by newest
        ]
```

## Query Patterns

### Find by User

```python
# Find all resume variants for a user
variants = await ResumeVariant.find(
    ResumeVariant.user_id == user_id
).to_list()

# With sorting
variants = await ResumeVariant.find(
    ResumeVariant.user_id == user_id
).sort(-ResumeVariant.created_at).to_list()  # Newest first
```

### Find One with Conditions

```python
# Find specific resume variant by user and name
variant = await ResumeVariant.find_one(
    ResumeVariant.user_id == user_id,
    ResumeVariant.name == "full-stack"
)

# Find by ID (with ownership check)
variant = await ResumeVariant.find_one(
    ResumeVariant.id == variant_id,
    ResumeVariant.user_id == user_id
)
```

### Pagination

```python
# Offset-based (simple)
variants = await ResumeVariant.find(
    ResumeVariant.user_id == user_id
).skip(skip).limit(limit).to_list()

# Cursor-based (better for large datasets)
variants = await ResumeVariant.find(
    ResumeVariant.user_id == user_id,
    ResumeVariant.created_at < last_seen_timestamp
).limit(limit).to_list()
```

### Create Document

```python
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

### Update Document

```python
# Method 1: Load, modify, save
variant = await ResumeVariant.get(variant_id)
variant.summary = "Updated summary"
variant.updated_at = datetime.utcnow()
await variant.save()

# Method 2: Direct update (more efficient)
await ResumeVariant.find_one(
    ResumeVariant.id == variant_id
).update({
    "$set": {
        "summary": "Updated summary",
        "updated_at": datetime.utcnow()
    }
})

# Method 3: Update nested field (experience bullet)
await variant.update({
    "$set": {
        "experience.0.bullets.1.text": "Updated bullet text",
        "updated_at": datetime.utcnow()
    }
})
```

### Delete Document

```python
variant = await ResumeVariant.get(variant_id)
await variant.delete()

# Or direct delete
await ResumeVariant.find_one(
    ResumeVariant.id == variant_id
).delete()
```

## Embedded Arrays (Experience, Education)

### Add Item to Array

```python
# Add new experience entry
variant = await ResumeVariant.get(variant_id)
new_job = {
    "company": "NewCorp",
    "title": "Engineer",
    "bullets": []
}
variant.experience.append(new_job)
await variant.save()

# Or use $push operator
await variant.update({
    "$push": {"experience": new_job}
})
```

### Update Item in Array

```python
# Update specific experience entry (by index)
variant.experience[0]["title"] = "Senior Engineer"
await variant.save()

# Or use array index in update
await variant.update({
    "$set": {"experience.0.title": "Senior Engineer"}
})
```

### Remove Item from Array

```python
# Remove by index
variant.experience.pop(0)
await variant.save()

# Or use $pull operator (by condition)
await variant.update({
    "$pull": {"experience": {"company": "OldCorp"}}
})
```

### Reorder Array (Drag-Drop Bullets)

```python
# Frontend sends new order
new_order = [2, 0, 1]  # New indices

# Reorder in Python
reordered = [variant.experience[0]["bullets"][i] for i in new_order]
variant.experience[0]["bullets"] = reordered
await variant.save()
```

## Indexing

### Create Index

Indexes are auto-created from `Settings.indexes`, but you can create manually:

```python
await ResumeVariant.get_motor_collection().create_index("user_id")
await ResumeVariant.get_motor_collection().create_index(
    [("user_id", 1), ("name", 1)],
    unique=True
)
```

### Compound Index for Uniqueness

```python
# Ensure unique resume name per user
class Settings:
    indexes = [
        [("user_id", 1), ("name", 1)]  # Ascending order
    ]

# This prevents duplicate names per user
# user_id=123, name="full-stack" ✓
# user_id=123, name="backend" ✓
# user_id=123, name="full-stack" ✗ (duplicate)
# user_id=456, name="full-stack" ✓ (different user)
```

## Aggregation Pipeline

For complex queries (analytics, reports):

```python
# Count applications by status
pipeline = [
    {"$match": {"user_id": user_id}},
    {"$group": {
        "_id": "$status",
        "count": {"$sum": 1}
    }}
]
results = await Application.aggregate(pipeline).to_list()
# Result: [{"_id": "draft", "count": 5}, {"_id": "submitted", "count": 12}]
```

## Transactions (Phase 2+)

For multi-document operations:

```python
from beanie import WriteTransaction

async with WriteTransaction() as session:
    # Create application
    app = Application(user_id=user_id, ...)
    await app.insert(session=session)

    # Update resume variant (mark as used)
    variant = await ResumeVariant.get(variant_id, session=session)
    variant.last_used_at = datetime.utcnow()
    await variant.save(session=session)

    # Both succeed or both rollback
```

## Testing

```python
@pytest.fixture(scope="function")
async def db():
    # Initialize test database
    client = AsyncIOMotorClient("mongodb://localhost:27017")
    await init_beanie(client.test_db, document_models=[ResumeVariant])

    yield

    # Cleanup after test
    await ResumeVariant.delete_all()
    client.close()

@pytest.mark.asyncio
async def test_create_resume_variant(db):
    variant = ResumeVariant(
        user_id="test_user",
        name="test",
        summary="Test summary"
    )
    await variant.insert()

    assert variant.id is not None
    assert variant.created_at is not None
```

## Best Practices

1. **Always filter by user_id** for user-scoped resources (security)
2. **Use indexes** for frequently queried fields
3. **Embed related data** for MVP (denormalization is OK)
4. **Update timestamps** on every change (`updated_at`)
5. **Validate before save** using Pydantic validators
6. **Use transactions** for multi-document operations (Phase 2+)
7. **Test with real MongoDB** (not mocks) for integration tests
8. **Clean up test data** after each test

## Common Errors

| Error | Cause | Fix |
|-------|-------|-----|
| `DuplicateKeyError` | Unique index violation | Check for existing document before insert |
| `DocumentNotFound` | Document doesn't exist | Handle None from `get()` or `find_one()` |
| `ValidationError` | Pydantic validation failed | Check required fields and types |
| `NetworkTimeout` | MongoDB connection issue | Check connection string, network |
