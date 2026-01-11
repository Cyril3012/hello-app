# Hello App – Automated Deployment on AWS EKS
Refrence Document: https://docs.google.com/document/d/138HAIRWifXOGWm_M_TJyn18DZ0f9UpMo/edit?usp=sharing&ouid=116786453322772063653&rtpof=true&sd=true
## Overview

This project demonstrates **an end-to-end DevOps** workflow to automatically build, containerize, and deploy a simple **Hello World web application on AWS EKS** using **Terraform, Docker, Kubernetes, and GitHub Actions.**
The solution focuses on Infrastructure as Code, CI/CD automation, and cost-effective design, following real-world DevOps best practices.

## Solution Summary
## Flow:

Git Commit (master)
   → GitHub Actions (CI/CD)
   → Docker Build & Push (Docker Hub)
   → Deploy to AWS EKS (kubectl)
   → Application exposed via NodePort

## Infrastructure as Code (Terraform)

Terraform is used to provision and manage:
- VPC with public subnets (multi-AZ)
- AWS EKS cluster
- Managed node group ( EC2 single node for cost optimization)
- Security group rule for NodePort access
- IAM for EKS Cluster

**Why Terraform?**

- Reproducible infrastructure
- Version-controlled changes
- Fast create / destroy to minimize cost
- Containerization & Kubernetes
- Application is packaged as a Docker image and stored in Docker Hub

**Most used commands:**
```
terraform init
terraform validate
terraform plan
terraform apply
terraform destroy
terraform init -reconfigure 
terraform state list
```

## Docker Design

- **Multi-stage** Docker build to separate build and runtime stages
- **Distroless** base image used for the final image
- Smaller image size
- Reduced attack surface
- No unnecessary OS packages or shell access
This approach improves security, performance, and reliability.

**Most used commands:**
```
docker build -t hello-app app
docker images
docker ps -a
docker stop hello-test
docker rm hello-test
docker run -d -p 3000:3000 --name hello-test hello-app
docker tag hello-app:latest <REPO_PATH>:latest
docker push chandrucyril/hello-app:latest
```

## Kubernetes resources used:

- **Deployment** (replicas = 1, rolling update with maxSurge: 0)
- **Service** (NodePort) for external access
- **Secrets** for runtime configuration
- **NodePort** is chosen to avoid additional AWS LoadBalancer cost and keep the setup simple.

**Most used commands:**
```
kubectl apply -f .\kubernetes\secret.yaml
kubectl apply -f .\kubernetes\service.yaml
kubectl apply -f .\kubernetes\deployment.yaml
kubectl get pods
kubectl describe pod hello-app-85675d7844-dsljq
kubectl get nodes -o wide
kubectl describe svc hello-service
```
```
kubectl config current-context
kubectl cluster-info
kubectl rollout restart deployment hello-app
kubectl delete pod hello-app-54fc5ff74f-865lk
kubectl scale deployment coredns -n kube-system --replicas=1 

```

## Helm
Deploy Using Helm
```
helm install hello-app ./helm/hello-app
helm upgrade hello-app ./helm/hello-app
helm list
kubectl get pods
kubectl get svc
```
Helm Versioning
```
helm history hello-app
```
Helm Rollback
```
helm rollback hello-app 1
```
Verify rollback:
```
kubectl rollout status deployment hello-app
```

## CI/CD Pipeline (GitHub Actions)

- The pipeline runs automatically on push to the master branch and performs:
- Source code checkout
- Docker image build
- Push image to Docker Hub
- Authenticate to AWS
- Update kubeconfig for EKS
- Apply Kubernetes manifests
- Rolling restart of the application

## Secrets Handling:

- **GitHub Secrets** for AWS and Docker credentials
- **Kubernetes Secrets** for application configuration
<img width="1886" height="725" alt="image" src="https://github.com/user-attachments/assets/f6bebf8d-a44f-4481-baf4-1b57689b0f5b" />


## Accessing the Application

Get node public IP:
> kubectl get nodes -o wide

Open in browser:
> http://<NODE_PUBLIC_IP>:30080
<img width="523" height="161" alt="image" src="https://github.com/user-attachments/assets/a027c548-fc77-42b7-85bd-a4a69216a12e" />

## Design Choices

- Single-node cluster to reduce cost
- NodePort service instead of LoadBalancer
- Static environment configuration for simplicity
- Optimized rolling updates to handle pod limits on small nodes
- These trade-offs are intentional for interview/demo clarity and cost control.

## Cleanup

To avoid AWS charges after testing:
```
terraform destroy
```
## Conclusion

This project showcases a complete DevOps CI/CD pipeline with:
- Infrastructure as Code
- Automated container build and deployment
- Kubernetes orchestration
- Secure secrets management
- Cost-aware cloud architecture
