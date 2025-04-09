# Use the official Docker CLI image as the base
FROM docker:20.10.21

USER root

# Install other utilities via apk
RUN apk update && \
    apk add --no-cache \
      bash \
      curl \
      git \
      docker-compose \
      openjdk11-jre

# Download and install kubectl manually
# For aarch64 (ARM64) architecture, use arm64 in the URL. For AMD64, replace 'arm64' with 'amd64'.
RUN curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/arm64/kubectl" && \
    chmod +x kubectl && \
    mv kubectl /usr/local/bin/kubectl

# (Optional) Install additional tools here (for example, maven or helm)
# RUN apk add --no-cache maven helm

# Create a workspace directory
RUN mkdir -p /home/jenkins/agent

# Set the working directory to the agent's working directory
WORKDIR /home/jenkins/agent

# In this example, we remain as root.
# Optionally create a non-root user if your Jenkins agent requires it:
# RUN adduser -D jenkins && chown -R jenkins:jenkins /home/jenkins/agent
# USER jenkins