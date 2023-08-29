locals {
    api_url = var.proxmox_api_url #ENV TF_VAR_proxmox_api_url=
    api_user = var.proxmox_api_user #ENV TF_VAR_proxmox_api_user=
    api_token = var.proxmox_api_token #ENV TF_VAR_proxmox_token=
    server_ip = "${var.cluster_ip_prefix}.${var.server_ip_last_octet}"
    client_ip = "${var.cluster_ip_prefix}.${var.client_ip_last_octet}"
    lxc_template = "230827134035-HashiPack-rockylinux-8-amd64.tar.gz"
}

module "nomad_server" {
    source = "../../modules/proxmox-lxc-nomad"
    os_template = local.lxc_template
    cpu_limit = 2
    memory_limit = 1024
    server_ip_address = local.server_ip
    client_ip_address = local.client_ip
    vmid = var.vmid_start
    isServer = true
    hostname = "NomadServer"
    lxc_password_var = "rockylinux"
    #define proxmox vars in ENVIRONMENT
    proxmox_api_url = local.api_url
    proxmox_api_user = local.api_user
    proxmox_api_token = local.api_token
}

module "nomad_lxc_client" {
    hostname = "NomadLxcClient"
    source = "../../modules/proxmox-lxc-nomad"
    os_template = local.lxc_template
    cpu_limit = 2
    memory_limit = 4192
    disk_size = "8G"
    server_ip_address = local.server_ip
    client_ip_address = "${var.cluster_ip_prefix}.${var.client_ip_last_octet}"
    vmid = var.vmid_start + 10
    isServer = false
    lxc_password_var = "rockylinux"
    #define proxmox vars in ENVIRONMENT
    proxmox_api_url = local.api_url
    proxmox_api_user = local.api_user
    proxmox_api_token = local.api_token
}

#module "nomad_vm_client" {
#    source = "../../modules/proxmox-vm-nomad"
#    template_name = "230827124613-Nomad-RockyLinux9"
#    isServer          = false
#    lxc_hostname      = "NomadVmClient"
#    vmid_start        = var.vmid_start + 20
#    proxmox_api_token = local.api_token
#    proxmox_api_url   = local.api_url
#    proxmox_api_user  = local.api_user
#    server_ip_address = local.server_ip
#    ip_address = "${var.cluster_ip_prefix}.${var.client_ip_last_octet+10}"
#}
#
