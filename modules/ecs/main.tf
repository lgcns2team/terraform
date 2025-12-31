# Data sources for Secrets Manager secrets
data "aws_secretsmanager_secret" "db_username" { name = "${var.project_name}/${var.environment}/db-username" }
data "aws_secretsmanager_secret" "db_password" { name = "${var.project_name}/${var.environment}/db-password" }
data "aws_secretsmanager_secret" "jwt_secret" { name = "${var.project_name}/${var.environment}/jwt-secret" }
data "aws_secretsmanager_secret" "aws_access_key" { name = "${var.project_name}/${var.environment}/aws-access-key" }
data "aws_secretsmanager_secret" "aws_secret_key" { name = "${var.project_name}/${var.environment}/aws-secret-key" }
data "aws_secretsmanager_secret" "bedrock_kb_id" { name = "${var.project_name}/${var.environment}/bedrock-kb-id" }
data "aws_secretsmanager_secret" "bedrock_kb_model_arn" { name = "${var.project_name}/${var.environment}/bedrock-kb-model-arn" }
data "aws_secretsmanager_secret" "bedrock_debate_prompt_arn" { name = "${var.project_name}/${var.environment}/bedrock-debate-prompt-arn" }
data "aws_secretsmanager_secret" "bedrock_ai_person_prompt_arn" { name = "${var.project_name}/${var.environment}/bedrock-ai-person-prompt-arn" }
data "aws_secretsmanager_secret" "bedrock_debate_summary_prompt_arn" { name = "${var.project_name}/${var.environment}/bedrock-debate-summary-prompt-arn" }

# ECS Cluster
resource "aws_ecs_cluster" "main" {
  name = "${var.project_name}-${var.environment}-cluster"

  setting {
    name  = "containerInsights"
    value = "enabled"
  }

  tags = {
    Name        = "${var.project_name}-${var.environment}-cluster"
    Project     = var.project_name
    Environment = var.environment
  }
}

# CloudWatch Log Groups
resource "aws_cloudwatch_log_group" "gateway" {
  name              = "/ecs/${var.project_name}-${var.environment}-gateway"
  retention_in_days = 7

  tags = {
    Name        = "${var.project_name}-${var.environment}-gateway-logs"
    Project     = var.project_name
    Environment = var.environment
  }
}

resource "aws_cloudwatch_log_group" "backend" {
  name              = "/ecs/${var.project_name}-${var.environment}-backend"
  retention_in_days = 7

  tags = {
    Name        = "${var.project_name}-${var.environment}-backend-logs"
    Project     = var.project_name
    Environment = var.environment
  }
}

resource "aws_cloudwatch_log_group" "django" {
  name              = "/ecs/${var.project_name}-${var.environment}-django"
  retention_in_days = 7

  tags = {
    Name        = "${var.project_name}-${var.environment}-django-logs"
    Project     = var.project_name
    Environment = var.environment
  }
}

# Gateway Task Definition
resource "aws_ecs_task_definition" "gateway" {
  family                   = "${var.project_name}-${var.environment}-gateway"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.gateway_cpu
  memory                   = var.gateway_memory
  execution_role_arn       = var.task_execution_role_arn
  task_role_arn            = var.task_role_arn

  container_definitions = jsonencode([{
    name  = "gateway"
    image = "${var.gateway_image}:${var.gateway_image_tag}"

    portMappings = [{
      containerPort = 8080
      protocol      = "tcp"
    }]

    environment = [
      # Backend 연결 (Service Discovery DNS)
      { name = "BACKEND_HOST", value = "backend.${var.service_discovery_namespace}" }, # ← SPRINGBOOT_HOST → BACKEND_HOST
      { name = "BACKEND_PORT", value = "8080" },                                       # ← SPRINGBOOT_PORT → BACKEND_PORT

      # Django 연결 (Service Discovery DNS)
      { name = "DJANGO_HOST", value = "django.${var.service_discovery_namespace}" },
      { name = "DJANGO_PORT", value = "8000" },

      # Redis 연결
      { name = "REDIS_HOST", value = var.redis_endpoint },
      { name = "REDIS_PORT", value = "6379" }
    ]

    secrets = [
      {
        name      = "JWT_SECRET_KEY",
        valueFrom = data.aws_secretsmanager_secret.jwt_secret.arn
      }
    ]

    logConfiguration = {
      logDriver = "awslogs"
      options = {
        "awslogs-group"         = aws_cloudwatch_log_group.gateway.name
        "awslogs-region"        = var.aws_region
        "awslogs-stream-prefix" = "ecs"
      }
    }

  }])

  tags = {
    Name        = "${var.project_name}-${var.environment}-gateway-task"
    Project     = var.project_name
    Environment = var.environment
  }
}

