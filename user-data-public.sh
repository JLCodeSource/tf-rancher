#!/bin/bash

# Update
# NB - needed to handle grub issue
sudo apt-get update
sudo DEBIAN_FRONTEND=noninteractive apt-get -y --force-yes upgrade
sudo reboot

# create public_key

echo "ssh-rsa PUBLIC_KEY > /home/ubuntu/.ssh/id_rsa.pub

echo "#!/bin/bash" > /home/ubuntu/copy_keys.sh
echo "## Create private key id_rsa first" >> /home/ubuntu/copy_keys.sh
echo "scp .ssh/id_rsa.pub ubuntu@172.21.8.100:.ssh/id_rsa.pub" >> /home/ubuntu/copy_keys.sh
echo "scp .ssh/id_rsa.pub ubuntu@172.21.16.100:.ssh/id_rsa.pub" >> /home/ubuntu/copy_keys.sh
echo "scp .ssh/id_rsa.pub ubuntu@172.21.24.100:.ssh/id_rsa.pub" >> /home/ubuntu/copy_keys.sh
echo "scp .ssh/id_rsa ubuntu@172.21.8.100:.ssh/id_rsa" >> /home/ubuntu/copy_keys.sh
echo "scp .ssh/id_rsa ubuntu@172.21.16.100:.ssh/id_rsa" >> /home/ubuntu/copy_keys.sh
echo "scp .ssh/id_rsa ubuntu@172.21.24.100:.ssh/id_rsa" >> /home/ubuntu/copy_keys.sh
chmod 755 /home/ubuntu/copy_keys.sh
chown ubuntu:ubuntu /home/ubuntu/copy_keys.sh
