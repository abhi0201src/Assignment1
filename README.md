# Django + Next.js AWS Deployment

This project demonstrates a full CI/CD pipeline for deploying a Django backend and Next.js frontend to AWS ECS with Terraform infrastructure.

## Features

- 🚀 Automated CI/CD pipeline with GitHub Actions
- ☁️ Infrastructure as Code with Terraform
- 🐳 Dockerized applications
- 🔄 Zero-downtime deployments
- 🛡️ Secure AWS configuration

## Prerequisites

- AWS account with proper permissions
- Terraform installed (for local development)
- Docker installed
- GitHub repository with AWS secrets configured

## Infrastructure Components

- AWS ECS with Fargate
- Application Load Balancer
- ECR repositories for Docker images
- VPC with public and private subnets
- Security groups for network isolation

## How to Use

### Deploying the Application

1. Push to the `main` branch to trigger automatic deployment
2. Or manually trigger the workflow from GitHub Actions UI

### Destroying the Infrastructure

1. Go to GitHub Actions
2. Select the "Build and Deploy" workflow
3. Click "Run workflow"
4. Check the "Destroy all infrastructure?" option
5. Click "Run workflow"

⚠️ **Warning**: This will permanently delete all AWS resources!

### Environment Variables

Required GitHub Secrets:
- `AWS_ACCESS_KEY_ID`
- `AWS_SECRET_ACCESS_KEY`
- `ECS_EXECUTION_ROLE_ARN`

### Local Development

```bash
# Backend
cd backend
python -m venv venv
source venv/bin/activate
pip install -r requirements.txt
python manage.py runserver

# Frontend
cd frontend
npm install
npm run dev
