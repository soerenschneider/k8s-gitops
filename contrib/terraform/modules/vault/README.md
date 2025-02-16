<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.7.0 |
| <a name="requirement_vault"></a> [vault](#requirement\_vault) | 4.2.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_vault"></a> [vault](#provider\_vault) | 4.2.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [vault_kv_secret_v2.tokens](https://registry.terraform.io/providers/hashicorp/vault/4.2.0/docs/resources/kv_secret_v2) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_access_keys"></a> [access\_keys](#input\_access\_keys) | n/a | <pre>object({<br/>    name       = string,<br/>    access_key = string,<br/>    secret_key = string<br/>  })</pre> | n/a | yes |
| <a name="input_metadata"></a> [metadata](#input\_metadata) | Optional metadata to attach to the secret. | `map(any)` | `null` | no |
| <a name="input_password_store_paths"></a> [password\_store\_paths](#input\_password\_store\_paths) | Paths to write the secret to. | `list(string)` | n/a | yes |
| <a name="input_vault_kv2_mount"></a> [vault\_kv2\_mount](#input\_vault\_kv2\_mount) | n/a | `string` | `"secret"` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->