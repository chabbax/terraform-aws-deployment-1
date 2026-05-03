# Attaching custom and existing policies to the task and execution roles
resource "aws_iam_role" "task_role" {
  name               = "${var.marlowe_service_name}-ecs-task-role-${terraform.workspace}"
  assume_role_policy = file("${path.module}/resources/policies/task_role_policy.json")
}

resource "aws_iam_role" "execution_role" {
  name               = "${var.marlowe_service_name}-ecs-execution-role-${terraform.workspace}"
  assume_role_policy = file("${path.module}/resources/policies/execution_role_policy.json")
}

resource "aws_iam_role_policy" "execution_role" {
  name = "${var.marlowe_service_name}-ecs-execution-role-policy-${terraform.workspace}"
  role = aws_iam_role.execution_role.id

  policy = templatefile("${path.module}/resources/policies/ecs_execution_role_policy.json", {
    media_bucket_arn = var.media_bucket_arn,
    aws_region       = var.aws_region,
    account_id       = var.account_id
  })
}

resource "aws_iam_role_policy_attachment" "attach_AmazonSSMFullAccess" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMFullAccess"
  role       = aws_iam_role.execution_role.id
}

resource "aws_iam_role_policy_attachment" "attach_SecretsManagerReadWrite" {
  policy_arn = "arn:aws:iam::aws:policy/SecretsManagerReadWrite"
  role       = aws_iam_role.execution_role.id
}

resource "aws_iam_role_policy_attachment" "attach_AmazonSQSFullAccess" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonSQSFullAccess"
  role       = aws_iam_role.task_role.id
}

resource "aws_iam_role_policy_attachment" "attach_AmazonDynamoDBGetItem" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonDynamoDBFullAccess"
  role       = aws_iam_role.task_role.id
}

resource "aws_iam_role_policy_attachment" "attach_AmazonS3FullAccess" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
  role       = aws_iam_role.task_role.id
}

resource "aws_iam_role_policy_attachment" "attach_ECS_FullAccessToTaskRole" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonECS_FullAccess"
  role       = aws_iam_role.task_role.id
}

resource "aws_iam_role_policy_attachment" "attach_ECS_FullAccessToExecutionRole" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonECS_FullAccess"
  role       = aws_iam_role.execution_role.id
}
