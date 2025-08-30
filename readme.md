# Social Media Microservices Platform 🚀

A microservices-based social media 3-tier platform built with Node.js, Docker, Kubernetes (EKS), and Jenkins CI/CD.  
The platform consists of multiple services deployed as containers, with Redis for caching and API Gateway for routing.  

---

## 🏗️ Architecture

- **API Gateway** → Routes requests to microservices.  
- **Post Service** → Handles posts (CRUD).  
- **Media Service** → Manages media uploads.  
- **Identify Service** → Authentication & user management.  
- **Search Service** → Search functionality.  
- **Redis** → Caching layer.  
- **EKS (Kubernetes)** → Orchestrates microservices.  
- **Jenkins** → CI/CD pipeline to automate build, push & deploy.  

---

⚙️ Jenkins CI/CD Pipeline

Jenkinsfile Highlights:

1. Builds & pushes Docker images for all services to DockerHub.

2. Deploys to Kubernetes (EKS) using kubectl apply.

3. Uses Jenkins credentials for DockerHub & Kubeconfig.



⚙️ Configure Jenkins: Add credentials:

- dockerhub-username
- dockerhub-password
- eks-kubeconfig (kubeconfig file as secret text/file).

Run pipeline:

git push origin main

Jenkins will
- Build & push images
- Deploy to EKS