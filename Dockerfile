FROM jenkins/inbound-agent:latest

USER root
ENV DEBIAN_FRONTEND=noninteractive
ENV HOME=/home/jenkins
ENV JENKINS_URL=http://jenkins.jenkins.svc.cluster.local:8080
RUN curl -L "${JENKINS_URL}/jnlpJars/agent.jar" -o /home/jenkins/agent/agent.jar

# Conditionally remove "stretch-backports" references if they exist.
RUN if [ -f /etc/apt/sources.list ]; then \
      sed -i '/stretch-backports/ d' /etc/apt/sources.list; \
    fi && \
    if [ -d /etc/apt/sources.list.d ]; then \
      find /etc/apt/sources.list.d -type f -exec sed -i '/stretch-backports/ d' {} \; ; \
    fi

# Install ca-certificates-java first then update certificates.
RUN apt-get update && \
    apt-get install -y --no-install-recommends ca-certificates-java && \
    update-ca-certificates -f

# Update apt and install necessary packages.
# Use openjdk-17-jre-headless because Debian Bookworm now provides JDK 17.
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
      bash \
      curl \
      git \
      docker-compose \
      openjdk-17-jre-headless && \
    dpkg --configure -a && \
    rm -rf /var/lib/apt/lists/*

# Download and install kubectl manually (amd64 version)
RUN curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" && \
    chmod +x kubectl && \
    mv kubectl /usr/local/bin/kubectl

# Download and install the Docker CLI (static binary for amd64)
RUN curl -fsSL "https://download.docker.com/linux/static/stable/x86_64/docker-20.10.21.tgz" | \
    tar xz --strip 1 -C /usr/local/bin docker

# Create a workspace directory for the Jenkins agent and adjust ownership for the jenkins user.
RUN mkdir -p /home/jenkins/agent && chown -R jenkins:jenkins /home/jenkins/agent
WORKDIR /home/jenkins/agent

USER jenkins