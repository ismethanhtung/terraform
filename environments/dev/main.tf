module "vpc" {
  source = "../../modules/vpc"

  environment          = var.environment
  project_name         = var.project_name
  vpc_cidr             = var.vpc_cidr
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  enable_nat           = false
}

locals {
  common_tags = {
    Environment = var.environment
    Project     = var.project_name
  }
}

# IAM roles cho ECS Task
module "iam_ecs" {
  source      = "../../modules/iam"
  environment = var.environment
  tags        = local.common_tags
}

# CloudWatch Log Group cho ECS
module "cloudwatch_ecs" {
  source           = "../../modules/cloudwatch"
  log_group_name   = "/ecs/${var.project_name}-${var.environment}-backend"
  retention_in_days = 30
  tags             = local.common_tags
}

# ECS Cluster
module "ecs_cluster" {
  source            = "../../modules/ecs-cluster"
  name              = "${var.environment}-${var.project_name}-cluster"
  container_insights = true
  log_group_name    = module.cloudwatch_ecs.log_group_name
  tags              = local.common_tags
}

# Security Group cho ECS Tasks (public, tạm thời mở trực tiếp Internet)
resource "aws_security_group" "ecs_public_sg" {
  name        = "${var.environment}-ecs-public-sg"
  description = "ECS backend tasks public HTTP access"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description = "Allow HTTP from anywhere"
    from_port   = 8000
    to_port     = 8000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = local.common_tags
}

# ALB đơn giản phía trước ECS (cần endpoint ổn định cho API Gateway)
module "security_group" {
  source        = "../../modules/security-group"
  environment   = var.environment
  vpc_id        = module.vpc.vpc_id
  vpc_cidr_block = module.vpc.vpc_cidr_block
}

module "alb" {
  source           = "../../modules/alb"
  environment      = var.environment
  project_name     = var.project_name
  vpc_id           = module.vpc.vpc_id
  public_subnet_ids = module.vpc.public_subnet_ids
  alb_sg_id        = module.security_group.alb_sg_id
}

# ECS Service chạy image Python backend
module "ecs_backend_service" {
  source = "../../modules/ecs-service"

  environment   = var.environment
  service_name  = "backend"
  cluster_id    = module.ecs_cluster.cluster_id
  cluster_name  = module.ecs_cluster.cluster_name
  region        = var.aws_region

  execution_role_arn = module.iam_ecs.execution_role_arn
  task_role_arn      = module.iam_ecs.task_role_arn
  log_group_name     = module.cloudwatch_ecs.log_group_name

  subnet_ids         = module.vpc.public_subnet_ids
  security_group_ids = [aws_security_group.ecs_public_sg.id]
  assign_public_ip   = true

  container_image = "ismethanhtung/polymarket-server:latest"
  container_port  = 8000

  desired_count      = 1
  enable_autoscaling = false

  target_group_arn = module.alb.target_group_arn

  environment_variables = {
    SUPABASE_URL = var.supabase_url
    SUPABASE_KEY = var.supabase_key
  }

  tags = local.common_tags
}

# API Gateway HTTP API proxy tới ALB (và từ đó tới ECS backend)
resource "aws_apigatewayv2_api" "backend" {
  name          = "${var.environment}-${var.project_name}-backend-api"
  protocol_type = "HTTP"
}

resource "aws_apigatewayv2_integration" "backend_http" {
  api_id                 = aws_apigatewayv2_api.backend.id
  integration_type       = "HTTP_PROXY"
  integration_method     = "ANY"
  integration_uri        = "http://${module.alb.alb_dns_name}"
  payload_format_version = "1.0"
}

resource "aws_apigatewayv2_route" "backend_proxy" {
  api_id    = aws_apigatewayv2_api.backend.id
  route_key = "ANY /{proxy+}"

  target = "integrations/${aws_apigatewayv2_integration.backend_http.id}"
}

resource "aws_apigatewayv2_stage" "backend_default" {
  api_id      = aws_apigatewayv2_api.backend.id
  name        = "$default"
  auto_deploy = true
}
