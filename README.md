
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
git commit -m "Microservices Project"
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
