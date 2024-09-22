output "access_key_id" {
  value = aws_iam_access_key.user.id
}

output "access_key_secret" {
  value = aws_iam_access_key.user.secret
}

output "access_key_user" {
  value = aws_iam_access_key.user.user
}
