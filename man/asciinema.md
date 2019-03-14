## asciinema

pip install asciinema

rec file.cast
play file.cast
asciinema play https://asciinema.org/a/22124
upload 
auth

--raw file.raw - ключ для записи в текст
Удобно смотреть через cat file.raw

Конвертировать cast в raw
asciinema cat file.cast file.raw

Прокинуть этот raw в сеть:
nc -l localhost 9999
asciinema rec --raw >(nc node123 9999)

альтернатива:
script - утилита
создающая svg 
termtosvg
