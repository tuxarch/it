### journalctl
/var/log/journal
journalctl --list-boot - просмотр файлов, сессий
journalctl -b a09dce7b2c1c458d861d7d0f0a7c8c65 - загрузить бот

Просмотр логов:

journalctl --since "2018-08-30 14:10:10"
journalctl --until yesterday

Просмотр логов по определеному сервису из лог-файла 1:
journalctl -b 1 -u docker.service


Удалить логи:
journalctl --vacuum-time=1s


Настроить уровень логирования можно /etc/systemd/journal.conf

MaxLevelStore=warning #не записывать уровень warnings в лог
MaxLevelSyslog=warning

