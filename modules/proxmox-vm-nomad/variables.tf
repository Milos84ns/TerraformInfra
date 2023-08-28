
variable "proxmox_host" {
  default = "pve"
}

variable "template_name" {
  default = "Template"
}

variable "ssh_key" {
  default = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC1WVEaWY0hmc24c37Hh5M/KEk/HSshgHLBPv93lyjixDkc5veYLeJ9dLyC5yo9ul+uVj3xGcKQm95kkdPwI/4yGMT0JT3WYTgf3Wy7vF2Su9k229g2nYTU/hW3M6XYQP3dx8Eb/qeWZOlWlGdjmHfLol2KQPZBVd0qaflKjXfcGiHdYDO72ZGGvQEEAT5F8xPgAg8bNgGIbul7ln7gQAOer0KNlCPJPqy4SnuMIc8vX6whakVa84l5njp4OeWQyxH/cSLtumWu7FSmwO/z5lS5x5Pr5oj0NB8r3Qu5rRxhzrODTw865HjIhM3MxhYuvZOJuhaveVAMbqK9hlGygoJnSIiKx/sNANYCVEcOS1svlzAONQUUG8HRduHMQycAw41QbxmukYrBONa5ILM1K5YO801pIo0ATM2uTjS6CBhj69h32ixiYDUNMAeH+N8IPoB6LDtnwsZ978szd1oAaCmMpnJJoRpu/O3vC6/W0KCOGNeW7iQGYEMsCjSlaJjwyzk= milos@pop-os"
}

variable "lxc_hostname" {
  type = string
}

variable "ip_address" {
  type = string
  default = "192.168.0.100"
}

variable "gateway_ip_address" {
  type = string
  default = "192.168.0.1"
}

variable "vmid_start" {
  type = number
  default = 1100
}
variable "isServer" {
  type = bool
}


variable "server_ip_last_octet" {
  type = number
  default = 100
}
variable "client_ip_last_octet" {
  type = number
  default = 120
}

variable "cluster_ip_prefix" {
  type = string
  default = "52.80.0"
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



