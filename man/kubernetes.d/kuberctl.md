# kubectl - cli control kubernetes cluster manager

### Install:
```bash
curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl && sudo chmod +x ./kubectl && sudo sudo mv ./kubectl /usr/local/bin/kubectl

```

**kubectl cluster-info**  
info of running cluster

**kubectl completion -h**  
enable autocomplete

**kubectl run hello-node --image=hello-node:v1 --port=8080 --image-pull-policy=Never**  
simply run container

### kubectl log&info 
**kuberctl get nods**  
**kuberctl get deployments**  
**kuberctl get pods**  
**kuberctl get events**  
**kuberctl config view**  
**kubectl get services**

**kubectl expose deployment hello-node --type=LoadBalancer**  
expose deployment 

**kubectl set image deployment/hello-node hello-node=hello-node:v2**  
update image of you Deployment


**kubectl delete service hello-node**  
**kubectl delete deployment hello-node**  
**docker rmi hello-node -f**  

