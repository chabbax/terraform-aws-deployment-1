output "valkey_address" {
  value       = aws_elasticache_replication_group.valkey.primary_endpoint_address
  description = "The primary endpoint address of the Valkey ElastiCache replication group."
}


output "valkey_port" {
  value       = aws_elasticache_replication_group.valkey.port
  description = "The port number on which the Valkey ElastiCache replication group is listening."
}