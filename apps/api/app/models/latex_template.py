"""LaTeXTemplate document — Jinja2-templated LaTeX sources."""

from datetime import datetime

from beanie import Document
from pydantic import Field


class LaTeXTemplate(Document):
    name: str = Field(..., min_length=1, max_length=100)
    description: str | None = None
    template_source: str
    is_default: bool = False
    created_at: datetime = Field(default_factory=datetime.utcnow)
    updated_at: datetime = Field(default_factory=datetime.utcnow)

    class Settings:
        name = "latex_templates"
        indexes = ["is_default"]
