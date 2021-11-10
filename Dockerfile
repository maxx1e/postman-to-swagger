FROM debian:stable-slim

# Prepare build arguments
ARG NODE_VERSION=v12.16.1
ARG NPM_CONFIG_LOGLEVEL=info
ARG POSTMAN_HOME=/opt/postman

# Provide environments
ENV NODE_HOME=/opt/nodejs
ENV POSTMAN_COLLECTION=input.json

# Install tools + purge all the things
RUN apt-get update && apt-get install -y \
    apt-transport-https \
    ca-certificates \
    wget \
    --no-install-recommends \
    && apt-get purge \
    && rm -rf /var/lib/apt/lists/*

# Install Node
RUN echo "[INFO] Install Node $NODE_VERSION." && \
    mkdir -p "${NODE_HOME}" && \
    mkdir -p "${POSTMAN_HOME}" && \
    wget -qO- "http://nodejs.org/dist/${NODE_VERSION}/node-${NODE_VERSION}-linux-x64.tar.gz" | tar -xzf - -C "${NODE_HOME}" && \
    ln -s "${NODE_HOME}/node-${NODE_VERSION}-linux-x64/bin/node" /usr/local/bin/node && \
    ln -s "${NODE_HOME}/node-${NODE_VERSION}-linux-x64/bin/npm" /usr/local/bin/npm && \
    ln -s "${NODE_HOME}/node-${NODE_VERSION}-linux-x64/bin/npx" /usr/local/bin/ && \
    # Install postman to swagger
    npm i postman-to-openapi -g && \
    ln -s "${NODE_HOME}/node-${NODE_VERSION}-linux-x64/bin/p2o" /usr/local/bin/p2o

COPY options.json "${POSTMAN_HOME}"

WORKDIR ${POSTMAN_HOME}

ENTRYPOINT ["/usr/local/bin/p2o"]
