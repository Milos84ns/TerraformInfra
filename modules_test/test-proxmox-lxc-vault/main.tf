locals {
  api_url = var.proxmox_api_url #ENV TF_VAR_proxmox_api_url=
  api_user = var.proxmox_api_user #ENV TF_VAR_proxmox_api_user=
  api_token = var.proxmox_api_token #ENV TF_VAR_proxmox_token=
  server_ip = "${var.cluster_ip_prefix}.${var.server_ip_last_octet}"
  client_ip = "${var.cluster_ip_prefix}.${var.client_ip_last_octet}"
  lxc_template = "230827134035-HashiPack-rockylinux-8-amd64.tar.gz"
}


module "vault_server" {
  source = "../../modules/proxmox-lxc-vault"
  os_template = local.lxc_template
  cpu_limit = 2
  memory_limit = 1024
  ip_address = local.server_ip
 # client_ip_address = local.client_ip
  vmid = var.vmid_start
  isServer = true
  hostname = "VaultServer"
  lxc_password_var = "rockylinux"
  #define proxmox vars in ENVIRONMENT
  proxmox_api_url = local.api_url
  proxmox_api_user = local.api_user
  proxmox_api_token = local.api_token
}