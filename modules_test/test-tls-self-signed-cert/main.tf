module "root_tls_self_signed_ca"{

  source = "../../modules/tls-self-signed-cert"

  name = "${var.name}-root"
  ca_cert_override = var.common_name
  organization_name = var.organization_name
  common_name = var.common_name
  download_certs = var.download_certs
  validity_period_hours = "8760"
  ca_allowed_uses = var.ca_allowed_uses

}

module "leaf_tls_self_sigend_cert"{

  source = "../../modules/tls-self-signed-cert"

  name = "${var.name}-leaf"
  organization_name = var.organization_name
  common_name = var.common_name
  ca_override = true
  ca_key_override = module.root_tls_self_signed_ca.ca_private_key_pem
  ca_cert_override = module.root_tls_self_signed_ca.ca_cert_pem
  download_certs = var.download_certs

  validity_period_hours = "8760"
  dns_names = [
    "localhost",
    "*.node.consul",
    "*.service.consul",
    "server.dc1.consul",
    "*.dc1.consul",
    "server.${var.name}.consul",
    "*.${var.name}.consul"
  ]

  ip_addresses = [
  "0.0.0.0",
    "127.0.0.1"
  ]

  ca_allowed_uses = [
    "key_encipherment",
    "digital_signature",
    "server_auth",
    "client_auth"
  ]
}