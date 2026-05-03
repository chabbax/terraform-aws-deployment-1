# Name of the application
variable "app_name" {
  description = "The name of the application"
  type        = string

  validation {
    condition     = length(var.app_name) > 0
    error_message = "The app_name must not be empty."
  }
}

# Minimum number of tasks for autoscaling
variable "autoscaling_capacity_min" {
  description = "Minimum number of desired tasks"
  type        = number
  default     = 2

  validation {
    condition     = var.autoscaling_capacity_min >= 0
    error_message = "The autoscaling_capacity_min must be a non-negative number."
  }
}

# Maximum number of tasks for autoscaling
variable "autoscaling_capacity_max" {
  description = "Maximum number of desired tasks"
  type        = number
  default     = 7
}

# AWS region where resources will be created
variable "aws_region" {
  description = "The AWS region where the resources will be created"
  type        = string

  validation {
    condition     = can(regex("^(us|eu|ap|sa|ca)-[a-z]+-[0-9]+$", var.aws_region))
    error_message = "The aws_region must be a valid AWS region code"
  }
}

# VPC where the resources will be created
variable "vpc_id" {
  description = "The ID of the VPC"
  type        = string

  validation {
    condition     = length(var.vpc_id) > 0
    error_message = "The vpc_id must not be empty."
  }
}

# Private subnets where the service will be deployed
variable "subnet_ids_private" {
  description = "List of private subnet IDs where the service will be deployed"
  type        = list(string)

  validation {
    condition     = length(var.subnet_ids_private) > 0
    error_message = "The subnet_ids_private list must not be empty."
  }
}

# Name of the ECS service
variable "marlowe_service_name" {
  description = "The name of the ECS service"
  type        = string

  validation {
    condition     = length(var.marlowe_service_name) > 0
    error_message = "The marlowe_service_name must not be empty."
  }
}

# Service ECR image for the service
variable "marlowe_ecr_image" {
  description = "The name of the service ECR image"
  type        = string

  validation {
    condition     = length(var.marlowe_ecr_image) > 0
    error_message = "The marlowe_ecr_image must not be empty."
  }
}

# Service ECR image tag for the service
variable "marlowe_ecr_image_tag" {
  description = "The tag of the service ECR image"
  type        = string

  validation {
    condition     = length(var.marlowe_ecr_image_tag) > 0
    error_message = "The marlowe_ecr_image_tag must not be empty."
  }
}

# The port on the service container bound to the host port
variable "marlowe_container_port" {
  description = "The port number on the service container that is bound to the host port"
  type        = number

  validation {
    condition     = var.marlowe_container_port > 0 && var.marlowe_container_port <= 65535
    error_message = "The marlowe_container_port must be a valid port number (1-65535)."
  }
}

# Service CPU units to reserve for the container
variable "marlowe_cpu" {
  description = "The number of service CPU units to reserve for the container"
  type        = number

  validation {
    condition     = var.marlowe_cpu >= 0
    error_message = "The service_cpu must be a non-negative number."
  }
}

# Service memory to reserve for the container
variable "marlowe_memory" {
  description = "The amount of service memory (in MiB) to reserve for the container"
  type        = number

  validation {
    condition     = var.marlowe_memory > 0
    error_message = "The marlowe_memory must be a positive number."
  }
}

# Number of on-demand instances
variable "capacity_on_demand_base" {
  description = "The number of on-demand instances"
  type        = number

  validation {
    condition     = var.capacity_on_demand_base >= 0
    error_message = "The capacity_on_demand_base must be a non-negative number."
  }
}

# Weight of on-demand instances for capacity providers
variable "capacity_on_demand_weight" {
  description = "The weight of on-demand instances for capacity providers"
  type        = number

  validation {
    condition     = var.capacity_on_demand_weight >= 0
    error_message = "The capacity_on_demand_weight must be a non-negative number."
  }
}

# Weight of spot instances to use for capacity
variable "capacity_spot_weight" {
  type        = number
  description = "The weight of spot instances to use for capacity"

  validation {
    condition     = var.capacity_spot_weight >= 0
    error_message = "The capacity_spot_weight must be a non-negative number."
  }
}

# The delay in seconds before registering targets with the target group
variable "target_group_start_delay_seconds" {
  type        = number
  default     = 0
  description = "The number of seconds to wait before registering targets to a target group"

  validation {
    condition     = var.target_group_start_delay_seconds >= 0
    error_message = "The target_group_start_delay_seconds must be a non-negative number."
  }
}

