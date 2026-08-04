FROM python:3.13-slim

WORKDIR /app

# Install Poetry
RUN pip install poetry==2.4.1

# Copy Poetry files
COPY pyproject.toml poetry.lock ./

# Configure Poetry to not create virtual environment (we're in Docker)
RUN poetry config virtualenvs.create false

# Install dependencies
RUN poetry install --no-root --no-interaction --no-ansi

# Expose FastAPI port
EXPOSE 8000

# Start Uvicorn with auto-reload
CMD ["poetry", "run", "uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8000", "--reload"]
