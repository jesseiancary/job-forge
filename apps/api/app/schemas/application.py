"""Application request/response schemas."""

from datetime import datetime
from typing import Literal

from pydantic import BaseModel

from app.models.resume_content import ResumeContent


class ApplicationCreate(BaseModel):
    company_name: str
    company_slug: str
    job_title: str
    job_description: str
    resume_variant_id: str


class ApplicationUpdate(BaseModel):
    status: Literal["draft", "ready", "applied"] | None = None
    cover_letter_approved: bool | None = None


class ApplicationResponse(BaseModel):
    id: str
    user_id: str
    company_name: str
    company_slug: str
    job_title: str
    job_description: str
    resume_variant_id: str
    resume_content: ResumeContent | None = None
    resume_latex: str | None = None
    resume_pdf_s3_key: str | None = None
    cover_letter_latex: str | None = None
    cover_letter_pdf_s3_key: str | None = None
    cover_letter_approved: bool
    status: Literal["draft", "ready", "applied"]
    created_at: datetime
    updated_at: datetime

    class Config:
        from_attributes = True
        json_encoders = {datetime: lambda v: v.isoformat()}
