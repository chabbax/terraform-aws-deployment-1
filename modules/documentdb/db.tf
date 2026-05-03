resource "aws_docdb_subnet_group" "docdb_subnet_group" {
  name        = "${var.app_name}-${terraform.workspace}-docdb-subnet-group"
  description = "Subnet group for DocumentDB cluster"
  subnet_ids  = var.private_subnet_ids

  tags = {
    Project     = var.app_name
    Environment = terraform.workspace
  }
}


resource "aws_docdb_cluster" "cluster" {
  cluster_identifier              = "${var.app_name}-${terraform.workspace}-doc-cluster"
  engine                          = "docdb"
  db_cluster_parameter_group_name = aws_docdb_cluster_parameter_group.docdb_cluster_parameter_group.name
  apply_immediately               = true
  port                            = 27017
  deletion_protection             = true
  skip_final_snapshot             = true
  master_username                 = var.doc_db_username
  master_password                 = var.doc_db_password

  db_subnet_group_name = aws_docdb_subnet_group.docdb_subnet_group.name

  vpc_security_group_ids = [aws_security_group.docdb_security_group.id]


  tags = {
    Project     = var.app_name
    Environment = terraform.workspace
  }
}


resource "aws_docdb_cluster_instance" "cluster_instances" {
  count              = var.docdb_replica_count
  identifier         = "${var.app_name}-${terraform.workspace}-doc-db"
  cluster_identifier = aws_docdb_cluster.cluster.id
  instance_class     = var.docdb_instance_class
  apply_immediately  = true

  tags = {
    Project     = var.app_name
    Environment = terraform.workspace
  }
}

resource "aws_security_group" "docdb_security_group" {
  name        = "${var.app_name}-${terraform.workspace}-docdb-sg"
  description = "Security group for DocumentDB cluster"
  vpc_id      = var.vpc_id

  ingress {
    description = "Allow inbound access from the VPC"
    from_port   = 27017
    to_port     = 27017
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr_block]
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_docdb_cluster_parameter_group" "docdb_cluster_parameter_group" {
  family      = "docdb5.0"
  description = "docdb cluster parameter group"

  parameter {
    name  = "tls"
    value = "disabled"
  }
}

resource "aws_security_group" "transformer_data_api_lambda_sg" {
  name        = "transformer-lambda-sg"
  description = "Allow Lambda outbound access to DocumentDB"
  vpc_id      = var.vpc_id

  egress {
    from_port   = 27017
    to_port     = 27017
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  // DynamoDB access for the lambda
  egress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Project     = var.app_name
    Environment = terraform.workspace
  }
}

resource "aws_security_group" "aapi_etl_sg" {
  name        = "example-etl-lambda-sg"
  description = "Allow Lambda outbound access to DocumentDB"
  vpc_id      = var.vpc_id

  egress {
    from_port   = 27017
    to_port     = 27017
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Project     = var.app_name
    Environment = terraform.workspace
  }
}



