# Create the private subnet
resource "aws_subnet" "private_subnet_1" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.pr1_subnet_cidr
  availability_zone = "${var.region}a"
  map_public_ip_on_launch = false
  tags = tomap(var.additional_tags)
}

resource "aws_subnet" "private_subnet_2" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.pr2_subnet_cidr
  availability_zone = "${var.region}b"
  map_public_ip_on_launch = false
  tags = tomap(var.additional_tags)

}

resource "aws_eip" "ps1" {
  vpc = true
}

resource "aws_eip" "ps2" { 
  vpc = true
}

resource "aws_nat_gateway" "nat1" {
  allocation_id = aws_eip.ps1.id
  subnet_id     = aws_subnet.private_subnet_1.id
  tags = tomap(var.additional_tags)

}

resource "aws_nat_gateway" "nat2" {
  allocation_id = aws_eip.ps2.id
  subnet_id     = aws_subnet.private_subnet_2.id
  tags = tomap(var.additional_tags)

}

resource "aws_route_table_association" "private-subnet-1" {
  subnet_id      = aws_subnet.private_subnet_1.id
  route_table_id = aws_route_table.nat-associations-1.id
  depends_on     = [aws_nat_gateway.nat1]
}

resource "aws_route_table_association" "private-subnet-2" {
  subnet_id      = aws_subnet.private_subnet_2.id
  route_table_id = aws_route_table.nat-associations-2.id
  depends_on     = [aws_nat_gateway.nat2]
}

resource "aws_route_table" "nat-associations-1" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat1.id
  }
  depends_on             = [aws_route_table.nat-associations-1]
}

resource "aws_route_table" "nat-associations-2" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat2.id
  }
  depends_on             = [aws_route_table.nat-associations-2]
}