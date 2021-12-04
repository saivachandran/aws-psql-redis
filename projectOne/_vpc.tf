resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true  
  tags = tomap(var.additional_tags)
}

resource "aws_subnet" "public_subnet-1" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.p1_subnet_cidr
  availability_zone = "${var.region}a"
  map_public_ip_on_launch = true
  tags = tomap(var.additional_tags)
}

resource "aws_subnet" "public_subnet-2" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.p2_subnet_cidr
  availability_zone = "${var.region}b"
  map_public_ip_on_launch = true
  tags = tomap(var.additional_tags)
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
  tags = tomap(var.additional_tags)
}

resource "aws_route_table" "rt" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = tomap(var.additional_tags)
}

resource "aws_route_table_association" "internet_access-1" {
  subnet_id      = aws_subnet.public_subnet-1.id
  route_table_id = aws_route_table.rt.id
}

resource "aws_route_table_association" "internet_access-2" {
  subnet_id      = aws_subnet.public_subnet-2.id
  route_table_id = aws_route_table.rt.id
}


