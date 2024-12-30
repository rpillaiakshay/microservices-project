module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.19.0"

  name            = "microservices-vpc"
  cidr            = var.vpc_cidr
  azs             = ["ap-south-1a", "ap-south-1b"]
  public_subnets  = var.public_subnets
  private_subnets = var.private_subnets

  enable_nat_gateway = true
  nat_gateway_instance_type = "t3.micro"  # Optional: You can specify the instance type for the NAT gateway
}

module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  cluster_name    = "micro-services"
  cluster_version = "1.21"
  subnets         = module.vpc.private_subnets
  vpc_id          = module.vpc.vpc_id

  node_groups = {
    eks_nodes = {
      desired_capacity = 2
      max_capacity     = 3
      min_capacity     = 1
      instance_types   = ["t2.micro"]
    }
  }
}
