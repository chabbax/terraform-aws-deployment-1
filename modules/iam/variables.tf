# Define the list of IAM group names with validation
variable "group_names" {
  type    = list(string)
  default = ["example-developers", "example-qa"]

  validation {
    condition     = alltrue([for name in var.group_names : length(name) > 0 && can(regex("^[a-zA-Z0-9-_]+$", name))])
    error_message = "Each group name must be a non-empty string and consist of alphanumeric characters, hyphens, or underscores."
  }
}
