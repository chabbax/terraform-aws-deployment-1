# Name of the application.
variable "app_name" {
  description = "The name of the application"
  type        = string

  validation {
    condition     = length(var.app_name) > 0
    error_message = "The app_name cannot be empty."
  }
}

# The AWS region where resources have been deployed.
variable "aws_region" {
  type        = string
  default     = "us-east-1"
  description = "The AWS region where resources have been deployed"

  validation {
    condition     = length(var.aws_region) > 0
    error_message = "The region cannot be empty."
  }
}

# List of availability zones for the selected region.
variable "availability_zones" {
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b", "us-east-1c"]
  description = "List of availability zones for the selected region"

  validation {
    condition     = length(var.availability_zones) > 0
    error_message = "At least one availability zone must be specified."
  }
}

# Number of private subnets.
variable "number_of_private_subnets" {
  description = "Number of private subnets"
  type        = number

  validation {
    condition     = var.number_of_private_subnets > 0
    error_message = "The number_of_private_subnets must be greater than zero."
  }
}

# Number of public subnets.
variable "number_of_public_subnets" {
  description = "Number of public subnets"
  type        = number

  validation {
    condition     = var.number_of_public_subnets > 0
    error_message = "The number_of_public_subnets must be greater than zero."
  }
}

# CIDR block range for VPC.
variable "vpc_cidr_block" {
  type        = string
  description = "CIDR block range for vpc"

  validation {
    condition     = can(regex("^(\\d{1,3}\\.){3}\\d{1,3}/\\d{1,2}$", var.vpc_cidr_block))
    error_message = "The vpc_cidr_block must be a valid CIDR block."
  }
}

# CIDR block range for the public subnets.
variable "public_subnet_cidr_blocks" {
  type        = list(string)
  default     = ["10.0.5.0/24", "10.0.10.0/24"]
  description = "CIDR block range for the public subnets"

  validation {
    condition     = can([for cidr in var.public_subnet_cidr_blocks : regex("^(\\d{1,3}\\.){3}\\d{1,3}/\\d{1,2}$", cidr)])
    error_message = "The public_subnet_cidr_blocks must each be a valid CIDR block."
  }
}

# CIDR block range for the private subnets.
variable "private_subnet_cidr_blocks" {
  type        = list(string)
  default     = ["10.0.15.0/24", "10.0.20.0/24"]
  description = "CIDR block range for the private subnets"

  validation {
    condition     = can([for cidr in var.private_subnet_cidr_blocks : regex("^(\\d{1,3}\\.){3}\\d{1,3}/\\d{1,2}$", cidr)])
    error_message = "The private_subnet_cidr_blocks must each be a valid CIDR block."
  }
}