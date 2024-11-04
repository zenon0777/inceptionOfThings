apt-get update
apt-get install -y curl git vim
curl -fsSL https://get.docker.com -o get-docker.sh && sh get-docker.sh
curl -s https://raw.githubusercontent.com/rancher/k3d/main/install.sh | bash
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
sleep 5
kubectl version --client
k3d --version
k3d cluster create argocd-cluster --api-port 6443
kubectl create namespace argocd
kubectl create namespace dev
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
sleep 5
kubectl patch svc argocd-server -n argocd -p '{"spec": {"type": "NodePort"}}'
git clone https://github.com/zenon0777/K3d-and-Argo-CD-adaifi.git
kubectl apply -f K3d-and-Argo-CD-adaifi/application.yaml
sleep 60
echo -e "\e[91mArgoCD Initial Admin Password: \e[0m"
kubectl get secret argocd-initial-admin-secret -n argocd -o jsonpath="{.data.password}" | base64 -d && echo "\n"
echo -e "\e[91mArgoCD UI: \e[0m"
kubectl port-forward svc/argocd-server -n argocd 8080:443 --address 0.0.0.0
kubectl port-forward service/web-app-1-service -n dev 8888:80 --address 0.0.0.0
kubectl get all --all-namespaces