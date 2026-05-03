output "sqs_queue_url" {
  value       = aws_sqs_queue.sqs_queue.url
  description = "The URL of the SQS queue"
}

output "llm_requests_queue_url" {
  value       = aws_sqs_queue.llm_requests_queue.url
  description = "The URL of the SQS queue for LLM requests"
}