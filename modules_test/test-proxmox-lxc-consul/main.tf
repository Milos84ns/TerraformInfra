locals {
    api_url = var.proxmox_api_url #ENV TF_VAR_proxmox_api_url=
    api_user = var.proxmox_api_user #ENV TF_VAR_proxmox_api_user=
    api_token = var.proxmox_api_token #ENV TF_VAR_proxmox_token=
    server_ip = "${var.cluster_ip_prefix}.${var.server_ip_last_octet}"
    client_ip = "${var.cluster_ip_prefix}.${var.client_ip_last_octet}"
    client_nodes = [ "NodeClient01","NodeClient02","NodeClient03"]
}

module "common" {
    source = "../../common"
}

module "consul_server" {
    source = "../../modules/proxmox-lxc-consul"
    os_template = module.common.lxc_hashi_template
    server_ip_address = module.common.consul_server_test.ip
    client_ip_address = module.common.consul_client_test.ip
    vmid = var.vmid_start
    isServer = true
    hostname = "ConsulServer"
    lxc_password_var = "rockylinux"
    #define proxmox vars in ENVIRONMENT
    proxmox_api_url = local.api_url
    proxmox_api_user = local.api_user
    proxmox_api_token = local.api_token
}

module "consul_client" {
    source = "../../modules/proxmox-lxc-consul"
    os_template = module.common.lxc_hashi_template
    server_ip_address = module.common.consul_server_test.ip
    client_ip_address = module.common.consul_client_test.ip
    vmid = 1110
    isServer = false
    hostname = "ConsulClient"
    lxc_password_var = "rockylinux"
    #define proxmox vars in ENVIRONMENT
    proxmox_api_url = local.api_url
    proxmox_api_user = local.api_user
    proxmox_api_token = local.api_token
}


