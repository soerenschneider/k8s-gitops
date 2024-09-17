locals {
  aws_name = "cert-manager-${var.cluster_name}"
}

#trivy:ignore:AVD-AWS-0143
resource "aws_iam_user" "user" {
  name = local.aws_name
  path = "/system/k8s/${var.cluster_name}"
}

resource "aws_iam_access_key" "user" {
  user = aws_iam_user.user.name
}

resource "aws_iam_user_policy" "route53_access" {
  name = local.aws_name
  user = aws_iam_user.user.name

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "route53:GetChange",
      "Resource": "arn:aws:route53:::change/*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "route53:ChangeResourceRecordSets",
        "route53:ListResourceRecordSets"
      ],
      "Resource": "arn:aws:route53:::hostedzone/${var.hosted_zone_id}"
    }
  ]
}
EOF
}
