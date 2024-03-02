# provision-consul.sh
# Este script instala Consul en el nodo y configura su archivo de configuración

# Instalación de Consul
sudo apt-get update -y
sudo apt-get install net-tools -y
sudo apt-get install nano -y
sudo apt-get install vim -y
sudo apt install git -y

# Instalación de Consul
wget -O- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt update -y
sudo apt install consul -y
sudo consul -v

sudo echo '# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: BUSL-1.1

# Full configuration options can be found at https://www.consul.io/docs/agent/config

# datacenter
# This flag controls the datacenter in which the agent is running. If not provided,
# it defaults to "dc1". Consul has first-class support for multiple datacenters, but
# it relies on proper configuration. Nodes in the same datacenter should be on a
# single LAN.
#datacenter = "my-dc-1"

# data_dir
# This flag provides a data directory for the agent to store state. This is required
# for all agents. The directory should be durable across reboots. This is especially
# critical for agents that are running in server mode as they must be able to persist
# cluster state. Additionally, the directory must support the use of filesystem
# locking, meaning some types of mounted folders (e.g. VirtualBox shared folders) may
# not be suitable.
data_dir = "/opt/consul"
enable_local_script_checks = true

# client_addr
# The address to which Consul will bind client interfaces, including the HTTP and DNS
# servers. By default, this is "127.0.0.1", allowing only loopback connections. In
# Consul 1.0 and later this can be set to a space-separated list of addresses to bind
# to, or a go-sockaddr template that can potentially resolve to multiple addresses.
#client_addr = "0.0.0.0"

# ui
# Enables the built-in web UI server and the required HTTP routes. This eliminates
# the need to maintain the Consul web UI files separately from the binary.
# Version 1.10 deprecated ui=true in favor of ui_config.enabled=true
#ui_config{
#  enabled = true
#}

# server
# This flag is used to control if an agent is in server or client mode. When provided,
# an agent will act as a Consul server. Each Consul cluster must have at least one
# server and ideally no more than 5 per datacenter. All servers participate in the Raft
# consensus algorithm to ensure that transactions occur in a consistent, linearizable
# manner. Transactions modify cluster state, which is maintained on all server nodes to
# ensure availability in the case of node failure. Server nodes also participate in a
# WAN gossip pool with server nodes in other datacenters. Servers act as gateways to
# other datacenters and forward traffic as appropriate.
#server = true

# Bind addr
# You may use IPv4 or IPv6 but if you have multiple interfaces you must be explicit.
#bind_addr = "[::]" # Listen on all IPv6
#bind_addr = "0.0.0.0" # Listen on all IPv4
#
# Advertise addr - if you want to point clients to a different address than bind or LB' > /etc/consul.d/consul.hcl

sudo echo '{
  "service": {
    "Name": "web",
    "Port": 80,
    "check": {
      "args": ["curl", "192.168.100.6"],
      "interval": "3s"
    }
  }
}' > /etc/consul.d/web-service.json

# Instalar componentes para microservicios
sudo apt update -y 
sudo apt upgrade -y
sudo apt install apache2 -y
sudo systemctl enable apache2
sudo chmod 777 /var/www/html/index.html
sudo echo "Hello from nodo2" > /var/www/html/index.html

# Arrancar agente de Consul
sudo consul agent   -ui   -node=agent-two   -bind=192.168.100.6   -enable-script-checks=true  -client=0.0.0.0   -data-dir=.   -config-dir=/etc/consul.d
sleep 8
sudo consul join 192.168.100.5
sudo consul members