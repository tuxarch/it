# minikube 

**minikube dashboard**
Open dashboard on browser

**eval $(minikube docker-env)**
Change docker environment on minikube


**minikube service $(kubectl get services)**  
open minikube project

**minikube addons list**  
support addons
**minikube addons enable heapster**  
install addons
**minikube addons open heapster**  
open monitoring

**minikube stop** && **minikube delete**
stop and delete vm

**eval $(minikube docker-env -u)**  
enabled local environment


Запуск вместе с libvirt
minikube start --vm-driver kvm2

Запуск на cri-o
--container-runtime=cri-o

Рабочий конфиг:
minikube start --vm-driver=kvm2 --container-runtime=crio  --cpus=8 --memory='6000mb' --kvm-network='default'


