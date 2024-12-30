module "vpc" {
  source = "./terraform/vpc.tf"
}

module "eks" {
  source = "./terraform/eks-cluster.tf"
  vpc_id = module.vpc.vpc_id
}

module "iam_roles" {
  source = "./terraform/iam_roles.tf"
}
