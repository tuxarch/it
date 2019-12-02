# Ceph

### Описание
Позволяет организовать отказоустойчивое хранилище

Службы:
OSD - демон отвечающий за хранение, обрабатывающий запросы клиентов и обенивающийся данными с другими OSD
Один демон OSD - один диск, требует 4GB озу. Можно обьеденять диски в рейды.

MON - клиенты узнают на какие OSD ходить, хранит информацию о состояниии кластера
MDS - сервер с метаданным если используестся cephFS файловая система
MGR - организует мониторинг, есть дашбор и интерфейсы zabbix, prometheus


Понятия:
Replication Factor - количество реплик
Placement Group - связующее звено между физическим и логическим устройством
MinSize - минимальный размер при репликации для осуществления транзакции
Crush - алгоритм-хэш-функция которая позволяет определить куда писать данные
Диски разбиваются на равные чанки, составляется их карта, данные пишуться на примари раздел исходя из составленной карты.


Клиенты:
Cephfs
RBD - образ виртуальной машины
Librados - библиотека для реализации доступа


#### Установка

Описание системы:
- admin node (ceph-deploy)
- 3 data node on 2 disks (mon, osd, mds)
- 2 client

На админ ноде
```bash
wget -q -O- 'https://download.ceph.com/keys/release.asc' | sudo apt-key add -
Указываем релиз ceph
echo deb https://download.ceph.com/debian-{ceph-release-version}/ $(lsb_release -sc) main | sudo tee /etc/apt/sources.list.d/ceph.list

Правим /etc/hosts

Создаем дополнительного юзера:
useradd -d /home/cephuser -m cephuser
Добавляем его в судо, и даем доступ по ключу на ноды

Инициализируем кластер с ceph-admin:
mkdir my-cluster && cd my-cluster
ceph-deploy new ceph1 ceph2 ceph3
Должны получить ceph.conf
ceph-deploy install ceph1 ceph2 ceph3

Ставим мониторы и ключи:
ceph-deploy mon create-initial
ceph-deploy admin ceph1 ceph2 ceph3

Создаем диски:
ceph-deploy osd create --data /dev/vdb ceph1 
ceph-deploy osd create --data /dev/vdb ceph2 
ceph-deploy osd create --data /dev/vdb ceph3 

Посмотреть диски на хостах:
/usr/bin/ceph-deploy disk list ceph1 ceph2 ceph3

Проверяем состояние кластера с любой из нод:
ssh ceph1 sudo ceph -s

Создаем сервер для работы glusterfs:
ceph-deploy mds create ceph1 ceph2 ceph3
На нодах:
sudo ceph osd pool create cephfs_data 128
sudo ceph osd pool create cephfs_metadata 128
sudo ceph fs new cephfs cephfs_metadata cephfs_data

Настройка клиента:


Клиент лучше монтировать через кернел - модуль и fstab
ceph-fuse на kernel drive




```



#### Настройки

osd scrub - важная опция отвечающая за проверку данных на нодах

Сеть в 10Gb, отдельная подсеть для обьединения OSD.

рекомендуемая файловая система xfs

