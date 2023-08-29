provider "proxmox" {
  # URL of proxmox API
  pm_api_url = var.proxmox_api_url
  # API token user
  pm_api_token_id = var.proxmox_api_user
  # API secret token
  pm_api_token_secret = var.proxmox_api_token
  # Is there tls security
  pm_tls_insecure = true
}

module "cert_infra" {
  source = "../../modules/tls-ca-infrastructure"
  ca_public_key_file_path = var.ca_public_cert
  public_key_file_path = var.vault_public_cert
  private_key_file_path = var.vault_key_cert
  owner = "vault"
}

resource "proxmox_lxc" "basic" {
  target_node  = "pve"
  hostname     = "${var.hostname}"
  ostemplate   = "local:vztmpl/${var.os_template}"
  password     = var.lxc_password_var
  unprivileged = true
  cores        = var.cpu_limit
  memory       = var.memory_limit
  vmid         = var.vmid
  onboot       = true // need to start to ssh to the box
  start        = true //start lxc if needed

  // Terraform will crash without rootfs defined
  rootfs {
    storage = "local-zfs"
    size    = var.storage_size
  }

  network {
    name   = "eth0"
    bridge = "vmbr0"
    ip     = "${var.ip_address}/24"
  }

  connection {
    type     = "ssh"
    user     = "root"
    password = var.lxc_password_var
    host     = var.ip_address
  }

  provisioner "file" {
    source      = "install-vault.sh"
    destination = "/tmp/install-vault.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "mkdir -p /etc/tls",
      "touch  ${var.ca_public_cert}",
      "touch  ${var.vault_key_cert}",
      "touch  ${var.vault_public_cert}",
      "echo '${module.cert_infra.ca_cert_pem}' > '${module.cert_infra.ca_public_key_file_path}'",
      "chmod ${module.cert_infra.permissions} '${module.cert_infra.ca_public_key_file_path}'",
      "chown ${module.cert_infra.owner} '${module.cert_infra.ca_public_key_file_path}'",
      "echo 'Setup Vault Public cert'",
      "echo '${module.cert_infra.cert_public_key}' > '${var.vault_public_cert}'",
      "chmod ${module.cert_infra.permissions} '${var.vault_public_cert}'",
      "chown ${module.cert_infra.owner} '${var.vault_public_cert}'",
      "echo 'Setup Vault private key'",
      "echo '${module.cert_infra.cert_private_key}' > '${var.vault_key_cert}'",
      "chmod ${module.cert_infra.permissions} '${var.vault_key_cert}'",
      "chown ${module.cert_infra.owner} '${var.vault_key_cert}'",
      "echo 'Done Cert setup'",
      "cd /tmp",
      "sh install-vault.sh"
    ]
  }



}