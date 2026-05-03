variable "app_name" {
  description = "The name of the application"
  type        = string
  default     = "example"

  validation {
    condition     = length(var.app_name) > 0
    error_message = "The app_name cannot be empty."
  }
}

variable "aws_region" {
  type        = string
  description = "The AWS region where resources have been deployed"

  validation {
    condition     = length(var.aws_region) > 0
    error_message = "The region cannot be empty."
  }
}

variable "private_subnet_ids" {
  description = "List of subnets in VPC"
  type        = list(string)
}

variable "vpc_id" {
  description = "vpc_id"
  type        = string
}
variable "vpc_cidr_block" {
  description = "vpc_cidr"
  type        = string
}

variable "node_type" {
  type        = string
  description = "Elasticache node type"
}


variable "availability_zones" {
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b", "us-east-1c"]
  description = "List of availability zones for the selected region"

  validation {
    condition     = length(var.availability_zones) > 0
    error_message = "At least one availability zone must be specified."
  }
}
