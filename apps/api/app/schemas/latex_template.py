"""LaTeXTemplate response schema.

No Create/Update schema yet — templates aren't user-created via API until
seeding lands in Milestone 1.4.
"""

from datetime import datetime

from pydantic import BaseModel


class LaTeXTemplateResponse(BaseModel):
    id: str
    name: str
    description: str | None = None
    template_source: str
    is_default: bool
    created_at: datetime
    updated_at: datetime

    class Config:
        from_attributes = True
        json_encoders = {datetime: lambda v: v.isoformat()}
