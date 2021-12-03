locals {
  user_data = base64encode(templatefile("${path.module}/userdata.sh.tpl", {
  host  = aws_db_instance.psql-sameed.address
  username  = var.username
  password  = var.password
    }
  ))
}