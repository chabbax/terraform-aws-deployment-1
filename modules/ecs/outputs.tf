# Name of the ECS service
output "service_name" {
  value       = aws_ecs_service.marlowe_service.name
  description = "Name of ECS service"
  sensitive   = false
}

output "transformer_service_dns_name" {
  value       = "${aws_service_discovery_service.transformer_service_discovery_service.name}.${aws_service_discovery_private_dns_namespace.main.name}"
  description = "DNS name of the Transformer service"
  sensitive   = false
}

output "marlowe_service_dns_name" {
  value       = "${aws_service_discovery_service.marlowe_service_discovery_service.name}.${aws_service_discovery_private_dns_namespace.main.name}"
  description = "DNS name of the Marlowe service"
  sensitive   = false
}

output "recommendation_service_dns_name" {
  value       = "${aws_service_discovery_service.recommendation_service_discovery_service.name}.${aws_service_discovery_private_dns_namespace.main.name}"
  description = "DNS name of the Recommendation service"
  sensitive   = false
}

output "sidecar_service_dns_name" {
  value       = "${aws_service_discovery_service.sidecar_service_discovery_service.name}.${aws_service_discovery_private_dns_namespace.main.name}"
  description = "DNS name of the Sidecar service"
  sensitive   = false
}