variable "access_keys" {
  type = object({
    name       = string,
    access_key = string,
    secret_key = string
  })
}

variable "password_store_paths" {
  type        = list(string)
  description = "Paths to write the secret to."

  validation {
    condition = alltrue([
      for path in var.password_store_paths : length(path) >= 5
    ])
    error_message = "Each path in password_store_paths must be at least 5 characters long."
  }

  validation {
    condition = alltrue([
      for path in var.password_store_paths :
      !startswith(path, "/") && !endswith(path, "/")
    ])
    error_message = "Each path in password_store_paths must not start or end with a slash ('/')."
  }
}

variable "vault_kv2_mount" {
  type    = string
  default = "secret"

  validation {
    condition     = !endswith(var.vault_kv2_mount, "/") && length(var.vault_kv2_mount) > 3
    error_message = "vault_kv2_mount should not end with a slash."
  }
}

variable "metadata" {
  type        = map(any)
  default     = null
  description = "Optional metadata to attach to the secret."
}
