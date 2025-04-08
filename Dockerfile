FROM jenkins/inbound-agent:latest

USER root
RUN apt-get update && \
    apt-get install -y apt-transport-https ca-certificates curl gnupg2 software-properties-common lsb-release && \
    # (Optional) If you prefer to see the codename:
    CODENAME=$(lsb_release -cs) && \
    echo "Detected codename: ${CODENAME}" && \
    # Now install docker.io from the default repos
    apt-get update && \
    apt-get install -y docker.io && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Allow Jenkins user to run docker without sudo
RUN usermod -aG docker jenkins

USER jenkins
WORKDIR /home/jenkins/agent
CMD ["sleep", "infinity"]