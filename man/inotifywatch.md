## inotifywatch
Позволяет отслеживать события в ФС

# install 
package inotify-tools


# git autocommit (for vi MOVE_SELF action)
inotifywait -q -m -e MOVE_SELF --format="git commit -m 'auto commit' %w && git push origin master" ~/main/pr/lin/mov.txt | bash

inotifywait -q -m -e CLOSE_WRITE --format="git commit -m 'autocommit on change' %w" file.txt | sh

Для директории используем ключ -rm

# Отслеживаем операции с директорией
inotifywatch /var/cache

## key
--exclude - шаблон для исключений

