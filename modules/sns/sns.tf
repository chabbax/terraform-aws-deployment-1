# SNS Topic for Marlowe Runtime Errors
resource "aws_sns_topic" "marlowe_runtime_errors" {
  name         = "${var.app_name}-${terraform.workspace}-marlowe-runtime-errors"
  display_name = "Marlowe Runtime Errors"

  tags = {
    Project     = var.app_name
    Environment = terraform.workspace
  }
}

# SNS Topic Policy to allow publishing
resource "aws_sns_topic_policy" "marlowe_runtime_errors_policy" {
  arn = aws_sns_topic.marlowe_runtime_errors.arn

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AllowPublishFromECS"
        Effect = "Allow"
        Principal = {
          AWS = "*"
        }
        Action = [
          "SNS:Publish"
        ]
        Resource = aws_sns_topic.marlowe_runtime_errors.arn
        Condition = {
          StringEquals = {
            "aws:RequestedRegion" = var.aws_region
          }
        }
      }
    ]
  })
}

# Email subscriptions for the SNS topic
resource "aws_sns_topic_subscription" "marlowe_runtime_errors_email" {
  count     = length(var.marlowe_runtime_errors_email_recipients)
  topic_arn = aws_sns_topic.marlowe_runtime_errors.arn
  protocol  = "email"
  endpoint  = var.marlowe_runtime_errors_email_recipients[count.index]
}

