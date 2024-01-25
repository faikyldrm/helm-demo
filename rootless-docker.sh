#!/bin/bash
echo "Docker Install"
sudo apt-get install uidmap -y
curl -fsSL https://get.docker.com/rootless -o get-docker.sh
export SKIP_IPTABLES=1
export FORCE_ROOTLESS_INSTALL=1
sh get-docker.sh
echo export PATH=/home/$USER/bin:$PATH >> ~/.bashrc
export userID=$(id -u $USER)
echo export DOCKER_HOST=export DOCKER_HOST=unix:///run/user/$userID/docker.sock >> ~/.bashrc
sudo groupadd docker
sudo gpasswd -a $USER docker
