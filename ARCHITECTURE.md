# Hệ Thống Quản Lý Phòng Khám (Clinic Management System) - Kiến Trúc Hệ Thống

Tài liệu này mô tả chi tiết về kiến trúc hạ tầng trên AWS cho hệ thống quản lý phòng khám và cách nó được hiện thực hóa thông qua Terraform.

## 1. Tổng Quan Nghiệp Vụ
Hệ thống phòng khám là một ứng dụng web phục vụ các chức năng:
- **Quản lý bệnh nhân:** Lưu trữ hồ sơ y tế, lịch sử khám bệnh.
- **Đặt lịch hẹn:** Quản lý lịch làm việc của bác sĩ và lịch hẹn của bệnh nhân.
- **Quản lý kho thuốc:** Theo dõi nhập/xuất thuốc và vật tư y tế.
- **Lưu trữ hình ảnh:** Lưu trữ phim X-quang, kết quả xét nghiệm (file PDF, ảnh).

## 2. Kiến Trúc Hạ Tầng (AWS Architecture)
Để đảm bảo tính sẵn sàng cao (High Availability), bảo mật (Security) và khả năng mở rộng (Scalability), hệ thống được thiết kế theo mô hình **3-Tier Architecture** (Kiến trúc 3 lớp) trên AWS.

### Các thành phần chính:

#### A. Networking (Mạng) - VPC
- **VPC (Virtual Private Cloud):** Tạo một mạng riêng ảo để chứa toàn bộ hệ thống.
- **Subnets:**
  - **Public Subnets (2 AZs):** Chứa Load Balancer và Bastion Host. Cho phép truy cập từ Internet.
  - **Private App Subnets (2 AZs):** Chứa các Web Server/Application Server. Không thể truy cập trực tiếp từ Internet (tăng tính bảo mật).
  - **Private Data Subnets (2 AZs):** Chứa Database và Caching layer.
- **NAT Gateway:** Cho phép các server trong Private Subnet truy cập Internet (để update OS, tải thư viện) mà không bị Internet truy cập ngược lại.

#### B. Compute (Tính toán) & Load Balancing
- **Application Load Balancer (ALB):** Đứng ở Public Subnet, nhận traffic từ người dùng (HTTP/HTTPS) và phân phối tải đến các server bên trong.
- **Auto Scaling Group (ASG):** Tự động tăng/giảm số lượng EC2 instances dựa trên tải (CPU, Memory). Đảm bảo hệ thống luôn hoạt động ổn định ngay cả khi lượng truy cập tăng đột biến.
- **EC2 Instances:** Chạy ứng dụng Backend/Frontend (Node.js/Java/Python). Nằm trong Private App Subnet.

#### C. Database (Cơ sở dữ liệu)
- **Amazon RDS (PostgreSQL):** Cơ sở dữ liệu quan hệ được quản lý (Managed Service).
  - Chế độ **Multi-AZ** được bật để dự phòng (nếu node chính chết, node phụ sẽ tự động thay thế).
  - Nằm trong Private Data Subnet, được bảo vệ bởi Security Group chỉ cho phép App Server truy cập.

#### D. Storage (Lưu trữ)
- **Amazon S3:** Lưu trữ object (ảnh X-quang, tài liệu PDF). S3 cung cấp độ bền dữ liệu 99.999999999%.
- **S3 Lifecycle Policies:** Tự động chuyển dữ liệu cũ sang Glacier để tiết kiệm chi phí.

#### E. Security (Bảo mật)
- **Security Groups:** Firewall ảo kiểm soát traffic vào/ra từng instance.
- **IAM Roles:** Cấp quyền cho EC2 truy cập S3 mà không cần lưu Hard-coded Access Key trong code.

---

## 3. Cấu Trúc Terraform
Dự án Terraform này được tổ chức theo cấu trúc **Modular** (Mô-đun hóa) chuyên nghiệp, giúp code dễ đọc, dễ tái sử dụng và dễ bảo trì.

### Cấu trúc thư mục:
- `modules/`: Chứa các thành phần hạ tầng độc lập (VPC, EC2, RDS...).
  - Mỗi module có `main.tf` (code chính), `variables.tf` (biến đầu vào), `outputs.tf` (kết quả đầu ra).
- `environments/`: Chứa cấu hình cho từng môi trường (Dev, Staging, Prod).
  - `dev/`: Môi trường phát triển, sử dụng các module từ thư mục `modules/`.

### Quy trình triển khai:
1. **Networking Module:** Tạo VPC, Subnets, Route Tables.
2. **Security Module:** Tạo Security Groups.
3. **Database Module:** Tạo RDS instance.
4. **Storage Module:** Tạo S3 Bucket.
5. **Compute Module:** Tạo ALB, Launch Template, Auto Scaling Group.

---
*Tài liệu này giúp Dev và Ops hiểu rõ bức tranh toàn cảnh trước khi đi sâu vào code Terraform.*
