resource "aws_ecs_cluster" "main" {
  name = "ecs-cluster-${var.app_name}-${terraform.workspace}"
  setting {
    name  = "containerInsights"
    value = "disabled"
  }

  tags = {
    Project     = var.app_name
    Environment = terraform.workspace
  }
}

# Sidecar ECS service configurations
resource "aws_ecs_task_definition" "sidecar_service_task_definition" {
  family                   = "${var.sidecar_name}-${terraform.workspace}-task-def"
  network_mode             = "awsvpc"
  requires_compatibilities = [var.launch_types]
  cpu                      = var.sidecar_cpu
  memory                   = var.sidecar_memory
  execution_role_arn       = aws_iam_role.execution_role.arn
  task_role_arn            = aws_iam_role.task_role.arn

  container_definitions = templatefile("${path.module}/resources/task_definition.json", {
    service_ecr_image      = var.sidecar_ecr_image
    service_ecr_image_tag  = var.sidecar_ecr_image_tag
    service_container_port = var.sidecar_container_port
    service_name           = var.sidecar_name
    service_cpu            = var.sidecar_cpu
    service_memory         = var.sidecar_memory
    service_environment    = var.sidecar_environment
    health_check_path      = "/health"
    //
    aws_region = var.aws_region
    workspace  = terraform.workspace
  })

  tags = {
    Project     = var.app_name
    Environment = terraform.workspace
  }
}

resource "aws_ecs_service" "sidecar_service" {
  name            = "${var.sidecar_name}-${terraform.workspace}"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.sidecar_service_task_definition.arn
  desired_count   = 1
  // setting the minimum healthy percent to 0 to avoid the service from read the SQS messages multiple times during the deployment
  deployment_maximum_percent         = 100
  deployment_minimum_healthy_percent = 0
  force_new_deployment               = true

  capacity_provider_strategy {
    capacity_provider = "FARGATE"
    weight            = 1
    base              = 0
  }

  network_configuration {
    security_groups = [var.task_security_group]
    subnets         = var.subnet_ids_private
  }

  service_registries {
    registry_arn = aws_service_discovery_service.sidecar_service_discovery_service.arn
  }

  triggers = {
    redeployment = plantimestamp()
  }

  lifecycle {
    prevent_destroy = true
  }

  depends_on = [
    aws_ecs_cluster.main,
    aws_ecs_task_definition.sidecar_service_task_definition,
    aws_cloudwatch_log_group.sidecar_log_group,
    aws_service_discovery_service.sidecar_service_discovery_service
  ]

  tags = {
    Project     = var.app_name
    Environment = terraform.workspace
  }
}


# Marlowe ECS service configurations
resource "aws_ecs_task_definition" "marlowe_service_task_definition" {
  family                   = "${var.marlowe_service_name}-${terraform.workspace}-task-def"
  network_mode             = "awsvpc"
  requires_compatibilities = [var.launch_types]
  cpu                      = var.marlowe_cpu
  memory                   = var.marlowe_memory

  execution_role_arn = aws_iam_role.execution_role.arn
  task_role_arn      = aws_iam_role.task_role.arn

  container_definitions = templatefile("${path.module}/resources/task_definition.json", {
    service_ecr_image      = var.marlowe_ecr_image
    service_ecr_image_tag  = var.marlowe_ecr_image_tag
    service_container_port = var.marlowe_container_port
    service_name           = var.marlowe_service_name
    service_cpu            = var.marlowe_cpu
    service_memory         = var.marlowe_memory
    service_environment    = var.marlowe_environment
    health_check_path      = "/health"
    //
    aws_region = var.aws_region
    workspace  = terraform.workspace
  })
  tags = {
    Project     = var.app_name
    Environment = terraform.workspace
  }
}

