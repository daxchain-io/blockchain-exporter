# syntax=docker/dockerfile:1

# Pinned by digest for reproducible, supply-chain-safe builds (multi-arch
# manifest). Dependabot's docker ecosystem keeps the digest current.
ARG PYTHON_IMAGE=python:3.11-slim@sha256:ae52c5bef62a6bdd42cd1e8dffef86b9cd284bde9427da79839de7a4b983e7ca

# ----------------------------------------------------------------------------
# Builder: install runtime dependencies into an in-project virtualenv.
# ----------------------------------------------------------------------------
FROM ${PYTHON_IMAGE} AS builder

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

ENV POETRY_VERSION=2.4.1 \
    POETRY_HOME=/opt/poetry \
    POETRY_NO_INTERACTION=1 \
    POETRY_VIRTUALENVS_IN_PROJECT=true \
    PATH="/opt/poetry/bin:${PATH}" \
    PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

# hadolint ignore=DL3008
RUN apt-get update \
    && apt-get install --no-install-recommends --yes curl \
    && curl -sSL https://install.python-poetry.org | python3 - \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY pyproject.toml poetry.lock ./

# Production dependencies only — no dev group, no project root package.
RUN poetry install --only main --no-root

# ----------------------------------------------------------------------------
# Runtime: minimal image with the venv copied in, running as a non-root user.
# ----------------------------------------------------------------------------
FROM ${PYTHON_IMAGE} AS runtime

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PYTHONPATH=/app/src \
    PATH="/app/.venv/bin:${PATH}" \
    BLOCKCHAIN_EXPORTER_CONFIG_PATH=/app/config/config.toml \
    HEALTH_PORT=8080 \
    METRICS_PORT=9100

# Dedicated unprivileged user/group (uid/gid 1000) — matches the Helm
# securityContext (runAsNonRoot, runAsUser: 1000).
RUN groupadd --system --gid 1000 app \
    && useradd --system --uid 1000 --gid app --no-create-home --shell /usr/sbin/nologin app

WORKDIR /app

COPY --from=builder /app/.venv /app/.venv
COPY src /app/src

USER 1000

EXPOSE 8080 9100

ENTRYPOINT ["python", "-m", "blockchain_exporter.main"]
