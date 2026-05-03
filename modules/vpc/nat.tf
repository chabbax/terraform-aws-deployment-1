resource "aws_eip" "nat_eip" {
  count  = var.number_of_public_subnets
  domain = "vpc"

  tags = {
    Project     = var.app_name
    Environment = terraform.workspace
  }

  depends_on = [aws_internet_gateway.main]
}


resource "aws_nat_gateway" "nat_gw" {
  count         = var.number_of_public_subnets
  allocation_id = element(aws_eip.nat_eip.*.id, count.index)
  subnet_id     = element(aws_subnet.public_subnet.*.id, count.index)

  tags = {
    Project     = var.app_name
    Environment = terraform.workspace
  }

  depends_on = [aws_internet_gateway.main]
}

resource "aws_security_group" "nat_gw_sg" {
  name   = "${var.app_name}-nat-gw-sg-${terraform.workspace}"
  vpc_id = aws_vpc.main.id

  ingress {
    protocol    = "tcp"
    from_port   = 80
    to_port     = 80
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    protocol    = "tcp"
    from_port   = 443
    to_port     = 443
    cidr_blocks = ["0.0.0.0/0"]
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
