# ---------------------------------------------------------------------------------------------------------------------
# General variables
# ---------------------------------------------------------------------------------------------------------------------

variable "name" {
  description = "Filename to write the certificate data to, default to \"tls-self-signed-cert\"."
  default     = "tls-self-signed-cert"
}


variable "ca_public_key_file_path" {
  description = "Write the PEM-encoded CA certificate public key to this path (e.g. /etc/tls/ca.crt.pem)"
  type = string
  default = "ca.crt.pem"
}

variable "public_key_file_path" {
  description = "Write PEM encoded certificate public key to this path (e.g /etc/tls/vault.crt.pem)"
  type = string
  default = "vault.crt.pem"
}

variable "private_key_file_path" {
  description = "Write PEM encoded certificate private key to this path (e.g /etc/tls/vault.key.pem)"
  type = string
  default = "vault.key.pem"
}

variable "owner" {
  description = " The OS user who should be given ownership over the certificate files."
  type = string
  default = "milos"
}

variable "organization_name" {
  description = "The name of the organization to associate with the certificates (e.g. Acme Co)"
  type = string
  default = "Acme Co"
}

variable "ca_common_name" {
  description = "The common name to use in the subject of the CA certificate (e.g. acme.co cert)"
  type = string
  default = "acme.com"
}

variable "common_name" {
  description = "The common name to use in the subject of the certificate (e.g. acme.co cert)"
  type = string
  default = "acme.com"
}

variable "dns_names" {
  description = "List of DNS names for which certificate will be valid (e.g. vault.service.consul,foo.example.com"
  type = list(string)
  default = [ "localhost",
    "*.node.consul",
    "*.service.consul",
    "server.dc1.consul",
    "*.dc1.consul"]
}

variable "ip_addresses" {
  description = "List of IP addresses for which the certificate will be valid (e.g. 127.0.0.1)"
  type = list(string)
  default = [
  "127.0.0.1","0.0.0.0","192.168.0.100","192.168.100.100"
  ]
}

variable "validity_period_hours" {
  description = "The number of hours after initial issuing that certificate will become invalid"
  type = number
  default = 1000
}

# ---------------------------------------------------------------------------------------------------------------------
# Optional Parameters
# ---------------------------------------------------------------------------------------------------------------------

variable "ca_allowed_uses" {
  description = "List of keywords from RFC5280 describing a use that is permitted for the CA certificate. For more info and the list of keywords, see https://www.terraform.io/docs/providers/tls/r/self_signed_cert.html#allowed_uses."
  type        = list(string)
  default = [
    "cert_signing",
    "key_encipherment",
    "digital_signature",
  ]
}


variable "allowed_uses" {
  description = "List of keywords from RFC5280 describing a use that is permitted for the issued certificate. For more info and the list of keywords, see https://www.terraform.io/docs/providers/tls/r/self_signed_cert.html#allowed_uses."
  type        = list(string)
  default = [
    "key_encipherment",
    "digital_signature",
  ]
}

variable "permissions" {
  description = "The Unix file permissions to assign to the cert files (e.g. 0600)"
  type = number
  default = 0600
}

variable "private_key_algorithm" {
  description = "The name of the algorithm to use for the private keys. Must be RSA or ECDSA"
  type = string
  default = "RSA"
}

variable "private_key_ecdsa_curve" {
  description = "The name of the elliptic curve to use. Should only be used if var.private_key_algorithm is ECDSA. Must be one of P224 P256 P384 P521"
  type = string
  default = "P256"
}

variable "private_key_rsa_bits" {
  description = "The size of the generated RSA keys in bits.Should only be used if var.private_key_algorithm is RSA"
  type = number
  default = 2048
}