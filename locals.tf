locals {
 user_data = base64encode(templatefile("${path.module}/userdata.sh.tpl", {
    username  = var.username
    password  = var.password
    host = aws_db_instance.psql-sameed.address
    }
  ))
}