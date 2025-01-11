
# Highly Available and Scalable Microservices Architecture on AWS

## Objective
Objective of this project is to build a highly available & scalable microservices architecture on AWS. The project involves designing a microservices setup for an application (e.g. ecommerce) & implementing the infrastructure and deployment pipeline. Key tasks include:
- Using Terraform to provision AWS infrastructure such as VPCs, subnets, security groups & EKS clusters.
- Deploying microservices on Kubernetes with features like service discovery, load balancing, and autoscaling.
- Integrating CI/CD pipelines with Jenkins for continuous deployment.
- Setting up monitoring systems using Prometheus & Grafana.
- Implementing security best practices and blue/green deployments for seamless updates.
- Managing version control and CI/CD integration with GitHub.

## Prerequisites
- **Operating System**: Ubuntu or another compatible Linux distribution.
- **AWS Account**: With appropriate IAM roles & permissions set.
- **Installed Tools**: Docker, Jenkins, Kubernetes tools (kubectl, eksctl), Terraform, Prometheus, Grafana & GitHub.
- **AWS CLI Configuration**: Access key, secret key, region set to ap-south-1 & the JSON output format.

## Steps to Set Up the Environment

### Install Docker
Update & install Docker:

```bash
sudo apt update
sudo apt install -y apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signedby=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt update
sudo apt install -y docker-ce
docker --version
```

Grant Root Privileges for Docker:
```bash
sudo usermod -aG docker $USER
newgrp docker
docker run hello-world
```

### Install Jenkins (with JDK 17)
Install OpenJDK 17:
```bash
sudo apt update
sudo apt install -y openjdk-17-jdk
java -version
```

Download and run Jenkins:
```bash
wget https://updates.jenkins.io/download/war/2.387.3/jenkins.war
java -jar jenkins.war --httpPort=8080
```

### Install Kubernetes Tools

#### kubectl Installation
```bash
curl -LO https://dl.k8s.io/release/$(curl -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
kubectl version --client
```

#### eksctl Installation
```bash
curl -LO https://github.com/eksctlio/eksctl/releases/latest/download/eksctl_Linux_amd64.tar.gz
tar -xzf eksctl_Linux_amd64.tar.gz -C /usr/local/bin
eksctl version
```

### Install AWS CLI
```bash
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
aws --version
```

### Configure AWS CLI
```bash
aws configure
```

Provide:
1. Access Key
2. Secret Key
3. Region
4. Output format

### Install GitHub
```bash
sudo apt update
sudo apt install -y git
git --version
```

### Create an EKS Cluster
Use eksctl to create a cluster with the following configuration:
```bash
eksctl create cluster --name micro-services --region ap-south-1 --nodegroup-name eks-nodes --nodes 3 --nodes-min 1 --nodes-max 4 --managed
```

Verify cluster and nodes:
```bash
eksctl get cluster --region ap-south-1
kubectl get nodes
```

## Prepare GitHub Repository

## Sample Commands to Make the GitHub Directory and Upload the Content to GitHub

Create the directories and files:
```bash
mkdir -p microservices-project/{app,k8s,terraform}
touch microservices-project/app/{.env,Dockerfile,package.json,server.js}
touch microservices-project/k8s/{backend-deployment-blue.yaml,backend-deployment-green.yaml,backend-service.yaml,hpa.yaml,ingress.yaml}
touch microservices-project/terraform/terraform.tf
cd microservices-project
git init
git add .
git commit -m "Microservices-Project"
git branch -M main
git remote add origin <github repo url>
git push -u origin main
```

## Setting Up Jenkins

1. Navigate to **Manage Jenkins > Credentials**.
2. Add the following credentials:
   - DockerHub Credentials: Add as Secret Text with the ID `DockerHub`.
   - GitHub Credentials: Add as Secret Text with the ID `GitHub`.
   - AWS Credentials: Add as Access Key and Secret Key.
