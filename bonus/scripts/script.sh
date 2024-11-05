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
    --set global.hosts.externalIP=68.183.29.151 \
    --set certmanager-issuer.email=abderrahmane.daifi@protonmail.com \
    --set global.initialRootPassword.encoded=JDJhJDEwJG5zZ3Z6b3J \
    --set gitlab-runner.runners.install=true \
    --set gitlab-runner.runners.privileged=true

