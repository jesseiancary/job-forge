"""LLMConversation document — cover letter feedback loop history."""

from datetime import datetime
from typing import Literal

from beanie import Document
from pydantic import BaseModel, Field


class Message(BaseModel):
    role: Literal["user", "assistant", "system"]
    content: str
    timestamp: datetime = Field(default_factory=datetime.utcnow)


class LLMConversation(Document):
    application_id: str = Field(..., description="Owning application")
    user_id: str = Field(..., description="Single-user placeholder in Phase 1")
    messages: list[Message] = Field(default_factory=list)
    created_at: datetime = Field(default_factory=datetime.utcnow)
    updated_at: datetime = Field(default_factory=datetime.utcnow)

    class Settings:
        name = "llm_conversations"
        indexes = ["application_id", "user_id"]
