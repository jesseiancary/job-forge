"""Embedded resume content shared by ResumeVariant and Application."""

from pydantic import BaseModel, Field


class ExperienceEntry(BaseModel):
    company: str
    title: str
    dates: str
    location: str
    bullets: list[str] = Field(default_factory=list)


class EducationEntry(BaseModel):
    school: str
    degree: str
    graduation_date: str
    location: str
    description: str


class ResumeContent(BaseModel):
    professional_summary: str
    experience: list[ExperienceEntry] = Field(default_factory=list)
    education: list[EducationEntry] = Field(default_factory=list)
    skills: list[str] = Field(default_factory=list)
