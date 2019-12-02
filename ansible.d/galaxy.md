## Управление ролями  

Установить и перезаписать роль
ansible-galaxy install role.name --force - перезаписать роль 
--no-deps - не загружать зависимости
--force-with-deps - c зависимостями

Установить определенную версию:
ansible-galaxy install geerlingguy.apache,v1.0.0

Установить пакеты из файла:
ansible-galaxy install -r requirements.yml  -p .

Получить список ролей
ansible-galaxy role list

Сгенирировать пустой проект:
init name.project

Скопировать проект в текущий каталог:
install name.project -p . 

Работать с текущим каталогом
info name.project -p . 

## Структура проекта (роли):
*В каждом каталоге будет искаться файл main.yml, кроме files, templates*
requirements.yml - содержит зависимые роли
defaults - переменные по умолчанию
files - копируемые на хосты файлы, скрипты
handlers - обработчики
meta - описание зависимостей, выполняется перед запуском роли
task - задачи из плейбука, точка запуска плейбука
templates
test
vars


include_role - подключить динамически другую роли. Динамическое исполняется во время запуска
import_playbook - статическое подключение

