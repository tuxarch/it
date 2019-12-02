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

