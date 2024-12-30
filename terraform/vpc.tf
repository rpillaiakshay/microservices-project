resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr
  enable_dns_support = true
  enable_dns_hostnames = true
  tags = {
    Name = "microservices-vpc"
  }
}

resource "aws_subnet" "subnet" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.subnet_cidr
  availability_zone       = "ap-south-1a"
  map_public_ip_on_launch = true
}

resource "aws_security_group" "eks_sg" {
  name        = "eks_security_group"
  vpc_id      = aws_vpc.main.id
  description = "Security group for EKS cluster"
}
