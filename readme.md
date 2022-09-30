# K3S HowTo

## 1 PREREQUISITES

Download Ubuntu Server 18.04
Install Two VM instances in VirtualBox

```
Use DynuDNS (https://www.dynu.com/en-US/ControlPanel) create two DDNS services
kudu.loseyourip.com : 10.154.2.93 (Master Node)
lion.loseyourip.com : 10.154.2.97 (Worker Node)
```

## 2 Create Master Node
```
sudo su -
#curl -sfL https://get.k3s.io | sh - //// don’t use this
curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC="--node-ip 10.154.2.93" K3S_NODE_NAME="kudu.loseyourip.com" sh -
```
### Verify K3S service is running
```
systemctl status k3s
● k3s.service - Lightweight Kubernetes

kubectl get nodes
NAME                  STATUS   ROLES                  AGE     VERSION
kudu.loseyourip.com   Ready    control-plane,master   8m49s   v1.24.3+k3s1

systemctl status k3s.service

systemctl stop k3s.service
systemctl start k3s.service

journalctl -f --unit k3s

which kubectl
/usr/local/bin/kubectl

kubectl get endpoints
10.154.2.93:6443
```
### To uninstall K3s master from a server node, run:
```
/usr/local/bin/k3s-uninstall.sh
```

## 3 Create worker Node #
### Run this on the master node
```
sudo su -
cat /var/lib/rancher/k3s/server/node-token
K10126418ddbe4732b2f119162f916b4c82d00cd5fb5acda3b129238e235efc79ac::server:971ae67ef424b60f3a07e8fc08f8f17b


node_ip="10.154.2.97"
node_name="tiger.loseyourip.com"
k3s_url="https://kudu.loseyourip.com:6443"
k3s_token="K1089b238ae11e3ba0c30299345c8cdc1158463c9dc30dc4b89475036cc256bcfc1::server:f4143edd79b4a8f8d6b2dc46861c7db7"

curl -sfL https://get.k3s.io | K3S_URL=${k3s_url} K3S_TOKEN=${k3s_token} K3S_NODE_NAME=${node_name} sh -


systemctl status k3s-agent
#systemctl stop k3s-agent.service
#systemctl start k3s-agent.service

journalctl -f --unit k3s-agent
```


### To uninstall K3s from an agent node, run:
```
/usr/local/bin/k3s-agent-uninstall.sh
```

### Open Master Node server in terminal
```
sudo su -

kubectl get nodes
NAME                  STATUS   ROLES                  AGE     VERSION
kudu.loseyourip.com   Ready    control-plane,master   84m     v1.24.3+k3s1
lion.loseyourip.com   Ready    <none>                 3m38s   v1.24.3+k3s1
```


## 4 Deploying a Service #


NGINX instances are being deployed to the cluster with the following manifest
-----------------------------------------------------------------------------
### Create Deployment YAML
```
nano nginx-deployment.yml
```
Add this content to file :
```
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-deployment
spec:
  selector:
    matchLabels:
      app: nginx
  replicas: 10
  template:
    metadata:
      labels:
        app: nginx
    spec:
      containers:
      - name: nginx
        image: nginx:1.14.2
        ports:
        - containerPort: 80
```
### Install this
```
kubectl apply -f nginx-deployment.yml
```
### Verify that there are 10 pods running an instance of NGINX
```
kubectl get pods -l app=nginx --output=wide
```
The RESPONSE  now you have 10 pods
```
NAME                                READY   STATUS    RESTARTS   AGE   IP           NODE                  NOMINATED NODE   READINESS GATES
nginx-deployment-6595874d85-smbtt   1/1     Running   0          10m   10.42.1.9    lion.loseyourip.com   <none>           <none>
nginx-deployment-6595874d85-8t8nk   1/1     Running   0          10m   10.42.1.10   lion.loseyourip.com   <none>           <none>
nginx-deployment-6595874d85-xxzv7   1/1     Running   0          10m   10.42.1.11   lion.loseyourip.com   <none>           <none>
nginx-deployment-6595874d85-4w8jz   1/1     Running   0          10m   10.42.1.12   lion.loseyourip.com   <none>           <none>
nginx-deployment-6595874d85-dt2jz   1/1     Running   0          10m   10.42.1.8    lion.loseyourip.com   <none>           <none>
nginx-deployment-6595874d85-jbzkh   1/1     Running   0          10m   10.42.0.24   kudu.loseyourip.com   <none>           <none>
nginx-deployment-6595874d85-bkrcg   1/1     Running   0          10m   10.42.1.13   lion.loseyourip.com   <none>           <none>
nginx-deployment-6595874d85-mv9lv   1/1     Running   0          10m   10.42.0.27   kudu.loseyourip.com   <none>           <none>
nginx-deployment-6595874d85-sxsgf   1/1     Running   0          10m   10.42.0.25   kudu.loseyourip.com   <none>           <none>
nginx-deployment-6595874d85-tjvkt   1/1     Running   0          10m   10.42.0.26   kudu.loseyourip.com   <none>           <none>
```
### Create the service
### Create the service YAML
```
nano nginx-service.yml
```
Put this content into file :
```
apiVersion: v1
kind: Service
metadata:
  name: nginx
  labels:
    run: nginx
spec:
  ports:
    - port: 80
  selector:
    app: nginx
```
### Apply the service
```
kubectl apply -f nginx-service.yml
```
### Check if service worked
```
kubectl get services
```
You should get this  RESPONSE
```
NAME         TYPE        CLUSTER-IP     EXTERNAL-IP   PORT(S)   AGE
kubernetes   ClusterIP   10.43.0.1      <none>        443/TCP   5d4h
nginx        ClusterIP   10.43.16.183   <none>        80/TCP    4m29s
```

