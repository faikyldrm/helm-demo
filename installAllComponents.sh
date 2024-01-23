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

processor_architecture=$(dpkg --print-architecture)

echo "kubectl install"
if [ "$processor_architecture" == "arm64" ]; then
  curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/arm64/kubectl"
else
   curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
fi

sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl


echo "Minikube install"
if [ "$processor_architecture" == "arm64" ]; then
  curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-arm64
  sudo install minikube-linux-arm64 /usr/local/bin/minikube
else
   curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
   sudo install minikube-linux-amd64 /usr/local/bin/minikube
fi


sudo usermod -aG docker $USER && sudo newgrp docker << subshell 
echo "minikube set drive"
minikube config set driver docker
echo "start minikube"
minikube start --driver=docker


echo "challange chart install"
if [ "$processor_architecture" == "arm64" ]; then
helm install challange -f ./helm/values.yaml  ./helm
elif [ "$processor_architecture" == "x86_64" ]; then
helm install challange    ./helm  --set producer.image.tag="v4"  --set consumer.image.tag="v2" 
 fi
