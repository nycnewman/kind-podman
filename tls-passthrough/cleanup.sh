kubectl delete secret nginx-server-certs
kubectl delete configmap nginx-configmap
kubectl delete service my-nginx
kubectl delete deployment my-nginx
kubectl delete gateway mygateway
kubectl delete virtualservice nginx
kubectl delete secret nginx-server-certs2
kubectl delete configmap nginx-configmap2
kubectl delete service my-nginx2
kubectl delete deployment my-nginx2
kubectl delete gateway mygateway2
kubectl delete virtualservice nginx2

rm example.com.crt example.com.key nginx.example.com.crt nginx.example.com.key nginx.example.com.csr
rm nginx2.example.com.crt nginx2.example.com.key nginx2.example.com.csr

