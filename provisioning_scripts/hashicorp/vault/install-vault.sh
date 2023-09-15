#!/usr/bin/env bash
set -euxo pipefail

# Variables
IP_ADDRESS=$(/sbin/ip -o -4 addr list eth0 | awk '{print $4}' | cut -d/ -f1)

directory_setup() {
  sudo mkdir -pm 0750 /etc/${1}.d /var/lib/${1} /opt/${1}/data
 # sudo mkdir -pm 0700 /etc/${1}.d/tls
  sudo chown -R ${2}:${2} /etc/${1}.d /opt/${1}/data
}

mkdir /etc/vault /etc/ssl/vault /mnt/vault
chown vault /etc/vault /etc/ssl/vault /mnt/vault /etc/tls
chmod 750 /etc/vault /etc/ssl/vault

directory_setup vault vault

cat <<EOF | sudo tee /etc/vault/config.hcl
disable_mlock = true
ui            = true

listener "tcp" {
  address = "$IP_ADDRESS:8200"
  cluster_address = "$IP_ADDRESS:8201"
  #api_addr = "$IP_ADDRESS:8200"
   tls_disable = 0
   tls_cert_file = "/etc/tls/vault.crt.pem"
   tls_key_file = "/etc/tls/vault.key"
   tls_disable_client_certs = "true"
}

#service_registration "consul" {
#  address      = "127.0.0.1:8500"
#}

storage "file" {
  path = "/opt/vault/data"
}
log_level = "INFO"
EOF

echo '[Unit]
Description="HashiCorp Vault - A tool for managing secrets"
Documentation=https://www.vaultproject.io
Requires=network-online.target
After=network-online.target
ConditionFileNotEmpty=/etc/vault/config.hcl
StartLimitIntervalSec=60

[Service]
User=vault
Group=vault
ProtectSystem=full
ProtectHome=read-only
PrivateTmp=yes
PrivateDevices=yes
SecureBits=keep-caps
AmbientCapabilities=CAP_IPC_LOCK
CapabilityBoundingSet=CAP_SYSLOG CAP_IPC_LOCK
NoNewPrivileges=yes
ExecStart=vault server -config=/etc/vault/config.hcl
ExecReload=/bin/kill -- signal HUP $MAINPID
KillMode=process
KillSignal=SIGINT
TimeoutStopSec=30s
Restart=on-failure
RestartSec=5
StartLimitBurst=3

[Install]
WantedBy=multi-user.target' >> /etc/systemd/system/vault.service

export VAULT_ADDR=http://$IP_ADDRESS
export VAULT_API_ADDR=http://$IP_ADDRESS
echo "Vault Installed at http://$IP_ADDRESS:8200"
sudo chmod 0644 /etc/systemd/system/vault.service
systemctl enable vault.service
service vault start

sudo firewall-cmd --add-port=8200/tcp --permanent
sudo firewall-cmd --add-port=8201/tcp --permanent
firewall-cmd --reload