#!/bin/bash

# Get AWS account ID and region
AWS_ACCOUNT_ID=$(aws sts get-caller-identity --query "Account" --output text)
AWS_REGION=$(aws configure get region)

# Change to the terraform directory and get the repository URLs
cd "$(dirname "$0")/../terraform"
FRONTEND_REPO_URL=$(terraform output -raw frontend_repository_url || echo "${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/django-nextjs-frontend")
BACKEND_REPO_URL=$(terraform output -raw backend_repository_url || echo "${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/django-nextjs-backend")

# ECR login
aws ecr get-login-password --region $AWS_REGION | docker login --username AWS --password-stdin ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com

# Return to the project root
cd ..

# Build and push frontend
echo "Building and pushing frontend image..."
cd menu-frontend
docker build -t django-nextjs-frontend .
docker tag django-nextjs-frontend:latest ${FRONTEND_REPO_URL}:latest
docker push ${FRONTEND_REPO_URL}:latest

# Build and push backend
echo "Building and pushing backend image..."
cd ..
docker build -t django-nextjs-backend .
docker tag django-nextjs-backend:latest ${BACKEND_REPO_URL}:latest
docker push ${BACKEND_REPO_URL}:latest

echo "Done! Images have been pushed to ECR."
