FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive

# Base build tools and libraries needed for Python 2.7 and Node builds
RUN apt-get update && apt-get install -y --no-install-recommends \
    patch build-essential perl pkg-config libssl-dev zlib1g-dev libbz2-dev \
    libreadline-dev libsqlite3-dev libffi-dev libncursesw5-dev liblzma-dev \
    curl ca-certificates wget xz-utils make autoconf git file zip unzip \
    && rm -rf /var/lib/apt/lists/*

# Prepare mise shims directory (mise will be installed at runtime if needed)
RUN mkdir -p /root/.local/share/mise/shims

# Let docker-compose control entrypoint and working_dir