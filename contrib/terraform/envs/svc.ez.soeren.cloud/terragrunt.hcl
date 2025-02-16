include "root" {
  path = find_in_parent_folders("root.hcl")
}

inputs = {
  cluster_name = basename(get_terragrunt_dir())
  route53_subdomain = basename(get_terragrunt_dir())
}
