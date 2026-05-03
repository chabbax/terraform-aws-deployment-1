# SQS queue to handle file events for the application
resource "aws_sqs_queue" "sqs_queue" {
  name                      = "${var.app_name}-file-event-queue-${terraform.workspace}"
  delay_seconds             = 90
  max_message_size          = 4096
  message_retention_seconds = 86400
  receive_wait_time_seconds = 10

  redrive_policy = jsonencode({
    // NOTE: setting the maxReceiveCount as high (200) cuz the side car will re-queue the message (every 5 sec) if the marlow containers are at its max concurrency limit or auto-scaling is undergoing
    // re-queue means setting the visible timeout to 0
    maxReceiveCount     = 200,
    deadLetterTargetArn = aws_sqs_queue.dlq_queue.arn
  })
  tags = {
    Project     = var.app_name
    Environment = terraform.workspace
  }
}

# SQS queue to handle file events for the application
resource "aws_sqs_queue_policy" "sqs_queue_policy" {
  queue_url = aws_sqs_queue.sqs_queue.id
  policy    = data.aws_iam_policy_document.sqs_policy.json
}

# Dead-Letter Queue (DLQ) for failed file events
resource "aws_sqs_queue" "dlq_queue" {
  name                      = "${var.app_name}-file-event-dlq-${terraform.workspace}"
  delay_seconds             = 90
  max_message_size          = 2048
  message_retention_seconds = 86400
  receive_wait_time_seconds = 10

  tags = {
    Project     = var.app_name
    Environment = terraform.workspace
  }
}

resource "aws_s3_bucket_notification" "pre_process_bucket_notification" {
  bucket = var.media_bucket_id

  queue {
    id            = "${var.app_name}-txt-process-event-${terraform.workspace}"
    queue_arn     = aws_sqs_queue.sqs_queue.arn
    events        = ["s3:ObjectCreated:*"]
    filter_prefix = "versions/"
    filter_suffix = ".txt"
  }

  lambda_function {
    lambda_function_arn = var.document_preprocessing_lambda_arn
    events              = ["s3:ObjectCreated:*"]
    filter_prefix       = "versions/"
    filter_suffix       = ".rtf"
  }

  lambda_function {
    lambda_function_arn = var.document_preprocessing_lambda_arn
    events              = ["s3:ObjectCreated:*"]
    filter_prefix       = "versions/"
    filter_suffix       = ".epub"
  }

  lambda_function {
    lambda_function_arn = var.document_preprocessing_lambda_arn
    events              = ["s3:ObjectCreated:*"]
    filter_prefix       = "versions/"
    filter_suffix       = ".docx"
  }
}

# SQS queue to handle ai service LLM requests
resource "aws_sqs_queue" "llm_requests_queue" {
  name                      = "${var.app_name}-${terraform.workspace}-ai-llm-requests-queue"
  max_message_size          = 4096
  message_retention_seconds = 3600
  receive_wait_time_seconds = 0

  redrive_policy = jsonencode({
    maxReceiveCount     = 200,
    deadLetterTargetArn = aws_sqs_queue.llm_requests_dlq_queue.arn
  })
  tags = {
    Project     = var.app_name
    Environment = terraform.workspace
  }
}


# Dead-Letter Queue (DLQ) for failed LLM requests
resource "aws_sqs_queue" "llm_requests_dlq_queue" {
  name                      = "${var.app_name}-${terraform.workspace}-ai-llm-requests-dlq-queue"
  max_message_size          = 4096
  message_retention_seconds = 86400
  receive_wait_time_seconds = 0

  tags = {
    Project     = var.app_name
    Environment = terraform.workspace
  }
}
