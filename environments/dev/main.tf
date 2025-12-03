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
  subnet_id                   = module.vpc.public_subnet_ids[0]
  security_group_ids          = [module.security_group.bastion_sg_id]
  associate_public_ip_address = true
  
  tags = {
    Environment = var.environment
    Role        = "Bastion"
  }
}

# 4. ALB Module
module "alb" {
  source = "../../modules/alb"

  environment       = var.environment
  vpc_id            = module.vpc.vpc_id
  public_subnet_ids = module.vpc.public_subnet_ids
  alb_sg_id         = module.security_group.alb_sg_id
}

# 5. Backend EC2 (Docker)
module "backend" {
  source = "../../modules/ec2"

  name               = "${var.environment}-backend"
  ami_id             = data.aws_ami.amazon_linux_2.id # Dùng Amazon Linux 2 để cài Docker
  instance_type      = var.instance_type
  subnet_id          = module.vpc.private_subnet_ids[0]
  security_group_ids = [module.security_group.app_sg_id]
  
  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              amazon-linux-extras install docker -y
              service docker start
              usermod -a -G docker ec2-user
              systemctl enable docker
              docker run -d -p 80:80 ismethanhtung/ngocminh-be:latest
              EOF

  tags = {
    Environment = var.environment
    Role        = "Backend"
  }
} 

# Attach Backend EC2 to ALB Target Group
resource "aws_lb_target_group_attachment" "backend" {
  target_group_arn = module.alb.target_group_arn
  target_id        = module.backend.instance_id
  port             = 80
}

# 6. DB EC2 (MSSQL)
module "db" {
  source = "../../modules/ec2"

  name               = "${var.environment}-db-mssql"
  ami_id             = "ami-0a2fc2446ff3412c3" # AMI cụ thể theo yêu cầu
  instance_type      = "t3.large" # MSSQL thường cần ít nhất t3.large/medium tùy workload
  subnet_id          = module.vpc.private_subnet_ids[1] # Để DB ở subnet khác backend cho phân tán (optional)
  security_group_ids = [module.security_group.db_sg_id]

  tags = {
    Environment = var.environment
    Role        = "Database"
  }
}

# EBS Volume cho DB (để lưu dữ liệu)
resource "aws_ebs_volume" "db_data" {
  availability_zone = module.db.availability_zone
  size              = 50
  type              = "gp3"
  
  tags = {
    Name = "${var.environment}-db-data"
  }
}

resource "aws_volume_attachment" "db_data_att" {
  device_name = "/dev/sdf"
  volume_id   = aws_ebs_volume.db_data.id
  instance_id = module.db.instance_id
}

# 7. API Gateway (HTTP API) kết nối tới ALB
resource "aws_apigatewayv2_api" "main" {
  name          = "${var.environment}-clinic-api"
  protocol_type = "HTTP"
}

resource "aws_apigatewayv2_vpc_link" "main" {
  name               = "${var.environment}-vpc-link"
  security_group_ids = [module.security_group.alb_sg_id] # Tái sử dụng SG hoặc tạo mới
  subnet_ids         = module.vpc.private_subnet_ids
}

resource "aws_apigatewayv2_integration" "alb" {
  api_id           = aws_apigatewayv2_api.main.id
  integration_type = "HTTP_PROXY"
  integration_uri  = module.alb.listener_arn
  
  integration_method = "ANY"
  connection_type    = "VPC_LINK"
  connection_id      = aws_apigatewayv2_vpc_link.main.id
  payload_format_version = "1.0"
}

resource "aws_apigatewayv2_route" "default" {
  api_id    = aws_apigatewayv2_api.main.id
  route_key = "$default"
  target    = "integrations/${aws_apigatewayv2_integration.alb.id}"
}

resource "aws_apigatewayv2_stage" "default" {
  api_id      = aws_apigatewayv2_api.main.id
  name        = "$default"
  auto_deploy = true
}

# 8. S3 Module (Giữ nguyên)
module "s3" {
  source = "../../modules/s3"

  environment = var.environment
}
 