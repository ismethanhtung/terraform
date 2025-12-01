# Terraform Clinic Infrastructure Repository

Đây là repository mẫu (mock project) chuyên nghiệp để học tập Terraform, mô phỏng việc triển khai hạ tầng cho một **Hệ thống Quản lý Phòng khám (Clinic Management System)** trên AWS.

## 📚 Mục Đích
- Học cách tổ chức code Terraform theo cấu trúc chuẩn (Modular).
- Hiểu cách kết nối các dịch vụ AWS: VPC, EC2, RDS, ALB, S3.
- Thực hành các best practices: State separation, variable usage, security groups chaining.

## 📂 Cấu Trúc Dự Án

```
clinic-infra/
├── ARCHITECTURE.md       # Tài liệu mô tả kiến trúc hệ thống
├── modules/              # Các thành phần tái sử dụng (Modules)
│   ├── networking/       # VPC, Subnets, Internet Gateway, NAT
│   ├── security/         # Security Groups, IAM Roles
│   ├── database/         # RDS (PostgreSQL)
│   ├── compute/          # EC2, Auto Scaling, Load Balancer
│   └── storage/          # S3 Buckets
└── environments/         # Cấu hình cho từng môi trường
    ├── dev/              # Môi trường Development
    └── prod/             # Môi trường Production (Placeholder)
```

## 🚀 Hướng Dẫn Sử Dụng (Cho Môi Trường Dev)

### 1. Yêu cầu
- [Terraform](https://www.terraform.io/downloads) (v1.0+)
- [AWS CLI](https://aws.amazon.com/cli/) (đã cấu hình `aws configure`)

### 2. Khởi tạo
Di chuyển vào thư mục môi trường `dev`:
```bash
cd environments/dev
terraform init
```

### 3. Kiểm tra kế hoạch (Plan)
Xem trước các tài nguyên sẽ được tạo:
```bash
terraform plan
```

### 4. Triển khai (Apply)
Tạo hạ tầng trên AWS:
```bash
terraform apply
```

### 5. Hủy bỏ (Destroy)
Xóa toàn bộ hạ tầng để tránh phát sinh chi phí (quan trọng khi học tập):
```bash
terraform destroy
```

## 📝 Ghi Chú
- Code được comment chi tiết bằng tiếng Việt để hỗ trợ việc học.
- Một số giá trị (như AMI ID) có thể cần điều chỉnh tùy theo Region bạn chọn (mặc định trong code là `ap-southeast-1` - Singapore).

---
*Project created for educational purposes.*
