# Specifies the required provider and version for the Terraform configuration
terraform {
  required_version = ">= 1.9.4"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.61.0"
    }
  }

  cloud {
    organization = "authors-ai"

    workspaces {
      name = "dev"
    }
  }
}

# AWS region
provider "aws" {
  region = var.aws_region
}
