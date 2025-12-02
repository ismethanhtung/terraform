# --- environments/dev/main.tf ---

# Lấy AMI Amazon Linux 2 mới nhất cho Bastion Host
data "aws_ami" "amazon_linux_2" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

# 1. VPC Module
module "vpc" {
  source = "../../modules/vpc"

  environment          = var.environment
  vpc_cidr             = var.vpc_cidr
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
}

# 2. Security Group Module
module "security_group" {
  source = "../../modules/security-group"

  environment    = var.environment
  vpc_id         = module.vpc.vpc_id
  vpc_cidr_block = module.vpc.vpc_cidr_block
}

# 3. Bastion Host (EC2 Module)
module "bastion" {
  source = "../../modules/ec2"

  name                        = "${var.environment}-bastion-host"
  ami_id                      = data.aws_ami.amazon_linux_2.id
  instance_type               = "t3.micro"
  subnet_id                   = module.vpc.public_subnet_ids[0] # Đặt tại Public Subnet đầu tiên
  security_group_ids          = [module.security_group.bastion_sg_id]
  associate_public_ip_address = true
  
  tags = {
    Environment = var.environment
    Role        = "Bastion"
  }
}

# 4. RDS Module
module "rds" {
  source = "../../modules/rds"

  environment        = var.environment
  private_subnet_ids = module.vpc.private_subnet_ids
  db_sg_id           = module.security_group.db_sg_id
  db_name            = var.db_name
  db_username        = var.db_username
  db_password        = var.db_password
}

# 5. S3 Module
module "s3" {
  source = "../../modules/s3"

  environment = var.environment
}

# 6. ALB Module
module "alb" {
  source = "../../modules/alb"

  environment       = var.environment
  vpc_id            = module.vpc.vpc_id
  public_subnet_ids = module.vpc.public_subnet_ids
  alb_sg_id         = module.security_group.alb_sg_id
}

# 7. Auto Scaling Module
module "autoscaling" {
  source = "../../modules/autoscaling"

  environment          = var.environment
  instance_type        = var.instance_type
  app_sg_id            = module.security_group.app_sg_id
  private_subnet_ids   = module.vpc.private_subnet_ids
  target_group_arns    = [module.alb.target_group_arn]
  asg_min_size         = 1
  asg_max_size         = 2
  asg_desired_capacity = 1
}
