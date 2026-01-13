# --- environments/dev/provider.tf ---

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }

  # Backend S3 + DynamoDB để lưu state Terraform
  backend "s3" {
    bucket         = "project-infra-terraform-state"
    key            = "dev/terraform.tfstate"
    region         = "ap-southeast-1"
    dynamodb_table = "project-infra-terraform-lock"
    encrypt        = true
  }
}

provider "aws" {
  region = var.aws_region
}
