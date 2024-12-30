module "vpc" {
  source = "github.com/rpillaiakshay/microservices-project//terraform/vpc"
}

module "eks" {
  source = "github.com/rpillaiakshay/microservices-project//terraform/eks-cluster.tf"
  vpc_id = module.vpc.vpc_id
}

module "iam_roles" {
  source = "github.com/rpillaiakshay/microservices-project//terraform/iam_roles.tf"
}
