
resource "aws_elasticache_subnet_group" "valkey_subnet_group" {
  name       = "${var.app_name}-${terraform.workspace}-valkey-subnet-group"
  subnet_ids = var.private_subnet_ids
  tags = {
    Project     = var.app_name
    Environment = terraform.workspace
  }
}

resource "aws_security_group" "valkey_security_group" {
  name        = "${var.app_name}-${terraform.workspace}-valkey-security-group"
  description = "Security group for Valkey instance"
  vpc_id      = var.vpc_id

  ingress {
    description = "allow_rds_db_port from VPC"
    from_port   = 6379
    to_port     = 6379
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr_block]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Project     = var.app_name
    Environment = terraform.workspace
  }
}

resource "aws_elasticache_replication_group" "valkey" {
  replication_group_id       = "${var.app_name}-${terraform.workspace}-valkey-instance"
  description                = "Valkey replication group for ${var.app_name} in ${terraform.workspace} environment"
  engine                     = "valkey"
  engine_version             = "8.0"
  node_type                  = "cache.t3.small"
  port                       = 6379
  automatic_failover_enabled = false
  multi_az_enabled           = false
  num_cache_clusters         = 1
  subnet_group_name          = aws_elasticache_subnet_group.valkey_subnet_group.name
  security_group_ids         = [aws_security_group.valkey_security_group.id]
  apply_immediately          = true
  parameter_group_name       = "default.valkey8"

  log_delivery_configuration {
    destination_type = "cloudwatch-logs"
    destination      = aws_cloudwatch_log_group.valkey_slow_log.name
    log_format       = "json"
    log_type         = "slow-log"
  }

  log_delivery_configuration {
    destination_type = "cloudwatch-logs"
    destination      = aws_cloudwatch_log_group.valkey_engine_log.name
    log_format       = "json"
    log_type         = "engine-log"
  }

  tags = {
    Project     = var.app_name
    Environment = terraform.workspace
  }
}


resource "aws_cloudwatch_log_group" "valkey_slow_log" {
  name = "${var.app_name}-${terraform.workspace}-valkey-slow-logs"

  tags = {
    Project     = var.app_name
    Environment = terraform.workspace
  }
}
resource "aws_cloudwatch_log_group" "valkey_engine_log" {
  name = "${var.app_name}-${terraform.workspace}-valkey-engine-logs"

  tags = {
    Project     = var.app_name
    Environment = terraform.workspace
  }
}