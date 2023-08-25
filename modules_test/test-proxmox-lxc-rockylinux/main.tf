locals {
    api_url = var.proxmox_api_url #ENV TF_VAR_proxmox_api_url=
    api_user = var.proxmox_api_user #ENV TF_VAR_proxmox_api_user=
    api_token = var.proxmox_api_token #ENV TF_VAR_proxmox_token=
    lxc_template = "230820145659-HashiPack-rockylinux-8-amd64.tar.gz"
    lxc_password_var = "rockylinux"
    hostname = "TestLXC"
    ip_address = "52.80.0.66"
}

module "test_lxc" {
    source = "../../modules/proxmox-lxc-rockylinux"
    os_template = local.lxc_template
    cpu_limit = 2
    memory_limit = 1024
    vmid = var.vmid_start
    isServer = true
    ip_address = local.ip_address
    hostname = local.hostname
    lxc_password_var = local.lxc_password_var

    #define proxmox vars in ENVIRONMENT
    proxmox_api_url = local.api_url
    proxmox_api_user = local.api_user
    proxmox_api_token = local.api_token
}

resource "null_resource" "test"{
    depends_on = [module.test_lxc]
    connection {
        type     = "ssh"
        user     = "root"
        password = local.lxc_password_var
        host     = local.ip_address
    }

    provisioner "remote-exec" {
        inline = [
            "cd /tmp",
            "echo 'Testing LXC'",
            "echo 'Removing Container in 5s'",
            "sleep 10"
        ]
    }
}
