# ---------------------------------------------------------------------------------------------------------------------
# General Variables
# ---------------------------------------------------------------------------------------------------------------------
variable "name"                  { default = "vault-best-practices" }
variable "common_name"           { default = "example.com" }
variable "organization_name"     { default = "Example Inc."}
variable "local_ip_url"          { default = "http://169.254.169.254/latest/meta-data/local-ipv4" }
variable "download_certs"        { default = false}

# ---------------------------------------------------------------------------------------------------------------------
# Network Variables
# ---------------------------------------------------------------------------------------------------------------------
variable "vpc_cidr" { default = "10.139.0.0/16"}

variable "vpc_cidrs_public"  {
  type = list(string)
  default = ["10.139.1.0/24","10.139.2.0/24","10.139.3.0./24"]
}

variable "vpc_cidrs_private"  {
  type = list(string)
  default = ["10.139.11.0/24","10.139.12.0/24","10.139.13.0./24"]
}

# ---------------------------------------------------------------------------------------------------------------------
# Proxmox Variables
# ---------------------------------------------------------------------------------------------------------------------
variable "proxmox_api_url"      { type = string }
variable "proxmox_api_user"     { type = string }
variable "proxmox_api_token"    { type = string }
variable "lxc_password_var"     { type = string }

# ---------------------------------------------------------------------------------------------------------------------
# LXC Variables
# ---------------------------------------------------------------------------------------------------------------------
variable "hostname"         { type = string }
variable "os_template"      { type = string }
variable "cpu_limit"        { type = number }
variable "memory_limit"     { type = number }
variable "storage_size"     { default = "8G" }
variable "vmid"             { type = number }
variable "isServer"         { type = bool }
variable "ip_address"       { default = "192.168.0.100" }

# ---------------------------------------------------------------------------------------------------------------------
# Vault Variables
# ---------------------------------------------------------------------------------------------------------------------

variable "ca_public_cert" { default = "/etc/tls/ca.crt.pem" }
variable "vault_public_cert" { default = "/etc/tls/vault.crt.pem" }
variable "vault_key_cert" { default = "/etc/tls/vault.key" }