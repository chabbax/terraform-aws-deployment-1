resource "aws_service_discovery_private_dns_namespace" "main" {
  name        = "${terraform.workspace}.authors-ai.local"
  vpc         = var.vpc_id
  description = "Private DNS namespace for service discovery"
}

resource "aws_service_discovery_service" "marlowe_service_discovery_service" {
  name = "marlowe"
  dns_config {
    namespace_id = aws_service_discovery_private_dns_namespace.main.id
    dns_records {
      type = "A"
      ttl  = 10
    }
    routing_policy = "MULTIVALUE"
  }

  health_check_custom_config {
    failure_threshold = 1
  }
}

resource "aws_service_discovery_service" "transformer_service_discovery_service" {
  name = "transformer"
  dns_config {
    namespace_id = aws_service_discovery_private_dns_namespace.main.id
    dns_records {
      type = "A"
      ttl  = 30
    }
    routing_policy = "MULTIVALUE"
  }

  health_check_custom_config {
    failure_threshold = 1
  }
}

resource "aws_service_discovery_service" "sidecar_service_discovery_service" {
  name = "sidecar"
  dns_config {
    namespace_id = aws_service_discovery_private_dns_namespace.main.id
    dns_records {
      type = "A"
      ttl  = 30
    }
    routing_policy = "MULTIVALUE"
  }

}

resource "aws_service_discovery_service" "recommendation_service_discovery_service" {
  name = "recommendation"
  dns_config {
    namespace_id = aws_service_discovery_private_dns_namespace.main.id
    dns_records {
      type = "A"
      ttl  = 10
    }
    routing_policy = "MULTIVALUE"
  }

  health_check_custom_config {
    failure_threshold = 1
  }
}

resource "aws_service_discovery_service" "ai_service_discovery_service" {
  name = "ai"
  dns_config {
    namespace_id = aws_service_discovery_private_dns_namespace.main.id
    dns_records {
      type = "A"
      ttl  = 10
    }
    routing_policy = "MULTIVALUE"
  }

  health_check_custom_config {
    failure_threshold = 1
  }
}
