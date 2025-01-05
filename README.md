Building a Highly Available and Scalable Microservices Architecture on AWS

Objective

The goal of this project is to build a highly available and scalable microservices architecture on AWS. The project involves designing a setup for an application (e.g., an e-commerce platform) and implementing infrastructure and deployment pipelines. Key tasks include:

Using Terraform to provision AWS infrastructure, including VPCs, subnets, security groups, and EKS clusters.

Deploying microservices on Kubernetes with service discovery, load balancing, and autoscaling.

Integrating CI/CD pipelines with Jenkins for continuous deployment.

Setting up monitoring systems using Prometheus and Grafana.

Implementing security best practices and blue/green deployments for seamless updates.

Managing version control and CI/CD integration with GitHub.

Prerequisites

Operating System: Ubuntu or another compatible Linux distribution.

AWS Account: Ensure IAM roles and permissions are appropriately configured.

Installed Tools: Docker, Jenkins, Kubernetes tools (kubectl, eksctl), Terraform, Prometheus, Grafana, and GitHub.

AWS CLI Configuration: Include access key, secret key, region (e.g., ap-south-1), and output format as JSON.

Environment Setup

Install Docker

Update system packages:

sudo apt update
sudo apt install -y apt-transport-https ca-certificates curl software-properties-common

Add Docker's official GPG key and repository:

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

Install Docker:

sudo apt update
sudo apt install -y docker-ce
docker --version

Add the current user to the Docker group:

sudo usermod -aG docker $USER
newgrp docker
docker run hello-world

Install Jenkins

Install JDK 17:

sudo apt update
sudo apt install -y openjdk-17-jdk
java -version

Download and run Jenkins:

wget https://updates.jenkins.io/download/war/2.387.3/jenkins.war
java -jar jenkins.war --httpPort=8080

Install Kubernetes Tools

Install kubectl

Download the binary:

curl -LO https://dl.k8s.io/release/$(curl -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl

Install kubectl:

sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
kubectl version --client

Install eksctl

Download and install:

curl -LO https://github.com/eksctlio/eksctl/releases/latest/download/eksctl_Linux_amd64.tar.gz
tar -xzf eksctl_Linux_amd64.tar.gz -C /usr/local/bin
eksctl version

Install AWS CLI

Download and install:

curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
aws --version

Configure AWS CLI:

aws configure

Provide the following:

Access Key

Secret Key

Region (e.g., ap-south-1)

Output format (e.g., JSON)

Install GitHub CLI

Install Git:

sudo apt update
sudo apt install -y git
git --version

Infrastructure Setup

Create an EKS Cluster

Use eksctl to create the cluster:

eksctl create cluster --name micro-services --region ap-south-1 --nodegroup-name eks-nodes --nodes 3 --nodes-min 1 --nodes-max 4 --managed

Verify the cluster and nodes:

eksctl get cluster --region ap-south-1
kubectl get nodes

Repository Structure

GitHub Repository

Repository Name: microservices-project

Directory Structure

microservices-project
|-- app
|   |-- .env
|   |-- Dockerfile
|   |-- package.json
|   |-- server.js
|-- k8s
|   |-- backend-deployment-blue.yaml
|   |-- backend-deployment-green.yaml
|   |-- backend-service.yaml
|   |-- hpa.yaml
|   |-- ingress.yaml
|-- terraform
|   |-- terraform.tf

Commands to Set Up Repository

Create directory structure:

mkdir -p microservices-project/{app,k8s,terraform}
touch microservices-project/app/{.env,Dockerfile,package.json,server.js}
touch microservices-project/k8s/{backend-deployment-blue.yaml,backend-deployment-green.yaml,backend-service.yaml,hpa.yaml,ingress.yaml}
touch microservices-project/terraform/terraform.tf

Initialize Git and push to GitHub:

cd microservices-project
git init
git add .
git commit -m "Initial commit"
git branch -M main
git remote add origin <github-repo-url>
git push -u origin main

Setting Up Jenkins

Navigate to Manage Jenkins > Credentials and add the following:

DockerHub: Secret Text with ID DockerHub

GitHub: Secret Text with ID GitHub

AWS: Access Key and Secret Key

Install plugins:

Pipeline

Terraform

Kubernetes CLI

AWS Credentials

Docker Commons

Git

Create a pipeline job:

Use "Pipeline script from SCM".

Provide GitHub repository URL and credentials.

Output

GitHub Repository: microservices-project

Docker Hub Image: docker pull rpillaiakshay/myapp:latest

Conclusion

The project demonstrates a robust Jenkins pipeline automating CI/CD for a microservice-based e-commerce application. Docker is used for containerization, with images pushed to Docker Hub. The setup supports blue/green deployments, scaling, and monitoring using Prometheus and Grafana for a highly available and scalable infrastructure.

