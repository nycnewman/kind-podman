#!/bin/bash

kubectl label ns pii-demo istio-injection=enabled

kubectl apply -f pii-gateway.yaml
kubectl apply -f pii-virtualservice.yaml

