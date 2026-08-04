"""Application settings loaded from environment variables."""

from pydantic_settings import BaseSettings, SettingsConfigDict


class Settings(BaseSettings):
    """Environment-driven configuration for the API."""

    mongodb_url: str = "mongodb://localhost:27017"
    mongodb_db_name: str = "job_forge"
    test_mongodb_url: str = "mongodb://localhost:27017"
    test_mongodb_db_name: str = "job_forge_test"
    debug: bool = False
    environment: str = "development"

    # Phase 1 has no auth; user-scoped queries filter on this placeholder
    # instead of a JWT-derived current_user until Phase 2 auth lands.
    default_user_id: str = "default-user"

    model_config = SettingsConfigDict(env_file=".env", case_sensitive=False)


settings = Settings()
