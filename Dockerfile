ARG PYTHON_VERSION=3.11.4
FROM python:${PYTHON_VERSION}-slim AS base

ENV PYTHONDONTWRITEBYTECODE=1

ENV PYTHONUNBUFFERED=1

# App specific environment vars
ENV DB_PASSWORD="foo"

ENV API_BASE_URL="/api"

ENV LOG_LEVEL="info"

ENV MAX_CONECTIONS=100


WORKDIR /app

ARG UID=10001
RUN adduser \
    --disabled-password \
    --gecos "" \
    --shell "/sbin/nologin" \
    --no-create-home \
    --uid "${UID}" \
    appuser


COPY ./app .

# Resolve the psutils installation
RUN apt-get update && apt-get install -y \
    gcc python3-dev \
    && rm -rf /var/lib/apt/lists/*

RUN python -m pip install -r requirements.txt

RUN python -m pip install fastapi[standard]

USER appuser

# Expose the port that the application listens on.
EXPOSE 8080

# Run the application.
CMD ["fastapi", "run", "main.py", "--port", "8080"]