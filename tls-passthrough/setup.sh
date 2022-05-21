#!/bin/bash

# Based on https://istio.io/latest/docs/tasks/traffic-management/ingress/ingress-sni-passthrough/

openssl req -x509 -sha256 -nodes -days 365 -newkey rsa:2048 -subj '/O=example Inc./CN=example.com' -keyout example.com.key -out example.com.crt
openssl req -out nginx.example.com.csr -newkey rsa:2048 -nodes -keyout nginx.example.com.key -subj "/CN=nginx.example.com/O=some organization"
openssl x509 -req -sha256 -days 365 -CA example.com.crt -CAkey example.com.key -set_serial 0 -in nginx.example.com.csr -out nginx.example.com.crt

kubectl create configmap nginx-configmap --from-file=nginx.conf=./nginx.conf
kubectl create secret tls nginx-server-certs --key nginx.example.com.key --cert nginx.example.com.crt

kubectl apply -f nginxapp.yaml

kubectl exec "$(kubectl get pod  -l run=my-nginx -o jsonpath={.items..metadata.name})" -c istio-proxy -- curl -sS -v -k --resolve nginx.example.com:443:127.0.0.1 https://nginx.example.com


kubectl apply -f nginx-gateway.yaml
kubectl apply -f nginx-virtualservice.yaml

curl -v --resolve "nginx.example.com:8443:127.0.0.1" --cacert example.com.crt -HHost:nginx.example.com "https://nginx.example.com:8443"
echo "" | openssl s_client -host 127.0.0.1 -port 8443 -servername nginx.example.com -tls1_2 -tlsextdebug -status -CAfile example.com.crt

