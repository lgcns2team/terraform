output "endpoint" {
  description = "Redis primary endpoint"
  value       = data.aws_elasticache_cluster.main.cache_nodes[0].address
}

output "primary_endpoint_address" {
  description = "Redis primary endpoint address"
  value       = data.aws_elasticache_cluster.main.cache_nodes[0].address
}

output "reader_endpoint" {
  description = "Redis reader endpoint"
  value       = aws_elasticache_replication_group.main.reader_endpoint_address
}

output "port" {
  description = "Redis port"
  value       = aws_elasticache_replication_group.main.port
}

output "id" {
  description = "Redis replication group ID"
  value       = aws_elasticache_replication_group.main.id
}
