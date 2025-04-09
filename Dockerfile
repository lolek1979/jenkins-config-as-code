FROM jenkins/jenkins

ARG HOST_UID=1004
ARG HOST_GID=999

USER root

# Update and install prerequisites
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

# Install kubectl by downloading the binary directly (this works well on Debian Bookworm)
RUN curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/$(dpkg --print-architecture)/kubectl" && \
    install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl && \
    rm kubectl

# # Adjust Jenkins user UID and add the Jenkins user to the docker group
# RUN usermod -u $HOST_UID jenkins && \
#     groupmod -g $HOST_GID docker || true && \
#     usermod -aG docker jenkins

# USER jenkins
# WORKDIR /var/jenkins_home

CMD ["jenkins"]