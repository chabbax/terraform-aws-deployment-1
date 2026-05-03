output "table_name" {
  description = "Name of the DynamoDB table"
  value       = aws_dynamodb_table.table.name
}

output "table_arn" {
  description = "ARN of the DynamoDB table"
  value       = aws_dynamodb_table.table.arn
}

output "stream_arn" {
  value       = aws_dynamodb_table.table.stream_arn
  description = "ARN of the write policy"
}
