locals {
  host = aws_db_instance.psql-sameed.address
  user_data = base64encode(templatefile("${path.module}/userdata.sh.tpl", {
    host  = local.host
    username  = var.username
    password  = var.password
    }
  ))
}