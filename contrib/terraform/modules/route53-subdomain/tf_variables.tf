variable "parent_zone_id" {
  description = "The Route 53 Hosted Zone ID for the parent domain"
  type        = string
}

variable "subdomain" {
  type = string
}

variable "wildcard_records_v4" {
  type = list(string)
  default = []
}

variable "wildcard_records_v6" {
  type = list(string)
  default = []
}
