# The name of the ECS service to be deployed.
variable "service_name" {
  description = "The name of the ECS service"
  type        = string

  validation {
    condition     = length(var.service_name) > 0
    error_message = "The service name must be non-empty."
  }
}

# The AWS account ID to be used for the ECR repository policy.
variable "account_id" {
  description = "AWS Account ID"
  type        = string

  validation {
    condition     = length(var.account_id) == 12 && can(regex("\\d{12}", var.account_id))
    error_message = "The account_id must be a 12-digit numeric string."
  }
}
