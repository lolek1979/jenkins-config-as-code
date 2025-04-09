# Start from the official Jenkins image
FROM jenkins/jenkins

# Define build arguments (defaults based on image layers)
ARG user=jenkins
ARG group=jenkins
ARG uid=1000
ARG gid=1000
ARG AGENT_WORKDIR=/home/jenkins/agent
ARG VERSION=3301.v4363ddcca_4e7

# Switch to root to install prerequisites and additional software
USER root

# --- Install Prerequisites and Docker ---
RUN apt-get update -y && \
    apt-get install -y \
      apt-transport-https \
      ca-certificates \
      curl \
      gnupg-agent \
      software-properties-common

# Set up Docker's official GPG key and repository for Debian
RUN install -m 0755 -d /etc/apt/keyrings && \
    curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg && \
    chmod a+r /etc/apt/keyrings/docker.gpg && \
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null && \
    apt-get update -y && \
    apt-get install -y \
      docker-ce \
      docker-ce-cli \
      containerd.io \
      docker-buildx-plugin \
      docker-compose-plugin

# --- Install kubectl directly ---
RUN curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/$(dpkg --print-architecture)/kubectl" && \
    install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl && \
    rm kubectl

# --- Switch to jenkins user temporarily ---
USER jenkins
ENV AGENT_WORKDIR=${AGENT_WORKDIR}

# (Optional) Here you may add RUN steps as needed under the jenkins user.
# Then switch back to root to copy the agent launcher.

USER root

# --- Adjust ownership: Set Jenkins user UID and add Jenkins to the docker group ---
RUN usermod -u ${uid} jenkins && \
    groupmod -g ${gid} docker || true && \
    usermod -aG docker jenkins

# --- Switch back to jenkins ---
USER jenkins
WORKDIR /home/jenkins

# Define volumes (as declared in the official image)
VOLUME ["/home/jenkins/.jenkins", "/home/jenkins/agent"]

# Set metadata labels (optional)
LABEL org.opencontainers.image.vendor="Jenkins" \
      org.opencontainers.image.title="Official Jenkins Inbound Agent - Custom with Docker" 

# Set the default entrypoint that starts the agent using the provided jenkins-agent launcher.
ENTRYPOINT ["/usr/local/bin/jenkins-agent"]