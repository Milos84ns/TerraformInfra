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
    size    = "8G"
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
    source      = var.isServer == true ? "install-nomad-server.sh"  : "install-nomad-client.sh"
    destination = "/tmp/install-nomad.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "cd /tmp",
      "sh install-nomad.sh ${var.server_ip_address} NomadClient"
    ]
  }
}