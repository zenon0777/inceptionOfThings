git clone http://159.203.187.180:8181/root/iot.git
cp -r  K3d-and-Argo-CD-adaifi/* iot/
sed -i 's|https://github.com/zenon0777/K3d-and-Argo-CD-adaifi.git|https://159.203.187.180:8181/root/iot.git|g' iot/application.yaml
kubectl config set-context --current --namespace=argocd
argocd repo add http://159.203.187.180:8181/root/iot.git \
  --username root \
  --password glpat-3uoo1gb-C8DCM873dVrq
kubectl apply -f iot/application.yaml
