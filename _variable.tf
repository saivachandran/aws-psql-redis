variable "vpc_cidr" {}
variable "p1_subnet_cidr" {}
variable "p2_subnet_cidr" {}
variable "additional_tags" { type = map(string) }



# instance 
variable "ami" {}
variable "instance_type" {}
variable "key_name" {}
variable "subnet_id" {}
variable "vpc_id" {}
variable "additional_tags" { type = map(string) }
variable "security_group_name" {}
variable "ingress_rule" { type = map(list(string)) }
variable "user_data" {
  type        = string
  description = "if we have user_data, we can update here in the from of bash script"
  default     = ""
}