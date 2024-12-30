resource "aws_eks_cluster" "eks" {
  name     = var.cluster_name
  role_arn = aws_iam_role.eks_service_role.arn

  vpc_config {
    subnet_ids = module.vpc.subnet_ids
  }

  depends_on = [aws_iam_role_policy_attachment.eks_service_role_policy_attachment]
}

resource "aws_iam_role" "eks_service_role" {
  name = "eks_service_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action    = "sts:AssumeRole"
        Effect    = "Allow"
        Principal = {
          Service = "eks.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "eks_service_role_policy_attachment" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks_service_role.name
}
