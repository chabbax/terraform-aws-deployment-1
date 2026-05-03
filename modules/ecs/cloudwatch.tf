# AWS CloudWatch Log Group for the service
resource "aws_cloudwatch_log_group" "marlowe_service_log_group" {
  name              = "/ecs/${var.marlowe_service_name}-${terraform.workspace}"
  retention_in_days = 14

  tags = {
    Project     = var.app_name
    Environment = terraform.workspace
  }
}

# AWS CloudWatch Log Group for the sidecar
resource "aws_cloudwatch_log_group" "sidecar_log_group" {
  name              = "/ecs/${var.sidecar_name}-${terraform.workspace}"
  retention_in_days = 14

  tags = {
    Project     = var.app_name
    Environment = terraform.workspace
  }
}

# AWS CloudWatch Log Group for the transformer task
resource "aws_cloudwatch_log_group" "transformer_log_group" {
  name              = "/ecs/${var.transformer_name}-${terraform.workspace}"
  retention_in_days = 14

  tags = {
    Project     = var.app_name
    Environment = terraform.workspace
  }
}

# AWS CloudWatch Log Group for the recommendation task
resource "aws_cloudwatch_log_group" "recommendation_log_group" {
  name              = "/ecs/${var.recommendation_name}-${terraform.workspace}"
  retention_in_days = 14

  tags = {
    Project     = var.app_name
    Environment = terraform.workspace
  }
}

# AWS CloudWatch Log Group for the AI task
resource "aws_cloudwatch_log_group" "ai_log_group" {
  name              = "/ecs/${var.ai_name}-${terraform.workspace}"
  retention_in_days = 14

  tags = {
    Project     = var.app_name
    Environment = terraform.workspace
  }
}
