FROM node:18
# Install Docker CLI - this uses apt-get for Debian/Ubuntu-based images
RUN apt-get update && apt-get install -y docker.io

WORKDIR /home/jenkins/agent

CMD ["sleep", "infinity"]