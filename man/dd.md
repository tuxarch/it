### dd backup/restore

Для создания резервной копии MBR:
Используем bs=100M - для скоростной записи
dd if=/dev/sda of=/path/mbr-backup bs=512 count=1
Восстановление MBR:
dd if=/path/mbr-backup of=/dev/sda bs=512 count=1

Если нужно сохранить только загрузочный код (он занимает 446 байт), то меняем размер блока следующим образом:
dd if=/dev/sda of=/path/mbr-boot-code bs=446 count=1

Для сохранения только таблицы разделов (66 байт) нужно выполнить такую команду:
dd if=/dev/sda of=/path/mbr-part-table bs=1 count=66 skip=446
Соответственно, для восстановления только загрузочного кода из файла mbr-backup:
dd if=/path/mbr-backup of=/dev/sda bs=446 count=1
dd if=/path/mbr-backup of=/dev/sda bs=1 skip=446 seek=466 count=66
Важно: Восстановление MBR на несоответствующую таблицу разделов сделает все ваши данные нечитабельными, вернуть их будет практически невозможно. Если вам нужно просто переустановить загрузчик, почитайте GRUB or LILO.

Чтобы очистить MBR, но оставить таблицу разделов (может быть полезно, если вы хотите полностью переустановить операционную систему):
dd if=/dev/zero of=/dev/sda bs=446 count=1

Просмотр загрузочной записи
dd if=/dev/sda bs=512 count=1 | hexdump -C



=======================
Восстановление windows loader
ms-sys --partition /dev/sda1
Чтобы прописать загрузчик 2000/XP/2003 выполните:

ms-sys --mbr /dev/sda


Создание бэкапа:
Заполнить всё свободное место в текущем разделе нулями:
dd if=/dev/zero of=zerofill
Бэкап плюс сжатие
dd if=/dev/sda | xz -9 --threads=2 > MyFuBu.ISO.XZ
Посмотреть прогресс dd
killall -USR1 dd
Восстановление бэкапа
gunzip -c /path/to/backup.img.gz | dd of=/dev/sdX
xz -c /path/to/backup.iso.xz | dd of=/dev/sdX

ddrescue - подобная программа расширеннным функционалом и возможность обрабатывать битые сектора
partclone, partimage - для логического копирования данных

Для ускорения записи можно попробовать ключ bs=8192

Узнать размер блока
tune2fs -l
mount -l  (blkzise) -for ntfs
