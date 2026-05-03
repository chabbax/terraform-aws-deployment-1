# Policy document for full S3 Access
data "aws_iam_policy_document" "s3_ecr_access" {
  version = "2012-10-17"
  statement {
    sid     = "FullS3Access"
    effect  = "Allow"
    actions = ["*"]

    principals {
      type        = "*"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}