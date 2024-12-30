module "vpc" {
  source = "./vpc.tf"
}

module "eks" {
  source = "./eks-cluster.tf"
  vpc_id = module.vpc.vpc_id
}

module "iam_roles" {
  source = "./iam_roles.tf"
}
