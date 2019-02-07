### Неизвестная в данный момент книга

## Технологии лежащие в основе
~ cgroup - управление группы процессов с возможностью их ограничения их доступа к ресурсам. Монтируем mount -t cgrop в разные подсистемы /sys/fs/cgroup
/proc/[pid]/cgroup - посмотреть в какую группу входит процесс. Управление: руками, libcgroup, cgmanager, systemd, container-specific
namespaces - изолирует процессы в пространстве имен. Хостовые имена, сетевые интерфейсы, пиды, юзер права.
  - clone - новый процесс к новым namespace
  - setns - присоединяет процесс к существующему
  - /proc/[pid]/ns - просмотр
  - unshare - перемещение процессов через namespace
  
union mount - для работы с оверлейной файловой системой. Позволяя совмещать образы файловой системы.
capabilites - отход от cуит-бита, бита прав доступа (ping)
/proc/sys/kernel/cap_last_cap - файл с количеством разрешениями
getcap/setcap - работа с битом
иногда можно обойтись не дачей прав на sudo. А выставлением capabilites cap_net_roo
seccomp - ограничение количества системных вызовов

mac - selinux, apparmor 

chroot - меняет корневую директорию. 
https://github.com/earthquake/chw00t.git - исходники для выхода chroot.

Образ - набор файлов
Контейнер - процессы запущенные в образе

## Запуск контейнера:

запуск userspace
чтение конфигов
скачивание image/rootfs
подготовка и вход директорию

## docker-machine start default - позволяет подключаться к сокету на машине

docker inspect stupefied_turing - инфо по контейнеру
Получить ip адресс контейнера:
docker inspect stupefied_turing | grep IPAddress
docker inspect --format {{.NetworkSettings.IPAddress}} stupefied_turing
docker diff stupefied_turing - изменение в контейнере
docker logs stupefied_turing - логи


docker rm -v $(docker ps -aq -f status=exited) - удалить все остановленные контейнеры

docker push - надо узать же

Регистрация на докер хабе
docker login
Вписываем свои данные в докерфайл MAITEINER
docker build -t username/package
docker push username/package
--rm - удалять контейнер при выходе из него

--link myredis:redis - команда для связи контейнеров (прокидывает имя в /etc/hosts, evn ports, ip)
-v пробросить данные в контейнер VOLUME /data - для докерфайла
--volumes-from - используется уже для последующего подключение к монтированой области
docker history просмотр команды по созданию образа
--mount работает лучше ключа v (anki не завелся)



## Работа docker

- Модули
Docker overlay - драйвер для реализации overlayfs (btrfs, aurfs)
Docker daemon - отвечает за создание и запуск, контроль работы контейнеров
client - http соединение через сокет unix по умолчанию, через tcp, 
docker redistry  - реестры для хранения объектов

- Проекты
Docker trusted registry - хранение образов
Swarm - создание кластеров
Compose - описание проекта из нескольиких докерфайлов
Machine - работа с хост-машинами
kitematic - веб-морда для управления на w, macos
создание сетевой среды между контейнерами на разных хостах weave, calico
counsul, registrator, etcd - обнаружение сревисов
оркестрация - kubernetes, mesos
flocker - работа с схд


Образы alpine, debian - вместо ubuntu
docker pull phusion/baseimage - с нормальным initd, cron, ssh. Для запуска в контейнерах нескольких процессов.
FROM scratch - позволяет создавать свои образы (можно только копировать и запускать команды)

docker port - посмотреть прокинутые порты


docker run --name dbdata - создание отдельно контейнера для данных
docker diff - показывает изменение в файловой системе контейнера
docker tag работа с тэгами

slim - маленькие образы
virtualenv - изоляция сред в python

docker run -P - случайный выбор порта на хосте (docker port чтобы найти)
-e "ENV=DEV" - создать переменную для переключения контекста

docker-compose
up -d  - запуск проекта c пересборкой
build - сборка
ps - состояние проекта
rm - удаление


supervisord, runit - использование в случае необходимости запусков нескольких app

подключаем git репозиторий к github

Создание собственного репозитория
docker run -d -p 5000:5000 registry:2
docker tag amouat/identidock:0.1 localhost:5000/identidock:0.1
docker push localhost:5000/identidock:0.1

Подключить к репозиторию:
docker pull 192.168.1.100:5000/identidock:0.1
--insecure-registry 192.168.1.100:5000 - перезапустить докер без tls

