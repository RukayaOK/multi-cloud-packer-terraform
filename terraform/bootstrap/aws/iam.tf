resource "aws_iam_user" "user" {
  name = var.aws_iam_user_name
  path = "/"
}

resource "aws_iam_access_key" "packer" {
  user = aws_iam_user.user.name
}

resource "aws_iam_policy" "policy" {
  name        = var.aws_iam_policy_name
  description = var.aws_iam_policy_definition
  policy      = file(var.aws_policy_file_path)
}

resource "aws_iam_policy_attachment" "attach-policy" {
  name       = var.policy_attachment_name
  users      = [aws_iam_user.user.name]
  policy_arn = aws_iam_policy.policy.arn
}

resource "aws_secretsmanager_secret" "access_key" {
  name                    = var.aws_secretsmanager_secret_access_key_name
  description             = var.aws_secretsmanager_secret_access_description
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "access_key" {
  secret_id     = aws_secretsmanager_secret.access_key.id
  secret_string = aws_iam_access_key.packer.id
}

resource "aws_secretsmanager_secret" "secret_key" {
  name                    = var.aws_secretsmanager_secret_version_secret_key_name
  description             = var.aws_secretsmanager_secret_version_secret_key_description
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "secret_key" {
  secret_id     = aws_secretsmanager_secret.secret_key.id
  secret_string = aws_iam_access_key.packer.secret
}

output "access_key" {
  value = aws_iam_access_key.packer.id
}

output "secret_key" {
  value     = aws_iam_access_key.packer.secret
  sensitive = true
}


