curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
chmod 700 get_helm.sh
./get_helm.sh
helm repo add gitlab https://charts.gitlab.io/
helm repo update
kubectl create namespace gitlab
helm upgrade --install gitlab gitlab/gitlab \
    --namespace gitlab \
    --timeout 600s \
    --set global.hosts.domain=nip.io \
    --set global.hosts.externalIP=157.230.3.130 \
    --set certmanager-issuer.email=abderrahmane.daifi@protonmail.com \
    --set gitlab-runner.runners.install=true \
    --set gitlab-runner.runners.privileged=true
sleep 30
kubectl port-forward svc/gitlab-webservice-default -n gitlab 8080:8080 --address 0.0.0.0
