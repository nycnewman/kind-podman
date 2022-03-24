#!/bin/bash

kubectl create namespace pii-demo

kubectl apply -f pii-demo.yaml
kubectl apply -f pii-gateway.yaml
kubectl apply -f pii-virtualservice.yaml

sleep 30

curl -s -i -HHost:http-healthcheck.example.com http://localhost:8080/
curl -s -i -HHost:http-healthcheck.example.com http://localhost:8080/create
curl -s -i -HHost:http-healthcheck.example.com http://localhost:8080/insert
curl -s -i -HHost:http-healthcheck.example.com http://localhost:8080/insert
curl -s -i -HHost:http-healthcheck.example.com http://localhost:8080/insert
curl -s -i -HHost:http-healthcheck.example.com http://localhost:8080/insert
curl -s -i -HHost:http-healthcheck.example.com http://localhost:8080/insert
curl -s -i -HHost:http-healthcheck.example.com http://localhost:8080/select
