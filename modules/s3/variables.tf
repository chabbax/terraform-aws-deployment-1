# The name of the application.
variable "app_name" {
  description = "The name of the application"
  type        = string

  validation {
    condition     = length(var.app_name) > 0
    error_message = "The app_name cannot be empty."
  }
}

# List of origins that are allowed to access the S3 bucket.
variable "s3_cors_allowed_origins" {
  type        = list(string)
  description = "S3 Cors allowed origins"
}

variable "account_id" {
  description = "AWS Account ID"
  type        = string

  validation {
    condition     = length(var.account_id) == 12 && can(regex("\\d{12}", var.account_id))
    error_message = "The account_id must be a 12-digit numeric string."
  }
}

variable "document_preprocessing_lambda_name" {
  description = "ARN of the Document Preprocessing Lambda function"
  type        = string

  validation {
    condition     = length(var.document_preprocessing_lambda_name) > 0
    error_message = "The document_preprocessing_lambda_name cannot be empty."
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

variable "swagger_allowed_ips" {
  type = list(string)
}
