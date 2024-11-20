#!/bin/bash

ARGOCD_PASSWORD_TOKEN=""
SERVER_IP=""
GITLAB_PORT="8181"
ARGOCD_PORT="8080"

GitLab_PASSWORD=$(kubectl get secret -n gitlab gitlab-gitlab-initial-root-password -o jsonpath="{.data.password}" | base64 --decode)

git clone https://github.com/zenon0777/K3d-and-Argo-CD-adaifi.git
git clone "http://oauth2:${ARGOCD_PASSWORD_TOKEN}@${SERVER_IP}:${GITLAB_PORT}/root/K3d-ArgoCd.git"

cp -r K3d-and-Argo-CD-adaifi/* K3d-ArgoCd/
sed -i "s|https://github.com/zenon0777/K3d-and-Argo-CD-adaifi.git|http://${SERVER_IP}:${GITLAB_PORT}/root/K3d-ArgoCd.git|g" K3d-ArgoCd/application.yaml

cd K3d-ArgoCd
git add .
git commit -m "ArgoCD application added"
git push
cd ..

kubectl config set-context --current --namespace=argocd
ArgoCD_PASSWORDN=$(kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d)
echo $ArgoCD_PASSWORDN
echo -e "\n"

argocd login --insecure ${SERVER_IP}:${ARGOCD_PORT} --username admin --password ${ArgoCD_PASSWORDN}
argocd repo add "http://${SERVER_IP}:${GITLAB_PORT}/root/K3d-ArgoCd.git" \
  --username root \
  --password ${ARGOCD_PASSWORD_TOKEN}

kubectl apply -f K3d-ArgoCd/application.yaml