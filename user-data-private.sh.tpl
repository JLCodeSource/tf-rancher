#!/bin/bash

#cloud-config
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
echo "    hostname_override: rancher01.${domain_name}" >> /home/ubuntu/rancher-cluster.yml
echo "  - address: 172.21.16.100" >> /home/ubuntu/rancher-cluster.yml
echo "    internal_address: 172.21.16.100" >> /home/ubuntu/rancher-cluster.yml
echo "    user: ubuntu" >> /home/ubuntu/rancher-cluster.yml
echo "    role: [controlplane, worker, etcd]" >> /home/ubuntu/rancher-cluster.yml
echo "    ssh_key_path: /home/ubuntu/.ssh/id_rsa" >> /home/ubuntu/rancher-cluster.yml
echo "    hostname_override: rancher02.${domain_name}" >> /home/ubuntu/rancher-cluster.yml
echo "  - address: 172.21.24.100" >> /home/ubuntu/rancher-cluster.yml
echo "    internal_address: 172.21.24.100" >> /home/ubuntu/rancher-cluster.yml
echo "    user: ubuntu" >> /home/ubuntu/rancher-cluster.yml
echo "    role: [controlplane, worker, etcd]" >> /home/ubuntu/rancher-cluster.yml
echo "    ssh_key_path: /home/ubuntu/.ssh/id_rsa" >> /home/ubuntu/rancher-cluster.yml
echo "    hostname_override: rancher03.${domain_name}" >> /home/ubuntu/rancher-cluster.yml
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
## Install rke
echo "echo '*** Installing rke' 2>&1 | tee -a ~/output.log" > /home/ubuntu/cluster_install.sh
echo "rke up -config /home/ubuntu/rancher-cluster.yml 2>&1 | tee -a ~/output.log" >> /home/ubuntu/cluster_install.sh
## Install kubectl
echo "echo '*** Installing kubectl' 2>&1 | tee -a ~/output.log" >> /home/ubuntu/cluster_install.sh
echo "sudo snap install kubectl --classic 2>&1 | tee -a ~/output.log" >> /home/ubuntu/cluster_install.sh
echo "export KUBECONFIG=/home/ubuntu/kube_config_rancher-cluster.yml" >> /home/ubuntu/cluster_install.sh
echo "mkdir /home/ubuntu/.kube" >> /home/ubuntu/cluster_install.sh
echo "cp /home/ubuntu/kube_config_rancher-cluster.yml /home/ubuntu/.kube/config 2>&1 | tee -a ~/output.log" >> /home/ubuntu/cluster_install.sh
## Install helm
echo "echo '*** Installing helm' 2>&1 | tee -a ~/output.log" >> /home/ubuntu/cluster_install.sh
echo "sudo snap install helm --classic 2>&1 | tee -a ~/output.log" >> /home/ubuntu/cluster_install.sh
## Check k8s
echo "echo '*** Checking K8s' 2>&1 | tee -a ~/output.log" >> /home/ubuntu/cluster_install.sh
echo "kubectl get nodes 2>&1 | tee -a ~/output.log" >> /home/ubuntu/cluster_install.sh
echo "kubectl get pods --all-namespaces 2>&1 | tee -a ~/output.log" >> /home/ubuntu/cluster_install.sh
## Add rancher repo
echo "echo '*** Adding rancher repo' 2>&1 | tee -a ~/output.log" >> /home/ubuntu/cluster_install.sh
echo "helm repo add rancher-stable https://releases.rancher.com/server-charts/stable 2>&1 | tee -a ~/output.log" >> /home/ubuntu/cluster_install.sh
# Create rancher namespace
echo "echo '*** Adding rancher namespace' 2>&1 | tee -a ~/output.log" >> /home/ubuntu/cluster_install.sh
echo "kubectl create namespace cattle-system 2>&1 | tee -a ~/output.log" >> /home/ubuntu/cluster_install.sh
# Get cert manager
echo "echo '*** Adding cert manager' 2>&1 | tee -a ~/output.log" >> /home/ubuntu/cluster_install.sh
echo "kubectl apply -f https://raw.githubusercontent.com/jetstack/cert-manager/release-0.12/deploy/manifests/00-crds.yaml 2>&1 | tee -a ~/output.log" >> /home/ubuntu/cluster_install.sh
# Create the namespace for cert-manager
echo "echo '*** Adding cert namespace' 2>&1 | tee -a ~/output.log" >> /home/ubuntu/cluster_install.sh
echo "kubectl create namespace cert-manager 2>&1 | tee -a ~/output.log" >> /home/ubuntu/cluster_install.sh
# Add the Jetstack Helm repository
echo "echo '*** Adding cert repo' 2>&1 | tee -a ~/output.log" >> /home/ubuntu/cluster_install.sh
echo "helm repo add jetstack https://charts.jetstack.io 2>&1 | tee -a ~/output.log" >> /home/ubuntu/cluster_install.sh

