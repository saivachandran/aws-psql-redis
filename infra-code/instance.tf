data "aws_ami" "amazon2" {
  most_recent = true
  filter {
    name = "name"
    values = ["amzn2-ami-hvm-*-x86_64-ebs"]
  }
  owners = ["amazon"]
}

resource "aws_instance" "tf" {
  for_each                          = var.instances
  associate_public_ip_address       = lookup(each.value, "associate_public_ip_address")
  availability_zone                 = lookup(each.value, "availability_zone")
  key_name                          = lookup(each.value, "key_name")
  instance_type                     = lookup(each.value, "instance_type")
  monitoring                        = lookup(each.value, "monitoring")
  ami                               = data.aws_ami.amazon2.id
  subnet_id                         = lookup(each.value, "instance_mode", "public") == "public" ? aws_subnet.public_subnet[0].id : aws_subnet.private_subnet[0].id
  vpc_security_group_ids            = [aws_security_group.tf[each.key].id]
  user_data                         = ""


  root_block_device {
    delete_on_termination = true
    encrypted             = true
    iops                  = 3000
    throughput            = 125
    volume_size           = 250
    volume_type           = "gp3"
  }
  tags   = merge(
    { 
      Name          = each.key
      creation_time = timestamp()
      region        = var.region
    }, 
      tomap(var.additional_tags)
    )
}


resource "aws_security_group" "tf" {
  for_each    = var.instances
  description = "Security group for ${var.application_name}"
  vpc_id      = aws_vpc.vpc.id
  name        = "${var.application_name}-sg"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

#   dynamic "ingress" {
#     for_each = var.ingress_rule
#     content {
#       from_port   = ingress.key
#       to_port     = ingress.key
#       protocol    = "tcp"
#       cidr_blocks = ingress.value
#     }
#   }

  tags   = merge(
    { 
      Name          = "${var.application_name}-sg"
      creation_time = timestamp()
      region        = var.region
    }, 
      tomap(var.additional_tags)
    )
}