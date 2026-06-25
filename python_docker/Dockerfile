# Container Python API, Kafka, Lambda consumer, via Terraform + CloudFormation
# github.com/sqlxpert/docker-python-openapi-kafka-terraform-cloudformation-aws
# GPLv3, Copyright Paul Marcelin

# Defaults required:
# https://docs.docker.com/reference/build-checks/invalid-default-arg-in-from
ARG BASE_AMAZONLINUX_REGISTRY_DOMAIN='public.ecr.aws'
ARG BASE_AMAZONLINUX_REGISTRY_PATH="${BASE_AMAZONLINUX_REGISTRY_DOMAIN}/amazonlinux/"
ARG BASE_AMAZONLINUX_TAG='2023.12.20260622.0'
ARG BASE_AMAZONLINUX_DIGEST='sha256:da8159b6af7d20f55f7e5da633dab214c04cac9ea660bb60963b6bca30c8a6a0'
FROM "${BASE_AMAZONLINUX_REGISTRY_PATH}amazonlinux:${BASE_AMAZONLINUX_TAG}@${BASE_AMAZONLINUX_DIGEST}"

ARG BASE_AMAZONLINUX_REGISTRY_PATH
ARG BASE_AMAZONLINUX_TAG
ARG BASE_AMAZONLINUX_DIGEST
LABEL org.opencontainers.image.base.name="${BASE_AMAZONLINUX_REGISTRY_PATH}amazonlinux:${BASE_AMAZONLINUX_TAG}"
LABEL org.opencontainers.image.base.digest="${BASE_AMAZONLINUX_DIGEST}"

LABEL org.opencontainers.image.documentation="https://github.com/sqlxpert/docker-python-openapi-kafka-terraform-cloudformation-aws"

LABEL org.opencontainers.image.title="Hello world API"
LABEL org.opencontainers.image.description="Uses Python 3.13, OpenAPI 3.0, Connexion, Uvicorn workers, Gunicorn"
LABEL org.opencontainers.image.authors="Paul Marcelin"
LABEL org.opencontainers.image.vendor="Paul Marcelin"
LABEL org.opencontainers.image.licenses="GPL-3.0-only"
LABEL org.opencontainers.image.source="https://github.com/sqlxpert/docker-python-openapi-kafka-terraform-cloudformation-aws/blob/main/Dockerfile"

SHELL ["/usr/bin/bash", "-c"]

RUN \
  --mount=type=cache,target=/var/cache/dnf,sharing=locked \
  --mount=type=cache,target=/var/lib/dnf,sharing=locked \
  dnf install \
    --assumeyes \
    --setopt=install_weak_deps=False \
    --nodocs \
    python3.13 \
    coreutils-single \
    util-linux \
    shadow-utils \
  && useradd --shell /usr/bin/bash --home /hello_api --user-group --uid 1011 hello_api \
  && dnf remove \
    --assumeyes \
    --setopt=clean_requirements_on_remove=True \
    shadow-utils
# shadow-utils provides useradd
# coreutils-single (present in Amazon Linux by default, but noted here as a
# dependency) provides cat and util-linux provides script for ECS Exec logging
# Operating system package versions are omitted, thanks to
# https://docs.aws.amazon.com/linux/al2023/ug/deterministic-upgrades.html

USER hello_api
WORKDIR /hello_api

ENV VIRTUAL_ENV="/hello_api/python_venv"
RUN python3.13 -m venv "${VIRTUAL_ENV}"
ENV PATH="${VIRTUAL_ENV}/bin:${PATH}"

###############################################################################
# Local file references ( --mount=type=bind,source= , COPY , ADD )
#
# Also add files to .dockerignore ; mine ignores files not explicitly listed.

RUN \
  --mount=type=bind,source=requirements.txt,target=/tmp/requirements.txt \
  --mount=type=cache,target=.cache/pip,uid=1011,gid=1011 \
  pip install --upgrade pip==26.1.2 \
  && pip install --requirement /tmp/requirements.txt \
  && pip uninstall --yes pip

COPY \
  hello_api.openapi.yaml \
  hello_api.py \
  ./

###############################################################################

EXPOSE 8000/tcp
CMD ["gunicorn", "--log-level", "error", "--error-logfile", "-", "--access-logfile", "-", "--worker-class", "uvicorn.workers.UvicornWorker", "--worker-tmp-dir", "/dev/shm", "--workers", "2",  "--bind", "0.0.0.0:8000", "hello_api:hello_api_app"]
