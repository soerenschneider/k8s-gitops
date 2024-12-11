resource "aws_route53_zone" "subdomain" {
  name = var.subdomain
}

resource "aws_route53_record" "subdomain_delegation" {
  zone_id = var.parent_zone_id
  name    = var.subdomain
  type    = "NS"

  ttl     = 172800
  records = aws_route53_zone.subdomain.name_servers
}

resource "aws_route53_record" "wildcard_record_v4" {
  count = length(var.wildcard_records_v4) == 0 ? 0 : 1

  zone_id = aws_route53_zone.subdomain.id
  name    = "*.${var.subdomain}"
  type    = "A"

  ttl     = 172800
  records = var.wildcard_records_v4
}

resource "aws_route53_record" "wildcard_record_v6" {
  count = length(var.wildcard_records_v6) == 0 ? 0 : 1

  zone_id = aws_route53_zone.subdomain.id
  name    = "*.${var.subdomain}"
  type    = "AAAA"

  ttl     = 172800
  records = var.wildcard_records_v6
}