resource "aws_ecs_service" "marlowe_service" {
  name                               = "${var.marlowe_service_name}-${terraform.workspace}"
  cluster                            = aws_ecs_cluster.main.id
  task_definition                    = aws_ecs_task_definition.marlowe_service_task_definition.arn
  desired_count                      = var.autoscaling_capacity_min
  deployment_maximum_percent         = 400
  deployment_minimum_healthy_percent = 100
  force_new_deployment               = true


  capacity_provider_strategy {
    capacity_provider = "FARGATE_SPOT"
    weight            = var.capacity_spot_weight
  }

  network_configuration {
    security_groups = [var.task_security_group]
    subnets         = var.subnet_ids_private
  }

  service_registries {
    registry_arn = aws_service_discovery_service.marlowe_service_discovery_service.arn
  }

  triggers = {
    redeployment = plantimestamp()
  }

  lifecycle {
    # Commenting out the below line to make a fresh start after the deployment. Otherwise, old tasks may be be preserved after the deployment and messed up. :(
    //ignore_changes  = [desired_count]
    prevent_destroy = true
  }

  depends_on = [
    aws_ecs_cluster.main,
    aws_ecs_task_definition.marlowe_service_task_definition,
    aws_cloudwatch_log_group.marlowe_service_log_group,
    aws_service_discovery_service.marlowe_service_discovery_service
  ]

  tags = {
    Project     = var.app_name
    Environment = terraform.workspace
  }
}
# Marlowe ECS service configurations End


# Transformer ECS service configurations
resource "aws_ecs_task_definition" "transformer_service_task_definition" {
  family                   = "${var.transformer_name}-${terraform.workspace}-task-def"
  network_mode             = "awsvpc"
  requires_compatibilities = [var.launch_types]
  cpu                      = var.transformer_cpu
  memory                   = var.transformer_memory
  execution_role_arn       = aws_iam_role.execution_role.arn
  task_role_arn            = aws_iam_role.task_role.arn

  container_definitions = templatefile("${path.module}/resources/task_definition.json", {
    service_ecr_image      = var.transformer_ecr_image
    service_ecr_image_tag  = var.transformer_ecr_image_tag
    service_cpu            = var.transformer_cpu
    service_memory         = var.transformer_memory
    service_name           = var.transformer_name
    service_environment    = var.transformer_environment
    service_container_port = var.transformer_container_port
    health_check_path      = "/health"
    //
    aws_region = var.aws_region
    workspace  = terraform.workspace
  })

  tags = {
    Project     = var.app_name
    Environment = terraform.workspace
  }
}

resource "aws_ecs_service" "transformer_service" {
  name                               = "${var.transformer_name}-${terraform.workspace}"
  cluster                            = aws_ecs_cluster.main.id
  task_definition                    = aws_ecs_task_definition.transformer_service_task_definition.arn
  desired_count                      = 1
  deployment_maximum_percent         = 200
  deployment_minimum_healthy_percent = 100
  force_new_deployment               = true

  capacity_provider_strategy {
    capacity_provider = "FARGATE"
    weight            = 1
    base              = 0
  }

  network_configuration {
    security_groups = [var.task_security_group]
    subnets         = var.subnet_ids_private
  }

  service_registries {
    registry_arn = aws_service_discovery_service.transformer_service_discovery_service.arn
  }

  triggers = {
    redeployment = plantimestamp()
  }

  lifecycle {
    prevent_destroy = true
  }

  depends_on = [
    aws_ecs_cluster.main,
    aws_ecs_task_definition.transformer_service_task_definition,
    aws_cloudwatch_log_group.transformer_log_group,
    aws_service_discovery_service.transformer_service_discovery_service
  ]

  tags = {
    Project     = var.app_name
    Environment = terraform.workspace
  }
}
# Transformer ECS service configurations End


