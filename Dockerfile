# This file is sourced from https://github.com/dbt-labs/dbt-adapters/blob/main/dbt-snowflake/docker

# this image gets published to GHCR for production use
ARG py_version=3.11.2

FROM python:$py_version AS base

RUN apt-get update
RUN apt-get dist-upgrade -y
# RUN apt-get install -y --no-install-recommends \
#   build-essential=12.9 \
#   ca-certificates=20210119 \
#   git=1:2.30.2-1+deb11u2 \
#   libpq-dev=13.18-0+deb11u1 \
#   make=4.3-4.1 \
#   openssh-client=1:8.4p1-5+deb11u3 \
#   software-properties-common=0.96.20.2-2.1
RUN apt-get clean
RUN rm -rf \
    /var/lib/apt/lists/* \
    /tmp/* \
    /var/tmp/*

ENV PYTHONIOENCODING=utf-8
ENV LANG=C.UTF-8

RUN python -m pip install --upgrade "pip==24.0" "setuptools==69.2.0" "wheel==0.43.0" --no-cache-dir


FROM base AS dbt-snowflake

ARG commit_ref=main

HEALTHCHECK CMD dbt --version || exit 1

WORKDIR /usr/app/dbt/
ENTRYPOINT ["dbt"]

RUN python -m pip install --no-cache-dir dbt-core dbt-snowflake
