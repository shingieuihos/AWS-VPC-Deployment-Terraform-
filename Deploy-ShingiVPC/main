provider "aws" {
  region = "us-east-1"
}

data "aws_availability_zones" "available" {}

# VPC
resource "aws_vpc" "main" {
  cidr_block                     = "10.0.0.0/16"
  enable_dns_support             = true
  enable_dns_hostnames           = true
  assign_generated_ipv6_cidr_block = true

  tags = {
    Name = "Shingi-North-Virginia-Office-1"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "IGW-Shingi-North-Virginia-Office-1"
  }
}

# Egress-Only Internet Gateway (for IPv6)
resource "aws_egress_only_internet_gateway" "egress" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "EgressGW-Shingi-North-Virginia-Office-1"
  }
}

# Public Subnet: web_servers
resource "aws_subnet" "web_servers" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = data.aws_availability_zones.available.names[0]
  map_public_ip_on_launch = true
  tags = {
    Name = "SNVO1web-servers"
  }
}

# Public Subnet: accounting
resource "aws_subnet" "accounting" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.3.0/24"
  availability_zone       = data.aws_availability_zones.available.names[2]
  map_public_ip_on_launch = true
  tags = {
    Name = "SNVO1accounting"
  }
}

# Private Subnet: operations (with IPv6)
resource "aws_subnet" "operations" {
  vpc_id                        = aws_vpc.main.id
  cidr_block                    = "10.0.2.0/24"
  availability_zone             = data.aws_availability_zones.available.names[1]
  assign_ipv6_address_on_creation = true
  ipv6_cidr_block               = cidrsubnet(aws_vpc.main.ipv6_cidr_block, 8, 1)
  tags = {
    Name = "SNVO1operations"
  }
}

# Elastic IP for NAT Gateway
resource "aws_eip" "nat" {
  vpc = true
  tags = {
    Name = "NAT-EIP"
  }
}

# NAT Gateway in Public Subnet
resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.web_servers.id
  tags = {
    Name = "NATGW-Shingi"
  }
}

# Public Route Table
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "RTShingi-Public"
  }
}

# Public Routes
resource "aws_route" "public_ipv4" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

# Public Associations
resource "aws_route_table_association" "web" {
  subnet_id      = aws_subnet.web_servers.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "accounting" {
  subnet_id      = aws_subnet.accounting.id
  route_table_id = aws_route_table.public.id
}

# Private Route Table
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "RTShingi-Private"
  }
}

# Private IPv4 Route via NAT Gateway
resource "aws_route" "private_ipv4" {
  route_table_id         = aws_route_table.private.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat.id
}

# Private IPv6 Route via Egress Gateway
resource "aws_route" "private_ipv6" {
  route_table_id              = aws_route_table.private.id
  destination_ipv6_cidr_block = "::/0"
  egress_only_gateway_id      = aws_egress_only_internet_gateway.egress.id
}

# Private Association
resource "aws_route_table_association" "operations" {
  subnet_id      = aws_subnet.operations.id
  route_table_id = aws_route_table.private.id
}
