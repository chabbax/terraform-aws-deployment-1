# Retrieves the AWS caller identity (current account's details)
data "aws_caller_identity" "current" {}

# Outputs the AWS account ID
output "account_id" {
  value       = data.aws_caller_identity.current.account_id
  description = "The AWS account ID of the current AWS account being utilized."
  sensitive   = true
}
