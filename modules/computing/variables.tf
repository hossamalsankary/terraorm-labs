variable "web_security_group" {
  description = "Security group ID for web traffic"
  type        = string
}

variable "private_subnets_list" {
  description = "List of private subnet IDs"
  type        = list(string)
}

variable "public_subnets_list" {
  description = "List of public subnet IDs"
  type        = list(string)
}


variable "vpc_id" {
  description = "VPC ID where resources will be created"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}

variable "key_pair_name" {
  description = "Name of the key pair for SSH access"
  type        = string
  default     = null
}

variable "min_size" {
  description = "Minimum number of instances in the autoscaling group"
  type        = number
  default     = 1
}

variable "max_size" {
  description = "Maximum number of instances in the autoscaling group"
  type        = number
  default     = 5
}

variable "desired_capacity" {
  description = "Desired number of instances in the autoscaling group"
  type        = number
  default     = 2
}