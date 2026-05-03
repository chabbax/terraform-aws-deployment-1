variable "cost_budget_limit_amount" {
  type        = string
  default     = "320"
  description = "USD limit amount used for cost budget"

  validation {
    condition     = can(regex("^[0-9]+(\\.[0-9]{1,2})?$", var.cost_budget_limit_amount)) && tonumber(var.cost_budget_limit_amount) > 0 && tonumber(var.cost_budget_limit_amount) <= 1000000
    error_message = "The cost_budget_limit_amount must be a positive numeric string up to two decimal places, and between 0.01 and 1,000,000 USD."
  }
}

variable "billing_email_recipients" {
  type = list(string)
}