# Backend Task Definition
resource "aws_ecs_task_definition" "backend" {
  family                   = "${var.project_name}-${var.environment}-backend"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.backend_cpu
  memory                   = var.backend_memory
  execution_role_arn       = var.task_execution_role_arn
  task_role_arn            = var.task_role_arn

  container_definitions = jsonencode([{
    name  = "backend"
    image = "${var.backend_image}:${var.backend_image_tag}"

    portMappings = [{
      containerPort = 8080
      protocol      = "tcp"
    }]

    environment = [
      { name = "SERVER_PORT", value = "8080" },
      { name = "SPRING_DATASOURCE_URL", value = "jdbc:postgresql://${var.rds_endpoint}:5432/${var.db_name}" },
      { name = "CLOUD_AWS_REGION", value = var.aws_region },
      { name = "REDIS_HOST", value = var.redis_endpoint },
      { name = "REDIS_PORT", value = "6379" },
      { name = "SPRING_DATA_REDIS_SSL_ENABLED", value = "true" }
    ]

    secrets = [
      { name = "SPRING_DATASOURCE_USERNAME", valueFrom = data.aws_secretsmanager_secret.db_username.arn },
      { name = "SPRING_DATASOURCE_PASSWORD", valueFrom = data.aws_secretsmanager_secret.db_password.arn },
      { name = "JWT_SECRET_KEY", valueFrom = data.aws_secretsmanager_secret.jwt_secret.arn },
      { name = "AWS_ACCESS_KEY_ID", valueFrom = data.aws_secretsmanager_secret.aws_access_key.arn },
      { name = "AWS_SECRET_ACCESS_KEY", valueFrom = data.aws_secretsmanager_secret.aws_secret_key.arn },
      { name = "AWS_BEDROCK_KB_ID", valueFrom = data.aws_secretsmanager_secret.bedrock_kb_id.arn },
      { name = "AWS_BEDROCK_KB_MODEL_ARN", valueFrom = data.aws_secretsmanager_secret.bedrock_kb_model_arn.arn },
      { name = "AWS_BEDROCK_DEBATE_TOPICS_PROMPT_ARN", valueFrom = data.aws_secretsmanager_secret.bedrock_debate_prompt_arn.arn },
      { name = "AWS_BEDROCK_AI_PERSON_PROMPT_ARN", valueFrom = data.aws_secretsmanager_secret.bedrock_ai_person_prompt_arn.arn },
      { name = "AWS_BEDROCK_DEBATE_SUMMARY_PROMPT_ARN", valueFrom = data.aws_secretsmanager_secret.bedrock_debate_summary_prompt_arn.arn }
    ]

    logConfiguration = {
      logDriver = "awslogs"
      options = {
        "awslogs-group"         = aws_cloudwatch_log_group.backend.name
        "awslogs-region"        = var.aws_region
        "awslogs-stream-prefix" = "ecs"
      }
    }

  }])

  tags = {
    Name        = "${var.project_name}-${var.environment}-backend-task"
    Project     = var.project_name
    Environment = var.environment
  }
}

