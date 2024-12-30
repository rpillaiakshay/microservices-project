module "vpc" {
  source = "./vpc"
}

module "eks" {
  source = "./eks_cluster"
  vpc_id = module.vpc.vpc_id
}

module "iam_roles" {
  source = "./iam_roles"
}
