locals {
  user_data = base64encode(templatefile("${path.module}/userdata.sh.tpl", {
  host  = aws_db_instance.psql-sameed.address
  username  = var.hostname
  password  = var.hostname
    }
  ))
}