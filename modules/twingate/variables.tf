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

variable "network" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "private_subnet_ids" {
  type = list(string)
}

variable "resource_doc_db_endpoint" {
  type = string
}

variable "resource_redis_db_endpoint" {
  type = string
}


variable "twingate_api_token" {
  type        = string
  description = "The twingate api key"
}
