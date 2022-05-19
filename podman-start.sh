#!/bin/bash

podman machine init --rootful --cpus 10 --memory 27000 --disk-size 70
podman machine start

podman machine ssh sudo touch /etc/sysctl.d/50-kind.conf
podman machine ssh sudo sh -c 'echo; echo fs.inotify.max_user_instances=2048 >> /etc/sysctl.d/50-kind.conf'

# If you want multiarch then these may work
podman machine ssh sudo sh -c 'echo; echo "root soft nofile 2048" >> /etc/security/limits.conf'
podman machine ssh sudo sh -c 'echo; echo "root hard nofile 4096" >> /etc/security/limits.conf'
podman machine ssh sudo sh -c 'echo; echo "fs.file-max = 3213254" >> /etc/sysctl.conf'
podman machine ssh sudo rpm-ostree install qemu-user-static --reboot

export KIND_EXPERIMENTAL_PROVIDER=podman