# The launch type for the ECS service
variable "launch_types" {
  type        = string
  default     = "FARGATE"
  description = "The launch types to use for the ECS service"

  validation {
    condition     = can(regex("^(EC2|FARGATE)$", var.launch_types))
    error_message = "The launch_types must be either EC2 or FARGATE."
  }
}

# List of environment variables for the service.
variable "marlowe_environment" {
  type        = string
  description = "Environment variable list for the service"
}

variable "sidecar_environment" {
  type        = string
  description = "Environment variable list for the sidecar"
}

# CIDR block range for vpc
variable "vpc_cidr_block" {
  type        = string
  default     = "10.0.0.0/16"
  description = "CIDR block range for vpc"

  validation {
    condition     = can(regex("^(\\d{1,3}\\.){3}\\d{1,3}/\\d{1,2}$", var.vpc_cidr_block))
    error_message = "The vpc_cidr_block must be a valid CIDR block."
  }
}

# Sidecar ECR image
variable "sidecar_ecr_image" {
  description = "The name of the sidecar ECR image"
  type        = string

  validation {
    condition     = length(var.sidecar_ecr_image) > 0
    error_message = "The sidecar_ecr_image must not be empty."
  }
}

# Sidecar ECR image tag
variable "sidecar_ecr_image_tag" {
  description = "The tag of the sidecar ECR image"
  type        = string

  validation {
    condition     = length(var.sidecar_ecr_image_tag) > 0
    error_message = "The sidecar_ecr_image_tag must not be empty."
  }
}

# The port on the sidecar container bound to the host port
variable "sidecar_container_port" {
  description = "The port number on the sidecar container that is bound to the host port"
  type        = number

  validation {
    condition     = var.sidecar_container_port > 0 && var.sidecar_container_port <= 65535
    error_message = "The sidecar_container_port must be a valid port number (1-65535)."
  }
}

# Name of the ECS sidecar
variable "sidecar_name" {
  description = "The name of the ECS sidecar"
  type        = string

  validation {
    condition     = length(var.sidecar_name) > 0
    error_message = "The sidecar_name must not be empty."
  }
}

# Sidecar CPU units to reserve for the container
variable "sidecar_cpu" {
  description = "The number of sidecar CPU units to reserve for the container"
  type        = number

  validation {
    condition     = var.sidecar_cpu >= 0
    error_message = "The sidecar_cpu must be a non-negative number."
  }
}

# Sidecar memory to reserve for the container
variable "sidecar_memory" {
  description = "The amount of sidecar memory (in MiB) to reserve for the container"
  type        = number

  validation {
    condition     = var.sidecar_memory > 0
    error_message = "The sidecar_memory must be a positive number."
  }
}

variable "appsettings_enable_dns_health_check" {
  description = "Enable DNS health check in appsettings.json"
  type        = bool
  default     = true
}

variable "media_bucket_arn" {
  description = "The ARN of the media bucket"
  type        = string

  validation {
    condition     = can(regex("^arn:aws:s3:::[a-zA-Z0-9.-]{3,63}$", var.media_bucket_arn))
    error_message = "The media_bucket_arn must be a valid S3 bucket ARN in the format 'arn:aws:s3:::bucket-name'."
  }
}

variable "task_security_group" {
  description = "The security group ID to be attached to the ECS task."
  type        = string

  validation {
    condition     = can(regex("^sg-[0-9a-f]{8,}$", var.task_security_group))
    error_message = "The provided security group ID is not valid. It should start with 'sg-' and be followed by 8 or more hexadecimal characters."
  }
}

variable "account_id" {
  description = "AWS Account ID"
  type        = string

  validation {
    condition     = length(var.account_id) == 12 && can(regex("\\d{12}", var.account_id))
    error_message = "The account_id must be a 12-digit numeric string."
  }
}

# Transformer ECR image for the service
variable "transformer_ecr_image" {
  description = "The name of the service ECR image"
  type        = string

  validation {
    condition     = length(var.transformer_ecr_image) > 0
    error_message = "The transformer_ecr_image must not be empty."
  }
}

# Transformer ECR image tag for the service
variable "transformer_ecr_image_tag" {
  description = "The tag of the service ECR image"
  type        = string

  validation {
    condition     = length(var.transformer_ecr_image_tag) > 0
    error_message = "The transformer_ecr_image_tag must not be empty."
  }
}

