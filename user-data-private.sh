#! /bin/bash

# Update
# NB - needed to handle grub issue
sudo apt-get update
sudo apt-get -y upgrade

# Install tools
sudo apt-get -y install docker.io jq

# Download rke K8s installer
curl -s https://api.github.com/repos/rancher/rke/releases/latest | jq -r ".assets[] | select(.name | test(\"rke_linux-amd64\")) | .browser_download_url"
curl -L $(cat latest.txt) --output rke_linux-amd 

# Install rke K8s installer
sudo chmod 755 rke_linux-amd
sudo chown root:root rke_linux-amd
sudo mv rke_linux-amd /usr/local/bin/rke


