FROM node:22-slim

RUN apt-get update && apt-get install -y \
    wget \
    gnupg \
    curl

RUN wget -O - https://packages.adoptium.net/artifactory/api/gpg/key/public \
    | gpg --dearmor -o /usr/share/keyrings/adoptium.gpg

RUN echo "deb [signed-by=/usr/share/keyrings/adoptium.gpg] \
    https://packages.adoptium.net/artifactory/deb bookworm main" \
    > /etc/apt/sources.list.d/adoptium.list

RUN apt-get update && apt-get install -y \
    temurin-21-jdk \
    gradle \
    git \
    gh \
    tmux \
    curl \
    wget \
    ripgrep \
    fd-find \
    build-essential \
    procps \
    unzip \
    zip \
    python3 \
    python3-pip \
    vim \
    && rm -rf /var/lib/apt/lists/*

RUN npm install -g \
    @anthropic-ai/claude-code \
    typescript \
    tsx \
    bun 

RUN usermod -l claude -d /home/claude -m node && \
    groupmod -n claude node

ENV JAVA_HOME=/usr/lib/jvm/temurin-21-jdk-amd64
ENV PATH="$JAVA_HOME/bin:$PATH"

WORKDIR /workspace

USER claude

CMD ["sleep", "infinity"]