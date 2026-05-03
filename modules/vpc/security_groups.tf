# AWS security group for ECS tasks associated with the service
resource "aws_security_group" "task_security_group" {
  name   = "${var.app_name}-task-sg-${terraform.workspace}"
  vpc_id = aws_vpc.main.id

  ingress {
    protocol    = "tcp"
    from_port   = 443
    to_port     = 443
    cidr_blocks = [var.vpc_cidr_block]
  }

  ingress {
    protocol    = "tcp"
    from_port   = 8080
    to_port     = 8080
    cidr_blocks = [var.vpc_cidr_block]
  }

  ingress {
    protocol    = "tcp"
    from_port   = 5000
    to_port     = 5000
    cidr_blocks = [var.vpc_cidr_block]
  }

  egress {
    protocol    = "tcp"
    from_port   = 443
    to_port     = 443
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Project     = var.app_name
    Environment = terraform.workspace
  }
}
