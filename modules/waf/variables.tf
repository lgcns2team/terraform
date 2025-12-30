variable "cloudfront_arn" {
  description = "CloudFront distribution ARN"
  type        = string
  default     = ""
}

variable "alb_arn" {
  description = "ALB ARN"
  type        = string
  default     = ""
}

variable "project_name" {
  description = "Project name"
  type        = string
}

variable "environment" {
  description = "Environment"
  type        = string
}
