locals {
  k8s_namespace = "external-dns"
}

resource "kubernetes_namespace" "cm" {
  metadata {
    name = local.k8s_namespace
  }
}

resource "kubernetes_secret" "aws_credentials" {
  metadata {
    name = "aws-route53-credentials"
    namespace = local.k8s_namespace
  }

  depends_on = [
    kubernetes_namespace.cm
  ]

  data = {
    access-key-id = aws_iam_access_key.user.id
    access-key-secret = aws_iam_access_key.user.secret
  }
}
