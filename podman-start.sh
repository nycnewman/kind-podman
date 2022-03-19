#!/bin/bash

podman machine init --rootful --cpus 5 --memory 16384
podman machine start

export KIND_EXPERIMENTAL_PROVIDER=podman
