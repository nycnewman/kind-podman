#!/bin/bash

set -e
export KIND_EXPERIMENTAL_PROVIDER=podman

kind create cluster --config=kind-cluster.yaml

PODS=`podman ps | grep -v NAMES | cut -d ' ' -f 1`
IFS=$'\n' PODS=($PODS)

for i in "${PODS[@]}"
do
   :
   # do whatever on "$i" here
   podman cp config.json $i:/var/lib/kubelet/config.json
done

sleep 8

# Install Calico
#kubectl create -f tigera-operator.yaml
#kubectl apply -f ./calico-config.yaml

sleep 40

#kubectl describe tigerastatus calico
#kubectl get pods -n calico-system

#kubectl -n kube-system rollout restart deployment coredns
#kubectl scale deployment --replicas 1 coredns --namespace kube-system

#kubectl get all -A

# Following needed in multi nodes configurations to allow istio-ingressgateway to start
#kubectl taint nodes --all node-role.kubernetes.io/master-
kubectl label node kind-worker ingress-ready=true

# Install Istio
istioctl x precheck
istioctl install --set profile=demo --set hub=docker.io/querycapistio -y -f install-istio.yaml
sleep 10

#istioctl install --set profile=demo -y
kubectl label namespace default istio-injection=enabled
istioctl analyze
kubectl apply -f istio-1.13.2/samples/addons

sleep 10 

# Install Dashboard
#kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/master/aio/deploy/recommended.yaml
kubectl apply -f dashboard-recommended.yaml
kubectl get pod -n kubernetes-dashboard
sleep 10
#kubectl create clusterrolebinding default-admin --clusterrole cluster-admin --serviceaccount=default:default
kubectl apply -f dashboard-adminuser.yaml
kubectl apply -f dashboard-clusterrolebinding.yaml

# Metal LB
#kubectl apply -f metallb-namespace.yaml
#kubectl apply -f metallb.yaml
#kubectl apply -f metallb-config.yaml

kubectl proxy &

# Metrics Server
#kubectl config set-context --current --namespace kube-system

#helm upgrade metrics-server --install \
#--set apiService.create=true \
#--set extraArgs.kubelet-insecure-tls=true \
#--set extraArgs.kubelet-preferred-address-types=InternalIP \
#bitnami/metrics-server --namespace kube-system

# Kiverno
#kubectl create -f kyverno-install.yaml
#kubectl patch mutatingwebhookconfigurations kyverno-resource-mutating-webhook-cfg \\n--type json \\n-p='[{"op": "replace", "path": "/webhooks/0/failurePolicy", "value": "Ignore"},{"op": "replace", "path": "/webhooks/0/timeoutSeconds", "value": 15}]'
#kubectl apply -f kyverno-verify.yaml

# Neuvector
#kubectl create namespace neuvector
#kubectl create -f nv_psp.yaml
#kubectl apply -f crd-k8s-1.19.yaml
#kubectl create -f neuvector.yaml
#kubectl get svc -n neuvector


# Install HTTPbin example
kubectl config set-context --current --namespace default

kubectl create -f httpbin.yaml
kubectl create -f httpbin-gateway.yaml
kubectl create -f httpbin-virtualservice.yaml

#export INGRESS_PORT=$(kubectl -n istio-system get service istio-ingressgateway -o jsonpath='{.spec.ports[?(@.name=="http2")].nodePort}')
#export SECURE_INGRESS_PORT=$(kubectl -n istio-system get service istio-ingressgateway -o jsonpath='{.spec.ports[?(@.name=="https")].nodePort}')
#export TCP_INGRESS_PORT=$(kubectl -n istio-system get service istio-ingressgateway -o jsonpath='{.spec.ports[?(@.name=="tcp")].nodePort}')
#export INGRESS_HOST=$(kubectl get po -l istio=ingressgateway -n istio-system -o jsonpath='{.items[0].status.hostIP}')

sleep 30

curl -s -I -HHost:httpbin.example.com http://localhost:8080/status/200
curl -s -I -HHost:httpbin.example.com http://localhost:8080/test
curl -s -I -HHost:httpbin.example.com http://localhost:8080/status/244
curl -s -I -HHost:httpbin.example.com http://localhost:8080/delay/3

# Install echoserver app
#kind load docker-image echoserver:0.1
#kubectl create -f echo-app.yaml

#open http://localhost:8001/api/v1/namespaces/kubernetes-dashboard/services/https:kubernetes-dashboard:/proxy/
istioctl dashboard kiali &

kubectl -n kubernetes-dashboard get secret $(kubectl -n kubernetes-dashboard get sa/admin-user -o jsonpath="{.secrets[0].name}") -o go-template="{{.data.token | base64decode}}"
echo ""

