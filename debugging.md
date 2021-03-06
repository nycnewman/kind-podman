# Interesting Information for debugging

# Kubernetes Local Dashboard
- http://localhost:8001/api/v1/namespaces/kubernetes-dashboard/services/https:kubernetes-dashboard:/proxy/#/login

# Istio

- https://istio.io/latest/docs/tasks/traffic-management/

## Istio Service Mesh Workshop
- https://www.istioworkshop.io/

# CoreDNS
- https://blog.codacy.com/add-a-custom-host-to-kubernetes/
```
kubectl -n kube-system edit configmap/coredns

Add record:

hosts custom.hosts mycustom.host {
   1.2.3.4 mycustom.host
   fallthrough
}
kubectl get pod -A
kubectl delete pod -n kube-system core-dns-#########
```

# Debugging Networking, DNS

- https://github.com/wbitt/Network-Multitool
- https://www.eficode.com/blog/debugging-kubernetes-networking

```aidl
kubectl create deployment multitool --image=wbitt/network-multitool
kubectl get pods -A
kubectl exec -it multitool-598c869c8d-m6ps7 /bin/bash

```

# Performance Testing

siege -r 10 -c 4 -v -d 1 -H "Host:httpbin.example.com" http://localhost:8080/status/234
fortio load -c 2 -n 400 -H "Host:httpbin.example.com" -loglevel Warning -stdclient http://localhost:8080/status/234