3. Install necessary plugins by going to **Manage Jenkins > Plugins > Available Plugins**:
   - Pipeline
   - Terraform
   - Kubernetes CLI
   - AWS Credentials
   - AWS CLI
   - Docker Commons
   - Git

## Create a Pipeline Job in Jenkins

1. From the Jenkins dashboard, select **New Item**.
2. Choose **Pipeline** as the job type, and name it (e.g. `Microservices Pipeline`).
3. In the pipeline configuration:
   - Under **Pipeline Definition**, select **Pipeline script from SCM**.
   - Choose Git as the SCM and provide the GitHub repository URL.
   - Add the branch to build.
   - Configure credentials to access the GitHub repository using the previously added credentials.
     

## Checking the System Status
Use Prometheus and Grafana to monitor system performance. Access the monitoring dashboard via Grafana to visualize metrics such as CPU and memory usage.

## Links
- **Docker Hub Image**: `docker pull rpillaiakshay/myapp:latest`

## Conclusion
The project leverages a robust Jenkins pipeline that automates the continuous integration and deployment of the microservice-based e-commerce application. By using Docker to containerize the microservices, the pipeline ensures that the application is efficiently built, tested & pushed to Docker Hub. The Docker Hub image for the e-commerce application provides a lightweight, containerized microservice with endpoints for health checks and product management. It is designed to be scalable and easily integrated into a larger application setup.


