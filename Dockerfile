# ---------------------------------------------------------------------------------------------------------------------#
# BASE IMAGE - BUILDERS
# ---------------------------------------------------------------------------------------------------------------------#
FROM python:3.9.10-slim as base-image
#FROM --platform=linux/amd64 python:3.9.10-slim as base-image

# output immediately without buffer, it's good for real time monitoring.
# we are a container, so no need to create virtualenvs
ENV PYTHONUNBUFFERED 1

# install poetry
# reference: https://python-poetry.org/docs/
RUN apt-get update \
    && apt-get install -y --no-install-recommends curl netcat \
    && curl -sSL https://install.python-poetry.org | python3 - \
    && apt-get remove -y curl \
    && apt-get autoremove -y

ENV POETRY_HOME /root/.local/bin
ENV PATH="$POETRY_HOME/:$PATH"


# install dependencies
WORKDIR /app
COPY . .


# ---------------------------------------------------------------------------------------------------------------------#
# DEVELOPMENT IMAGE
# ---------------------------------------------------------------------------------------------------------------------#
FROM base-image as dev
ENV FASTAPI_ENV=dev

WORKDIR /app

RUN poetry install --no-root --no-interaction

# Expose the port that the app will run on
EXPOSE 8000

# Start the application using Uvicorn
#WORKDIR example
#CMD ["poetry", "run", "uvicorn", "api:api", "--host", "0.0.0.0", "--port", "8000"]


## ---------------------------------------------------------------------------------------------------------------------#
## PRODUCTION IMAGE
## ---------------------------------------------------------------------------------------------------------------------#
#FROM base-image as production
#ENV FASTAPI_ENV=production
#
#WORKDIR /example
#
## production enviorment no need dev dependencies
#RUN poetry install --no-root --no-dev --no-interaction
#
## copy source code
#COPY /example .
