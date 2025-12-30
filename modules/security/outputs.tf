output "alb_sg_id" {
  description = "ALB security group ID"
  value       = aws_security_group.alb.id
}

output "gateway_sg_id" {
  description = "Gateway security group ID"
  value       = aws_security_group.gateway.id
}

output "backend_sg_id" {
  description = "Backend security group ID"
  value       = aws_security_group.backend.id
}

output "django_sg_id" {
  description = "Django security group ID"
  value       = aws_security_group.django.id
}

output "rds_sg_id" {
  description = "RDS security group ID"
  value       = aws_security_group.rds.id
}

output "redis_sg_id" {
  description = "Redis security group ID"
  value       = aws_security_group.redis.id
}
