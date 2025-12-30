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

variable "target_group_arn" {
  description = "Target group ARN"
  type        = string
}

variable "project_name" {
  description = "Project name"
  type        = string
}

variable "environment" {
  description = "Environment"
  type        = string
}

variable "ami_id" {
  description = "AMI ID for instances"
  type        = string
  default     = ""
}

variable "instance_type" {
  description = "Instance type"
  type        = string
  default     = "t3.medium"
}

variable "min_size" {
  description = "Minimum size"
  type        = number
  default     = 2
}

variable "max_size" {
  description = "Maximum size"
  type        = number
  default     = 10
}

variable "desired_capacity" {
  description = "Desired capacity"
  type        = number
  default     = 2
}

variable "user_data" {
  description = "User data script"
  type        = string
  default     = ""
}
