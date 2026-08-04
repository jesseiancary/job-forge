"""ResumeVariant request/response schemas."""

from datetime import datetime

from pydantic import BaseModel, Field

from app.models.resume_content import ResumeContent


class ResumeVariantCreate(BaseModel):
    name: str = Field(..., min_length=1, max_length=100)
    description: str | None = None
    content: ResumeContent
    template_id: str


class ResumeVariantUpdate(BaseModel):
    name: str | None = Field(None, min_length=1, max_length=100)
    description: str | None = None
    content: ResumeContent | None = None
    template_id: str | None = None


class ResumeVariantResponse(BaseModel):
    id: str
    user_id: str
    name: str
    description: str | None = None
    content: ResumeContent
    latex_source: str | None = None
    pdf_s3_key: str | None = None
    template_id: str
    created_at: datetime
    updated_at: datetime
    last_compiled_at: datetime | None = None

    class Config:
        from_attributes = True
        json_encoders = {datetime: lambda v: v.isoformat()}
