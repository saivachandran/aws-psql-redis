variable "region" {}
variable "vpc_cidr_block" {}
variable "availability_zones" {}
variable "public_subnet_cidr_blocks" {}
variable "private_subnet_cidr_blocks" {}
variable "additional_tags" {
    default = {}
}

variable "application_name" {}
variable "instance_type" {}
variable "availability_zone" {}
variable "key_name" {}
variable "instances" {
  type        = any
  default     = {}
}

