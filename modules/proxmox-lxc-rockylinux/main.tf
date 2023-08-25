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
}