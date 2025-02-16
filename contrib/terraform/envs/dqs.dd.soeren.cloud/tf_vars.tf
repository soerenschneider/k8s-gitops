variable "parent_zone_id" {
  description = "The Route 53 Hosted Zone ID for the parent domain"
  type        = string
}

variable "use_cert_manager" {
  type    = bool
  default = true
}

variable "use_external_dns" {
  type    = bool
  default = false
}

variable "route53_subdomain" {
  type = string
}

variable "cluster_name" {
  type = string
}

variable "wildcard_records_v4" {
  type    = list(string)
  default = []
}

variable "wildcard_records_v6" {
  type    = list(string)
  default = []
}
