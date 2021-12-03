locals {
  host = 
  user_data = base64encode(templatefile("${path.module}/userdata.sh.tpl", {
    username  = var.username
    password  = var.password
    }
  ))
}