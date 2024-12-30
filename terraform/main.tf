module "vpc" {
  source = "https://github.com/rpillaiakshay/microservices-project/blob/main/terraform/vpc.tf"
}

module "eks" {
  source = "./eks_cluster"
  vpc_id = module.vpc.vpc_id
}

module "iam_roles" {
  source = "./iam_roles"
}
