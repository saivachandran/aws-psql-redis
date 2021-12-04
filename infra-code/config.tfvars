region                      = "us-east-2"
vpc_cidr_block              = "10.68.0.0/16"
availability_zones          = ["us-east-2a", "us-east-2b"]
public_subnet_cidr_blocks   = ["10.68.1.0/24", "10.68.2.0/24"]
private_subnet_cidr_blocks  = ["10.68.3.0/24", "10.68.4.0/24"]
additional_tags             = { Envs = "production" }
application_name            = "dodo"

instances = {
    first  = {
        associate_public_ip_address = true
        availability_zone           = "eu-central-1a"
        key_name                    = "siva"
        instance_type               = "t2.micro"
        monitoring                  = false
        instance_mode               = "public"
    }
}
