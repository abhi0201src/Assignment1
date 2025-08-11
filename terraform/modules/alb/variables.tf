variable "project_name" {
  description = "Name of the project"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "public_subnet_ids" {
  description = "List of public subnet IDs"
  type        = list(string)
}

variable "ecs_cluster_name" {
  description = "Name of the ECS cluster"
  type        = string
  default     = null
}

variable "ecs_service_name" {
  description = "Name of the ECS service"
  type        = string
  default     = null
}
