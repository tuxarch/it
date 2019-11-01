* генерируем пароль
```bash
head -c 32 /dev/urandom | base64
```
* выключить компьютер по завершении процесса

su -c 'while [[ -d /proc/21528 ]]; do sleep 1; done; poweroff'



