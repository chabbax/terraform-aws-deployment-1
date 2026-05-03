variable "app_name" {
  type        = string
  description = "The name of the application"
  default     = "example"

  validation {
    condition     = length(var.app_name) > 0
    error_message = "The app_name must not be empty."
  }
}



variable "marlowe_runtime_errors_email_recipients" {
  type        = list(string)
  description = "List of email addresses to subscribe to Marlowe runtime error notifications"

  validation {
    condition     = length(var.marlowe_runtime_errors_email_recipients) > 0
    error_message = "At least one email recipient must be provided."
  }

  validation {
    condition = alltrue([
      for email in var.marlowe_runtime_errors_email_recipients : can(regex("^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$", email))
    ])
    error_message = "All email addresses must be valid email format."
  }
}

variable "aws_region" {
  type        = string
  description = "The AWS region to deploy resources in"
  default     = "us-east-1"

  validation {
    condition     = length(var.aws_region) > 0
    error_message = "The aws_region must not be empty."
  }
}
