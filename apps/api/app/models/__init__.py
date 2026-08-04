"""Beanie document registry."""

from app.models.application import Application
from app.models.latex_template import LaTeXTemplate
from app.models.llm_conversation import LLMConversation
from app.models.personal_info import PersonalInfo
from app.models.resume_variant import ResumeVariant
from app.models.user import User

DOCUMENT_MODELS = [
    User,
    PersonalInfo,
    ResumeVariant,
    LaTeXTemplate,
    Application,
    LLMConversation,
]
