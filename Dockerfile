# ---------- STAGE 1: Builder ----------
ARG BASHATE_VERSION=2.1.1
ARG YAMLLINT_VERSION=1.37.0
ARG MARKDOWNLINT_VERSION=0.41.0
ARG HADOLINT_VERSION=2.12.0
ARG NODE_VERSION=18.19.1
ARG NPM_VERSION=10.2.4

FROM node:${NODE_VERSION}-bullseye-slim AS builder

ARG BASHATE_VERSION
ARG YAMLLINT_VERSION
ARG MARKDOWNLINT_VERSION
ARG HADOLINT_VERSION
ARG NPM_VERSION

# hadolint ignore=DL3008
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl ca-certificates && \
    curl -fsSL \
    "https://github.com/hadolint/hadolint/releases/download/v${HADOLINT_VERSION}/\
hadolint-Linux-x86_64" -o /usr/local/bin/hadolint && \
    chmod +x /usr/local/bin/hadolint && \
    npm install -g npm@${NPM_VERSION} && \
    npm install -g markdownlint-cli@${MARKDOWNLINT_VERSION} && \
    npm cache clean --force && \
    apt-get purge -y curl && \
    apt-get autoremove -y && apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# ---------- STAGE 2: Final ----------
FROM debian:bullseye-slim

ARG TITLE
ARG DESCRIPTION
ARG VERSION
ARG CREATED
ARG REVISION
ARG AUTHORS
ARG SOURCE
ARG DOCUMENTATION
ARG VENDOR
ARG REFNAME
ARG LICENSES
ARG BUILD_TIMESTAMP

ARG BASHATE_VERSION=2.1.1
ARG YAMLLINT_VERSION=1.37.0

LABEL org.opencontainers.image.title="${TITLE}" \
      org.opencontainers.image.description="${DESCRIPTION}" \
      org.opencontainers.image.version="${VERSION}" \
      org.opencontainers.image.created="${CREATED}" \
      org.opencontainers.image.revision="${REVISION}" \
      org.opencontainers.image.authors="${AUTHORS}" \
      org.opencontainers.image.url="${SOURCE}" \
      org.opencontainers.image.documentation="${DOCUMENTATION}" \
      org.opencontainers.image.source="${SOURCE}" \
      org.opencontainers.image.vendor="${VENDOR}" \
      org.opencontainers.image.licenses="${LICENSES}" \
      org.opencontainers.image.ref.name="${REFNAME}" \
      build-timestamp="${BUILD_TIMESTAMP}"

# hadolint ignore=DL3008
RUN apt-get update && apt-get install -y --no-install-recommends \
    python3-minimal python3-pip bash ca-certificates && \
    pip3 install --no-cache-dir \
    bashate==${BASHATE_VERSION} yamllint==${YAMLLINT_VERSION} && \
    apt-get purge -y python3-pip && \
    apt-get autoremove -y && apt-get clean && \
    rm -rf /var/lib/apt/lists/*

COPY --from=builder /usr/local/bin/hadolint /usr/local/bin/
COPY --from=builder /usr/local/bin/node /usr/local/bin/
COPY --from=builder /usr/local/bin/npm /usr/local/bin/
COPY --from=builder /usr/local/lib/node_modules /usr/local/lib/node_modules

RUN ln -s \
  /usr/local/lib/node_modules/markdownlint-cli/markdownlint.js \
  /usr/local/bin/markdownlint

COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

ENV PATH="/usr/local/bin:$PATH"
WORKDIR /src
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
CMD ["bash"]
