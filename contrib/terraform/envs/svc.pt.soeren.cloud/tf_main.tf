locals {
  instance                     = basename(abspath(path.module))
  password_store_paths_default = ["soeren.cloud/k8s/${local.instance}/%s"]
}

module "route53_subdomain" {
  source = "../../modules/route53-subdomain"

  parent_zone_id = var.parent_zone_id
  subdomain      = var.route53_subdomain

  wildcard_records_v4 = var.wildcard_records_v4
  wildcard_records_v6 = var.wildcard_records_v6
}

module "cert_manager" {
  source         = "../../modules/iam-cert-manager"
  count          = var.use_cert_manager ? 1 : 0
  cluster_name   = var.cluster_name
  hosted_zone_id = module.route53_subdomain.subdomain_zone_id
}

module "vault_cert_manager" {
  source               = "../../modules/vault"
  count                = var.use_cert_manager ? 1 : 0
  access_keys          = nonsensitive(module.cert_manager[0].access_keys)
  password_store_paths = coalescelist(var.password_store_paths, local.password_store_paths_default)
  metadata             = {}
}

module "external_dns" {
  source         = "../../modules/iam-external-dns"
  count          = var.use_external_dns ? 1 : 0
  cluster_name   = var.cluster_name
  hosted_zone_id = module.route53_subdomain.subdomain_zone_id
}

module "vault_external_dns" {
  source               = "../../modules/vault"
  count                = var.use_external_dns ? 1 : 0
  access_keys          = nonsensitive(module.external_dns[0].access_keys)
  password_store_paths = coalescelist(var.password_store_paths, local.password_store_paths_default)
  metadata             = {}
}
