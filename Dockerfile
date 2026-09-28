FROM ubuntu:22.04

# Prevent interactive timezone/keyboard prompts during installation
ENV DEBIAN_FRONTEND=noninteractive

# Install core dependencies and the repository manager for PPAs
RUN apt-get update && apt-get install -y \
    software-properties-common \
    curl \
    git \
    unzip \
    xz-utils \
    zip \
    libglu1-mesa \
    sudo \
    # Add the deadsnakes PPA to get Python 3.11 on Ubuntu 22.04
    && add-apt-repository ppa:deadsnakes/ppa -y \
    && apt-get update \
    && apt-get install -y \
    python3.11 \
    python3.11-venv \
    python3.11-dev \
    && rm -rf /var/lib/apt/lists/*

# Set Python 3.11 as the default for the 'python' and 'python3' commands
RUN update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.11 1 && \
    update-alternatives --install /usr/bin/python python /usr/bin/python3.11 1

# Install pip specifically for Python 3.11
RUN curl -sS https://bootstrap.pypa.io/get-pip.py | python3.11

# Install code-server globally
RUN curl -fsSL https://code-server.dev/install.sh | sh

# Create a non-root user
RUN useradd -m -s /bin/bash coder && \
    echo "coder ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

USER coder
WORKDIR /home/coder

# Install Flutter SDK - pinned to version 3.47.0
RUN git clone --depth 1 --branch 3.47.0 https://github.com/flutter/flutter.git /home/coder/flutter
ENV PATH="/home/coder/flutter/bin:${PATH}"

# Pre-download Flutter development binaries
RUN flutter config --no-analytics && flutter precache

# Create a directory for your persistent projects
RUN mkdir -p /home/coder/workspace

# Expose the web-based IDE port
EXPOSE 8080

# Start code-server without a password, scoped to your workspace folder
CMD ["code-server", "--bind-addr", "0.0.0.0:8080", "--auth", "none", "/home/coder/workspace"]