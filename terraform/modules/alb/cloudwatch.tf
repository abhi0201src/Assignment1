resource "aws_sns_topic" "alarms" {
  name = "${var.project_name}-alarms"
}

resource "aws_sns_topic_subscription" "alarm_email" {
  topic_arn = aws_sns_topic.alarms.arn
  protocol  = "email"
  endpoint  = "abhishek.sa.2001@gmail.com"
}

# ALB 5XX Errors Alarm
resource "aws_cloudwatch_metric_alarm" "alb_5xx" {
  alarm_name          = "${var.project_name}-alb-5xx-errors"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "2"
  metric_name        = "HTTPCode_Target_5XX_Count"
  namespace          = "AWS/ApplicationELB"
  period            = "300"
  statistic         = "Sum"
  threshold         = "10"
  alarm_description = "This metric monitors ALB 5XX errors"
  alarm_actions     = [aws_sns_topic.alarms.arn]
  ok_actions        = [aws_sns_topic.alarms.arn]

  dimensions = {
    LoadBalancer = aws_lb.main.arn_suffix
  }
}

# Target Response Time Alarm
resource "aws_cloudwatch_metric_alarm" "target_response_time" {
  alarm_name          = "${var.project_name}-target-response-time"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "2"
  metric_name        = "TargetResponseTime"
  namespace          = "AWS/ApplicationELB"
  period            = "300"
  statistic         = "Average"
  threshold         = "5"
  alarm_description = "This metric monitors target response time"
  alarm_actions     = [aws_sns_topic.alarms.arn]
  ok_actions        = [aws_sns_topic.alarms.arn]

  dimensions = {
    LoadBalancer = aws_lb.main.arn_suffix
  }
}

# Unhealthy Hosts Alarm
resource "aws_cloudwatch_metric_alarm" "unhealthy_hosts" {
  alarm_name          = "${var.project_name}-unhealthy-hosts"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "2"
  metric_name        = "UnHealthyHostCount"
  namespace          = "AWS/ApplicationELB"
  period            = "300"
  statistic         = "Maximum"
  threshold         = "0"
  alarm_description = "This metric monitors number of unhealthy hosts"
  alarm_actions     = [aws_sns_topic.alarms.arn]
  ok_actions        = [aws_sns_topic.alarms.arn]

  dimensions = {
    TargetGroup = aws_lb_target_group.backend.arn_suffix
    LoadBalancer = aws_lb.main.arn_suffix
  }
}

# CPU Utilization Alarm
resource "aws_cloudwatch_metric_alarm" "cpu_utilization" {
  count = var.ecs_cluster_name != null && var.ecs_service_name != null ? 1 : 0
  
  alarm_name          = "${var.project_name}-cpu-utilization"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "2"
  metric_name        = "CPUUtilization"
  namespace          = "AWS/ECS"
  period            = "300"
  statistic         = "Average"
  threshold         = "80"
  alarm_description = "This metric monitors ECS service CPU utilization"
  alarm_actions     = [aws_sns_topic.alarms.arn]
  ok_actions        = [aws_sns_topic.alarms.arn]

  dimensions = {
    ClusterName = var.ecs_cluster_name
    ServiceName = var.ecs_service_name
  }
}

# Memory Utilization Alarm
resource "aws_cloudwatch_metric_alarm" "memory_utilization" {
  count = var.ecs_cluster_name != null && var.ecs_service_name != null ? 1 : 0
  
  alarm_name          = "${var.project_name}-memory-utilization"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "2"
  metric_name        = "MemoryUtilization"
  namespace          = "AWS/ECS"
  period            = "300"
  statistic         = "Average"
  threshold         = "80"
  alarm_description = "This metric monitors ECS service memory utilization"
  alarm_actions     = [aws_sns_topic.alarms.arn]
  ok_actions        = [aws_sns_topic.alarms.arn]

  dimensions = {
    ClusterName = var.ecs_cluster_name
    ServiceName = var.ecs_service_name
  }
}

# ALB Request Count Alarm (for sudden traffic drops)
resource "aws_cloudwatch_metric_alarm" "request_count" {
  alarm_name          = "${var.project_name}-request-count-drop"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = "2"
  metric_name        = "RequestCount"
  namespace          = "AWS/ApplicationELB"
  period            = "300"
  statistic         = "Sum"
  threshold         = "10"
  alarm_description = "This metric monitors for sudden drops in traffic"
  alarm_actions     = [aws_sns_topic.alarms.arn]
  ok_actions        = [aws_sns_topic.alarms.arn]

  dimensions = {
    LoadBalancer = aws_lb.main.arn_suffix
  }
}
