output "cognito_user_pool_id" {
  description = "The ID of the Cognito User Pool"
  value       = aws_cognito_user_pool.main.id
}

output "cognito_user_pool_client_id" {
  description = "The ID of the Cognito User Pool Client"
  value       = aws_cognito_user_pool_client.main.id
}

output "cognito_user_pool_client_secret" {
  description = "The Secret of the Cognito User Pool Client"
  value       = aws_cognito_user_pool_client.main.client_secret
}
