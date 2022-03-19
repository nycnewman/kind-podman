# Interesting Information for debugging

# Kubernetes Dashboard
http://localhost:8001/api/v1/namespaces/kubernetes-dashboard/services/https:kubernetes-dashboard:/proxy/#/login

# Istio

https://istio.io/latest/docs/tasks/traffic-management/

## Istio Service Mesh Workshop
https://www.istioworkshop.io/


# CoreDNS
https://blog.codacy.com/add-a-custom-host-to-kubernetes/

kubectl -n kube-system edit configmap/coredns

Add record:

hosts custom.hosts mycustom.host {
   1.2.3.4 mycustom.host
   fallthrough
}
kubectl get pod -A
kubectl delete pod -n kube-system core-dns-#########

# Debugging Networking, DNS

https://github.com/wbitt/Network-Multitool
https://www.eficode.com/blog/debugging-kubernetes-networking


kubectl create deployment multitool --image=wbitt/network-multitool
kubectl get pods -A
kubectl exec -it multitool-598c869c8d-m6ps7 /bin/bash
