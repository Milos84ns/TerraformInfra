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
variable "cpu_limit" {
  type = number
}
variable "memory_limit" {
  type = number
}
variable "storage_size" {
  type = string
  default = "8G"
}
variable "vmid" {
  type = number
}
variable "isServer" {
  type = bool
}

variable "ip_address" {
  type = string
  default = "192.168.0.100"
}

