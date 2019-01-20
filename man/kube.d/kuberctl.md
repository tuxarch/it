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

kubectl run -i -t alpine-interactive --image=alpine -- sh - запустить образ и войти в контейнер
simply run container

### kubectl log&info 
**kuberctl get nods**  
**kuberctl get deployments**  
kubectl get deployments.apps redis -o yaml --export > flask_dep.yaml - сохранить в файл
kubectl repalce -f flask_dep.yaml - востанавливаем из файла
**kuberctl get pods**  
**kuberctl get events**  
**kuberctl config view**  
**kubectl get services**
kubectl logs pods -f - интерактивный режим вывода лога

## Exec in container
export POD_NAME=$(kubectl get pods -o go-template --template '{{range .items}}{{.metadata.name}}{{"\n"}}{{end}}')
kubectl exec -ti $POD_NAME bash
kubectl expose deployment/kubernetes-bootcamp --type="NodePort" --port 8080 - открываем наш порт, зачем стучимся по расшаренному порту, ip
kubectl set image deployments/kubernetes-bootcamp kubernetes-bootcamp=gcr - изменить версию контейнера

kubectl scale deployments/kubernetes-bootcamp --replicas=4 - увеличить количество реплик
**kubectl expose deployment hello-node --type=LoadBalancer**  
expose deployment 

**kubectl set image deployment/hello-node hello-node=hello-node:v2**  
update image of you Deployment


**kubectl delete service hello-node**  
**kubectl delete deployment hello-node**  
**docker rmi hello-node -f**  


kubectl rollout history deployment redis - история деплоймента
kubectl rollout undo deployment/flask - откатиться на старую версию
kubectl rollout status deployment/flask -w - история изменения

