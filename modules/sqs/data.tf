# SQS queue policy allowing S3 to send events to the queue
data "aws_iam_policy_document" "sqs_policy" {
  statement {
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["s3.amazonaws.com"]
    }
    actions   = ["sqs:SendMessage"]
    resources = [aws_sqs_queue.sqs_queue.arn]
    condition {
      test     = "ArnEquals"
      variable = "aws:SourceArn"
      values   = [var.media_bucket_arn]
    }
  }
}