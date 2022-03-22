# Test App
- Testing Istio in a cluster

kubectl apply -f pii-demo.yaml

# Building Docker image
podman build --arch="arm64/v8" -t nycnewman/web-frontend:0.1 .
podman push nycnewman/web-frontend:0.1
podman run -p 10001:10001 -e MYSQL_USER=pii_user -e MYSQL_DATABASE=employees -e MYSQL_PASSWORD=Fmjuf3uUz9g8tT2TaCpyRa3nA6V9 -e MYSQL_HOST=192.168.1.78 -e MYSQL_PORT=3306 -e DATABASE=mysql nycnewman/web-frontend:0.1

# Port forward to mysql pod in K8s including machine IP
kubectl port-forward -n pii-demo --address localhost,192.168.1.78 mysql-server-64dc487699-nnb2w 3306:3306

# Accessing through Istio
curl -s -HHost:http-healthcheck.example.com http://localhost:8080/
curl -s -HHost:http-healthcheck.example.com http://localhost:8080/create
curl -s -HHost:http-healthcheck.example.com http://localhost:8080/insert
curl -s -HHost:http-healthcheck.example.com http://localhost:8080/select


# References

## MySQL Python
https://dev.mysql.com/doc/connector-python/en/connector-python-example-connecting.html

## MySQL Sample Data
https://dev.mysql.com/doc/employee/en/employees-installation.html

## MySQL Permissions
https://www.digitalocean.com/community/tutorials/how-to-create-a-new-user-and-grant-permissions-in-mysql

## Docker mysql 
https://hub.docker.com/_/mysql

