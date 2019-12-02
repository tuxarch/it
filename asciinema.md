## asciinema

= Установка:
pacman -S asciinema
pip install asciinema


= Запись
asciinema rec file.cast 
--stdin - Enable stdin (keyboard) recording (see below)
--append - Append to existing recording
--raw - Save raw STDOUT output, without timing information or other metadata
--overwrite - Overwrite the recording if it already exists
-c, --command=<command> - Specify command to record, defaults to $SHELL
-e, --env=<var-names> - List of environment variables to capture, defaults to SHELL,TERM
-t, --title=<title> - Specify the title of the asciicast
-i, --idle-time-limit=<sec> - Limit recorded terminal inactivity to max <sec> seconds
-y, --yes - Answer “yes” to all prompts (e.g. upload confirmation)
-q, --quiet - Be quiet, suppress all notices/warnings (implies -y)

= Проигрывание:
asciinema play file.cast 
asciinema play https://asciinema.org/a/22124
ssh user@host cat asciicast.cast | asciinema play -

-i, --idle-time-limit=<sec> - Limit replayed terminal inactivity to max <sec> seconds
-s, --speed=<factor> - Playback speed (can be fractional)

= Cat
Конвертировать cast в raw:
asciinema cat existing.cast >output.txt


= auth
конфиг файл 
$HOME/.config/asciinema/install-id
Максимальный размер 5mb. На сайте есть возможность перемотки

upload 


==== bashrc

== для локального пользователя
if [[ -z $ASCIINEMA_REC ]]; then
    mkdir -p ~/history/$(date +"%Y%m%d")
    asciinema rec -i 1.4 ~/history/$(date +"%Y%m%d")/$(whoami)-$(date +"%Y%m%d-%H%M%S").json
fi


==== tricks

Прокинуть этот raw в сеть:
nc -l localhost 9999
asciinema rec --raw >(nc node123 9999)

альтернатива:
script - утилита
создающая svg 
termtosvg
