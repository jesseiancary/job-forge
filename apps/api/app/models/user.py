"""User document (future-proofing for multi-user, Phase 2 auth)."""

from datetime import datetime

from beanie import Document
from pydantic import EmailStr, Field
from pymongo import IndexModel


class User(Document):
    email: EmailStr
    full_name: str = Field(..., min_length=1, max_length=200)
    created_at: datetime = Field(default_factory=datetime.utcnow)
    updated_at: datetime = Field(default_factory=datetime.utcnow)

    class Settings:
        name = "users"
        indexes = [IndexModel([("email", 1)], unique=True)]
