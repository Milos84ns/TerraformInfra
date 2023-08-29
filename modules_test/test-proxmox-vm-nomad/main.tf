locals {
  api_url = var.proxmox_api_url #ENV TF_VAR_proxmox_api_url=
  api_user = var.proxmox_api_user #ENV TF_VAR_proxmox_api_user=
  api_token = var.proxmox_api_token #ENV TF_VAR_proxmox_token=
  server_ip = "${var.cluster_ip_prefix}.${var.server_ip_last_octet}"
  client_ip = "${var.cluster_ip_prefix}.${var.client_ip_last_octet}"
  vm_template = "230827124613-Nomad-RockyLinux9"
}

module "nomad_vm_client" {
    source = "../../modules/proxmox-vm-nomad"
    template_name = local.vm_template
    isServer          = false
    lxc_hostname      = "NomadVmClient"
    vmid_start        = var.vmid_start + 20
    proxmox_api_token = local.api_token
    proxmox_api_url   = local.api_url
    proxmox_api_user  = local.api_user
    server_ip_address = local.server_ip
    ip_address = "${var.cluster_ip_prefix}.${var.client_ip_last_octet+10}"
}
