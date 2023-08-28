#----------------------------------------------------------------------------------------------------------------------
# General Variables
# ---------------------------------------------------------------------------------------------------------------------
variable "name"                  { default = "vault-best-practices" }
variable "common_name"           { default = "example.com" }
variable "organization_name"     { default = "Example Inc."}
#variable "provider"              { default = "aws" }
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

variable "ca_allowed_uses" {
  type = list(string)
  default = [
    "cert_signing",
    "key_encipherment",
    "digital_signature",
    "server_auth",
    "client_auth"
  ]
}

# -----------------------------------------------------------------------------------