output "load_balancer_dns" {
  description = "DNS name of the load balancer"
  value       = aws_lb.web_app_alb.dns_name
}

output "load_balancer_zone_id" {
  description = "Zone ID of the load balancer"
  value       = aws_lb.web_app_alb.zone_id
}

output "autoscaling_group_name" {
  description = "Name of the autoscaling group"
  value       = aws_autoscaling_group.web_app_asg.name
}

output "target_group_arn" {
  description = "ARN of the target group"
  value       = aws_lb_target_group.web_app_tg.arn
}

output "launch_template_id" {
  description = "ID of the launch template"
  value       = aws_launch_template.web_app_template.id
}