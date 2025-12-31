# AWS Configuration
variable "aws_region" {
  description = "AWS region for resources"
  type        = string
  default     = "ap-northeast-2"
}

# Project Configuration
variable "project_name" {
  description = "Project name for resource naming"
  type        = string
  default     = "history-ai"
}

variable "environment" {
  description = "Environment (dev, staging, prod)"
  type        = string
  default     = "prod"
}

# Network Configuration (Multi-AZ)
variable "vpc_cidr" {
  description = "VPC CIDR block"
  type        = string
  default     = "10.0.0.0/16"
}

variable "availability_zone_a" {
  description = "First availability zone"
  type        = string
  default     = "ap-northeast-2a"
}

variable "availability_zone_c" {
  description = "Second availability zone"
  type        = string
  default     = "ap-northeast-2c"
}

variable "public_subnet_cidr_a" {
  description = "Public subnet CIDR block A"
  type        = string
  default     = "10.0.1.0/24"
}

variable "public_subnet_cidr_c" {
  description = "Public subnet CIDR block C"
  type        = string
  default     = "10.0.2.0/24"
}

variable "private_subnet_cidr_a" {
  description = "Private subnet CIDR block A"
  type        = string
  default     = "10.0.11.0/24"
}

variable "private_subnet_cidr_c" {
  description = "Private subnet CIDR block C"
  type        = string
  default     = "10.0.12.0/24"
}

# RDS Configuration
variable "postgres_version" {
  description = "PostgreSQL version"
  type        = string
  default     = "15.15"
}

variable "rds_instance_class" {
  description = "RDS instance class"
  type        = string
  default     = "db.t3.micro"
}

variable "rds_allocated_storage" {
  description = "RDS allocated storage in GB"
  type        = number
  default     = 20
}

variable "postgres_db_name" {
  description = "PostgreSQL database name"
  type        = string
  default     = "historyai"
}

variable "postgres_master_username" {
  description = "PostgreSQL master username"
  type        = string
  default     = "postgres"
  sensitive   = true
}

variable "postgres_master_password" {
  description = "PostgreSQL master password"
  type        = string
  sensitive   = true
}

# ElastiCache Configuration
variable "redis_node_type" {
  description = "ElastiCache Redis node type"
  type        = string
  default     = "cache.t3.micro"
}

variable "redis_engine_version" {
  description = "Redis engine version"
  type        = string
  default     = "7.0"
}

# ECS Configuration
variable "gateway_image_tag" {
  description = "Gateway Docker image tag"
  type        = string
  default     = "latest"
}

variable "backend_image_tag" {
  description = "Backend Docker image tag"
  type        = string
  default     = "latest"
}

variable "django_image_tag" {
  description = "Django Docker image tag"
  type        = string
  default     = "latest"
}

variable "gateway_cpu" {
  description = "Gateway CPU units (1024 = 1 vCPU)"
  type        = string
  default     = "512"
}

variable "gateway_memory" {
  description = "Gateway memory in MB"
  type        = string
  default     = "1024"
}

variable "backend_cpu" {
  description = "Backend CPU units"
  type        = string
  default     = "512"
}

variable "backend_memory" {
  description = "Backend memory in MB"
  type        = string
  default     = "1024"
}

variable "django_cpu" {
  description = "Django CPU units"
  type        = string
  default     = "256"
}

variable "django_memory" {
  description = "Django memory in MB"
  type        = string
  default     = "512"
}

# SSL Certificate (Optional)
variable "domain_name" {
  description = "Domain name for the application"
  type        = string
  default     = "khistoryai.com"
}

variable "acm_certificate_arn" {
  description = "ACM certificate ARN for HTTPS (leave empty for automatic creation)"
  type        = string
  default     = ""
}
