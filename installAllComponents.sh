#!/bin/bash
echo "Docker Install"
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh
sudo groupadd docker
sudo gpasswd -a $USER docker
sudo service docker restart
docker context use default

echo "Helm install"
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3
chmod +x get_helm.sh
./get_helm.sh
rm get_helm.sh


echo "kubectl install"
  curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/arm64/kubectl"
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl


echo "Minikube install"
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-arm64
sudo install minikube-linux-arm64 /usr/local/bin/minikube
sudo usermod -aG docker $USER && newgrp docker << subshell 
echo "minikube set drive"
minikube config set driver docker
echo "start minikube"
minikube start


echo "challange chart install"

helm install challange -f ./helm/values.yaml  ./helm


 