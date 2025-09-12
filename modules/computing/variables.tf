variable "availability_zone" {
  description = "The availability zone for the resources"
  type = list(string)
  default = []
}

variable "web_security_group" {
  description = "The security group for the web instances"
  type = string
  
}

variable "public_subnets_list" {
  description = "The list of public subnets"
  type = list(string)
  default = []
}