## install new firmware

wipe - format data - yes 
advanced wipe - 5 items besides microsd,otg 
reboot in recovery 
install - zip-archive 


## Снять отпечатки пальцев, пинкод если нет шифрования раздела:

по пути data/system/ следующие файлы:
gatekeeper.password.key
gatekeeper.pattern.key
locksettings.db
locksettings.db-shm
locksettings.db-wal
по пути data/system/users/0/ следующий файл:
settings_fingerprint.xml
по пути data/system/users/0/fpdata/ следующий файл:
user.db


## Бэкап 
System или system image (образ, а не файлы)
Data, Boot, Recovery, Firmware, Bootloader, Modem, EFS


## Шифрование

Пароль на расшифровку данных и ключ первоначально совпадают. 
Чтобы изменить пароль на фс, делаем 
su -c vdc cryptfs changepw пароль
EncPassChanger - приложение
После смены Pin пароль на фс также изменится

