#!/bin/bash

# Apply all set of production resources defined in kustomization.yaml in `production` directory .
kubectl apply -k https://github.com/metacontroller/metacontroller/manifests/production

kubectl create namespace hello
kubectl apply -f crd.yaml
kubectl apply -f controller.yaml
kubectl -n hello create configmap hello-controller --from-file=sync.py
kubectl -n hello apply -f webhook.yaml
kubectl -n hello apply -f hello.yaml

sleep 15
kubectl -n hello get pods
kubectl -n hello logs your-name

sleep 10
kubectl -n hello patch helloworld your-name --type=merge -p '{"spec":{"who":"My Name"}}'

sleep 10
kubectl -n hello logs your-name

#kubectl delete compositecontroller hello-controller
#kubectl delete crd helloworlds.example.com
#kubectl delete ns hello
