### Glusterfs
Распределенная ФС.  
Работает на пространстве пользователя, использует механизм fuse и строиться над существующими ФС (ext,)
Не требует отдельный сервер для метаданных в отличии от ceph.

Есть два процесса:
	glusterfsd - шарит данные на серверах
	glusterfs - подключает к серверам и монтирует все средствами Fuse

Может шардить, реплецировать, читать с разных нод, восстанавливать данные на нодах. Может быть совместим с NFS.
Требует одинаковой настройки клиентов.


Поддерживает 5 типов распределения контента объединённого в volume:

 - Distributed (распределённый)
 - Replicated (реплицируемый)
 - Striped (разделенный по частям)
 - Distributed Striped (распределённый и разделенный по частям)
 - Distributed Replicated (распределённый и реплицируемый)


##### Установка

Есть официальный плейбук на ansible

Правим /etc/hosts
Ставим apt install glusterfs-server

Стартуем:
 service glusterd start
 service glusterd status

Подключаемся к другой ноде:
From "server1"
    gluster peer probe server2
    gluster peer probe server3

Смотрим статус:
gluster peer status

На всех серверах создаем:  
mkdir -p /data/{dist1,dist2}

На любой ноде запускаем реплицирование:
gluster volume create replicated replica 6 transport tcp gfs1:/mnt/dist1 gfs1:/mnt/dist2 gfs2:/mnt/dist1 gfs2:/mnt/dist2 gfs3:/mnt/dist1 gfs3:/mnt/dist2 force
gluster volume start replicated

Смотрим состояние кластера:
gluster volume info

Создаем на клиенте точку монтируем и проверяем запись (записывать можно только через монтирование):
mount -t glusterfs server1:/gv0 /mnt
      for i in `seq -w 1 100`; do cp -rp /var/log/messages /mnt/copy-test-$i; done


##### Управление

Смотрим:
gluster volume list

Удаляем
gluster volume delete distributed

Узнать состояние восстановления:
gluster volume heal


##  Heketi
API для автоматизации разворацивания кластера в облаке

