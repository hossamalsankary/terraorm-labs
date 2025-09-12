module "networking" {
  source = "./modules/Networking"
  vpc_cider = var.vpc_cider
  subnets_cirder = var.subnets_cirder
  availability_zone = var.availability_zone
}

module "computing" {
  source             = "./modules/computing"
  web_security_group = module.networking.web_security_group
  public_subnets_list = module.networking.public_subnets_list
  
}
