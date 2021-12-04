resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc_cidr_block
  enable_dns_support   = true
  enable_dns_hostnames = true  
  tags = {}
}

# public subnet function
resource "aws_subnet" "public_subnet" {
  count             = length(var.availability_zones)
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = element(var.public_subnet_cidr_blocks, count.index)
  availability_zone = element(var.availability_zones, count.index)
  map_public_ip_on_launch = false
  tags              = {}
}

resource "aws_internet_gateway" "igw" {
  count             = length(var.availability_zones)
  vpc_id            = aws_vpc.vpc.id
}

resource "aws_route_table" "main" {
  count             = length(var.availability_zones)
  vpc_id            = aws_vpc.vpc.id
  tags              = {}
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw[count.index].id
  }
}

resource "aws_route_table_association" "internet_access" {
  count          = length(var.availability_zones)
  subnet_id      = aws_subnet.public_subnet[count.index].id
  route_table_id = aws_route_table.main[count.index].id
}

# Private subnet functins
resource "aws_subnet" "private_subnet" {
  count             = length(var.availability_zones)
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = element(var.private_subnet_cidr_blocks, count.index)
  availability_zone = element(var.availability_zones, count.index)
  map_public_ip_on_launch = false
  tags = {}
}

resource "aws_eip" "eip" {
    count           = length(var.availability_zones)
    vpc             = true
}

resource "aws_nat_gateway" "nat" {
  count           = length(var.availability_zones)
  allocation_id = aws_eip.eip[count.index].id
  subnet_id     = aws_subnet.private_subnet[count.index].id
  tags = {}
}

resource "aws_route_table" "rt" {
  tags            = {}
  count           = length(var.availability_zones)
  vpc_id          = aws_vpc.vpc.id
  route {
    cidr_block    = "0.0.0.0/0"
    gateway_id    = aws_nat_gateway.nat[count.index].id
  }
  depends_on      = [aws_nat_gateway.nat]
}

resource "aws_route_table_association" "route_table_association" {
  subnet_id      = aws_subnet.private_subnet[count.index].id
  route_table_id = aws_route_table.rt[count.index].id
  depends_on     = [aws_route_table.rt]
  tags           = {}
}