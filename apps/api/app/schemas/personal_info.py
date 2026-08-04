"""PersonalInfo request/response schemas."""

from datetime import datetime

from pydantic import BaseModel, EmailStr


class PersonalInfoUpsert(BaseModel):
    name: str
    title: str
    city: str
    state: str
    phone: str
    email: EmailStr
    linkedin_url: str | None = None
    github_url: str | None = None


class PersonalInfoResponse(BaseModel):
    id: str
    user_id: str
    name: str
    title: str
    city: str
    state: str
    phone: str
    email: EmailStr
    linkedin_url: str | None = None
    github_url: str | None = None
    signature_s3_key: str | None = None
    created_at: datetime
    updated_at: datetime

    class Config:
        from_attributes = True
        json_encoders = {datetime: lambda v: v.isoformat()}
