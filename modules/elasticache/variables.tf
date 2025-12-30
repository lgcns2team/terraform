variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "private_subnet_ids" {
  description = "List of private subnet IDs"
  type        = list(string)
}

variable "security_group_ids" {
  description = "List of security group IDs"
  type        = list(string)
}

variable "project_name" {
  description = "Project name"
  type        = string
}

variable "environment" {
  description = "Environment"
  type        = string
}

variable "engine" {
  description = "Cache engine"
  type        = string
  default     = "redis"
}

variable "engine_version" {
  description = "Engine version"
  type        = string
  default     = "7.0"
}

variable "node_type" {
  description = "Node type"
  type        = string
  default     = "cache.t3.medium"
}

variable "num_cache_nodes" {
  description = "Number of cache nodes"
  type        = number
  default     = 2
}

variable "parameter_group_name" {
  description = "Parameter group name"
  type        = string
  default     = "default.redis7"
}

variable "port" {
  description = "Port"
  type        = number
  default     = 6379
}

variable "at_rest_encryption_enabled" {
  description = "Enable at-rest encryption"
  type        = bool
  default     = true
}

variable "transit_encryption_enabled" {
  description = "Enable transit encryption"
  type        = bool
  default     = true
}

variable "auth_token_enabled" {
  description = "Enable auth token"
  type        = bool
  default     = false
}

variable "automatic_failover_enabled" {
  description = "Enable automatic failover"
  type        = bool
  default     = true
}

variable "multi_az_enabled" {
  description = "Enable Multi-AZ"
  type        = bool
  default     = true
}

