FROM ghcr.io/anomalyco/opencode:latest

USER root

# Install dependencies including Node.js and npm
RUN apk add --no-cache curl bash unzip git nodejs npm

# Install oh-my-opencode globally via npm (ignore scripts to avoid binary issues)
RUN npm install -g oh-my-opencode --ignore-scripts

WORKDIR /workspace
