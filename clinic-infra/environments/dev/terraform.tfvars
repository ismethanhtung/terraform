# --- environments/dev/terraform.tfvars ---

aws_region           = "ap-southeast-1"
environment          = "dev"
vpc_cidr             = "10.0.0.0/16"
public_subnet_cidrs  = ["10.0.1.0/24", "10.0.2.0/24"]
private_subnet_cidrs = ["10.0.3.0/24", "10.0.4.0/24"]
db_name              = "clinic_dev_db"
db_username          = "admin"
db_password          = "SuperSecretPass123!" # Trong thực tế nên dùng AWS Secrets Manager
instance_type        = "t3.micro"
