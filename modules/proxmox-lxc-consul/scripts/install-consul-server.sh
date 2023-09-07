CONSUL_VERSION=1.15.3
# Variables
IP_ADDRESS=$(/sbin/ip -o -4 addr list eth0 | awk '{print $4}' | cut -d/ -f1)

directory_setup() {
  sudo mkdir -pm 0750 /etc/${1}.d /var/lib/${1} /opt/${1}/data /opt/${1}/logs
  sudo mkdir -pm 0700 /etc/${1}.d/tls
  sudo chown -R ${2}:${2} /etc/${1}.d /opt/${1}/data
}

directory_setup consul consul

cat <<EOF > /opt/consul/server.hcl
 node_name = "ConsulServer"
 server = true
 datacenter = "us-east-1"
 primary_datacenter = "dc1"
 bootstrap_expect = 1

 client_addr = "127.0.0.1 $IP_ADDRESS"
 serf_lan = "$IP_ADDRESS"
 advertise_addr = "$IP_ADDRESS"

 data_dir = "/opt/consul/data"

 ui_config {
   enabled = true
  }
ports {
 http = -1,
 https = 8501
}

log_level = "INFO"
log_file = "/opt/consul/logs/log"
log_rotate_max_files = 30
log_rotate_duration = "24h"
enable_agent_tls_for_checks = false
EOF

echo "Create Start service"

cat <<EOF > /usr/lib/systemd/system/consul.service
[Unit]
Description=consul.agent
Requires=network-online.target
After=network-online.target

[Service]
Restart=on-failure
ExecStart=consul agent \
  -config-file=/opt/consul/server.hcl \
  -config-dir=/opt/consul \
  -data-dir=/opt/consul/data

ExecReload=/bin/kill -HUP $MAINPID
KillSignal=SIGINT
KillMode=process

[Install]
WantedBy=multi-user.target
EOF
echo "Consul started at http://${IP_ADDRESS}:8500"
echo "Done...starting service now."
systemctl enable consul.service
systemctl start consul.service

sudo firewall-cmd --add-port=8300/tcp --permanent
sudo firewall-cmd --add-port=8301/tcp --permanent
sudo firewall-cmd --add-port=8301/udp --permanent #consul clients to connect - LAN Serf: The Serf LAN port (TCP and UDP)
sudo firewall-cmd --add-port=8500/tcp --permanent
sudo firewall-cmd --add-port=8501/tcp --permanent
sudo firewall-cmd --add-port=8600/tcp --permanent
sudo firewall-cmd --add-port=8600/udp --permanent

firewall-cmd --reload