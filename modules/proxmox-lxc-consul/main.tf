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

module "common" {
  source = "../../common"
}

resource "proxmox_lxc" "basic" {
  target_node  = module.common.proxmox_setup.node
  hostname     = var.hostname
  ostemplate   = "local:vztmpl/${module.common.lxc_hashi_template}"
  password     = var.lxc_password_var
  unprivileged = true
  cores        = module.common.standard_test_lxc.cpu
  memory       = module.common.standard_test_lxc.memory
  vmid         = var.vmid
  onboot       = true // need to start to ssh to the box
  start        = true //start lxc if needed

  // Terraform will crash without rootfs defined
  rootfs {
    storage = "local-zfs"
    size    = module.common.standard_test_lxc.disksize
  }

  network {
    name   = "eth0"
    bridge = "vmbr0"
    ip     = var.isServer == true ? "${var.server_ip_address}/24" : "${var.client_ip_address}/24"
  }

  connection {
    type     = "ssh"
    user     = "root"
    password = var.lxc_password_var
    host     = var.isServer == true ? var.server_ip_address : var.client_ip_address
  }

  provisioner "file" {
    source      = var.isServer == true ? "../../provisioning_scripts/hashicorp/consul/install-consul-server.sh"  : "../../provisioning_scripts/hashicorp/consul/install-consul-client.sh"
    destination = "/tmp/install-consul.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "cd /tmp",
      "sh install-consul.sh ${var.server_ip_address} ConsulClient"
    ]
  }
}