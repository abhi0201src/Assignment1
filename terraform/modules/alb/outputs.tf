output "alb_security_group_id" {
  value = aws_security_group.alb.id
}

output "frontend_target_group_arn" {
  value = aws_lb_target_group.frontend.arn
}

output "backend_target_group_arn" {
  value = aws_lb_target_group.backend.arn
}

output "alb_dns_name" {
  value = aws_lb.main.dns_name
}
