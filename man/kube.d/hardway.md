### Hard way install on vagrant

### Components
* kubernetes - system for managing
* containerd - managing container 
*Управление контейнерами через gRPC API и сокет UNIX. Может быть использована утилита ctr. Считается достаточно низкоуровневым решением.*
* gVisor - отвечает за изоляцию контейнеров

* CNI - container network interface
*Управление сетью в rkt, kubernetes*

* etcd - распределенное хранилище конфигурации

### Устанавливаемый софт
cni - управление сетью контейнеров
crio
runc - запуск контейнеров
conmon
etcd
traefik - балансировщик на go
kube-apiserver
kube-controler-manager
kube-sheduler
kube-proxy
kubelet
kubectl


### client tools

* cfssl 
* cfssljson - работа с сертификатами tls
* kubectl 

### Install infrastructure 
Vagrant - 4gb free memory

### generate certs
Создаем сертификаты на основе json.
* CA (Certificat Autority)
ca_config, ca_scr
cfssl gencert -initca ca-csr.json | cfssljson -bare ca
* admin_csr
admin-key.pem, admin.pem
* client  key
worker.pem, worker-key.pem
* kubecontroller manager
* kube-proxy
  



