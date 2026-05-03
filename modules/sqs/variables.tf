# Name of the application.
variable "app_name" {
  description = "The name of the application"
  type        = string

  validation {
    condition     = length(var.app_name) > 0
    error_message = "The app_name cannot be empty."
  }
}

variable "account_id" {
  description = "AWS Account ID"
  type        = string

  validation {
    condition     = length(var.account_id) == 12 && can(regex("\\d{12}", var.account_id))
    error_message = "The account_id must be a 12-digit numeric string."
  }
}

variable "media_bucket_id" {
  description = "The ID of the media bucket."
  type        = string

  validation {
    condition     = length(var.media_bucket_id) > 0 && can(regex("^([a-z0-9.-]{3,63})$", var.media_bucket_id))
    error_message = "The media_bucket_id must be a valid S3 bucket name, containing only lowercase letters, numbers, hyphens, and periods, and must be between 3 and 63 characters long."
  }
}

variable "media_bucket_arn" {
  description = "The ARN of the media bucket"
  type        = string

  validation {
    condition     = can(regex("^arn:aws:s3:::[a-zA-Z0-9.-]{3,63}$", var.media_bucket_arn))
    error_message = "The media_bucket_arn must be a valid S3 bucket ARN in the format 'arn:aws:s3:::bucket-name'."
  }
}

variable "document_preprocessing_lambda_arn" {
  description = "ARN of the Document Preprocessing Lambda function"
  type        = string

  validation {
    condition     = length(var.document_preprocessing_lambda_arn) > 0
    error_message = "The document_preprocessing_lambda_arn cannot be empty."
  }
}


