pipeline {
    agent any

    environment {
        DOCKER_IMAGE = 'rpillaiakshay/myapp'
        GITHUB_REPO = 'https://github.com/rpillaiakshay/microservices-project.git'
        AWS_REGION = 'ap-south-1'
        CLUSTER_NAME = 'micro-services'
        AWS_ACCESS_KEY_ID = credentials('AwsKey')  // Ensuring AWS credentials are globally available
        AWS_SECRET_ACCESS_KEY = credentials('AwsKey')
    }

    stages {
        stage('Clean Workspace') {
            steps {
                script {
                    // Clean up the workspace
                    sh 'rm -rf microservices-project'
                }
            }
        }

        stage('Clone Code from GitHub') {
            steps {
                script {
                    withCredentials([string(credentialsId: 'GitHub', variable: 'GITHUB_TOKEN')]) {
                        // Clone the repository using the GitHub token
                        sh 'git clone https://$GITHUB_TOKEN@github.com/rpillaiakshay/microservices-project.git'
                    }
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    // Build the Docker image
                    sh 'docker build -t $DOCKER_IMAGE ./microservices-project/app'
                }
            }
        }

        stage('Push Docker Image to Docker Hub') {
            steps {
                script {
                    withCredentials([string(credentialsId: 'DockerHub', variable: 'DOCKERHUB_TOKEN')]) {
                        // Login and push the Docker image to Docker Hub
                        sh '''
                            echo $DOCKERHUB_TOKEN | docker login -u rpillaiakshay --password-stdin
                            docker push $DOCKER_IMAGE
                        '''
                    }
                }
            }
        }

        stage('Deploy Backend to Kubernetes (Blue Environment)') {
            steps {
                script {
                    // Authenticate with AWS credentials and configure kubectl
                    withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'AwsKey']]) {
                        sh '''
                            aws eks --region $AWS_REGION update-kubeconfig --name $CLUSTER_NAME
                            kubectl apply -f microservices-project/k8s/backend-deployment-blue.yaml
                            kubectl apply -f microservices-project/k8s/backend-service.yaml
                        '''
                    }
                }
            }
        }

        stage('Deploy Backend to Kubernetes (Green Environment)') {
            steps {
                script {
                    // Deploy to the Green environment
                    withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'AwsKey']]) {
                        sh '''
                            aws eks --region $AWS_REGION update-kubeconfig --name $CLUSTER_NAME
                            kubectl apply -f microservices-project/k8s/backend-deployment-green.yaml
                            kubectl apply -f microservices-project/k8s/backend-service.yaml
                        '''
                    }
                }
            }
        }

        stage('Switch Traffic to Green (Blue/Green Switch)') {
            steps {
                script {
                    // Ensure credentials are available for kubectl
                    withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'AwsKey']]) {
                        sh '''
                            aws eks --region $AWS_REGION update-kubeconfig --name $CLUSTER_NAME
                            kubectl apply -f microservices-project/k8s/ingress.yaml
                        '''
                    }
                }
            }
        }

        stage('Delete Blue Environment') {
            steps {
                script {
                    // Delete the Blue environment if it exists
                    def deploymentExists = sh(script: 'kubectl get deployments backend-deployment-blue -o name', returnStatus: true)
                    if (deploymentExists == 0) {
                        sh 'kubectl delete -f microservices-project/k8s/backend-deployment-blue.yaml'
                    } else {
                        echo 'Blue environment deployment does not exist. Skipping deletion.'
                    }
                }
            }
        }
stage('Apply Terraform Configuration') {
    steps {
        script {
            // Change to the terraform directory
            sh '''
                cd microservices-project/terraform

                # Check if the cluster exists
                if aws eks describe-cluster --name micro-services --region ap-south-1 > /dev/null 2>&1; then
                    echo "EKS cluster micro-services already exists. Using existing cluster."

                    # Handle existing IAM roles
                    terraform init
                    terraform import aws_iam_role.eks_cluster micro-services-cluster-role || true
                    terraform import aws_iam_role.eks_nodes micro-services-nodes-role || true

                    # Backup terraform.tf before modifying
                    cp terraform.tf terraform.tf.bak || true

                    # Comment out the aws_vpc block manually or use a more precise method:
                    awk '/resource "aws_vpc" "main"/ {in_block=1} in_block {print "# " $0; next} /}/ && in_block {in_block=0} 1' terraform.tf > temp.tf && mv temp.tf terraform.tf

                    # Reinitialize after commenting out VPC
                    if ! terraform init -reconfigure; then
                        echo "Failed to initialize Terraform. Restoring original configuration."
                        cp terraform.tf.bak terraform.tf
                        exit 1
                    fi

                    # Plan the infrastructure changes, excluding the VPC
                    terraform plan -out=tfplan

                    # Apply the changes
                    if terraform apply -auto-approve tfplan; then
                        echo "Terraform apply was successful."
                    else
                        echo "Terraform apply failed. Attempting to clean up and re-try..."
                        terraform state list | xargs -I {} terraform state rm {}
                        terraform init
                        terraform apply -auto-approve tfplan
                    fi
                else
                    echo "EKS cluster micro-services does not exist. Skipping Terraform apply for now."
                fi
            '''
        }
    }
}
    }
}
