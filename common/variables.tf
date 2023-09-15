#----------------------------------------------------------------------------------------------------------------------
# General Variables
# ---------------------------------------------------------------------------------------------------------------------
variable "lxc_hashi_template" { default =  "230911053458-HashiPack-rockylinux-8-amd64.tar.gz"}
variable "lxc_docker_template" { default =  "230909041018-DockerLXC-rockylinux-8-amd64.tar.gz"}


variable "hosted_zone_domain_nme" {
  description = "The domain name of the Hosted zone to add a DNS entry(e.g. example.com"
  type = string
  default = "example.com"
}

variable "ddns_zones" {
  default = {
    ddns_net = ".ddns.net" //FreeDNS zone
    my_to = ".my.to" // FreeDNS zone
  }
}
#----------------------------------------------------------------------------------------------------------------------
# HashiCorp variables
# ---------------------------------------------------------------------------------------------------------------------

variable "consul_cluster_name" { default = ""}
variable "nomad_cluster_name" { default =  ""}
variable "vault_cluster_name" { default = ""}


#----------------------------------------------------------------------------------------------------------------------
# Proxmox Variables
# ---------------------------------------------------------------------------------------------------------------------
variable "proxmox_setup" {
  default = {
    node = "pve"
  }
}

# ---------------------------------------------------------------------------------------------------------------------

variable "standard_test_lxc" {
  default = {
    memory = 1024
    cpu = 2
    disksize = "8GB"
  }
}

variable "consul_server_test" {
  default = {
    ip          = "52.80.0.110"
    common_name = "ConsulServer"
    vmid        = 1100
  }
}

variable "consul_client_test" {
  default = {
    ip          = "52.80.0.111"
    common_name = "ConsulClient"
    vmid        = 1105
  }
}

variable "vault_master_test" {
  default = {
    ip          = "52.80.0.112"
    common_name = "VaultMaster"
    vmid        = 1110
  }
}

variable "docker_test" {
  default = {
    ip          = "52.80.0.113"
    common_name = "DockerTest"
    vmid        = 1115
  }
}

