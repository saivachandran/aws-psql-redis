resource "aws_db_subnet_group" "_" {
  name       = "psql-subnet-group"
  subnet_ids = [aws_subnet.private_subnet_1.id, aws_subnet.private_subnet_2.id]
}


resource "aws_security_group" "psql" {
  vpc_id      = aws_vpc.vpc.id
  name        = "psql"
  description = "Allow all inbound for Postgres"
ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
resource "aws_db_instance" "psql-sameed" {
  db_subnet_group_name    = aws_db_subnet_group._.id
  identifier             = "psql-sameed"
  name                   = "psql"
  instance_class         = "db.t2.micro"
  allocated_storage      = 5
  engine                 = "postgres"
  engine_version         = "12.5"
  skip_final_snapshot    = true
  publicly_accessible    = true
  vpc_security_group_ids = [aws_security_group.psql.id]
  username               = var.username
  password               = var.password
}