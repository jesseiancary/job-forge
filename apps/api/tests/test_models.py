"""Model creation/validation smoke tests for all six Beanie documents."""

import pytest
from pydantic import ValidationError

from app.models.application import Application
from app.models.latex_template import LaTeXTemplate
from app.models.llm_conversation import LLMConversation, Message
from app.models.personal_info import PersonalInfo
from app.models.resume_content import EducationEntry, ExperienceEntry, ResumeContent
from app.models.resume_variant import ResumeVariant
from app.models.user import User


class TestUser:
    async def test_creates_with_valid_data(self):
        user = User(email="jane@example.com", full_name="Jane Doe")
        await user.insert()

        assert user.id is not None
        assert user.created_at is not None
        assert user.updated_at is not None

    def test_rejects_invalid_email(self):
        with pytest.raises(ValidationError):
            User(email="not-an-email", full_name="Jane Doe")

    def test_rejects_empty_full_name(self):
        with pytest.raises(ValidationError):
            User(email="jane@example.com", full_name="")


class TestPersonalInfo:
    async def test_creates_with_valid_data(self):
        info = PersonalInfo(
            user_id="default-user",
            name="Jane Doe",
            title="Senior Engineer",
            city="Austin",
            state="TX",
            phone="555-0100",
            email="jane@example.com",
        )
        await info.insert()

        assert info.id is not None
        assert info.signature_s3_key is None

    def test_rejects_invalid_email(self):
        with pytest.raises(ValidationError):
            PersonalInfo(
                user_id="default-user",
                name="Jane Doe",
                title="Senior Engineer",
                city="Austin",
                state="TX",
                phone="555-0100",
                email="not-an-email",
            )


class TestResumeVariant:
    def _valid_content(self) -> ResumeContent:
        return ResumeContent(
            professional_summary="Senior engineer with 10 years of experience.",
            experience=[
                ExperienceEntry(
                    company="Acme Corp",
                    title="Senior Engineer",
                    dates="2020 - Present",
                    location="Remote",
                    bullets=["Built system X", "Led team of 5"],
                )
            ],
            education=[
                EducationEntry(
                    school="State University",
                    degree="B.S. Computer Science",
                    graduation_date="2010",
                    location="Austin, TX",
                    description="",
                )
            ],
            skills=["Python", "MongoDB"],
        )

    async def test_creates_with_valid_data(self):
        variant = ResumeVariant(
            user_id="default-user",
            name="full-stack-fintech",
            content=self._valid_content(),
            template_id="65f1a2b3c4d5e6f7a8b9c0d1",
        )
        await variant.insert()

        assert variant.id is not None

    def test_rejects_name_too_long(self):
        with pytest.raises(ValidationError):
            ResumeVariant(
                user_id="default-user",
                name="x" * 101,
                content=self._valid_content(),
                template_id="65f1a2b3c4d5e6f7a8b9c0d1",
            )

    async def test_embedded_content_round_trips(self):
        variant = ResumeVariant(
            user_id="default-user",
            name="backend-healthtech",
            content=self._valid_content(),
            template_id="65f1a2b3c4d5e6f7a8b9c0d1",
        )
        await variant.insert()

        reloaded = await ResumeVariant.get(variant.id)

        assert reloaded is not None
        assert reloaded.content.professional_summary == self._valid_content().professional_summary
        assert reloaded.content.experience[0].company == "Acme Corp"
        assert reloaded.content.experience[0].bullets == ["Built system X", "Led team of 5"]
        assert reloaded.content.education[0].school == "State University"


class TestLaTeXTemplate:
    async def test_creates_with_valid_data(self):
        template = LaTeXTemplate(
            name="modern-two-column",
            template_source="\\documentclass{article}",
            is_default=True,
        )
        await template.insert()

        assert template.id is not None
        assert template.is_default is True


class TestApplication:
    async def test_creates_with_valid_data_and_defaults(self):
        application = Application(
            user_id="default-user",
            company_name="Acme Corp",
            company_slug="acme-corp",
            job_title="Senior Backend Engineer",
            job_description="Build things.",
            resume_variant_id="65f1a2b3c4d5e6f7a8b9c0d1",
        )
        await application.insert()

        assert application.id is not None
        assert application.status == "draft"
        assert application.resume_content is None
        assert application.cover_letter_approved is False

    def test_rejects_invalid_status(self):
        with pytest.raises(ValidationError):
            Application(
                user_id="default-user",
                company_name="Acme Corp",
                company_slug="acme-corp",
                job_title="Senior Backend Engineer",
                job_description="Build things.",
                resume_variant_id="65f1a2b3c4d5e6f7a8b9c0d1",
                status="submitted",
            )


class TestLLMConversation:
    async def test_creates_with_embedded_messages(self):
        conversation = LLMConversation(
            application_id="65f1a2b3c4d5e6f7a8b9c0d1",
            user_id="default-user",
            messages=[
                Message(role="user", content="Make it more technical."),
                Message(role="assistant", content="Here is a revised draft."),
            ],
        )
        await conversation.insert()

        assert conversation.id is not None
        assert len(conversation.messages) == 2
        assert conversation.messages[0].role == "user"

    def test_rejects_invalid_role(self):
        with pytest.raises(ValidationError):
            Message(role="bot", content="Hello")
