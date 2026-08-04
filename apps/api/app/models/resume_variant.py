"""ResumeVariant document — structured resume content, source of truth."""

from datetime import datetime

from beanie import Document
from pydantic import Field
from pymongo import IndexModel

from app.models.resume_content import ResumeContent


class ResumeVariant(Document):
    user_id: str = Field(..., description="Single-user placeholder in Phase 1")
    name: str = Field(..., min_length=1, max_length=100)
    description: str | None = None

    content: ResumeContent

    latex_source: str | None = None
    pdf_s3_key: str | None = None
    template_id: str

    created_at: datetime = Field(default_factory=datetime.utcnow)
    updated_at: datetime = Field(default_factory=datetime.utcnow)
    last_compiled_at: datetime | None = None

    class Settings:
        name = "resume_variants"
        indexes = [
            "user_id",
            "created_at",
            IndexModel([("user_id", 1), ("name", 1)], unique=True),
        ]

    class Config:
        json_schema_extra = {
            "example": {
                "user_id": "default-user",
                "name": "full-stack-fintech",
                "description": "FinTech/Payment resume for backend roles",
                "content": {
                    "professional_summary": "17 years of experience...",
                    "experience": [
                        {
                            "company": "TechCorp",
                            "title": "Senior Engineer",
                            "dates": "2020 - Present",
                            "location": "Remote",
                            "bullets": ["Built system X", "Led team of 5"],
                        }
                    ],
                    "education": [],
                    "skills": ["Python", "MongoDB"],
                },
                "template_id": "65f1a2b3c4d5e6f7a8b9c0d1",
            }
        }
