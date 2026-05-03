variable "app_name" {
  description = "The name of the application"
  type        = string

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

variable "docdb_instance_class" {
  type        = string
  description = "The instance class for the DocumentDB cluster"
  default     = "db.t3.medium"

  validation {
    condition     = length(var.docdb_instance_class) > 0
    error_message = "The instance class cannot be empty."
  }
}

variable "doc_db_username" {
  description = "DocumentDB username"
  type        = string
  sensitive   = true
}

variable "doc_db_password" {
  description = "DocumentDB password"
  type        = string
  sensitive   = true
}


variable "docdb_replica_count" {
  type        = number
  description = "The number of replicas in the DocumentDB cluster"
  default     = 1

  validation {
    condition     = var.docdb_replica_count > 0
    error_message = "The replica count must be greater than 0."
  }
}

variable "private_subnet_ids" {
  type        = list(string)
  description = "The IDs of the private subnets in the VPC"
}

variable "vpc_cidr_block" {
  type        = string
  description = "CIDR block of the main VPC"
}

variable "vpc_id" {
  type        = string
  description = "ID of the main VPC"
}