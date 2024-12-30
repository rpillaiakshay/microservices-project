variable "aws_region" {
  description = "AWS region"
  default     = "ap-south-1"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  default     = "10.0.0.0/16"
}

variable "subnet_cidr" {
  description = "CIDR block for the subnets"
  default     = "10.0.1.0/24"
}

variable "cluster_name" {
  description = "EKS cluster name"
  default     = "microservices-cluster"
}
