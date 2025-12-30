output "gateway_repository_url" {
  description = "Gateway ECR repository URL"
  value       = aws_ecr_repository.gateway.repository_url
}

output "backend_repository_url" {
  description = "Backend ECR repository URL"
  value       = aws_ecr_repository.backend.repository_url
}

output "django_repository_url" {
  description = "ECR repository URL for Django"
  value       = aws_ecr_repository.django.repository_url
}

output "gateway_repository_arn" {
  description = "Gateway ECR repository ARN"
  value       = aws_ecr_repository.gateway.arn
}

output "backend_repository_arn" {
  description = "Backend ECR repository ARN"
  value       = aws_ecr_repository.backend.arn
}

output "django_repository_arn" {
  description = "Django ECR repository ARN"
  value       = aws_ecr_repository.django.arn
}
