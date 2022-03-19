# Testing K-in-D on Podman
## Testing Kind on Podman on Apple M1 & Intel

Goals:
- Basic testing of Podman and bridge networking (ability to connect back to host services)
- Basic testing of KinD (Kubernetes in Docker) with podman 
- Test framework for Istio
- Anything else that's fun

Known Issues
- Podman support is experimental
- Mapping of local files is not yet supported (4.0.2)
- On M1, containers must be for linux/arm64 (exec error when runnning Intel containers on M1)

[Debugging and other Reference Information](./debugging.md)

## Setup

brew install podman kubectl istioctl calicoctl  

To start up Cluster

```$xslt
# Start up Podman with 5 cpus and 16Gb of RAM, Rootful 
./podman-start.sh

# Start KinD with
# - Mapped local ports (8080, 8443, 15021)
# - Kubernetes (defaults to 1.23)
# - Calico Network
# - Kubernetes Dashboard
# - Istio & plugins & sidecar enabled
# - MetalLB (not really used yet)
# - Test httpbin app & Istio config
./setup.sh
```

To Shutdown & clean up Podman
```
./shutdown.sh
./podman-stop.sh
```

