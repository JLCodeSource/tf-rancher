#!/bin/bash

# Variable
export SETUP_DOMAIN_NAME="rancher.tf-support.com"


# Update
# NB - needed to handle grub issue
sudo apt-get update
sudo DEBIAN_FRONTEND=noninteractive apt-get -y --force-yes upgrade

# Install tools
sudo apt-get -y --force-yes install docker.io jq ntp

# Add Docker permissions
sudo groupadd docker
sudo usermod -aG docker ubuntu

# Download rke K8s installer

echo "Installing rke"
curl -L $(curl -s https://api.github.com/repos/rancher/rke/releases/latest | jq -r ".assets[] | select(.name | test(\"rke_linux-amd64\")) | .browser_download_url") --output rke_linux-amd 


# Install rke K8s installer
sudo chmod 755 rke_linux-amd
sudo chown root:root rke_linux-amd
sudo mv rke_linux-amd /usr/local/bin/rke

# Create rancher-cluster.yml
echo "nodes:" > /home/ubuntu/rancher-cluster.yml
echo "  - address: 172.21.8.100" >> /home/ubuntu/rancher-cluster.yml
echo "    internal_address: 172.21.8.100" >> /home/ubuntu/rancher-cluster.yml
echo "    user: ubuntu" >> /home/ubuntu/rancher-cluster.yml
echo "    role: [controlplane, worker, etcd]" >> /home/ubuntu/rancher-cluster.yml
echo "    ssh_key_path: /home/ubuntu/.ssh/id_rsa" >> /home/ubuntu/rancher-cluster.yml
echo "    hostname_override: rancher01.$SETUP_DOMAIN_NAME" >> /home/ubuntu/rancher-cluster.yml
echo "  - address: 172.21.16.100" >> /home/ubuntu/rancher-cluster.yml
echo "    internal_address: 172.21.16.100" >> /home/ubuntu/rancher-cluster.yml
echo "    user: ubuntu" >> /home/ubuntu/rancher-cluster.yml
echo "    role: [controlplane, worker, etcd]" >> /home/ubuntu/rancher-cluster.yml
echo "    ssh_key_path: /home/ubuntu/.ssh/id_rsa" >> /home/ubuntu/rancher-cluster.yml
echo "    hostname_override: rancher02.$SETUP_DOMAIN_NAME" >> /home/ubuntu/rancher-cluster.yml
echo "  - address: 172.21.24.100" >> /home/ubuntu/rancher-cluster.yml
echo "    internal_address: 172.21.24.100" >> /home/ubuntu/rancher-cluster.yml
echo "    user: ubuntu" >> /home/ubuntu/rancher-cluster.yml
echo "    role: [controlplane, worker, etcd]" >> /home/ubuntu/rancher-cluster.yml
echo "    ssh_key_path: /home/ubuntu/.ssh/id_rsa" >> /home/ubuntu/rancher-cluster.yml
echo "    hostname_override: rancher03.$SETUP_DOMAIN_NAME" >> /home/ubuntu/rancher-cluster.yml
echo "" >> /home/ubuntu/rancher-cluster.yml
echo "cluster_name: tf-rancher" >> /home/ubuntu/rancher-cluster.yml
echo "prefix_path: /opt/rke" >> /home/ubuntu/rancher-cluster.yml
echo "" >> /home/ubuntu/rancher-cluster.yml
echo "services:" >> /home/ubuntu/rancher-cluster.yml
echo "  etcd:" >> /home/ubuntu/rancher-cluster.yml
echo "    snapshot: true" >> /home/ubuntu/rancher-cluster.yml
echo "    creation: 6h" >> /home/ubuntu/rancher-cluster.yml
echo "    retention: 24h" >> /home/ubuntu/rancher-cluster.yml
echo "" >> /home/ubuntu/rancher-cluster.yml
echo "ingress:" >> /home/ubuntu/rancher-cluster.yml
echo "  provider:" nginx >> /home/ubuntu/rancher-cluster.yml
echo "  options:" >> /home/ubuntu/rancher-cluster.yml
echo "    use-forwarded-headers: \"true\"" >> /home/ubuntu/rancher-cluster.yml

# Create rke install script
echo "rke up -config /home/ubuntu/rancher-cluster.yml" > /home/ubuntu/cluster_install.sh
echo "sudo snap install kubectl --classic" >> /home/ubuntu/cluster_install.sh
echo "export KUBECONFIG=/home/ubuntu/kube_config_rancher-cluster.yml" >> /home/ubuntu/cluster_install.sh
echo "cp /home/ubuntu/kube_config_rancher-cluster.yml /home/ubuntu/.kube/config"
echo "sudo snap install helm --classic" >> /home/ubuntu/cluster_install.sh
chmod 755 /home/ubuntu/cluster_install.sh

# Restart ready for install
sudo reboot
