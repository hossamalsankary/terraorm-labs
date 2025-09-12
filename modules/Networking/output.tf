output "vpc_id" {
  value = aws_vpc.route_project.id
}



output "Private_subnets_list" {
  value = [ aws_subnet.private_subnet[0].id , aws_subnet.private_subnet[1].id ]
}

output "public_subnets_list" {
  value = [ aws_subnet.public_subnet[0].id , aws_subnet.public_subnet[1].id ]
}

output "web_security_group" {
  value = aws_security_group.security_group.id
}
