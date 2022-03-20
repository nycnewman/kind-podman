# Test Postgres in Cluster

kubectl create -f postgres-config.yaml
kubectl create -f postgres-storage.yaml
kubectl create -f postgres-deployment.yaml
kubectl create -f postgres-service.yaml

export POSTGRES_POD=`kubectl get pods | grep postgres | cut -d ' ' -f 1`
kubectl exec -it $POSTGRES_POD /bin/bash
# Local to Pod
psql -h localhost -U postgresadmin --password postgresdb

kubectl port-forward $POSTGRES_POD 5432:5432

psql -h localhost -U postgresadmin --password -p 31070 postgresdb

kubectl delete service postgres 
kubectl delete deployment postgres
kubectl delete configmap postgres-config
kubectl delete persistentvolumeclaim postgres-pv-claim
kubectl delete persistentvolume postgres-pv-volume

# References

- https://severalnines.com/database-blog/using-kubernetes-deploy-postgresql
