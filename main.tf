terraform {
  required_version = ">= 1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  # Backend configuration for state management (optional but recommended)
  # Uncomment and configure for production use
  # backend "s3" {
  #   bucket         = "your-terraform-state-bucket"
  #   key            = "history-ai/terraform.tfstate"
  #   region         = "ap-northeast-2"
  #   encrypt        = true
  #   dynamodb_table = "terraform-state-lock"
  # }
}

provider "aws" {
  region = var.aws_region
}

# ACM certificate for CloudFront must be in us-east-1
provider "aws" {
  alias  = "us_east_1"
  region = "us-east-1"
}

# Data source for current AWS account
data "aws_caller_identity" "current" {}

# VPC Module (Multi-AZ)
module "vpc" {
  source = "./modules/vpc"

  vpc_cidr              = var.vpc_cidr
  availability_zone_a   = var.availability_zone_a
  availability_zone_c   = var.availability_zone_c
  public_subnet_cidr_a  = var.public_subnet_cidr_a
  public_subnet_cidr_c  = var.public_subnet_cidr_c
  private_subnet_cidr_a = var.private_subnet_cidr_a
  private_subnet_cidr_c = var.private_subnet_cidr_c
  project_name          = var.project_name
  environment           = var.environment
}

# VPC Endpoints Module
module "vpc_endpoints" {
  source = "./modules/vpc_endpoints"

  vpc_id                 = module.vpc.vpc_id
  vpc_cidr               = var.vpc_cidr
  private_subnet_id      = module.vpc.private_subnet_id
  private_route_table_id = module.vpc.private_route_table_id
  aws_region             = var.aws_region
  project_name           = var.project_name
  environment            = var.environment
}

# Security Groups Module
module "security_groups" {
  source = "./modules/security"

  vpc_id       = module.vpc.vpc_id
  project_name = var.project_name
  environment  = var.environment
}

# ECR Module
module "ecr" {
  source = "./modules/ecr"

  project_name = var.project_name
  environment  = var.environment
}

# IAM Module
module "iam" {
  source = "./modules/iam"

  project_name       = var.project_name
  environment        = var.environment
  secrets_arn_prefix = "arn:aws:secretsmanager:${var.aws_region}:${data.aws_caller_identity.current.account_id}:secret:${var.project_name}/${var.environment}"
}

# ALB Module
module "alb" {
  source = "./modules/alb"

  vpc_id                     = module.vpc.vpc_id
  public_subnet_ids          = module.vpc.public_subnet_ids
  security_group_ids         = [module.security_groups.alb_sg_id]
  project_name               = var.project_name
  environment                = var.environment
  enable_deletion_protection = false
  certificate_arn            = var.acm_certificate_arn
}

# RDS PostgreSQL Module
module "rds_postgresql" {
  source = "./modules/rds"

  vpc_id                          = module.vpc.vpc_id
  private_subnet_ids              = module.vpc.private_subnet_ids
  security_group_ids              = [module.security_groups.rds_sg_id]
  engine                          = "postgres"
  engine_version                  = var.postgres_version
  instance_class                  = var.rds_instance_class
  allocated_storage               = var.rds_allocated_storage
  db_name                         = var.postgres_db_name
  master_username                 = var.postgres_master_username
  master_password                 = var.postgres_master_password
  multi_az                        = false # Single-AZ for DB instance, but in private subnets
  project_name                    = var.project_name
  environment                     = var.environment
  identifier_suffix               = "postgresql"
  enabled_cloudwatch_logs_exports = ["postgresql"]
}

# ElastiCache Redis Module
module "redis" {
  source = "./modules/elasticache"

  vpc_id               = module.vpc.vpc_id
  private_subnet_ids   = module.vpc.private_subnet_ids
  security_group_ids   = [module.security_groups.redis_sg_id]
  engine               = "redis"
  node_type            = var.redis_node_type
  num_cache_nodes      = 1                # Single-AZ for Redis node, but in private subnets
  parameter_group_name = "default.redis7" # 추가 권장
  port                 = 6379             # 추가 권장
  engine_version       = "7.0"
  project_name         = var.project_name
  environment          = var.environment
}

# ECS Module
module "ecs" {
  source = "./modules/ecs"

  project_name            = var.project_name
  environment             = var.environment
  vpc_id                  = module.vpc.vpc_id
  private_subnet_id       = module.vpc.private_subnet_id
  gateway_sg_id           = module.security_groups.gateway_sg_id
  backend_sg_id           = module.security_groups.backend_sg_id
  django_sg_id            = module.security_groups.django_sg_id
  alb_target_group_arn    = module.alb.target_group_arn
  alb_listener_arn        = module.alb.listener_arn
  task_execution_role_arn = module.iam.ecs_task_execution_role_arn
  task_role_arn           = module.iam.ecs_task_role_arn

  # Docker Images (update these after pushing to ECR)
  gateway_image     = module.ecr.gateway_repository_url
  gateway_image_tag = var.gateway_image_tag
  backend_image     = module.ecr.backend_repository_url
  backend_image_tag = var.backend_image_tag
  django_image      = module.ecr.django_repository_url
  django_image_tag  = var.django_image_tag

  # Resource allocation
  gateway_cpu    = var.gateway_cpu
  gateway_memory = var.gateway_memory
  backend_cpu    = var.backend_cpu
  backend_memory = var.backend_memory
  django_cpu     = var.django_cpu
  django_memory  = var.django_memory

  # Dependencies
  redis_endpoint              = module.redis.primary_endpoint_address
  rds_endpoint                = module.rds_postgresql.endpoint_address
  db_name                     = var.postgres_db_name
  secrets_arn_prefix          = "arn:aws:secretsmanager:${var.aws_region}:${data.aws_caller_identity.current.account_id}:secret:${var.project_name}/${var.environment}"
  aws_region                  = var.aws_region
  service_discovery_namespace = "${var.project_name}-${var.environment}.local"
}

# S3 for Frontend
module "s3_frontend" {
  source = "./modules/s3"

  bucket_name  = "${var.project_name}-${var.environment}-s3-frontend"
  project_name = var.project_name
  environment  = var.environment
}

# ACM Certificate (Global for CloudFront)
module "acm" {
  source = "./modules/acm"

  providers = {
    aws = aws.us_east_1
  }

  domain_name  = var.domain_name
  project_name = var.project_name
  environment  = var.environment
}

# CloudFront Distribution
module "cloudfront" {
  source = "./modules/cloudfront"

  s3_bucket_regional_domain_name = module.s3_frontend.bucket_regional_domain_name
  s3_bucket_id                   = module.s3_frontend.bucket_id
  alb_dns_name                   = module.alb.dns_name
  project_name                   = var.project_name
  environment                    = var.environment
  acm_certificate_arn            = var.acm_certificate_arn != "" ? var.acm_certificate_arn : module.acm.certificate_arn
  domain_name                    = var.domain_name
}

# DNS Records (Route53)
module "route53" {
  source = "./modules/route53"

  domain_name               = var.domain_name
  cloudfront_domain_name    = module.cloudfront.domain_name
  cloudfront_hosted_zone_id = module.cloudfront.hosted_zone_id
  alb_dns_name              = module.alb.dns_name
  alb_zone_id               = module.alb.zone_id
  project_name              = var.project_name
  environment               = var.environment
  domain_validation_options = module.acm.domain_validation_options
}
