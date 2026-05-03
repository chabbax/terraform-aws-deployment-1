# Outputs the ARN of the main VPC
output "vpc_arn" {
  value       = aws_vpc.main.arn
  description = "ARN of the main VPC"
  sensitive   = false
}

# Outputs the ID of the main VPC
output "vpc_id" {
  value       = aws_vpc.main.id
  description = "ID of the main VPC"
  sensitive   = false
}

# CIDR block of the main VPC
output "vpc_cidr_block" {
  value       = aws_vpc.main.cidr_block
  description = "CIDR block of the main VPC"
  sensitive   = false
}

# Outputs the IDs of the private subnets in the VPC
output "private_subnet_ids" {
  value       = aws_subnet.private_subnet.*.id
  description = "IDs of the private subnets in the VPC"
  sensitive   = false
}

# Outputs the IDs of the public subnets in the VPC
output "public_subnet_ids" {
  value       = aws_subnet.public_subnet.*.id
  description = "IDs of the public subnets in the VPC"
  sensitive   = false
}

output "task_security_group" {
  value       = aws_security_group.task_security_group.id
  description = "IDs of the ECS task security group"
  sensitive   = false
}