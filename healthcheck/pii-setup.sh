#!/bin/bash

kubectl create namespace pii-demo

kubectl apply -f pii-demo.yaml
kubectl apply -f pii-gateway.yaml
kubectl apply -f pii-virtualservice.yaml


sleep 20

curl -s -I -HHost:http-healthcheck.example.com http://localhost:8080/
