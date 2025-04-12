# Jenkins Configuration as Code (JCasC) with Docker, Kubernetes, and Custom Agents

This project provides a complete Jenkins setup using [Jenkins Configuration as Code (JCasC)](https://www.jenkins.io/projects/jcasc/), customized for Kubernetes environments with Docker support, GitHub integration, and Argo CD CLI.

## 🔧 What's Included

- **Base Docker Image**: Custom `jenkins/inbound-agent` extended with Docker, Helm, kubectl, and Argo CD CLI.
- **Credentials**: Docker Hub, GitHub, and Argo CD tokens configured for pipeline use.
- **Jenkins Controller Settings**: Admin user, authorization, cloud agent templates, and SCM polling.
- **Jenkins Agent Pods**: Kubernetes-based agents with support for Docker socket mounting.
- **Pipeline Bootstrap**: A predefined pipeline for the `sw-movie-app` using GitHub.

---

## 📦 Custom Docker Agent (`pkonieczny321/jenkins-docker-agent:latest`)

Extended from the official `jenkins/inbound-agent`, this custom image includes:

- Docker CLI
- Docker Compose
- OpenJDK 17
- Git
- `kubectl` (latest stable)
- Helm 3
- Argo CD CLI

This image enables Jenkins agents to build and push Docker images, interact with Kubernetes clusters, and deploy apps via Argo CD.

### Dockerfile Highlights

- Adds Docker group and adds `jenkins` to it
- Installs OpenJDK 17
- Installs Docker CLI (v20.10.21)
- Installs Helm & Argo CD CLI
- Downloads `agent.jar` for JNLP communication
- Installs required certificates

---

## ⚙️ Jenkins JCasC Configuration Overview

### Kubernetes Cloud Agents

Two agent templates:

1. **jenkins-jenkins-agent**: Base `jenkins/inbound-agent` for general use.
2. **docker-agent**: Custom Docker-capable agent with access to host Docker socket.

### Credentials

- **Docker Hub**: `docker-hub-creds`
- **GitHub**: `github-creds`
- **Argo CD**: `argocd-token`

All credentials are stored securely and scoped globally for use in any pipeline.

### Admin User

A single admin user is preconfigured:

- **Username**: `admin`
- **Permissions**: Full access, no anonymous read

---

## 🚀 Pipeline Job Bootstrap

A pipeline named `sw-movie-app` is created on boot with:

- SCM: GitHub (`https://github.com/lolek1979/sw-movie-app-k8s.git`)
- Jenkinsfile Path: `Jenkinsfile`
- Parameters:
  - `imageName`: Docker image to build (default: `pkonieczny321/sw-movie-app`)
  - `imageTag`: Docker image tag (default: `1.0.0`)

---

## 🧪 Usage

1. Deploy Jenkins in your Kubernetes cluster using Helm or YAML manifests.
2. Ensure your Docker agent image is pushed to a registry accessible by Kubernetes.
3. Jenkins will automatically bootstrap with your defined configuration and pipeline.

---

## 📁 File Structure

```
.
├── Dockerfile                 # Docker image for custom Jenkins agent
├── jenkins.yaml              # ConfigMap with JCasC config (optional)
└── README.md                 # You're reading it!
```

---

## 🌐 URLs (when deployed in Kubernetes)

- **Jenkins**: [http://jenkins.jenkins.svc.cluster.local:8080](http://jenkins.jenkins.svc.cluster.local:8080)
- **JNLP Agent Tunnel**: `jenkins-agent.jenkins.svc.cluster.local:50000`

---

## 🔐 Security Notes

- All sensitive data like credentials are encrypted using Jenkins’ credentials plugin.
- Legacy token creation is disabled.
- Host verification is enabled for Git over SSH.

---

## 📜 License

MIT

---

## 🙋‍♂️ Author

**Lolek / pkonieczny321**

Feel free to reach out or contribute!
