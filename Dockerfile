# ---------------------------------------------------------------------------------------------------------------------#
# BASE IMAGE - BUILDERS
# ---------------------------------------------------------------------------------------------------------------------#
FROM python:3.9.10-slim as base-image

LABEL maintainer="LI Tian"

ENV PYTHONUNBUFFERED 1 \  # output immediately without buffer, it's good for real time monitoring.
    POETRY_VERSION=1.4.0 \  # poetry version
    POETRY_VIRTUALENVS_CREATE=false \  # we are a container, so no need to create virtualenvs

# install poetry
# reference: https://python-poetry.org/docs/
RUN apt-get update \
    && apt install -y curl netcat \
    && curl -sSL https://install.python-poetry.org | python3 -
ENV PATH="/root/.poetry/bin:${PATH}"

# install dependencies
COPY pyproject.toml poetry.lock ./


# ---------------------------------------------------------------------------------------------------------------------#
# DEVELOPMENT IMAGE
# ---------------------------------------------------------------------------------------------------------------------#
FROM base-image as development
ENV FASTAPI_ENV=development

WORKDIR /example

# developer no need interaction wwith
# developer is already at the bottom, so no need to use sudo
RUN poetry install --no-root --no-interaction



# ---------------------------------------------------------------------------------------------------------------------#
# PRODUCTION IMAGE
# ---------------------------------------------------------------------------------------------------------------------#
FROM base-image as production
ENV FASTAPI_ENV=production

WORKDIR /example

# production enviorment no need dev dependencies
RUN poetry install --no-root --no-dev --no-interaction --no-dev

# copy source code
COPY /example .