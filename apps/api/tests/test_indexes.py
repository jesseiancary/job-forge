"""Index presence and uniqueness-enforcement tests."""

import pytest
from pymongo.errors import DuplicateKeyError

from app.models.application import Application
from app.models.personal_info import PersonalInfo
from app.models.resume_content import ResumeContent
from app.models.resume_variant import ResumeVariant
from app.models.user import User


class TestIndexesExist:
    async def test_user_email_index_exists(self):
        indexes = await User.get_pymongo_collection().index_information()
        assert "email_1" in indexes
        assert indexes["email_1"]["unique"] is True

    async def test_personal_info_user_id_index_exists(self):
        indexes = await PersonalInfo.get_pymongo_collection().index_information()
        assert "user_id_1" in indexes
        assert indexes["user_id_1"]["unique"] is True

    async def test_resume_variant_indexes_exist(self):
        indexes = await ResumeVariant.get_pymongo_collection().index_information()
        assert "user_id_1" in indexes
        assert "created_at_1" in indexes
        assert "user_id_1_name_1" in indexes
        assert indexes["user_id_1_name_1"]["unique"] is True

    async def test_application_indexes_exist(self):
        indexes = await Application.get_pymongo_collection().index_information()
        assert "user_id_1" in indexes
        assert "user_id_1_created_at_-1" in indexes


class TestUniqueConstraints:
    async def test_duplicate_email_raises(self):
        await User(email="dup@example.com", full_name="First User").insert()

        with pytest.raises(DuplicateKeyError):
            await User(email="dup@example.com", full_name="Second User").insert()

    async def test_duplicate_personal_info_user_id_raises(self):
        await PersonalInfo(
            user_id="default-user",
            name="Jane Doe",
            title="Senior Engineer",
            city="Austin",
            state="TX",
            phone="555-0100",
            email="jane@example.com",
        ).insert()

        with pytest.raises(DuplicateKeyError):
            await PersonalInfo(
                user_id="default-user",
                name="Jane Doe Again",
                title="Staff Engineer",
                city="Austin",
                state="TX",
                phone="555-0101",
                email="jane2@example.com",
            ).insert()

    async def test_duplicate_resume_variant_name_per_user_raises(self):
        content = ResumeContent(professional_summary="Summary")

        await ResumeVariant(
            user_id="default-user",
            name="full-stack-fintech",
            content=content,
            template_id="65f1a2b3c4d5e6f7a8b9c0d1",
        ).insert()

        with pytest.raises(DuplicateKeyError):
            await ResumeVariant(
                user_id="default-user",
                name="full-stack-fintech",
                content=content,
                template_id="65f1a2b3c4d5e6f7a8b9c0d1",
            ).insert()

    async def test_same_variant_name_allowed_for_different_user(self):
        content = ResumeContent(professional_summary="Summary")

        await ResumeVariant(
            user_id="user-a",
            name="full-stack-fintech",
            content=content,
            template_id="65f1a2b3c4d5e6f7a8b9c0d1",
        ).insert()

        # Should not raise — same name, different user.
        await ResumeVariant(
            user_id="user-b",
            name="full-stack-fintech",
            content=content,
            template_id="65f1a2b3c4d5e6f7a8b9c0d1",
        ).insert()