## Get endpoints
```
kubectl get endpoints
```
You should get this RESPONSE
```
NAME         ENDPOINTS                                               AGE
kubernetes   10.154.2.93:6443                                        5d5h
nginx        10.42.0.24:80,10.42.0.25:80,10.42.0.26:80 + 7 more...   46m
```

### Open an instance of nginx with curl command
```
curl http://10.42.0.24
```
and
```
curl http://10.43.16.183
```
You should get this RESPONSE
```
<!DOCTYPE html>
<html>
<head>
<title>Welcome to nginx!</title>
<style>
    body {
        width: 35em;
        margin: 0 auto;
        font-family: Tahoma, Verdana, Arial, sans-serif;
    }
</style>
</head>
<body>
<h1>Welcome to nginx!</h1>
<p>If you see this page, the nginx web server is successfully installed and
working. Further configuration is required.</p>

<p>For online documentation and support please refer to
<a href="http://nginx.org/">nginx.org</a>.<br/>
Commercial support is available at
<a href="http://nginx.com/">nginx.com</a>.</p>

<p><em>Thank you for using nginx.</em></p>
</body>
</html>
```
### getting ENDPOINTS
```
kubectl get endpoints
```
You should get this RESPONSE
```
NAME         ENDPOINTS                                               AGE
kubernetes   10.154.2.93:6443                                        5d5h
nginx        10.42.0.24:80,10.42.0.25:80,10.42.0.26:80 + 7 more...   46m
```

## Exposing the service
```
nano service-exposed.yaml
```
Add this content

We dont use:  apiVersion: networking.k8s.io/v1beta1 # for k3s < v1.19
```
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: nginx
  annotations:
    ingress.kubernetes.io/ssl-redirect: "false"
spec:
  rules:
  - http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: nginx
            port:
              number: 80
```
### Applying this YAML
```
kubectl apply -f service-exposed.yaml

curl localhost:80
```

You should get this RESPONSE
```
<!DOCTYPE html>
<html>
<head>
<title>Welcome to nginx!</title>
<style>
    body {
        width: 35em;
        margin: 0 auto;
        font-family: Tahoma, Verdana, Arial, sans-serif;
    }
</style>
</head>
<body>
<h1>Welcome to nginx!</h1>
<p>If you see this page, the nginx web server is successfully installed and
working. Further configuration is required.</p>

<p>For online documentation and support please refer to
<a href="http://nginx.org/">nginx.org</a>.<br/>
Commercial support is available at
<a href="http://nginx.com/">nginx.com</a>.</p>

<p><em>Thank you for using nginx.</em></p>
</body>
</html>
```
Now open nginx in your browser
http://kudu.loseyourip.com/

http://lion.loseyourip.com/

# References
I have learned hundreds of ways not to get K3S working but the following links got me going
I have also learned many ways that Vagrant did not work for me
Thanks to the following links I eventually got its working
I also learned that you need to use YAML files to get K3S working properly

https://www.youtube.com/watch?v=SLOdZc2uolQ&t=206s (Dont use vagrant just create VMs using Ubuntu 18.04 ISO file)

https://itnext.io/setup-your-own-kubernetes-cluster-with-k3s-b527bf48e36a

https://k3d.io/v5.4.3/usage/exposing_services/
