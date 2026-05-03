# VPC with the specified CIDR block, and enables DNS support and DNS hostnames for the VPC.
resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr_block
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Project     = var.app_name
    Environment = terraform.workspace
  }
}
