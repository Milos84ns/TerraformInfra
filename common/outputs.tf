output "lxc_hashi_template" { value = var.lxc_hashi_template }
output "lxc_docker_template" { value = var.lxc_docker_template }



output "consul_server_test" {
  value = {
    common_name     = var.consul_server_test.common_name
    ip              = var.consul_server_test.ip
    vmid            = var.consul_server_test.vmid
  }
}

output "consul_client_test" {
  value = {
    common_name     = var.consul_client_test.common_name
    ip              = var.consul_client_test.ip
    vmid            = var.consul_client_test.vmid
  }
}

output "vault_master_test" {
  value = {
    common_name     = var.vault_master_test.common_name
    ip              = var.vault_master_test.ip
    vmid            = var.vault_master_test.vmid
  }
}

output "docker_test" {
  value = {
    common_name     = var.docker_test.common_name
    ip              = var.docker_test.ip
    vmid            = var.docker_test.vmid
  }
}

output "standard_test_lxc" {
  value = {
    memory = var.standard_test_lxc.memory
    cpu = var.standard_test_lxc.cpu
    disksize = var.standard_test_lxc.disksize
  }
}

output "proxmox_setup" {
  value = {
    node = var.proxmox_setup.node
  }
}



