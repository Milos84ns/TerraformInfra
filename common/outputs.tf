output "lxc_hashi_template" { value = var.lxc_hashi_template }


output "consul_server_test" {
  value = {
    common_name     = var.consul_server_test.common_name
    ip              = var.consul_server_test.ip
  }
}

output "consul_client_test" {
  value = {
    common_name     = var.consul_client_test.common_name
    ip              = var.consul_client_test.ip
  }
}



