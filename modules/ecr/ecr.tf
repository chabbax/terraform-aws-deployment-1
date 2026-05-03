# Create ECR repository
resource "aws_ecr_repository" "ecr" {
  name                 = "${var.service_name}-${terraform.workspace}"
  image_tag_mutability = "MUTABLE"
}

# Attach Lifecycle Policy to ECR Repository
resource "aws_ecr_lifecycle_policy" "ecr" {
  repository = aws_ecr_repository.ecr.name

  policy = file("${path.module}/resources/lifecycle_policy.json")
}

# Apply Repository Policy to ECR Repository
resource "aws_ecr_repository_policy" "ecr_repo_policy" {
  repository = aws_ecr_repository.ecr.name

  policy = templatefile("${path.module}/resources/repository_policy.json", {
    account_id = var.account_id
  })
}
