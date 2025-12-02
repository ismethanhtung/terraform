# --- modules/vpc/main.tf ---

# 1. Tạo VPC (Virtual Private Cloud)
# Đây là mạng riêng ảo chứa toàn bộ tài nguyên của phòng khám.
resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true # Cho phép sử dụng DNS hostname
  enable_dns_support   = true

  tags = {
    Name        = "${var.environment}-clinic-vpc"
    Environment = var.environment
    Project     = "ClinicSystem"
  }
}

# 2. Tạo Internet Gateway (IGW)
# Cổng kết nối để VPC có thể giao tiếp với Internet (dành cho Public Subnet).
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name        = "${var.environment}-clinic-igw"
    Environment = var.environment
  }
}

# 3. Lấy danh sách các Availability Zones (AZs) có sẵn
data "aws_availability_zones" "available" {
  state = "available"
}

# 4. Tạo Public Subnets
# Dùng cho Load Balancer và Bastion Host.
resource "aws_subnet" "public" {
  count                   = length(var.public_subnet_cidrs)
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_cidrs[count.index]
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = true # Tự động gán Public IP cho instance

  tags = {
    Name        = "${var.environment}-public-subnet-${count.index + 1}"
    Environment = var.environment
    Type        = "Public"
  }
}

# 5. Tạo Private Subnets
# Dùng cho Application Servers và Database (Bảo mật cao).
resource "aws_subnet" "private" {
  count             = length(var.private_subnet_cidrs)
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnet_cidrs[count.index]
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = {
    Name        = "${var.environment}-private-subnet-${count.index + 1}"
    Environment = var.environment
    Type        = "Private"
  }
}

# 6. NAT Gateway (Network Address Translation)
# Cho phép Private Subnet truy cập Internet (chiều đi ra) nhưng chặn chiều từ Internet vào.
# Cần một Elastic IP (EIP) cho NAT Gateway.

resource "aws_eip" "nat" {
  domain = "vpc"
  tags = {
    Name = "${var.environment}-nat-eip"
  }
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public[0].id # Đặt NAT Gateway tại Public Subnet đầu tiên

  tags = {
    Name = "${var.environment}-nat-gateway"
  }

  depends_on = [aws_internet_gateway.igw] # Đảm bảo IGW có trước
}

# 7. Route Tables (Bảng định tuyến)

# Route Table cho Public Subnet (Đi qua IGW)
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "${var.environment}-public-rt"
  }
}

# Route Table cho Private Subnet (Đi qua NAT Gateway)
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
  }

  tags = {
    Name = "${var.environment}-private-rt"
  }
}

# 8. Route Table Associations (Gán Route Table vào Subnet)

resource "aws_route_table_association" "public" {
  count          = length(var.public_subnet_cidrs)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "private" {
  count          = length(var.private_subnet_cidrs)
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private.id
}
