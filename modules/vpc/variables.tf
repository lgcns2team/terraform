variable "project_name" {
  description = "Project name"
  type        = string
}

variable "environment" {
  description = "Environment (dev, staging, prod)"
  type        = string
}

variable "vpc_cidr" {
  description = "VPC CIDR block"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidr_a" {
  description = "CIDR block for public subnet A"
  type        = string
}

variable "public_subnet_cidr_c" {
  description = "CIDR block for public subnet C"
  type        = string
}

variable "private_subnet_cidr_a" {
  description = "CIDR block for private subnet A"
  type        = string
}

variable "private_subnet_cidr_c" {
  description = "CIDR block for private subnet C"
  type        = string
}

variable "availability_zone_a" {
  description = "First availability zone"
  type        = string
}

variable "availability_zone_c" {
  description = "Second availability zone"
  type        = string
}
