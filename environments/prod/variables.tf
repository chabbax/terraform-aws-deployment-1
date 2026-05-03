# The name of the application.
variable "app_name" {
  type        = string
  description = "The name of the application"
  default     = "example"

  validation {
    condition     = length(var.app_name) > 0
    error_message = "The app_name must not be empty."
  }
}

# The AWS region where resources have been deployed.
variable "aws_region" {
  type        = string
  default     = "us-east-1"
  description = "The AWS region where resources have been deployed"

  validation {
    condition     = length(var.aws_region) > 0
    error_message = "At least one availability zone must be specified."
  }
}

# CIDR block range for VPC.
variable "vpc_cidr_block" {
  type        = string
  default     = "10.0.0.0/16"
  description = "CIDR block range for vpc"

  validation {
    condition     = can(regex("^(\\d{1,3}\\.){3}\\d{1,3}/\\d{1,2}$", var.vpc_cidr_block))
    error_message = "The vpc_cidr_block must be a valid CIDR block."
  }
}

# List of availability zones for the selected region.
variable "availability_zones" {
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b", "us-east-1c"]
  description = "List of availability zones for the selected region"

  validation {
    condition     = length(var.availability_zones) > 0
    error_message = "At least one availability zone must be specified."
  }
}

variable "AWS_ACCESS_KEY_ID" {
  description = "The AWS access key ID."
  type        = string
  sensitive   = true

  validation {
    condition     = length(var.AWS_ACCESS_KEY_ID) > 0
    error_message = "The AWS_ACCESS_KEY_ID variable must be set and cannot be empty."
  }
}

variable "AWS_SECRET_ACCESS_KEY" {
  description = "The AWS secret access key."
  type        = string
  sensitive   = true

  validation {
    condition     = length(var.AWS_SECRET_ACCESS_KEY) > 0
    error_message = "The AWS_SECRET_ACCESS_KEY variable must be set and cannot be empty."
  }
}

variable "email_recipients" {
  type = list(string)

}

# List of origins that are allowed to access the S3 bucket.
variable "s3_cors_allowed_origins" {
  type        = list(string)
  description = "S3 Cors allowed origins"
}

# The name of the marlowe application.
variable "marlowe_service" {
  type        = string
  description = "The name of the marlowe application"
  default     = "marlowe"

  validation {
    condition     = length(var.marlowe_service) > 0
    error_message = "The marlowe_service must not be empty."
  }
}

# The name of the sqs polling sidecar application.
variable "sidecar_name" {
  type        = string
  description = "The name of the sqs polling application"
  default     = "sqs-polling-sidecar"

  validation {
    condition     = length(var.sidecar_name) > 0
    error_message = "The sidecar_name must not be empty."
  }
}

# The name of the transformer application.
variable "transformer_service" {
  type        = string
  description = "The name of the transformer application"
  default     = "transformer"

  validation {
    condition     = length(var.transformer_service) > 0
    error_message = "The transformer_service must not be empty."
  }
}

variable "recommendation_service" {
  type        = string
  description = "The name of the recommendation application"
  default     = "recommendation"

  validation {
    condition     = length(var.recommendation_service) > 0
    error_message = "The recommendation_service must not be empty."
  }
}

variable "docdb_instance_class" {
  type        = string
  description = "The instance class for the DocumentDB cluster"
  default     = "db.t3.medium"

  validation {
    condition     = length(var.docdb_instance_class) > 0
    error_message = "The instance class cannot be empty."
  }
}

variable "doc_db_username" {
  description = "DocumentDB username"
  type        = string
  sensitive   = true
}

variable "doc_db_password" {
  description = "DocumentDB password"
  type        = string
  sensitive   = true
}


variable "docdb_replica_count" {
  type        = number
  description = "The number of replicas in the DocumentDB cluster"
  default     = 1

  validation {
    condition     = var.docdb_replica_count > 0
    error_message = "The replica count must be greater than 0."
  }
}


variable "marlowe_assets" {
  type        = string
  description = "The URL of the Marlowe assets"

  validation {
    condition     = length(var.marlowe_assets) > 0
    error_message = "The marlowe_assets must not be empty."
  }
}

variable "marlowe_max_concurrency" {
  type        = number
  description = "The maximum concurrency for the Marlowe service"
  default     = 2

  validation {
    condition     = var.marlowe_max_concurrency > 0
    error_message = "The max concurrency must be greater than 0."
  }
}


variable "default_organization_id" {
  type        = string
  description = "The default organization ID"

  validation {
    condition     = length(var.default_organization_id) > 0
    error_message = "The defaultorganizationid must not be empty."
  }
}

