### PROXMOX VARS ###
variable "proxmox_api_url" {
  type = string
}
variable "proxmox_api_user" {
  type = string
}
variable "proxmox_api_token" {
  type = string
}
variable "lxc_password_var" {
  type = string
}

### LXC VARS ###
variable "hostname" {
  type = string
}
variable "os_template" {
  type = string
}
#variable "server_ip_prefix" {
#  type = string
#}
variable "cpu_limit" {
  type = number
}

variable "disk_size" {
  default = "8G"
}
variable "memory_limit" {
  type = number
}
variable "vmid" {
  type = number
}
variable "isServer" {
  type = bool
}

variable "client_ip_address" {
  type = string
  default = "192.168.0.100"
}

variable "server_ip_address" {
  type = string
  default = "192.168.0.1"
}


