output "registry_id" {
  value       = aws_ecr_repository.ecr.registry_id
  description = "The account ID of the registry"
}

output "ecr_repository_url" {
  value       = aws_ecr_repository.ecr.repository_url
  description = "The URL of the repository (in the form aws_account_id.dkr.ecr.region.amazonaws.com/repositoryName)"
}

output "ecr_repository_arn" {
  value       = aws_ecr_repository.ecr.arn
  description = "The Amazon Resource Name (ARN) of the repository"
}
