module "aci" {
  source = "../../modules/aci"
}

module "cost_budgets" {
  source                   = "../../modules/budget"
  billing_email_recipients = var.billing_email_recipients
}

module "vpc" {
  source                    = "../../modules/vpc"
  app_name                  = var.app_name
  vpc_cidr_block            = var.vpc_cidr_block
  number_of_private_subnets = 2
  number_of_public_subnets  = 2
  aws_region                = var.aws_region
  availability_zones        = var.availability_zones
}

module "dynamodb" {
  source                  = "../../modules/dynamodb"
  max_read_request_units  = 2000
  max_write_request_units = 2000
}

module "media_bucket" {
  source                             = "../../modules/s3"
  app_name                           = var.app_name
  s3_cors_allowed_origins            = var.s3_cors_allowed_origins
  account_id                         = module.aci.account_id
  aws_region                         = var.aws_region
  document_preprocessing_lambda_name = var.document_preprocessing_lambda_name
  swagger_allowed_ips                = var.swagger_allowed_ips
}

module "cognito_module" {
  source                 = "../../modules/cognito"
  app_name               = var.app_name
  aws_region             = var.aws_region
  account_id             = module.aci.account_id
  documentdb_instance_id = module.documentdb_module.doc_db_instance_id
  documentdb_cluster_id  = module.documentdb_module.doc_db_cluster_id
}

module "sqs" {
  source                            = "../../modules/sqs"
  app_name                          = var.app_name
  account_id                        = module.aci.account_id
  media_bucket_id                   = module.media_bucket.bucket_id
  media_bucket_arn                  = module.media_bucket.bucket_arn
  document_preprocessing_lambda_arn = var.document_preprocessing_lambda_arn
}

module "marlowe_ecr" {
  source       = "../../modules/ecr"
  service_name = var.marlowe_service
  account_id   = module.aci.account_id
}

module "sidecar_ecr" {
  source       = "../../modules/ecr"
  service_name = var.sidecar_name
  account_id   = module.aci.account_id
}

module "transformer_ecr" {
  source       = "../../modules/ecr"
  service_name = var.transformer_service
  account_id   = module.aci.account_id
}

module "recommendation_ecr" {
  source       = "../../modules/ecr"
  service_name = var.recommendation_service
  account_id   = module.aci.account_id
}

module "ai_ecr" {
  source       = "../../modules/ecr"
  service_name = var.ai_service
  account_id   = module.aci.account_id
}

module "documentdb_module" {
  source             = "../../modules/documentdb"
  app_name           = var.app_name
  aws_region         = var.aws_region
  doc_db_username    = var.doc_db_username
  doc_db_password    = var.doc_db_password
  private_subnet_ids = module.vpc.private_subnet_ids
  vpc_cidr_block     = var.vpc_cidr_block
  vpc_id             = module.vpc.vpc_id
}

module "marlowe_service" {
  source              = "../../modules/ecs"
  app_name            = var.app_name
  account_id          = module.aci.account_id
  aws_region          = var.aws_region
  media_bucket_arn    = module.media_bucket.bucket_arn
  vpc_id              = module.vpc.vpc_id
  vpc_cidr_block      = module.vpc.vpc_cidr_block
  task_security_group = module.vpc.task_security_group
  subnet_ids_private  = module.vpc.private_subnet_ids

  capacity_on_demand_base   = 1
  capacity_on_demand_weight = 0
  capacity_spot_weight      = 100

  marlowe_service_name   = var.marlowe_service
  marlowe_ecr_image      = module.marlowe_ecr.ecr_repository_url
  marlowe_ecr_image_tag  = "latest"
  marlowe_container_port = 5000
  marlowe_cpu            = 4096
  marlowe_memory         = 8192
  marlowe_environment = templatefile("../../modules/parameters/marlowe_service_env.json", {
    transformer_container_port = 8080,
    marlowe_assets             = var.marlowe_assets,
    exec_bin                   = var.exec_bin,
    exec_params                = var.exec_params,
    aws_access_key_id          = var.AWS_ACCESS_KEY_ID,
    aws_secret_access_key      = var.AWS_SECRET_ACCESS_KEY,
    aws_default_region         = var.aws_region,
    mallet_path                = var.mallet_path,
    model_dir                  = var.model_dir,
    spacy_model_name           = var.spacy_model_name,
    reticulate_python          = var.reticulate_python,
    rstudio_pandoc             = "/usr/bin/pandoc",
    max_concurrency            = var.marlowe_max_concurrency
  })

