# Stage 1: Builder
FROM buildpack-deps:bullseye as build

# Install build dependencies
RUN apt-get update \
 && apt-get install -y --no-install-recommends \
        golang \
        libglvnd-dev \
        libsecret-1-dev \
 && rm -rf /var/lib/apt/lists/*

# Download source
ARG BRIDGE_VERSION=v2.1.0
ARG BRDIGE_SOURCE_URL=https://github.com/ProtonMail/proton-bridge.git
WORKDIR /source
RUN git clone --branch "${BRIDGE_VERSION}" --config advice.detachedHead=false "${BRDIGE_SOURCE_URL}" .

# Build
RUN make build-nogui

# Stage 2: Runtime
FROM debian:11-slim

# Install runtime dependencies
RUN apt-get update \
 && apt-get install -y --no-install-recommends \
        gnupg \
        libsecret-1-0 \
        pass \
 && rm -rf /var/lib/apt/lists/*

# Install binary
COPY --from=build /source/proton-bridge /usr/local/bin/

# Define variable for passing armored GPG key for import
ENV BRIDGE_GPG_KEY ""

# Setup entrypoint
COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT [ "/entrypoint.sh" ]
