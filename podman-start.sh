#!/bin/bash

podman machine init --rootful --cpus 5 --memory 22528 --disk-size 100
podman machine start

export KIND_EXPERIMENTAL_PROVIDER=podman

