# --- modules/compute/main.tf ---

# 1. Lấy AMI mới nhất của Amazon Linux 2
data "aws_ami" "amazon_linux_2" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

# 2. Application Load Balancer (ALB)
# Phân phối tải từ Internet vào các EC2 instances.
resource "aws_lb" "main" {
  name               = "${var.environment}-clinic-alb"
  internal           = false # Internet-facing
  load_balancer_type = "application"
  security_groups    = [var.alb_sg_id]
  subnets            = var.public_subnet_ids

  tags = {
    Name        = "${var.environment}-clinic-alb"
    Environment = var.environment
  }
}

# 3. Target Group
# Nhóm các EC2 instances sẽ nhận traffic từ ALB.
resource "aws_lb_target_group" "main" {
  name     = "${var.environment}-clinic-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    path                = "/"
    healthy_threshold   = 2
    unhealthy_threshold = 10
    timeout             = 5
    interval            = 30
    matcher             = "200" # Mong đợi HTTP 200 OK
  }
}

# 4. Listener
# Lắng nghe traffic trên port 80 và chuyển tiếp vào Target Group.
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.main.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.main.arn
  }
}

# 5. Launch Template
# Cấu hình mẫu cho các EC2 instances (AMI, Instance Type, User Data...).
resource "aws_launch_template" "main" {
  name_prefix   = "${var.environment}-clinic-lt-"
  image_id      = data.aws_ami.amazon_linux_2.id
  instance_type = var.instance_type

  network_interfaces {
    associate_public_ip_address = false # Instance trong Private Subnet không cần Public IP
    security_groups             = [var.app_sg_id]
  }

  # User Data: Script chạy khi instance khởi động (Cài đặt Web Server giả lập)
  user_data = base64encode(<<-EOF
              #!/bin/bash
              yum update -y
              yum install -y httpd
              systemctl start httpd
              systemctl enable httpd
              echo "<h1>Clinic Management System (${var.environment})</h1><p>Server ID: $(hostname)</p>" > /var/www/html/index.html
              EOF
  )

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name        = "${var.environment}-clinic-app-server"
      Environment = var.environment
    }
  }
}

# 6. Auto Scaling Group (ASG)
# Tự động tăng/giảm số lượng instance dựa trên cấu hình.
resource "aws_autoscaling_group" "main" {
  name                = "${var.environment}-clinic-asg"
  vpc_zone_identifier = var.private_subnet_ids # Chạy trong Private Subnets
  target_group_arns   = [aws_lb_target_group.main.arn] # Kết nối với ALB Target Group

  min_size         = var.asg_min_size
  max_size         = var.asg_max_size
  desired_capacity = var.asg_desired_capacity

  launch_template {
    id      = aws_launch_template.main.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "${var.environment}-clinic-asg-instance"
    propagate_at_launch = true
  }
}
