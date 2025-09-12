output "vpc_id" {
  value = module.networking.vpc_id
}



output "Private_subnets_list" {
  value = module.networking.Private_subnets_list
}

output "public_subnets_list" {
  value = module.networking.public_subnets_list
}

output "web_security_group" {
  value = module.networking.web_security_group
}
