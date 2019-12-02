### config termux

## Termux boot 
запускаем процессы при старте

/data/data/com.termux/files/home - default folder


## доступ к системным файлам
$PREFIX/{bin,etc}

Для работы скриптов нужно их модифицировать
termux-fix-shebang


## Отключить приветсвие консоли
touch .hushlogin
