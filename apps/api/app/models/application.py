"""Application document — a tailored resume + cover letter for one job."""

from datetime import datetime
from typing import Literal

from beanie import Document
from pydantic import Field

from app.models.resume_content import ResumeContent


class Application(Document):
    user_id: str = Field(..., description="Single-user placeholder in Phase 1")
    company_name: str
    company_slug: str
    job_title: str
    job_description: str
    resume_variant_id: str

    # Populated by the LLM/PDF generation pipeline (Milestone 1.9+), not at creation time.
    resume_content: ResumeContent | None = None
    resume_latex: str | None = None
    resume_pdf_s3_key: str | None = None

    cover_letter_latex: str | None = None
    cover_letter_pdf_s3_key: str | None = None
    cover_letter_approved: bool = False

    status: Literal["draft", "ready", "applied"] = "draft"
    created_at: datetime = Field(default_factory=datetime.utcnow)
    updated_at: datetime = Field(default_factory=datetime.utcnow)

    class Settings:
        name = "applications"
        indexes = [
            "user_id",
            [("user_id", 1), ("created_at", -1)],
        ]
