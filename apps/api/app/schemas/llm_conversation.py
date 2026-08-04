"""LLMConversation response schema.

No Create schema yet — conversations/messages are created as a side effect
of a future chat endpoint (Milestone 1.8), not directly by clients.
"""

from datetime import datetime
from typing import Literal

from pydantic import BaseModel


class MessageResponse(BaseModel):
    role: Literal["user", "assistant", "system"]
    content: str
    timestamp: datetime

    class Config:
        json_encoders = {datetime: lambda v: v.isoformat()}


class LLMConversationResponse(BaseModel):
    id: str
    application_id: str
    user_id: str
    messages: list[MessageResponse]
    created_at: datetime
    updated_at: datetime

    class Config:
        from_attributes = True
        json_encoders = {datetime: lambda v: v.isoformat()}
