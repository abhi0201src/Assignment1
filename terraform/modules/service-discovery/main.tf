resource "aws_service_discovery_private_dns_namespace" "main" {
  name        = "django-nextjs.local"
  description = "Private DNS namespace for service discovery"
  vpc         = var.vpc_id
}

resource "aws_service_discovery_service" "backend" {
  name = "backend"

  dns_config {
    namespace_id = aws_service_discovery_private_dns_namespace.main.id

    dns_records {
      ttl  = 10
      type = "A"
    }

    routing_policy = "MULTIVALUE"
  }

  health_check_custom_config {
    failure_threshold = 1
  }
}
