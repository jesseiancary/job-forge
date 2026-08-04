"""PersonalInfo document — singleton per user."""

from datetime import datetime

from beanie import Document
from pydantic import EmailStr, Field
from pymongo import IndexModel


class PersonalInfo(Document):
    user_id: str = Field(..., description="Single-user placeholder in Phase 1")
    name: str
    title: str
    city: str
    state: str
    phone: str
    email: EmailStr
    linkedin_url: str | None = None
    github_url: str | None = None
    signature_s3_key: str | None = None
    created_at: datetime = Field(default_factory=datetime.utcnow)
    updated_at: datetime = Field(default_factory=datetime.utcnow)

    class Settings:
        name = "personal_info"
        indexes = [IndexModel([("user_id", 1)], unique=True)]
