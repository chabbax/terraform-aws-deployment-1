# Specifies the required provider and version for the Terraform configuration
terraform {
  required_version = ">= 1.9.4"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.99.1"
    }
  }

  cloud {
    organization = "authors-ai"

    workspaces {
      name = "prod"
    }
  }
}

# AWS region
provider "aws" {
  region = var.aws_region
}
