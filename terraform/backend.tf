terraform {
  backend "s3" {
    bucket = "rpillaiakshay"  # Update with your actual S3 bucket name
    key    = "microservices-project/terraform.tfstate"  # Path within the S3 bucket for storing state
    region = "ap-south-1"  # Region for your AWS infrastructure
  }
}
