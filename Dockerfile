# Use an official Node.js image as the base
FROM node:22.14.0-alpine3.21

# Install Docker CLI (for Alpine, use apk)
RUN apk add --no-cache docker-cli

# This command keeps the container running for the agent
CMD ["cat"]