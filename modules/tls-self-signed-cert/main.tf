terraform {
  required_version = ">= 1.5.6"
}

resource "random_id" "name" {
  count = var.create ? 1 : 0
  byte_length = 4
  prefix      = "${var.name}-"
}

resource "tls_private_key" "ca" {
  count = var.create && !var.ca_override ? 1 : 0

  algorithm   = var.algorithm
  ecdsa_curve = var.ecdsa_curve
  rsa_bits    = var.rsa_bits
}

resource "tls_self_signed_cert" "ca" {
  count = var.create && !var.ca_override ? 1 : 0

  #key_algorithm     = tls_private_key.ca[count.index].algorithm
  private_key_pem   = var.ca_key_override == "" ? tls_private_key.ca[count.index].private_key_pem : var.ca_key_override
  is_ca_certificate = true

  validity_period_hours = var.validity_period_hours
  allowed_uses          = var.ca_allowed_uses

  subject {
    common_name  = var.ca_common_name
    organization = var.organization_name
  }
}

resource "tls_private_key" "leaf" {
  count = var.create ? 1 : 0

  algorithm   = var.algorithm
  ecdsa_curve = var.ecdsa_curve
  rsa_bits    = var.rsa_bits
}

resource "tls_cert_request" "leaf" {
  count = var.create ? 1 : 0

 # key_algorithm   = tls_private_key.leaf[c].algorithm
  private_key_pem = tls_private_key.leaf[count.index].private_key_pem

  dns_names    = var.dns_names
  ip_addresses = var.ip_addresses

  subject {
    common_name  = var.common_name
    organization = var.organization_name
  }
}

#resource "tls_locally_signed_cert" "leaf" {
#  count = var.create ? 1 : 0
#
#  cert_request_pem = tls_cert_request.leaf[count.index].cert_request_pem
#
# #ca_key_algorithm   = !var.ca_override ? element(concat(tls_private_key.ca.*.algorithm, list("")), 0) : var.algorithm
#  ca_private_key_pem = var.ca_key_override == "" ? element(concat(tls_private_key.ca.*.private_key_pem, tolist([""])), 0) : var.ca_key_override
#  ca_cert_pem        = var.ca_cert_override == "" ? element(concat(tls_self_signed_cert.ca.*.cert_pem, tolist([""])), 0) : var.ca_cert_override
#
#  validity_period_hours = var.validity_period_hours
#  allowed_uses          = var.allowed_uses
#}

resource "tls_locally_signed_cert" "leaf" {
  count = var.create ? 1 : 0

  cert_request_pem = tls_cert_request.leaf[count.index].cert_request_pem

 #ca_key_algorithm   = !var.ca_override ? element(concat(tls_private_key.ca.*.algorithm, list("")), 0) : var.algorithm
  ca_private_key_pem = var.ca_key_override == "" ? tls_private_key.ca.private_key_pem : var.ca_key_override
  ca_cert_pem        = var.ca_cert_override == "" ? tls_self_signed_cert.ca.*.cert_pem : var.ca_cert_override

  validity_period_hours = var.validity_period_hours
  allowed_uses          = var.allowed_uses
}

resource "null_resource" "download_ca_cert" {
  count = var.create && var.download_certs ? 1 : 0

  # Write the PEM-encoded CA certificate public key to this path (e.g. /etc/tls/ca.crt.pem).
  provisioner "local-exec" {
    command = "echo '${chomp(var.ca_cert_override == "" ? element(concat(tls_self_signed_cert.ca.*.cert_pem, tolist([""])), 0) : var.ca_cert_override)}' > ${format("%s-ca.crt.pem", random_id.name[count.index].hex)} && chmod ${var.permissions} '${format("%s-ca.crt.pem", random_id.name[count.index].hex)}'"
  }
}