# Django Task Definition
resource "aws_ecs_task_definition" "django" {
  family                   = "${var.project_name}-${var.environment}-django"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.django_cpu
  memory                   = var.django_memory
  execution_role_arn       = var.task_execution_role_arn
  task_role_arn            = var.task_role_arn

  container_definitions = jsonencode([{
    name  = "django"
    image = "${var.django_image}:${var.django_image_tag}"

    portMappings = [{
      containerPort = 8000
      protocol      = "tcp"
    }]

    environment = [
      { name = "AWS_DEFAULT_REGION", value = var.aws_region },

      { name = "REDIS_HOST", value = var.redis_endpoint },
      { name = "REDIS_PORT", value = "6379" },

      { name = "DB_HOST", value = split(":", var.rds_endpoint)[0] },
      { name = "DB_PORT", value = "5432" },
      { name = "DB_NAME", value = var.db_name },
    ]

    secrets = [
      # AWS Credentials
      { name = "AWS_ACCESS_KEY_ID", valueFrom = data.aws_secretsmanager_secret.aws_access_key.arn },
      { name = "AWS_SECRET_ACCESS_KEY", valueFrom = data.aws_secretsmanager_secret.aws_secret_key.arn },

      # Database Credentials 추가
      { name = "DB_USER", valueFrom = data.aws_secretsmanager_secret.db_username.arn },
      { name = "DB_PASSWORD", valueFrom = data.aws_secretsmanager_secret.db_password.arn },

      # Bedrock Secrets 추가
      { name = "AWS_BEDROCK_KB_ID", valueFrom = data.aws_secretsmanager_secret.bedrock_kb_id.arn },
      { name = "AWS_BEDROCK_KB_MODEL_ARN", valueFrom = data.aws_secretsmanager_secret.bedrock_kb_model_arn.arn },
      { name = "AWS_BEDROCK_DEBATE_TOPICS_PROMPT_ARN", valueFrom = data.aws_secretsmanager_secret.bedrock_debate_prompt_arn.arn },
      { name = "AWS_BEDROCK_AI_PERSON", valueFrom = data.aws_secretsmanager_secret.bedrock_ai_person_prompt_arn.arn },
      { name = "AWS_BEDROCK_DEBATE_SUMMARY_PROMPT_ARN", valueFrom = data.aws_secretsmanager_secret.bedrock_debate_summary_prompt_arn.arn }
    ]

    logConfiguration = {
      logDriver = "awslogs"
      options = {
        "awslogs-group"         = aws_cloudwatch_log_group.django.name
        "awslogs-region"        = var.aws_region
        "awslogs-stream-prefix" = "ecs"
      }
    }


  }])

  tags = {
    Name        = "${var.project_name}-${var.environment}-django-task"
    Project     = var.project_name
    Environment = var.environment
  }
}

# Service Discovery Namespace
resource "aws_service_discovery_private_dns_namespace" "main" {
  name = var.service_discovery_namespace
  vpc  = var.vpc_id

  tags = {
    Name        = "${var.project_name}-${var.environment}-service-discovery"
    Project     = var.project_name
    Environment = var.environment
  }
}

# Service Discovery Service for Backend
resource "aws_service_discovery_service" "backend" {
  name = "backend"

  dns_config {
    namespace_id = aws_service_discovery_private_dns_namespace.main.id

    dns_records {
      ttl  = 10
      type = "A"
    }
  }
}

# Service Discovery Service for Django
resource "aws_service_discovery_service" "django" {
  name = "django"

  dns_config {
    namespace_id = aws_service_discovery_private_dns_namespace.main.id

    dns_records {
      ttl  = 10
      type = "A"
    }
  }

}

# ECS Service for Gateway
resource "aws_ecs_service" "gateway" {
  name            = "${var.project_name}-${var.environment}-gateway"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.gateway.arn
  desired_count   = 1
  launch_type     = "FARGATE"



  network_configuration {
    subnets          = [var.private_subnet_id]
    security_groups  = [var.gateway_sg_id]
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = var.alb_target_group_arn
    container_name   = "gateway"
    container_port   = 8080
  }

  depends_on = [var.alb_listener_arn]

  tags = {
    Name        = "${var.project_name}-${var.environment}-gateway-service"
    Project     = var.project_name
    Environment = var.environment
  }
}

# ECS Service for Backend
resource "aws_ecs_service" "backend" {
  name            = "${var.project_name}-${var.environment}-backend"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.backend.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  enable_execute_command = true

  network_configuration {
    subnets          = [var.private_subnet_id]
    security_groups  = [var.backend_sg_id]
    assign_public_ip = false
  }

  service_registries {
    registry_arn = aws_service_discovery_service.backend.arn
  }

  tags = {
    Name        = "${var.project_name}-${var.environment}-backend-service"
    Project     = var.project_name
    Environment = var.environment
  }
}

# ECS Service for Django
resource "aws_ecs_service" "django" {
  name            = "${var.project_name}-${var.environment}-django"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.django.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = [var.private_subnet_id]
    security_groups  = [var.django_sg_id]
    assign_public_ip = false
  }

  service_registries {
    registry_arn = aws_service_discovery_service.django.arn
  }

  tags = {
    Name        = "${var.project_name}-${var.environment}-django-service"
    Project     = var.project_name
    Environment = var.environment
  }
}
