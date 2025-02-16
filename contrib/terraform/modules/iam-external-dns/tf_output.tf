output "access_keys" {
  value = {
    name       = "external-dns"
    access_key = aws_iam_access_key.user.id
    secret_key = aws_iam_access_key.user.secret
  }
}
