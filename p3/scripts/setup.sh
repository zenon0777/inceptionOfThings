#!/bin/bash

# Colors for output
GREEN='\033[0;32m'
NC='\033[0m'

echo_step() {
    echo -e "${GREEN}[+] $1${NC}"
}


# Update system
echo_step "Updating system packages..."
sudo apt-get update && apt-get upgrade -y


# Install Docker if not present
echo_step "Installing Docker..."
sudo apt-get install -y docker.io
sudo systemctl start docker
sudo systemctl enable docker


# Install kubectl
echo_step "Installing kubectl..."
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
chmod +x kubectl
mv kubectl /usr/local/bin/



# Install K3D
echo_step "Installing K3D..."
wget -q -O - https://raw.githubusercontent.com/k3d-io/k3d/main/install.sh | bash


# Create K3D cluster
echo_step "Creating K3D cluster..."
k3d cluster create mycluster


# Install Argo CD
echo_step "Installing Argo CD..."
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

# Wait until the Argo CD server pod is running
while [[ $(kubectl get pods -n argocd -l app.kubernetes.io/name=argocd-server -o jsonpath='{.items[0].status.phase}') != "Running" ]]; do
  echo_step "Waiting for Argo CD server pod to be in 'Running' status..."
  sleep 5
done

# Apply Argo CD application
echo_step "Applying Argo CD application..."
kubectl apply -n argocd -f https://raw.githubusercontent.com/zenon0777/K3d-and-Argo-CD-adaifi/refs/heads/main/application.yaml


# get password
echo_step "Retrieving Argo CD initial admin password..."
echo "Argo CD Initial Admin Password: $(kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d)"

# # Install Argo CD CLI
echo_step "Installing Argo CD CLI..."
curl -sSL -o /usr/local/bin/argocd https://github.com/argoproj/argo-cd/releases/latest/download/argocd-linux-amd64
chmod +x /usr/local/bin/argocd

echo_step "Installation complete!"
echo_step "You can access Argo CD UI by port-forwarding:"
echo_step "kubectl port-forward -n argocd svc/argocd-server -n argocd 8080:443 --address 0.0.0.0"
echo_step "kubectl port-forward service/web-app-1-service -n dev 8888:80 --address 0.0.0.0"

# get machine ip
ip=$(hostname -I | awk '{print $1}')
echo "Then visit: https://$ip:8080"
