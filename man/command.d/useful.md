* выключить компьютер по завершении процесса

```bash
su -c 'while [[ -d /proc/21528 ]]; do sleep 1; done; poweroff'
```


