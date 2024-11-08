#!/bin/bash

export DEBIAN_FRONTEND=noninteractive
apt-get update
apt-get install -y curl

cat /home/vagrant/.ssh/me.pub >>/home/vagrant/.ssh/authorized_keys
mkdir -p /root/.ssh

cat /home/vagrant/.ssh/me.pub >>/root/.ssh/authorized_keys

# Install K3s server

curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC="server \
  --node-ip=192.168.56.110 \
  --advertise-address=192.168.56.110" sh -

# Create Docker Hub credentials secret
sudo k3s kubectl create secret docker-registry dockerhub-secret \
  --docker-username="its0me" \
  --docker-password="\$\$aDocker\$\$12"

# apply the configurations
sudo kubectl apply -f ./confs/web-app-1/web-app-1-deployement.yaml
sudo kubectl apply -f ./confs/web-app-2/web-app-2-deployement.yaml
sudo kubectl apply -f ./confs/web-app-3/web-app-3-deployement.yaml
sudo kubectl apply -f ./confs/web-app-1/web-app-1-service.yaml
sudo kubectl apply -f ./confs/web-app-2/web-app-2-service.yaml
sudo kubectl apply -f ./confs/web-app-3/web-app-3-service.yaml
sudo kubectl apply -f ./confs/ingress.yaml
