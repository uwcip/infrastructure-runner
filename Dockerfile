FROM debian:bullseye-slim@sha256:a23887a2e830b815955e010f30d4c2430cd5ef82e93c130471024bc9f808d5d3 AS base

# github metadata
LABEL org.opencontainers.image.source=https://github.com/uwcip/infrastructure-runner

# install updates and dependencies
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get -q update && apt-get -y upgrade && \
    # install our dependencies
    apt-get install -y --no-install-recommends tini git git-lfs jq make curl ca-certificates gnupg && \
    # install the github runner dependencies
    apt-get install -y --no-install-recommends liblttng-ust0 libkrb5-3 zlib1g libssl1.1 libicu67 && \
    # install docker dependencies
    curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /etc/apt/trusted.gpg.d/docker-archive-bullseye.gpg && \
    echo -n "deb [arch=amd64] https://download.docker.com/linux/debian bullseye stable" > /etc/apt/sources.list.d/docker.list && \
    apt-get -q update && apt-get install -y --no-install-recommends docker-ce-cli docker-compose pass && \
    # clean up apt files
    apt-get clean && rm -rf /var/lib/apt/lists/*

# these should be filled in by the container user
# if these are NOT set then the container probably will not work
ENV GITHUB_RUNNER_OWNER=""
ENV GITHUB_RUNNER_NAME=""
ENV GITHUB_TOKEN=""

# copy the entrypoint file
RUN mkdir /opt/runner
COPY entrypoint /entrypoint

# this will run as root to deal with container issues
ENV RUNNER_ALLOW_RUNASROOT="1"

ENTRYPOINT ["tini", "--", "/entrypoint"]
