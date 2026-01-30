FROM ghcr.io/anomalyco/opencode:latest

USER root

# Install dependencies
RUN apk add --no-cache curl bash unzip git

# Install bun
RUN curl -fsSL https://bun.sh/install | bash
ENV BUN_INSTALL="/root/.bun"
ENV PATH="$BUN_INSTALL/bin:$PATH"

# Install oh-my-opencode
RUN bun install -g oh-my-opencode

# Initialize oh-my-opencode
RUN bunx oh-my-opencode install || true

WORKDIR /workspace
