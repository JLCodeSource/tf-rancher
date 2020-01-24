#!/bin/bash

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

curl -L $(curl -s https://api.github.com/repos/rancher/rke/releases/latest | jq -r ".assets[] | select(.name | test(\"rke_linux-amd64\")) | .browser_download_url") --output rke_linux-amd 

# Install rke K8s installer
sudo chmod 755 rke_linux-amd
sudo chown root:root rke_linux-amd
sudo mv rke_linux-amd /usr/local/bin/rke

# Restart ready for install
sudo reboot