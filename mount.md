## Работа с занятым устройством

#### Определеям каким процессом занято устройство

lsof | grep /media/82AE-233
lsof +D /media/8322-ad
fuser -vm /media/333ss-dd

Если процессы завершены, но устройство занято. То можно очистить файловый кэш
sync && echo 2 > /proc/sys/vm/drop_caches

### Iso mounted
mount -o loop disk1.iso /mnt/disk


