resource "aws_db_subnet_group" "main" {
  name       = "${var.project_name}-${var.environment}-${var.identifier_suffix}-subnet-group"
  subnet_ids = var.private_subnet_ids
  
  tags = {
    Name        = "${var.project_name}-${var.environment}-${var.identifier_suffix}-subnet-group"
    Environment = var.environment
    Project     = var.project_name
  }
}

resource "aws_db_instance" "main" {
  identifier     = "${var.project_name}-${var.environment}-${var.identifier_suffix}"
  engine         = var.engine
  engine_version = var.engine_version
  instance_class = var.instance_class
  
  allocated_storage     = var.allocated_storage
  max_allocated_storage = var.max_allocated_storage
  storage_type          = var.storage_type
  storage_encrypted     = var.storage_encrypted
  
  db_name  = var.db_name
  username = var.master_username
  password = var.master_password
  port     = var.port
  
  multi_az               = var.multi_az
  publicly_accessible    = false
  db_subnet_group_name   = aws_db_subnet_group.main.name
  vpc_security_group_ids = var.security_group_ids
  
  backup_retention_period = var.backup_retention_period
  backup_window          = var.backup_window
  maintenance_window     = var.maintenance_window
  
  skip_final_snapshot       = var.skip_final_snapshot
  final_snapshot_identifier = var.skip_final_snapshot ? null : "${var.project_name}-${var.environment}-${var.identifier_suffix}-final-snapshot"
  
  enabled_cloudwatch_logs_exports = var.enabled_cloudwatch_logs_exports
  
  tags = {
    Name        = "${var.project_name}-${var.environment}-${var.identifier_suffix}"
    Environment = var.environment
    Project     = var.project_name
  }
}
