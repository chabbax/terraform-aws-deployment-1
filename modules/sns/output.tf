output "marlowe_runtime_errors_sns_arn" {
  value       = aws_sns_topic.marlowe_runtime_errors.arn
  description = "The ARN of the SNS topic for Marlowe runtime error notifications."
}