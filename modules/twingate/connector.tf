data "aws_ami" "twingate" {
  most_recent = true

  filter {
    name   = "name"
    values = ["twingate/images/hvm-ssd/twingate-amd64-*"]
  }

  owners = ["617935088040"] # Twingate
}

resource "aws_security_group" "twingate_connector" {
  name        = "${var.app_name}-twingate-sg"
  description = "allow the Twingate connector outbound internet access"
  vpc_id      = var.vpc_id

  egress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 30000
    to_port     = 31000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "allows option for peer-to-peer connectivity for optimal performance"
  }
}

resource "aws_instance" "twingate_connector" {
  ami                         = data.aws_ami.twingate.id
  instance_type               = "t3.nano"
  associate_public_ip_address = true
  subnet_id                   = var.private_subnet_ids[0]
  user_data                   = <<-EOT
    #!/bin/bash
    set -e
    mkdir -p /etc/twingate/
    {
      echo TWINGATE_URL="https://${var.network}.twingate.com"
      echo TWINGATE_ACCESS_TOKEN="${twingate_connector_tokens.aws_connector_tokens.access_token}"
      echo TWINGATE_REFRESH_TOKEN="${twingate_connector_tokens.aws_connector_tokens.refresh_token}"
    } > /etc/twingate/connector.conf
    sudo systemctl enable --now twingate-connector
  EOT

  tags = {
    Name        = "Twingate-Connector"
    Project     = var.app_name
    Environment = terraform.workspace
  }
}
