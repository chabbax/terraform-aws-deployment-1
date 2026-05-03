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

variable "documentdb_instance_id" {
  description = "The name of the DynamoDB table"
  type        = string

  validation {
    condition     = length(var.documentdb_instance_id) > 0
    error_message = "The documentdb instance id cannot be empty."
  }
}

variable "documentdb_cluster_id" {
  description = "The name of the DynamoDB table"
  type        = string

  validation {
    condition     = length(var.documentdb_cluster_id) > 0
    error_message = "The documentdb cluster id cannot be empty."
  }
}

variable "account_id" {
  description = "The AWS account ID"
  type        = string

  validation {
    condition     = length(var.account_id) > 0
    error_message = "The account_id cannot be empty."
  }
}