# Update your local Helm chart repository cache
echo "echo '*** Updating repos' 2>&1 | tee -a ~/output.log" >> /home/ubuntu/cluster_install.sh
echo "helm repo update 2>&1 | tee -a ~/output.log" >> /home/ubuntu/cluster_install.sh

# Install the cert-manager Helm chart
echo "echo '*** Installing cert manger chart' 2>&1 | tee -a ~/output.log" >> /home/ubuntu/cluster_install.sh
echo "helm install cert-manager jetstack/cert-manager --namespace cert-manager --version v0.12.0 2>&1 | tee -a ~/output.log" >> /home/ubuntu/cluster_install.sh

# Config cert-manager installed
echo "echo '*** Checking cert manager installed' 2>&1 | tee -a ~/output.log" >> /home/ubuntu/cluster_install.sh
echo "kubectl -n cert-manager rollout status deploy/cert-manager | tee -a ~/output.log" >> /home/ubuntu/cluster_install.sh
echo "kubectl -n cert-manager rollout status deploy/cert-manager-webhook | tee -a ~/output.log" >> /home/ubuntu/cluster_install.sh
echo "kubectl -n cert-manager rollout status deploy/cert-manager-cainjector | tee -a ~/output.log" >> /home/ubuntu/cluster_install.sh

# Check cert-manager
echo "echo '*** Checking cert-manager' 2>&1 | tee -a ~/output.log" >> /home/ubuntu/cluster_install.sh
echo "kubectl get pods --namespace cert-manager 2>&1 | tee -a ~/output.log" >> /home/ubuntu/cluster_install.sh

# Install rancher with letsEncrypt
echo "echo '*** Installing rancher with Lets Encrypt' 2>&1 | tee -a ~/output.log" >> /home/ubuntu/cluster_install.sh
echo "helm install rancher rancher-stable/rancher --namespace cattle-system --set hostname=${domain_name} --set ingress.tls.source=letsEncrypt --set letsEncrypt.email=firstname.lastname@tf.com 2>&1 | tee -a ~/output.log" >> /home/ubuntu/cluster_install.sh

# Check rancher deployment
echo "echo '*** Checking rancher deployment' 2>&1 | tee -a ~/output.log" >> /home/ubuntu/cluster_install.sh
echo "kubectl -n cattle-system rollout status deploy/rancher 2>&1 | tee -a ~/output.log" >> /home/ubuntu/cluster_install.sh
# Check pods
echo "echo '*** Checking kube setup' 2>&1 | tee -a ~/output.log" >> /home/ubuntu/cluster_install.sh
echo "kubectl get pods --all-namespaces -o wide 2>&1 | tee -a ~/output.log" >> /home/ubuntu/cluster_install.sh
echo "echo '*** Rancher Installed' 2>&1 | tee -a ~/output.log" >> /home/ubuntu/cluster_install.sh

chmod 755 /home/ubuntu/cluster_install.sh

echo "${public_key}" > /home/ubuntu/.ssh/id_rsa.pub
echo "${private_key}" > /home/ubuntu/.ssh/id_rsa

# Restart ready for install

sudo reboot
