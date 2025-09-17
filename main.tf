module "networking" {
  source = "./modules/Networking"
  vpc_cider = var.vpc_cider
  subnets_cirder = var.subnets_cirder
  availability_zone = var.availability_zone
}

module "computing" {
  source             = "./modules/computing"
  web_security_group = module.networking.web_security_group
  private_subnets_list = module.networking.private_subnets_list
  public_subnets_list  = module.networking.public_subnets_list
  vpc_id             = module.networking.vpc_id
  
  # Auto-scaling configuration
  instance_type     = var.instance_type
  key_pair_name     = var.key_pair_name
  min_size          = var.min_size
  max_size          = var.max_size
  desired_capacity  = var.desired_capacity
}