{{


# GitHub Repository Structure
The GitHub repository contains the following directories:

1. `app`: Node.js application source code
2. `k8s`: Kubernetes manifests for deploying the application
3. `terraform`: Terraform configuration files for provisioning AWS infrastructure

App Directory
The `app` directory contains the following files:

*`.env` File*
The `.env` file contains environment variables for the application:

- `NODE_ENV=production`: Sets the Node.js environment to production.
- `PORT=8080`: Specifies the port number for the application.

*`Dockerfile` File*
The `Dockerfile` contains instructions for building a Docker image:

1. `FROM node:14-alpine`: Uses the official Node.js 14 Alpine image as the base image.
2. `WORKDIR /app`: Sets the working directory to `/app`.
3. `COPY package*.json ./`: Copies the `package.json` and `package-lock.json` files to the working directory.
4. `RUN npm install`: Installs dependencies listed in `package.json`.
5. `COPY . .`: Copies the rest of the application code to the working directory.
6. `EXPOSE 8080`: Exposes port 8080 for the application.
7. `CMD ["npm", "start"]`: Sets the default command to run `npm start`.

*`package.json` File*
The `package.json` file contains metadata and dependencies for the application:

- `name`: Specifies the application name.
- `version`: Specifies the application version.
- `description`: Provides a brief description of the application.
- `main`: Specifies the entry point of the application (`server.js`).
- `scripts`: Defines scripts for the application, including `start` and `dev`.
- `dependencies`: Lists dependencies required by the application, including Express.js.
- `devDependencies`: Lists development dependencies, including nodemon.

*`server.js` File*
The `server.js` file contains the main application code:

1. `const express = require('express')`: Imports the Express.js module.
2. `const app = express()`: Creates an Express.js application instance.
3. `const port = process.env.PORT || 8080`: Sets the port number from the environment variable or defaults to 8080.
4. `app.use(express.json())`: Enables JSON parsing for incoming requests.
5. Defines routes for the application, including a health check and product retrieval.

K8s Directory
The `k8s` directory contains the following files:

*`backend-deployment-blue.yaml` and `backend-deployment-green.yaml` Files*
These files define Kubernetes deployments for the "blue" and "green" environments:

1. `apiVersion: apps/v1`: Specifies the API version for the deployment.
2. `kind: Deployment`: Defines a deployment resource.
3. `metadata.name`: Specifies the deployment name.
4. `spec.replicas`: Sets the number of replicas (i.e., pods) to run.
5. `spec.selector.matchLabels`: Selects pods with specific labels.
6. `spec.template.metadata.labels`: Sets labels for the pods.
7. `spec.template.spec.containers`: Defines the container configuration, including the Docker image and port.

*`backend-service.yaml` File*
This file defines a Kubernetes service for the application:

1. `apiVersion: v1`: Specifies the API version for the service.
2. `kind: Service`: Defines a service resource.
3. `metadata.name`: Specifies the service name.
4. `spec.selector`: Selects pods with specific labels.
5. `spec.ports`: Defines the port configuration, including the port number and target port.

*`ingress.yaml` File*
This file defines a Kubernetes ingress resource for routing traffic:

1. `apiVersion: networking.k8s.io/v1`: Specifies the API version for the ingress.
2. `kind: Ingress`: Defines an ingress resource.
3. `metadata.name`: Specifies the ingress name.
4. `spec.rules`: Defines the ingress rules, including the host and path.

*`hpa.yaml` File*
This file defines a Kubernetes horizontal pod autoscaling (HPA) resource:

1. `apiVersion: autoscaling/v2`: Specifies the API version for the HPA.
2. `kind: HorizontalPodAutoscaler`: Defines an HPA resource.
3. `metadata.name`: Specifies the HPA name.
4. `spec.scaleTargetRef`: References the deployment to scale.
5. `spec.metrics`: Defines the metrics for scaling, including CPU utilization.


Terraform Directory
The `terraform` directory contains the following files:

_`terraform.tf` File_
The `terraform.tf` file defines the Terraform configuration:

1. `terraform { ... }`: Specifies the Terraform configuration.
2. `provider "aws" { ... }`: Defines the AWS provider configuration.
3. `variable "cluster_name" { ... }`: Defines a variable for the cluster name.
4. `variable "vpc_cidr" { ... }`: Defines a variable for the VPC CIDR.
5. `resource "aws_vpc" "main" { ... }`: Defines a VPC resource.
6. `resource "aws_subnet" "public" { ... }`: Defines public subnet resources.
7. `resource "aws_eks_cluster" "eks" { ... }`: Defines an EKS cluster resource.
8. `resource "aws_eks_node_group" "nodes" { ... }`: Defines an EKS node group resource.

_`variables.tf` File_
The `variables.tf` file defines input variables for the Terraform configuration:

1. `variable "cluster_name" { ... }`: Defines a variable for the cluster name.
2. `variable "vpc_cidr" { ... }`: Defines a variable for the VPC CIDR.
3. `variable "private_subnets" { ... }`: Defines a variable for the private subnets.
4. `variable "public_subnets" { ... }`: Defines a variable for the public subnets.

_`outputs.tf` File_
The `outputs.tf` file defines output values for the Terraform configuration:

1. `output "cluster_name" { ... }`: Defines an output value for the cluster name.
2. `output "cluster_endpoint" { ... }`: Defines an output value for the cluster endpoint.
3. `output "lb_dns_name" { ... }`: Defines an output value for the load balancer DNS name.

# Jenkins Pipeline
The Jenkins pipeline automates the following tasks:

1. Clones the GitHub repository.
2. Builds the Docker image.
3. Pushes the Docker image to Docker Hub.
4. Deploys the application to the "blue" environment.
5. Deploys the application to the "green" environment.
6. Switches traffic to the "green" environment.
7. Deletes the "blue" environment.
8. Applies the Terraform configuration.


# Blue/Green Deployments
The project uses blue/green deployments to ensure zero downtime during deployments. The "blue" environment represents the current production environment, while the "green" environment represents the new version of the application.

# Autoscaling
The project uses horizontal pod autoscaling (HPA) to scale the application based on CPU utilization. This ensures that the application can handle changes in traffic and maintains optimal performance.

# Security
The project follows security best practices, including:

1. Using IAM roles and policies to manage access.
2. Encrypting sensitive data.
3. Implementing network security groups to control traffic.
4. Using secrets management to store sensitive information.

}}