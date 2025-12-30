#!/bin/bash

set -e

ENVIRONMENT=${1:-prod}
PROJECT_NAME="history-ai"
AWS_REGION="ap-northeast-2"
AWS_ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)

echo "🚀 Building and pushing Docker images for ${PROJECT_NAME}-${ENVIRONMENT}"
echo "AWS Account: ${AWS_ACCOUNT_ID}"
echo "Region: ${AWS_REGION}"
echo ""

# Setup buildx for multi-platform builds
echo "🔧 Setting up Docker Buildx..."
docker buildx create --name multiarch-builder --use 2>/dev/null || docker buildx use multiarch-builder
docker buildx inspect --bootstrap

# Login to ECR
echo "🔐 Logging in to ECR..."
aws ecr get-login-password --region ${AWS_REGION} | \
  docker login --username AWS --password-stdin ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com

# Build and push Gateway (AMD64)
echo ""
echo "📦 Building Gateway image for AMD64..."
cd ../gateway
docker buildx build \
  --platform linux/amd64 \
  -t ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/${PROJECT_NAME}-${ENVIRONMENT}-gateway:latest \
  --push \
  .

# Build and push Backend (AMD64)
echo ""
echo "📦 Building Backend image for AMD64..."
cd ../backend
docker buildx build \
  --platform linux/amd64 \
  -t ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/${PROJECT_NAME}-${ENVIRONMENT}-backend:latest \
  --push \
  .

# Build and push Django (AMD64)
echo ""
echo "📦 Building Django image for AMD64..."
cd ../django
docker buildx build \
  --platform linux/amd64 \
  -t ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/${PROJECT_NAME}-${ENVIRONMENT}-django:latest \
  --push \
  .

echo ""
echo "✅ All images pushed successfully!"
echo ""
echo "🔄 Updating ECS services..."

# Update ECS services
CLUSTER_NAME="${PROJECT_NAME}-${ENVIRONMENT}-cluster"

aws ecs update-service \
  --cluster ${CLUSTER_NAME} \
  --service ${PROJECT_NAME}-${ENVIRONMENT}-gateway \
  --force-new-deployment \
  --region ${AWS_REGION} \
  --no-cli-pager

aws ecs update-service \
  --cluster ${CLUSTER_NAME} \
  --service ${PROJECT_NAME}-${ENVIRONMENT}-backend \
  --force-new-deployment \
  --region ${AWS_REGION} \
  --no-cli-pager

aws ecs update-service \
  --cluster ${CLUSTER_NAME} \
  --service ${PROJECT_NAME}-${ENVIRONMENT}-django \
  --force-new-deployment \
  --region ${AWS_REGION} \
  --no-cli-pager

echo ""
echo "✅ ECS services updated!"# terraform
