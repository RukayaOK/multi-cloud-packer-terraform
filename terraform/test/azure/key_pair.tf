resource "tls_private_key" "main" {
  algorithm = "RSA"
}

resource "local_sensitive_file" "main" {
  filename        = "${var.key_pair_name}.pem"
  content         = tls_private_key.main.private_key_pem
  file_permission = "0400"
}
