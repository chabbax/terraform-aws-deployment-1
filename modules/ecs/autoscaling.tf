resource "aws_iam_role" "ecs_autoscaling_role" {
  name = "ecsAutoScalingRole"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "application-autoscaling.amazonaws.com"
        },
      },
    ],
  })
}

resource "aws_iam_role_policy_attachment" "ecs_full_access" {
  role       = aws_iam_role.ecs_autoscaling_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonECS_FullAccess"
}

resource "aws_iam_role_policy_attachment" "ecr_full_access" {
  role       = aws_iam_role.ecs_autoscaling_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryFullAccess"
}

resource "aws_iam_role_policy_attachment" "cloudwatch_full_access" {
  role       = aws_iam_role.ecs_autoscaling_role.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchFullAccess"
}


resource "aws_appautoscaling_target" "marlowe_service_target" {
  max_capacity       = var.autoscaling_capacity_max
  min_capacity       = var.autoscaling_capacity_min
  resource_id        = "service/${aws_ecs_cluster.main.name}/${aws_ecs_service.marlowe_service.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
  role_arn           = aws_iam_role.ecs_autoscaling_role.arn
}

resource "aws_appautoscaling_policy" "marlowe_service_scale_out_memory" {
  name               = "scale-out-memory"
  resource_id        = aws_appautoscaling_target.marlowe_service_target.resource_id
  scalable_dimension = aws_appautoscaling_target.marlowe_service_target.scalable_dimension
  service_namespace  = aws_appautoscaling_target.marlowe_service_target.service_namespace
  policy_type        = "TargetTrackingScaling"

  target_tracking_scaling_policy_configuration {
    target_value = 5
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageMemoryUtilization"
    }
    scale_out_cooldown = 5
    scale_in_cooldown  = 1200
  }
}



