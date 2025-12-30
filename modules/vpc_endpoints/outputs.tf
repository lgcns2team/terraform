output "vpc_endpoints_sg_id" {
  description = "Security group ID for VPC Endpoints"
  value       = aws_security_group.vpc_endpoints.id
}

output "ecr_api_endpoint_id" {
  description = "ECR API VPC Endpoint ID"
  value       = aws_vpc_endpoint.ecr_api.id
}

output "ecr_dkr_endpoint_id" {
  description = "ECR DKR VPC Endpoint ID"
  value       = aws_vpc_endpoint.ecr_dkr.id
}

output "s3_endpoint_id" {
  description = "S3 VPC Endpoint ID"
  value       = aws_vpc_endpoint.s3.id
}

output "logs_endpoint_id" {
  description = "CloudWatch Logs VPC Endpoint ID"
  value       = aws_vpc_endpoint.logs.id
}

output "secrets_manager_endpoint_id" {
  description = "Secrets Manager VPC Endpoint ID"
  value       = aws_vpc_endpoint.secrets_manager.id
}

output "bedrock_runtime_endpoint_id" {
  description = "Bedrock Runtime VPC Endpoint ID"
  value       = aws_vpc_endpoint.bedrock_runtime.id
}
