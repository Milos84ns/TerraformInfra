terraform {
  required_providers {
    proxmox = {
      source = "telmate/proxmox"
      version = "2.9.14"
    }
  }
}

provider "proxmox" {
  # URL of proxmox API
  pm_api_url = var.proxmox_api_url
  # API token id
  pm_api_token_id = var.proxmox_api_user
  # This is the secret value of the api token
  pm_api_token_secret = var.proxmox_api_token
  pm_tls_insecure = true
}
resource "proxmox_vm_qemu" "test_nomad_client" {
  count = 1 # just want 1 for now, set to 0 and apply to destroy VM
  name = "TestNomadClient" #count.index starts at 0, so + 1 means this VM will be named test-vm-1 in proxmox
  # this now reaches out to the vars file. I could've also used this var above in the pm_api_url setting but wanted to spell it out up there. target_node is different than api_url. target_node is which node hosts the template and thus also which node will host the new VM. it can be different than the host you use to communicate with the API. the variable contains the contents "prox-1u"
  target_node = var.proxmox_host
  # another variable with contents "ubuntu-2004-cloudinit-template"
  clone = var.template_name
  # basic VM settings here. agent refers to guest agent
  agent = 1
  full_clone = true
  os_type = "CentOS"
  cores = 2
  sockets = 1
  cpu = "host"
  vmid = var.vmid_start
  memory = 4192
  scsihw = "virtio-scsi-pci"
  bootdisk = "scsi0"

  disk {
    slot = 0
    # set disk size here. leave it small for testing because expanding the disk takes time.
    size = "64G"
    type = "scsi"
    storage = "local-zfs"
    iothread = 1
  }

  # if you want two NICs, just copy this whole network section and duplicate it
  network {
    model = "virtio"
    bridge = "vmbr0"
  }
#  # not sure exactly what this is for. presumably something about MAC addresses and ignore network changes during the life of the VM
  lifecycle {
    ignore_changes = [
      network,
    ]
  }

  # the ${count.index + 1} thing appends text to the end of the ip address
  # in this case, since we are only adding a single VM, the IP will
  # be 10.98.1.91 since count.index starts at 0. this is how you can create
  # multiple VMs and have an IP assigned to each (.91, .92, .93, etc.)
  ipconfig0 = "ip=${var.ip_address}/22,gw=${var.gateway_ip_address}"

  # sshkeys set using variables.tf. the variable contains the text of the key.
  sshkeys = <<EOF
  ${var.ssh_key}
  EOF

  provisioner "file" {
    source      = "install-nomad-client.sh"
    destination = "/tmp/install-nomad.sh ${var.server_ip_address} NomadVmClient "


    connection {
      type     = "ssh"
      user     = "root"
      password = "Packer"
      host     = var.ip_address
    }
  }

  provisioner "remote-exec" {
    inline = [
      "echo 'Execute installation'",
      "cd /tmp",
      "sh install-nomad.sh "
    ]

    connection {
      type     = "ssh"
      user     = "localadmin"
      password = "Packer"
      host     = var.ip_address
    }
  }
}
