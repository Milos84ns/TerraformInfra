variable "vmid_start" {
  type = number
  default = 1100
}

variable "server_ip_last_octet" {
  type = number
  default = 100
}
variable "client_ip_last_octet" {
  type = number
  default = 120
}
variable "proxmox_api_user" {
  type = string
}
variable "proxmox_api_token" {
  type = string
}
variable "proxmox_api_url" {
  type = string
}



