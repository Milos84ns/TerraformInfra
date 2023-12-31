terraform {
  required_version = ">= 1.5.6"
}

# ---------------------------------------------------------------------------------------------------------------------
# Create A CA Certificate
# ---------------------------------------------------------------------------------------------------------------------

resource "tls_private_key" "ca" {
  algorithm = var.private_key_algorithm
  ecdsa_curve = var.private_key_ecdsa_curve
  rsa_bits = var.private_key_rsa_bits
}

resource "tls_self_signed_cert" "ca" {
  allowed_uses          = var.ca_allowed_uses
 # key_algorithm         = tls_private_key.ca.algorithm
  private_key_pem       = tls_private_key.ca.private_key_pem
  validity_period_hours = var.validity_period_hours
  is_ca_certificate = true
  subject {
    common_name = var.ca_common_name
    organization = var.organization_name
    organizational_unit = var.organization_name
  }

  #Store the CA public key in a file
#  provisioner "local-exec" {
#    command = "echo '${tls_self_signed_cert.ca.cert_pem}' > '${var.ca_public_key_file_path}' && chmod ${var.permissions} '${var.ca_public_key_file_path}' && chown ${var.owner} '${var.ca_public_key_file_path}'"
#  }
}


# ---------------------------------------------------------------------------------------------------------------------
# Create A TLS Certificate signeed using CA Certificate
# ---------------------------------------------------------------------------------------------------------------------
resource "tls_private_key" "cert" {
  algorithm = var.private_key_algorithm
  ecdsa_curve = var.private_key_ecdsa_curve
  rsa_bits = var.private_key_rsa_bits

#  provisioner "local-exec" {
#    command = "echo '${tls_private_key.cert.private_key_pem}' > '${var.private_key_file_path}' && chmod ${var.permissions} '${var.private_key_file_path}' && chown ${var.owner} '${var.private_key_file_path}'"
#  }
}

resource "tls_cert_request" "cert" {
  #key_algorithm   = tls_private_key.cert.algorithm
  private_key_pem = tls_private_key.cert.private_key_pem

  dns_names = var.dns_names
  ip_addresses = var.ip_addresses

  subject {
    common_name = var.common_name
    organization = var.organization_name
    organizational_unit = var.organization_name

  }
}

resource "tls_locally_signed_cert" "cert" {

  allowed_uses          = var.allowed_uses
  ca_cert_pem           = tls_self_signed_cert.ca.cert_pem
  #ca_key_algorithm      = tls_private_key.ca.algorithm
  ca_private_key_pem    = tls_private_key.ca.private_key_pem
  cert_request_pem      = tls_cert_request.cert.cert_request_pem
  validity_period_hours = var.validity_period_hours

#  provisioner "local-exec" {
#    command = "echo '${tls_locally_signed_cert.cert.cert_pem}' > '${var.public_key_file_path}' && chmod ${var.permissions} '${var.public_key_file_path}' && chown ${var.owner} '${var.public_key_file_path}'"
#  }
}