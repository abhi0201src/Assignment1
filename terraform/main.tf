provider "aws" {
  region = var.aws_region
}

module "ecr" {
  source = "./modules/ecr"

  project_name = var.project_name
  environment  = var.environment
}

module "networking" {
  source = "./modules/networking"

  project_name       = var.project_name
  vpc_cidr          = var.vpc_cidr
  public_subnets    = var.public_subnets
  private_subnets   = var.private_subnets
  availability_zones = var.availability_zones
}

module "alb" {
  source = "./modules/alb"

  project_name      = var.project_name
  vpc_id           = module.networking.vpc_id
  public_subnet_ids = module.networking.public_subnet_ids
}

module "ecs" {
  source = "./modules/ecs"

  project_name             = var.project_name
  aws_region              = var.aws_region
  vpc_id                  = module.networking.vpc_id
  private_subnet_ids      = module.networking.private_subnet_ids
  alb_security_group_id   = module.alb.alb_security_group_id
  frontend_target_group_arn = module.alb.frontend_target_group_arn
  backend_target_group_arn  = module.alb.backend_target_group_arn
  frontend_image          = module.ecr.frontend_repository_url
  backend_image           = module.ecr.backend_repository_url
  alb_dns_name           = module.alb.alb_dns_name
}