# Transformer CPU units to reserve for the container
variable "transformer_cpu" {
  description = "The number of service CPU units to reserve for the container"
  type        = number

  validation {
    condition     = var.transformer_cpu >= 0
    error_message = "The transformer_cpu must be a non-negative number."
  }
}

# Transformer memory to reserve for the container
variable "transformer_memory" {
  description = "The amount of service memory (in MiB) to reserve for the container"
  type        = number

  validation {
    condition     = var.transformer_memory > 0
    error_message = "The transformer_memory must be a positive number."
  }
}

# Name of the ECS Transformer service
variable "transformer_name" {
  description = "The name of the ECS service"
  type        = string

  validation {
    condition     = length(var.transformer_name) > 0
    error_message = "The transformer_name must not be empty."
  }
}

# List of environment variables for the transformer service.
variable "transformer_environment" {
  type        = string
  description = "Environment variable list for the transformer service"
}

# The port on the transformer container bound to the host port
variable "transformer_container_port" {
  description = "The port number on the service container that is bound to the host port"
  type        = number

  validation {
    condition     = var.transformer_container_port > 0 && var.transformer_container_port <= 65535
    error_message = "The transformer_container_port must be a valid port number (1-65535)."
  }
}

# recomdation task vars
variable "recommendation_ecr_image" {
  description = "The name of the service ECR image"
  type        = string

  validation {
    condition     = length(var.recommendation_ecr_image) > 0
    error_message = "The recommendation_ecr_image must not be empty."
  }
}

# recommendation ECR image tag for the service
variable "recommendation_ecr_image_tag" {
  description = "The tag of the service ECR image"
  type        = string

  validation {
    condition     = length(var.recommendation_ecr_image_tag) > 0
    error_message = "The recommendation_ecr_image_tag must not be empty."
  }
}

# recommendation CPU units to reserve for the container
variable "recommendation_cpu" {
  description = "The number of service CPU units to reserve for the container"
  type        = number

  validation {
    condition     = var.recommendation_cpu >= 0
    error_message = "The recommendation_cpu must be a non-negative number."
  }
}

# recommendation memory to reserve for the container
variable "recommendation_memory" {
  description = "The amount of service memory (in MiB) to reserve for the container"
  type        = number

  validation {
    condition     = var.recommendation_memory > 0
    error_message = "The recommendation_memory must be a positive number."
  }
}

# Name of the ECS recommendation service
variable "recommendation_name" {
  description = "The name of the ECS service"
  type        = string

  validation {
    condition     = length(var.recommendation_name) > 0
    error_message = "The recommendation_name must not be empty."
  }
}

# List of environment variables for the recommendation service.
variable "recommendation_environment" {
  type        = string
  description = "Environment variable list for the recommendation service"
}

# The port on the recommendation container bound to the host port
variable "recommendation_container_port" {
  description = "The port number on the service container that is bound to the host port"
  type        = number

  validation {
    condition     = var.recommendation_container_port > 0 && var.recommendation_container_port <= 65535
    error_message = "The recommendation_container_port must be a valid port number (1-65535)."
  }
}

# AI ECR image for the service

variable "ai_name" {
  description = "The name of the ECS service"
  type        = string

  validation {
    condition     = length(var.ai_name) > 0
    error_message = "The ai_name must not be empty."
  }
}

variable "ai_cpu" {
  description = "The number of service CPU units to reserve for the container"
  type        = number

  validation {
    condition     = var.ai_cpu >= 0
    error_message = "The ai_cpu must be a non-negative number."
  }
}
variable "ai_memory" {
  description = "The amount of service memory (in MiB) to reserve for the container"
  type        = number

  validation {
    condition     = var.ai_memory > 0
    error_message = "The ai_memory must be a positive number."
  }
}

variable "ai_ecr_image" {
  description = "The name of the service ECR image"
  type        = string

  validation {
    condition     = length(var.ai_ecr_image) > 0
    error_message = "The ai_ecr_image must not be empty."
  }
}

variable "ai_ecr_image_tag" {
  description = "The tag of the service ECR image"
  type        = string

  validation {
    condition     = length(var.ai_ecr_image_tag) > 0
    error_message = "The ai_ecr_image_tag must not be empty."
  }
}

variable "ai_container_port" {
  description = "The port number on the service container that is bound to the host port"
  type        = number

  validation {
    condition     = var.ai_container_port > 0 && var.ai_container_port <= 65535
    error_message = "The ai_container_port must be a valid port number (1-65535)."
  }
}

variable "ai_environment" {
  type        = string
  description = "Environment variable list for the ai service"
}