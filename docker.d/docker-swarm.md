### Docker swarm
Применение до сотни хостов (2015), если более то в связке с mesos

Токен используется как сервис дескавери. Но есть и другие варианты

Создание токена для подключения к кластеру
SWARM_TOKEN=$(docker run swarm create)

Создаем мастер-ноду
docker-machine create -d kvm --engine-label dc=a --swarm --swarm-master --swarm-discovery token://$SWARM_TOKEN swarm-master

Создаем ноды
docker-machine create -d kvm --engine-label dc=a --swarm --swarm-discovery token://$SWARM_TOKEN swarm-1
docker-machine create -d kvm --engine-label dc=b --swarm --swarm-discovery token://$SWARM_TOKEN swarm-2

Просмотр добавленны ли узлы в кластер:
curl https://discovery-stage.hub.docker.com/v1/clusters/$SWARM_TOKEN
docker run swarm list token://$SWARM_TOKEN

Получить информацию о кластере:
eval $(docker-machine env --swarm swarm-master)
docker info

Идем на мастер ноду и запускаем выполнение в кластере
docker run -d debian sleep 10
docker ps

Поместить контейнер на заданный хост
Если контенер требует одного порта, то запуститься столько копий сколько портов есть в кластере.
docker run -d -e constraint:dc==b postgres


docker-machine ssh node1 - подрубиться к ноде

на ноде
docker swarm init --advertise-addr [ip]:2377
docker swarm join --token [token] [manager ip]:[manager port]  - на других
нодах
docker network create -d overlay mynetwork - создать сеть
docker service create --name web --network mynetwork --replicas 3 -p 5001:80
francois/apache-hostname - создаем сервис
docker service ls
docker service ps web
