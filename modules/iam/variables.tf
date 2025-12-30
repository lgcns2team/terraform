variable "project_name" {
  description = "Project name for resource naming"
  type        = string
}

variable "environment" {
  description = "Environment (dev, staging, prod)"
  type        = string
}

variable "secrets_arn_prefix" {
  description = "ARN prefix for Secrets Manager secrets"
  type        = string
}
