# --- environments/dev/main.tf ---

# Cấu hình Provider AWS
provider "aws" {
  region = var.aws_region
}

# 1. Networking Module
module "networking" {
  source = "../../modules/networking"

  environment          = var.environment
  vpc_cidr             = var.vpc_cidr
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
}

# 2. Security Module
module "security" {
  source = "../../modules/security"

  environment    = var.environment
  vpc_id         = module.networking.vpc_id
  vpc_cidr_block = module.networking.vpc_cidr_block
}

# 3. Database Module
module "database" {
  source = "../../modules/database"

  environment        = var.environment
  private_subnet_ids = module.networking.private_subnet_ids
  db_sg_id           = module.security.db_sg_id
  db_name            = var.db_name
  db_username        = var.db_username
  db_password        = var.db_password
}

# 4. Storage Module
module "storage" {
  source = "../../modules/storage"

  environment = var.environment
}

# 5. Compute Module
module "compute" {
  source = "../../modules/compute"

  environment          = var.environment
  vpc_id               = module.networking.vpc_id
  public_subnet_ids    = module.networking.public_subnet_ids
  private_subnet_ids   = module.networking.private_subnet_ids
  alb_sg_id            = module.security.alb_sg_id
  app_sg_id            = module.security.app_sg_id
  instance_type        = var.instance_type
  asg_min_size         = 1
  asg_max_size         = 2
  asg_desired_capacity = 1
}
