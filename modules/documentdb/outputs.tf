output "doc_db_endpoint" {
  value       = aws_docdb_cluster.cluster.endpoint
  description = "The DNS address of the DocDB instance"
}

output "doc_db_cluster_id" {
  value       = aws_docdb_cluster.cluster.id
  description = "The DocDB cluster ID"
}

output "doc_db_instance_id" {
  value       = aws_docdb_cluster_instance.cluster_instances[0].id
  description = "The DocDB instance ID"
}