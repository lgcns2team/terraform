variable "project_name" {
  description = "Project name for resource naming"
  type        = string
}

variable "environment" {
  description = "Environment (dev, staging, prod)"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "private_subnet_id" {
  description = "Private subnet ID for ECS tasks"
  type        = string
}

variable "gateway_sg_id" {
  description = "Security group ID for Gateway"
  type        = string
}

variable "backend_sg_id" {
  description = "Security group ID for Backend"
  type        = string
}

variable "django_sg_id" {
  description = "Security group ID for Django"
  type        = string
}

variable "alb_target_group_arn" {
  description = "ALB Target Group ARN for Gateway"
  type        = string
}

variable "alb_listener_arn" {
  description = "ALB Listener ARN (for depends_on)"
  type        = string
}

variable "task_execution_role_arn" {
  description = "ECS Task Execution Role ARN"
  type        = string
}

variable "task_role_arn" {
  description = "ECS Task Role ARN"
  type        = string
}

variable "gateway_image" {
  description = "Gateway Docker image URL"
  type        = string
}

variable "gateway_image_tag" {
  description = "Gateway Docker image tag"
  type        = string
  default     = "latest"
}

variable "backend_image" {
  description = "Backend Docker image URL"
  type        = string
}

variable "backend_image_tag" {
  description = "Backend Docker image tag"
  type        = string
  default     = "latest"
}

variable "django_image" {
  description = "Django Docker image URL"
  type        = string
}

variable "django_image_tag" {
  description = "Django Docker image tag"
  type        = string
  default     = "latest"
}

variable "gateway_cpu" {
  description = "CPU units for Gateway task"
  type        = string
  default     = "512"
}

variable "gateway_memory" {
  description = "Memory for Gateway task"
  type        = string
  default     = "1024"
}

variable "backend_cpu" {
  description = "CPU units for Backend task"
  type        = string
  default     = "512"
}

variable "backend_memory" {
  description = "Memory for Backend task"
  type        = string
  default     = "1024"
}

variable "django_cpu" {
  description = "CPU units for Django task"
  type        = string
  default     = "256"
}

variable "django_memory" {
  description = "Memory for Django task"
  type        = string
  default     = "512"
}

variable "redis_endpoint" {
  description = "Redis endpoint address"
  type        = string
}

variable "rds_endpoint" {
  description = "RDS endpoint address"
  type        = string
}

variable "db_name" {
  description = "Database name"
  type        = string
}

variable "secrets_arn_prefix" {
  description = "ARN prefix for Secrets Manager secrets"
  type        = string
}

variable "aws_region" {
  description = "AWS region"
  type        = string
}

variable "service_discovery_namespace" {
  description = "Service Discovery namespace"
  type        = string
  default     = "local"
}
