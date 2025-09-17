output "vpc_id" {
  value = module.networking.vpc_id
}



output "public_subnets_list" {
  value = module.networking.public_subnets_list
}

output "web_security_group" {
  value = module.networking.web_security_group
}

output "load_balancer_dns" {
  description = "DNS name of the Application Load Balancer"
  value       = module.computing.load_balancer_dns
}

output "load_balancer_url" {
  description = "URL of the Application Load Balancer"
  value       = "http://${module.computing.load_balancer_dns}"
}

output "autoscaling_group_name" {
  description = "Name of the Auto Scaling Group"
  value       = module.computing.autoscaling_group_name
}
