variable "app_name" {
  type        = string
  description = "The name of the application"
  default     = "example"

  validation {
    condition     = length(var.app_name) > 0
    error_message = "The app_name must not be empty."
  }
}

variable "max_read_request_units" {
  description = "Read capacity for the table."
  type        = number

  validation {
    condition     = can(var.max_read_request_units + 0)
    error_message = "Read capacity must be a valid number."
  }
}

variable "max_write_request_units" {
  description = "Write capacity for the table."
  type        = number

  validation {
    condition     = can(var.max_write_request_units + 0)
    error_message = "Write capacity must be a valid number."
  }
}
