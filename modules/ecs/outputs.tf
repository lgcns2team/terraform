output "cluster_id" {
  description = "ECS Cluster ID"
  value       = aws_ecs_cluster.main.id
}

output "cluster_name" {
  description = "ECS Cluster name"
  value       = aws_ecs_cluster.main.name
}

output "gateway_service_name" {
  description = "Gateway ECS Service name"
  value       = aws_ecs_service.gateway.name
}

output "backend_service_name" {
  description = "Backend ECS Service name"
  value       = aws_ecs_service.backend.name
}

output "django_service_name" {
  description = "Django ECS Service name"
  value       = aws_ecs_service.django.name
}

output "service_discovery_namespace_id" {
  description = "Service Discovery Namespace ID"
  value       = aws_service_discovery_private_dns_namespace.main.id
}

output "service_discovery_namespace_name" {
  description = "Service Discovery Namespace name"
  value       = aws_service_discovery_private_dns_namespace.main.name
}
