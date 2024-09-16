output "subdomain_zone_id" {
  value = aws_route53_zone.subdomain.id
}

output "subdomain_name_servers" {
  value = aws_route53_zone.subdomain.name_servers
}
