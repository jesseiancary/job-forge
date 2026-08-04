"""Shared pytest fixtures — real MongoDB test database, no mocks."""

import pytest
from beanie import init_beanie
from pymongo import AsyncMongoClient

from app.config import settings
from app.models import DOCUMENT_MODELS


@pytest.fixture
async def db_client():
    """Async Mongo client for the test database."""
    client = AsyncMongoClient(settings.test_mongodb_url)
    yield client
    await client.close()


@pytest.fixture(autouse=True)
async def clear_database(db_client):
    """Initialize Beanie against the test database and clear it before each test."""
    database = db_client[settings.test_mongodb_db_name]
    await init_beanie(database=database, document_models=DOCUMENT_MODELS)

    for model in DOCUMENT_MODELS:
        await model.delete_all()

    yield

    for model in DOCUMENT_MODELS:
        await model.delete_all()