Создаем сертификат для доступа
mkdir registry_certs
root@reginald:~# openssl req -newkey rsa:4096 -nodes -sha256 \
-keyout registry_certs/domain.key -x509 -days 365 \
-out registry_certs/domain.crt
sudo mkdir -p /etc/docker/certs.d/reginald:5000
root@reginald:~# sudo cp registry_certs/domain.crt \
/etc/docker/certs.d/reginald:5000/ca.crt

Настройка аутентификации через прокси и токен
https://docs.docker.com/registry/nginx/  
https://github.com/cesanta/docker_auth

RUN - одна команда - один слой


docker in docker (dind) - 
docker run --rm --privileged -t -i -e LOG=file jpetazzo/dind

Сборка и запуск jenkins контейнера
docker run -v /var/run/docker.sock:/var/run/docker.sock identijenk sudo docker ps

webhock - уведомление об успешной сборки продакшен версии

docker модуль для динамической поддержки при сборках в jenkins

docker run --volumes-from jenkins-data -v $(pwd):/backup debian tar -zcvf /backup/jenkins-data.tar.gz /var/jenkins_home
Бэкап 
docker-backup - софт для создания бэкапов

Тестирование в процессе эксплуатации
блу-грин версия. В процессе эксплуатации новая версия вводиться не сразу, а постепенно

docker-machine - простой интерфейс для работы с хостами и машинами удаленными
В том числе aws, do, google - генерим токены и работаем с машинами
docker-machine create --driver digitalocean --digitalocean-access-token 4820... \
identihost-do
docker-machine env identihost-do - подключаемся

Использование extends для docker compose

docker-gen - служит для мониторинга изменений значений (к примеру ipd)

docker ansible - описание проектов docker c помощью ansible

aufs - не поддерживается ядром, работает на уровне файлов
overlay - лучше всего подходит для использвания

Передача секретных ключей через переменные среды
через шифрование
через подключаемые тома
о

Маршрутизация с помощью докера очень дорогостоящая. Лучше аппаратная или уровня ядра.

----
Логирование
стандар отправлять на stdout, stderr

Забрать логи с удаленного сервера
curl -i --cacert ~/.docker/machine/certs/ca.pem \
--cert ~/.docker/machine/certs/ca.pem \
--key ~/.docker/machine/certs/key.pem \
"https://$(docker-machine ip default):2376/containers/\
$(docker ps -lq)/logs?stderr=1&stdout=1"

ELK стэк (elastic, logstash, kibana)

logspout - собираем логи с докера в logstash

docker events - события в докере
Собирать логи с контейнеров непосредственно с хост машины
в отдельный файл
docker stats - получени информации по запущенным контейнерам

cAdvisor - мониторинг работы контейнеров и хостов
Heapster - мониторинг для kubernetes, coreos
Prometethus - решение для контроля кластера

Service Discovery/Обнаружение среды
Использование посредников для связи контейнеров


Поднимаем хост для контейнеров

docker-machine create -d kvm default
eval $(docker-machine env redis-host) 


ambassador - посредник для обнаружение среды, балансировки, шифрования

etcd - распределенное хранилище key:value
Минимальные кластер от 3. REST интерфейс

skydns - etcd на dns

Consul - обнаружение сервисов, распределенное хранилище 
registrator - автоматическая регистрация контейнеров

База для обнаружения - DNS

сеть: бридж, хост, без сети. Режим хост работает в пространсте хоста и его портами

overlay - сеть на базе vxlan 
weave - система управления сетью
flannel - сетевое решение с возможностью распределения контейнеров по разным хостам

сalico - сетевое решение на 3 уровне osi

==============

Оркестрация и кластеризация
Кластеризация - объединение хостов в группы
Оркестрация - обеспечение совместной работы
Управление - общий контроль


docker swarm - решение от докера
fleet - низкоуровневая система от coreos
kubernetes - высокоуровневое решение
mesos - низкоуровневая сестема

Swarm - на каждом хосте запускается swarm agent отдельно swarm manager, который отвечает за оркестрацию и планирование

fleet
fleectlc statrt redis.servise - запускает юниты на нодах
Подходит для жизни длинных процессов. А не коротких

kubernets 
балансировка, отказоустойчивость. Но значительное утяжеление проекта

Mesos, marathon 
Zookeper как сервис дескавери

