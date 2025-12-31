# VPC Outputs
output "vpc_id" {
  description = "VPC ID"
  value       = module.vpc.vpc_id
}

output "public_subnet_id" {
  description = "Public Subnet ID"
  value       = module.vpc.public_subnet_id
}

output "private_subnet_id" {
  description = "Private Subnet ID"
  value       = module.vpc.private_subnet_id
}

# ECR Outputs
output "ecr_gateway_repository_url" {
  description = "ECR Gateway Repository URL"
  value       = module.ecr.gateway_repository_url
}

output "ecr_backend_repository_url" {
  description = "ECR Backend Repository URL"
  value       = module.ecr.backend_repository_url
}

output "ecr_django_repository_url" {
  description = "ECR Django Repository URL"
  value       = module.ecr.django_repository_url
}

# ALB Outputs
output "alb_dns_name" {
  description = "ALB DNS name"
  value       = module.alb.dns_name
}

output "alb_url" {
  description = "ALB URL"
  value       = "http://${module.alb.dns_name}"
}

# RDS Outputs
output "rds_endpoint" {
  description = "RDS endpoint"
  value       = module.rds_postgresql.endpoint
  sensitive   = true
}

output "rds_endpoint_address" {
  description = "RDS endpoint address"
  value       = module.rds_postgresql.endpoint_address
  sensitive   = true
}

# Redis Outputs
output "redis_endpoint" {
  description = "Redis primary endpoint"
  value       = module.redis.primary_endpoint_address
  sensitive   = true
}

# ECS Outputs
output "ecs_cluster_name" {
  description = "ECS Cluster name"
  value       = module.ecs.cluster_name
}

output "ecs_gateway_service_name" {
  description = "ECS Gateway Service name"
  value       = module.ecs.gateway_service_name
}

output "ecs_backend_service_name" {
  description = "ECS Backend Service name"
  value       = module.ecs.backend_service_name
}

output "ecs_django_service_name" {
  description = "ECS Django Service name"
  value       = module.ecs.django_service_name
}

# S3 Outputs
output "s3_frontend_bucket_name" {
  description = "S3 Frontend bucket name"
  value       = module.s3_frontend.bucket_id
}

# CloudFront Outputs
output "cloudfront_distribution_id" {
  description = "CloudFront Distribution ID"
  value       = module.cloudfront.distribution_id
}

output "cloudfront_domain_name" {
  description = "CloudFront distribution domain name"
  value       = module.cloudfront.domain_name
}

output "application_url" {
  description = "Application custom domain URL"
  value       = "https://${var.domain_name}"
}

output "acm_certificate_arn" {
  description = "ACM certificate ARN"
  value       = module.acm.certificate_arn
}

output "cloudfront_url" {
  description = "CloudFront URL (Frontend + API endpoint)"
  value       = "https://${module.cloudfront.domain_name}"
}

# Summary Output
output "deployment_summary" {
  description = "Deployment summary"
  value       = <<-EOT
  
  ===========================================
  🚀 Deployment Complete!
  ===========================================
  
  📦 Frontend URL:
     https://${module.cloudfront.domain_name}
  
  🔌 API Endpoint (via CloudFront):
     https://${module.cloudfront.domain_name}/api
  
  🌐 ALB Direct URL:
     http://${module.alb.dns_name}
  
  📝 Next Steps:
     1. Push Docker images to ECR:
        - Gateway: ${module.ecr.gateway_repository_url}
        - Backend: ${module.ecr.backend_repository_url}
        - Django: ${module.ecr.django_repository_url}
     
     2. Update ECS services to use new images:
        aws ecs update-service --cluster ${module.ecs.cluster_name} --service ${module.ecs.gateway_service_name} --force-new-deployment
     
     3. Deploy frontend to S3:
        aws s3 sync ./frontend/dist s3://${module.s3_frontend.bucket_id}
     
     4. Invalidate CloudFront cache:
        aws cloudfront create-invalidation --distribution-id ${module.cloudfront.distribution_id} --paths "/*"
  
  ===========================================
  EOT
}
