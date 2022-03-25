#!/bin/bash

IMG=nycnewman/web-frontend
VERSION=0.2

podman build --arch=amd64 -t ${IMG}:${VERSION}.amd64 -f Dockerfile
podman build --arch=arm64/v8 -t ${IMG}:${VERSION}.arm64 -f Dockerfile

podman manifest create ${IMG}:${VERSION}
podman manifest add ${IMG}:${VERSION} ${IMG}:${VERSION}.amd64
podman manifest add ${IMG}:${VERSION} ${IMG}:${VERSION}.arm64


# Alternatives

podman buildx build --platform linux/arm64/v8,linux/amd64 --tag nycnewman/web-frontend:0.2 .
podman push nycnewman/web-frontend:0.2
