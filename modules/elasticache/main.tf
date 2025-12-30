resource "aws_elasticache_subnet_group" "main" {
  name       = "${var.project_name}-${var.environment}-redis-subnet-group"
  subnet_ids = var.private_subnet_ids

  tags = {
    Name        = "${var.project_name}-${var.environment}-redis-subnet-group"
    Environment = var.environment
    Project     = var.project_name
  }
}

resource "aws_elasticache_replication_group" "main" {
  replication_group_id = "${var.project_name}-${var.environment}-redis"
  description          = "Redis cluster for ${var.project_name} ${var.environment}"

  engine               = var.engine
  engine_version       = var.engine_version
  node_type            = var.node_type
  num_cache_clusters   = var.num_cache_nodes
  parameter_group_name = var.parameter_group_name
  port                 = var.port

  subnet_group_name  = aws_elasticache_subnet_group.main.name
  security_group_ids = var.security_group_ids

  at_rest_encryption_enabled = var.at_rest_encryption_enabled
  transit_encryption_enabled = var.transit_encryption_enabled

  # Single-AZ deployment - disable automatic failover
  automatic_failover_enabled = false
  multi_az_enabled           = false

  tags = {
    Name        = "${var.project_name}-${var.environment}-redis"
    Environment = var.environment
    Project     = var.project_name
  }
}

data "aws_elasticache_cluster" "main" {
  cluster_id = "${aws_elasticache_replication_group.main.replication_group_id}-001"
}
