# --- environments/prod/main.tf ---

# Môi trường Production (Placeholder)
# Cấu trúc tương tự Dev nhưng có thể khác về cấu hình (Instance lớn hơn, Multi-AZ DB...)

provider "aws" {
  region = "ap-southeast-1"
}

# Ví dụ: Production dùng module giống Dev nhưng cấu hình mạnh hơn
# module "networking" { ... }
# module "compute" { instance_type = "t3.medium", asg_min_size = 2 ... }