# Recommendation ECS service configurations
resource "aws_ecs_task_definition" "recommendation_service_task_definition" {
  family                   = "${var.recommendation_name}-${terraform.workspace}-task-def"
  network_mode             = "awsvpc"
  requires_compatibilities = [var.launch_types]
  cpu                      = var.recommendation_cpu
  memory                   = var.recommendation_memory

  execution_role_arn = aws_iam_role.execution_role.arn
  task_role_arn      = aws_iam_role.task_role.arn

  container_definitions = templatefile("${path.module}/resources/task_definition.json", {
    service_ecr_image      = var.recommendation_ecr_image
    service_ecr_image_tag  = var.recommendation_ecr_image_tag
    service_cpu            = var.recommendation_cpu
    service_memory         = var.recommendation_memory
    service_name           = var.recommendation_name
    service_environment    = var.recommendation_environment
    service_container_port = var.recommendation_container_port
    health_check_path      = "/health"
    //
    aws_region = var.aws_region
    workspace  = terraform.workspace
  })

  tags = {
    Project     = var.app_name
    Environment = terraform.workspace
  }
}

resource "aws_ecs_service" "recommendation_service" {
  name                               = "${var.recommendation_name}-${terraform.workspace}"
  cluster                            = aws_ecs_cluster.main.id
  task_definition                    = aws_ecs_task_definition.recommendation_service_task_definition.arn
  desired_count                      = 1
  deployment_maximum_percent         = 200
  deployment_minimum_healthy_percent = 100
  force_new_deployment               = true

  capacity_provider_strategy {
    capacity_provider = "FARGATE_SPOT"
    weight            = var.capacity_spot_weight
  }

  network_configuration {
    security_groups = [var.task_security_group]
    subnets         = var.subnet_ids_private
  }

  triggers = {
    redeployment = plantimestamp()
  }

  lifecycle {
    prevent_destroy = true
  }

  service_registries {
    registry_arn = aws_service_discovery_service.recommendation_service_discovery_service.arn
  }

  depends_on = [
    aws_ecs_cluster.main,
    aws_ecs_task_definition.recommendation_service_task_definition,
    aws_cloudwatch_log_group.recommendation_log_group
  ]

  tags = {
    Project     = var.app_name
    Environment = terraform.workspace
  }
}
# Recommendation ECS service configurations End



# AI service ECS service configurations
resource "aws_ecs_task_definition" "ai_service_task_definition" {
  family                   = "${var.ai_name}-${terraform.workspace}-task-def"
  network_mode             = "awsvpc"
  requires_compatibilities = [var.launch_types]
  cpu                      = var.ai_cpu
  memory                   = var.ai_memory

  execution_role_arn = aws_iam_role.execution_role.arn
  task_role_arn      = aws_iam_role.task_role.arn

  container_definitions = templatefile("${path.module}/resources/task_definition.json", {
    service_ecr_image      = var.ai_ecr_image
    service_ecr_image_tag  = var.ai_ecr_image_tag
    service_cpu            = var.ai_cpu
    service_memory         = var.ai_memory
    service_name           = var.ai_name
    service_environment    = var.ai_environment
    service_container_port = var.ai_container_port
    health_check_path      = "/health"
    //
    aws_region = var.aws_region
    workspace  = terraform.workspace
  })

  tags = {
    Project     = var.app_name
    Environment = terraform.workspace
  }
}

resource "aws_ecs_service" "ai_service" {
  name                               = "${var.ai_name}-${terraform.workspace}"
  cluster                            = aws_ecs_cluster.main.id
  task_definition                    = aws_ecs_task_definition.ai_service_task_definition.arn
  desired_count                      = 1
  deployment_maximum_percent         = 200
  deployment_minimum_healthy_percent = 100
  force_new_deployment               = true

  capacity_provider_strategy {
    capacity_provider = "FARGATE_SPOT"
    weight            = var.capacity_spot_weight
  }

  network_configuration {
    security_groups = [var.task_security_group]
    subnets         = var.subnet_ids_private
  }
  triggers = {
    redeployment = plantimestamp()
  }
  lifecycle {
    prevent_destroy = true
  }
  service_registries {
    registry_arn = aws_service_discovery_service.ai_service_discovery_service.arn
  }
  depends_on = [
    aws_ecs_cluster.main,
    aws_ecs_task_definition.ai_service_task_definition,
    aws_cloudwatch_log_group.ai_log_group
  ]
  tags = {
    Project     = var.app_name
    Environment = terraform.workspace
  }
}