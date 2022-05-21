kubectl delete secret nginx-server-certs
kubectl delete configmap nginx-configmap
kubectl delete service my-nginx
kubectl delete deployment my-nginx
kubectl delete gateway mygateway
kubectl delete virtualservice nginx

rm example.com.crt example.com.key nginx.example.com.crt nginx.example.com.key nginx.example.com.csr

