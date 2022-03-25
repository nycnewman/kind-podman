#!/bin/bash

podman machine init --rootful --cpus 5 --memory 22528 --disk-size 100
podman machine start

# If you want multiarch then these may work
podman machine ssh sudo rpm-ostree install qemu-user-static --reboot

export KIND_EXPERIMENTAL_PROVIDER=podman