  sidecar_name           = var.sidecar_name
  sidecar_ecr_image      = module.sidecar_ecr.ecr_repository_url
  sidecar_ecr_image_tag  = "latest"
  sidecar_container_port = 8080
  sidecar_cpu            = 256
  sidecar_memory         = 512
  sidecar_environment = templatefile("../../modules/parameters/sidecar_service_env.json", {
    appsettings_sqsqueueurl             = module.sqs.sqs_queue_url,
    appsettings_tablename               = module.dynamodb.table_name,
    appsettings_defaultorganizationid   = var.default_organization_id,
    appsettings_s3bucket                = module.media_bucket.bucket_name,
    appsettings_marlowreportinghost     = "http://transformer.${terraform.workspace}.authors-ai.local:8080/process",
    appsettings_MarlowProxyUrl          = "http://marlowe.${terraform.workspace}.authors-ai.local:5000/api/v1/workflow:execute"
    appsettings_enable_dns_health_check = true
  })

  transformer_name           = var.transformer_service
  transformer_ecr_image      = module.transformer_ecr.ecr_repository_url
  transformer_ecr_image_tag  = "latest"
  transformer_cpu            = 1024
  transformer_memory         = 2048
  transformer_container_port = 8080
  transformer_environment = templatefile("../../modules/parameters/transformer_service_env.json", {
    nodeenv                            = "production"
    documentdburi                      = "${var.doc_db_uri}"
    databasename                       = "MARLOWE-${terraform.workspace}"
    s3_bucket_name                     = module.media_bucket.bucket_name
    default_organization_id            = var.default_organization_id
    dynamo_db_primary_table            = module.dynamodb.table_name
    recommendation_engine_endpoint_url = "http://recommendation.${terraform.workspace}.authors-ai.local:8080/actions/transformer-webhook",
    ai_engine_endpoint_url             = "http://ai.${terraform.workspace}.authors-ai.local:8080/process/",
    marlowe_runtime_errors_sns_arn     = module.sns.marlowe_runtime_errors_sns_arn
  })

  recommendation_name           = var.recommendation_service
  recommendation_ecr_image      = module.recommendation_ecr.ecr_repository_url
  recommendation_ecr_image_tag  = "latest"
  recommendation_cpu            = 256
  recommendation_memory         = 512
  recommendation_container_port = 8080
  recommendation_environment = templatefile("../../modules/parameters/recommendation_service_env.json", {
    document_db_uri              = "${var.doc_db_uri}"
    database_name                = "MARLOWE-${terraform.workspace}"
    debug                        = true
    redis_db_uri                 = "${module.elasticache.valkey_address}:${module.elasticache.valkey_port}"
    topic_model_names_order      = "T150,N125,S25,V25,A25,E1",
    narratives_model_names_order = "plotArc,plotTurns,pacing",
    coordinates_array_length     = 661,
    dynamo_db_primary_table      = module.dynamodb.table_name,
    default_organization_id      = var.default_organization_id
  })

  ai_name           = var.ai_service
  ai_ecr_image      = module.ai_ecr.ecr_repository_url
  ai_ecr_image_tag  = "latest"
  ai_cpu            = 256
  ai_memory         = 512
  ai_container_port = 8080
  ai_environment = templatefile("../../modules/parameters/ai_service_env.json", {
    document_db_uri              = "${var.doc_db_uri}"
    database_name                = "MARLOWE-${terraform.workspace}"
    anthropic_api_key            = var.anthropic_api_key
    openai_api_key               = var.openai_api_key
    langfuse_public_key          = var.langfuse_public_key
    langfuse_secret_key          = var.langfuse_secret_key
    default_organization_id      = var.default_organization_id
    s3_bucket_name               = module.media_bucket.bucket_name
    primary_llm_provider_model   = var.primary_llm_provider_model
    primary_llm_provider         = var.primary_llm_provider
    secondary_llm_provider_model = var.secondary_llm_provider_model
    secondary_llm_provider       = var.secondary_llm_provider
    tertiary_llm_provider_model  = var.tertiary_llm_provider_model
    tertiary_llm_provider        = var.tertiary_llm_provider
    sqs_queue_url                = module.sqs.llm_requests_queue_url
  })
}


module "iam" {
  source = "../../modules/iam"
}

module "elasticache" {
  source             = "../../modules/elasticache"
  app_name           = var.app_name
  aws_region         = var.aws_region
  node_type          = var.elasticache_node_type
  vpc_id             = module.vpc.vpc_id
  vpc_cidr_block     = var.vpc_cidr_block
  private_subnet_ids = module.vpc.private_subnet_ids
  availability_zones = var.availability_zones
}

module "twingate" {
  source                     = "../../modules/twingate"
  app_name                   = var.app_name
  network                    = var.twingate_network
  twingate_api_token         = var.twingate_api_token
  aws_region                 = var.aws_region
  vpc_id                     = module.vpc.vpc_id
  private_subnet_ids         = module.vpc.private_subnet_ids
  resource_doc_db_endpoint   = module.documentdb_module.doc_db_endpoint
  resource_redis_db_endpoint = module.elasticache.valkey_address
}

module "sns" {
  source = "../../modules/sns"

  app_name                                = var.app_name
  marlowe_runtime_errors_email_recipients = var.marlowe_runtime_errors_email_recipients
  aws_region                              = var.aws_region
}
