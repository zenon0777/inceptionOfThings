kubectl create namespace gitlab
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
chmod 700 get_helm.sh
./get_helm.sh
kubectl config set-context --current --namespace=gitlab
helm repo add gitlab https://charts.gitlab.io/
helm repo update
helm install gitlab gitlab/gitlab \
    --set global.hosts.https="false" \
    --set global.ingress.configureCertmanager="false" \
    --set gitlab-runner.install="false" -n gitlab
sleep 30
kubectl port-forward svc/gitlab-webservice-default -n gitlab 8181:8181 --address 0.0.0.0

kubectl get secret -n gitlab gitlab-gitlab-initial-root-password -o jsonpath="{.data.password}" | base64 --decode

# glpat-3uoo1gb-C8DCM873dVrq
