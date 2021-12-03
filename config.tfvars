ami                 = "ami-083654bd07b5da81d"
region              = "us-east-1"
key_name            = "myweb"
vpc_cidr            = "10.0.0.0/16"
p1_subnet_cidr      = "10.0.1.0/24"
p2_subnet_cidr      = "10.0.2.0/24"
instance_type       = "t2.micro"
security_group_name = "bastion-host"

pr1_subnet_cidr     = "10.0.3.0/24"
pr2_subnet_cidr     = "10.0.4.0/24"

additional_tags = {
  "Application" = "db"
  "Name"        = "db-server"
  "Type"        = "Instance"
}
ingress_rule = {
  "22" = ["0.0.0.0/0"]
}


username = "dodonotdo"
password = "password12345"