variable "exec_bin" {
  type        = string
  description = "The executable binary"

  validation {
    condition     = length(var.exec_bin) > 0
    error_message = "The exec_bin must not be empty."
  }
}

variable "exec_params" {
  type        = string
  description = "The executable parameters"

  validation {
    condition     = length(var.exec_params) > 0
    error_message = "The exec_params must not be empty."
  }
}

variable "twingate_api_token" {
  type        = string
  description = "The twingate api key"
}

variable "twingate_network" {
  type        = string
  description = "The twingate network"
}

variable "doc_db_uri" {
  type        = string
  description = "The documentdb uri"
  sensitive   = true
}

variable "elasticache_node_type" {
  type        = string
  description = "Node Type"
  default     = "cache.t3.small"
}

variable "mallet_path" {
  type        = string
  description = "The path to the mallet binary"

  validation {
    condition     = length(var.mallet_path) > 0
    error_message = "The mallet_path must not be empty."
  }
}

variable "model_dir" {
  type        = string
  description = "The path to the model directory"

  validation {
    condition     = length(var.model_dir) > 0
    error_message = "The model_dir must not be empty."
  }
}

variable "spacy_model_name" {
  type        = string
  description = "The name of the spacy model"

  validation {
    condition     = length(var.spacy_model_name) > 0
    error_message = "The spacy_model_name must not be empty."
  }
}

variable "reticulate_python" {
  type        = string
  description = "The path to the python binary"

  validation {
    condition     = length(var.reticulate_python) > 0
    error_message = "The reticulate_python must not be empty."
  }
}

variable "ai_service" {
  type        = string
  description = "The name of the ai application"
  default     = "ai"

  validation {
    condition     = length(var.ai_service) > 0
    error_message = "The ai_service must not be empty."
  }
}

variable "document_preprocessing_lambda_name" {
  description = "ARN of the Document Preprocessing Lambda function"
  type        = string

  validation {
    condition     = length(var.document_preprocessing_lambda_name) > 0
    error_message = "The document_preprocessing_lambda_name cannot be empty."
  }
}

variable "langfuse_public_key" {
  type        = string
  description = "The public key for Langfuse"

  validation {
    condition     = length(var.langfuse_public_key) > 0
    error_message = "The langfuse_public_key must not be empty."
  }
}

variable "langfuse_secret_key" {
  type        = string
  description = "The secret key for Langfuse"
  sensitive   = true

  validation {
    condition     = length(var.langfuse_secret_key) > 0
    error_message = "The langfuse_secret_key must not be empty."
  }
}

# llm_provider_model

variable "primary_llm_provider" {
  type        = string
  description = "The primary LLM provider"
  default     = ""

}

variable "primary_llm_provider_model" {
  type        = string
  description = "The primary LLM provider model"

  validation {
    condition     = length(var.primary_llm_provider_model) > 0
    error_message = "The primary_llm_provider_model must not be empty."
  }
}

variable "secondary_llm_provider" {
  type        = string
  description = "The secondary LLM provider"
  default     = ""

  validation {
    condition     = length(var.secondary_llm_provider) > 0
    error_message = "The secondary_llm_provider must not be empty."
  }
}

variable "secondary_llm_provider_model" {
  type        = string
  description = "The secondary LLM provider model"

  validation {
    condition     = length(var.secondary_llm_provider_model) > 0
    error_message = "The secondary_llm_provider_model must not be empty."
  }
}

variable "tertiary_llm_provider" {
  type        = string
  description = "The tertiary LLM provider"

  validation {
    condition     = length(var.tertiary_llm_provider) > 0
    error_message = "The tertiary_llm_provider must not be empty."
  }
}
variable "tertiary_llm_provider_model" {
  type        = string
  description = "The tertiary LLM provider model"

  validation {
    condition     = length(var.tertiary_llm_provider_model) > 0
    error_message = "The tertiary_llm_provider_model must not be empty."
  }
}


variable "anthropic_api_key" {
  type        = string
  description = "The API key for Anthropic"
  sensitive   = true

  validation {
    condition     = length(var.anthropic_api_key) > 0
    error_message = "The anthropic_api_key must not be empty."
  }
}

variable "openai_api_key" {
  type        = string
  description = "The API key for OpenAI"
  sensitive   = true

  validation {
    condition     = length(var.openai_api_key) > 0
    error_message = "The openai_api_key must not be empty."
  }
}


variable "document_preprocessing_lambda_arn" {
  description = "ARN of the Document Preprocessing Lambda function"
  type        = string

  validation {
    condition     = length(var.document_preprocessing_lambda_arn) > 0
    error_message = "The document_preprocessing_lambda_arn cannot be empty."
  }
}
