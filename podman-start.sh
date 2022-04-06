#!/bin/bash

podman machine init --rootful --cpus 6 --memory 25000 --disk-size 100
podman machine start

podman machine ssh echo fs.inotify.max_user_instances=2048 > /etc/sysctl.d/50-kind.conf

# If you want multiarch then these may work
podman machine ssh sudo rpm-ostree install qemu-user-static --reboot

export KIND_EXPERIMENTAL_PROVIDER=podman

