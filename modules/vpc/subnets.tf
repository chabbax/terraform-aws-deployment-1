# Private subnets in VPC
resource "aws_subnet" "private_subnet" {
  count             = var.number_of_private_subnets
  vpc_id            = aws_vpc.main.id
  cidr_block        = element(var.private_subnet_cidr_blocks, count.index)
  availability_zone = element(var.availability_zones, count.index)

  tags = {
    Project     = var.app_name
    Environment = terraform.workspace
  }
}

# Public subnets in VPC
resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = element(var.public_subnet_cidr_blocks, count.index)
  availability_zone       = element(var.availability_zones, count.index)
  count                   = var.number_of_public_subnets
  map_public_ip_on_launch = true

  tags = {
    Project     = var.app_name
    Environment = terraform.workspace
  }
}

# Route table for public subnets in the VPC
resource "aws_route_table" "public" {
  count  = var.number_of_public_subnets
  vpc_id = aws_vpc.main.id

  tags = {
    Project     = var.app_name
    Environment = terraform.workspace
  }
}

# Route table for private subnets in the VPC
resource "aws_route_table" "private" {
  count  = var.number_of_private_subnets
  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = element(aws_nat_gateway.nat_gw.*.id, count.index)
  }

  tags = {
    Project     = var.app_name
    Environment = terraform.workspace
  }
}

# Route for the route table that directs all traffic to the Internet Gateway
resource "aws_route" "public" {
  count                  = var.number_of_public_subnets
  route_table_id         = aws_route_table.public[count.index].id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.main.id
}

# Associate the public subnets with the route table
resource "aws_route_table_association" "public" {
  count          = var.number_of_public_subnets
  subnet_id      = aws_subnet.public_subnet[count.index].id
  route_table_id = aws_route_table.public[count.index].id
}

# Associate the public subnets with the route table
resource "aws_route_table_association" "private" {
  count          = var.number_of_private_subnets
  subnet_id      = aws_subnet.private_subnet[count.index].id
  route_table_id = aws_route_table.private[count.index].id
}