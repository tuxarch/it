Проблемы с запуском wine optirun вывыливает ошибку.
Также проблемы с простым запуском glxinfo

Для запуска с ускорением запускаем
optirun -b primus app

Также не просходит самостоятельное переключение на дрова intel;
Для того чтобы погасить драйвер 

pkill app && rmmod nvidia && tee /proc/acpi/bbswitch <<<OFF


