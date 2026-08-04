"""MongoDB client + Beanie initialization."""

from beanie import init_beanie
from pymongo import AsyncMongoClient

from app.config import settings
from app.models import DOCUMENT_MODELS

_client: AsyncMongoClient | None = None


async def init_db() -> None:
    """Create the async Mongo client and initialize Beanie (creates indexes)."""
    global _client
    _client = AsyncMongoClient(settings.mongodb_url)
    database = _client[settings.mongodb_db_name]
    await init_beanie(database=database, document_models=DOCUMENT_MODELS)


async def close_db() -> None:
    """Close the Mongo client on shutdown."""
    if _client is not None:
        await _client.close()
