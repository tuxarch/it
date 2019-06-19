 Rsync
=========

## flags
- r - рекурсия 
--delete-after - удалить файлы которых нет в источнике
-t - сохранить время
-p - сохранить права доступа
-a - работать в режиме архивирования
--delete - удалить файлы которых нет в источнике
--exclude-from=asylum_backup.excludes - список с исключениями
-n симуляция копирования
-P - продолжить закачку (в случае больших файлов)
-W - отключить оверхедные вычесления
--info=progress2 - общий прогресс


Синхронизация библиотеки
rsync -rv --size-only /mnt/data/book/ /mnt/allsync/book/ --temp-dir=/tmp --no-owner --no-group --progress --delete

Быстрая передача:
 rsync -aHAXxv --numeric-ids --delete --progress -e "ssh -F /dev/null -T -c aes128-gcm@openssh.com -o Compression=no -x" /backups/mysql/daily/2019-05-07-2003_full/ root@46.
4.ll.17:/tank/backup

rsync -aHAXxv --numeric-ids --delete --progress -e "ssh -i /home/userg/.ssh/id_rsa -p 58319 -T -c aes128-gcm@openssh.com -o Compression=no -x" /backups/mys
ql/daily/2019-05-15-1903_full/ user@sqlssd.ru:/var/lib/mysql/
