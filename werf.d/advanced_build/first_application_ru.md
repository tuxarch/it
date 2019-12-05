---
title: Первое приложение
sidebar: documentation
permalink: ru/documentation/guides/advanced_build/first_application.html
author: Ivan Mikheykin <ivan.mikheykin@flant.com>
ref: documentation_guides_advanced_build_first_application
lang: ru
---

## Обзор задачи

В статье рассматривается сборка простого PHP-приложения — [Symfony application](https://github.com/symfony/demo), которая включает в том числе следующие шаги:

1. Установка требуемых пакетов и зависимостей: `php`, `curl`, `php-sqlite` (для приложения),  `php-xml` и `php-zip` (для composer).
1. Создание пользователя и группы `app` для работы веб-сервера.
1. Скачивание и установка composer из `phar-файла`.
1. Установка других зависимостей проекта с помощью composer.
1. Добавление кода приложения в папку `/app` конечного образа и установка владельца `app:app` на файлы и папки.
1. Установка IP адресов, на которых web-сервер будет принимать запросы. Это делается в скрипте  `/opt/start.sh`, который запускается во время старта контейнера.
1. Выполнение других действий по настройке приложения. В качестве примера таких действий, мы будем записывать текущую дату в файл `version.txt`.

Также, мы проверим что приложение работает и запушим образ в Docker-регистри.

## Требования

* Минимальные знания [Docker](https://www.docker.com/) и [инструкций Dockerfile'а](https://docs.docker.com/engine/reference/builder/).
* Установленные [зависимости Werf]({{ site.baseurl }}/ru/documentation/guides/installation.html#install-dependencies).
* Установленный [Multiwerf](https://github.com/flant/multiwerf).

### Выбор версии Werf

Перед началом работы с Werf, нужно выбрать версию Werf, которую вы будете использовать. Для выбора актуальной версии Werf в канале beta, релиза 1.0, выполните в вашей shell-сессии:

```shell
source <(multiwerf use 1.0 beta)
```

## Шаг 1: Добавление конфигурации

Чтобы выполнить все необходимые шаги по сборке с помощью Werf, добавим специальный файл `werf.yaml` к исходному коду приложения.

1. Клонироуйте git-репозиторий [Symfony Demo Application](https://github.com/symfony/demo):

    ```shell
    git clone https://github.com/symfony/symfony-demo.git
    cd symfony-demo
    ```

2.  В корневой папке проекта создайте файл `werf.yaml` следующего содержания:

    <div class="tabs">
      <a href="javascript:void(0)" class="tabs__btn active" onclick="openTab(event, 'tabs__btn', 'tabs__content', 'Ansible')">Ansible</a>
      <a href="javascript:void(0)" class="tabs__btn" onclick="openTab(event, 'tabs__btn', 'tabs__content', 'Shell')">Shell</a>
    </div>

    <div id="Ansible" class="tabs__content active" markdown="1">
    {% raw %}
    ```yaml
    project: symfony-demo
    configVersion: 1
    ---

    image: ~
    from: ubuntu:16.04
    docker:
      WORKDIR: /app
      # Non-root user
      USER: app
      EXPOSE: "80"
      ENV:
        LC_ALL: en_US.UTF-8
    ansible:
      beforeInstall:
      - name: "Install additional packages"
        apt:
          state: present
          update_cache: yes
          pkg:
          - locales
          - ca-certificates
      - name: "Generate en_US.UTF-8 default locale"
        locale_gen:
          name: en_US.UTF-8
          state: present
      - name: "Create non-root group for the main application"
        group:
          name: app
          state: present
          gid: 242
      - name: "Create non-root user for the main application"
        user:
          name: app
          comment: "Create non-root user for the main application"
          uid: 242
          group: app
          shell: /bin/bash
          home: /app
      - name: Add repository key
        apt_key:
          keyserver: keyserver.ubuntu.com
          id: E5267A6C
      - name: "Add PHP apt repository"
        apt_repository:
          repo: 'deb http://ppa.launchpad.net/ondrej/php/ubuntu xenial main'
          update_cache: yes
      - name: "Install PHP and modules"
        apt:
          name: "{{`{{packages}}`}}"
          state: present
          update_cache: yes
        vars:
          packages:
          - php7.2
          - php7.2-sqlite3
          - php7.2-xml
          - php7.2-zip
          - php7.2-mbstring
          - php7.2-intl
      - name: Install composer
        get_url:
          url: https://getcomposer.org/download/1.6.5/composer.phar
          dest: /usr/local/bin/composer
          mode: a+x
      install:
      - name: "Install app deps"
        # NOTICE: Always use `composer install` command in real world environment!
        shell: composer update
        become: yes
        become_user: app
        args:
          creates: /app/vendor/
          chdir: /app/
      setup:
      - name: "Create start script"
        copy:
          content: |
            #!/bin/bash
            php bin/console server:run 0.0.0.0:8000
          dest: /app/start.sh
          owner: app
          group: app
          mode: 0755
      - raw: echo `date` > /app/version.txt
      - raw: chown app:app /app/version.txt
    git:
    - add: /
      to: /app
      owner: app
      group: app
    ```
    {% endraw %}
    </div>

    <div id="Shell" class="tabs__content" markdown="1">
    {% raw %}
    ```yaml
    project: symfony-demo
    configVersion: 1
    ---

    image: ~
    from: ubuntu:16.04
    docker:
      WORKDIR: /app
      # Non-root user
      USER: app
      EXPOSE: "80"
      ENV:
        LC_ALL: en_US.UTF-8
    shell:
      beforeInstall:
      - apt-get update
      - apt-get install -y locales ca-certificates curl software-properties-common
      - locale-gen en_US.UTF-8
      - groupadd -g 242 app
      - useradd -m -d /app -g 242 -u 242 -s /bin/bash app
      # https://askubuntu.com/posts/490910/revisions
      - LC_ALL=C.UTF-8 add-apt-repository -y ppa:ondrej/php
      - apt-get update
      - apt-get install -y php7.2 php7.2-sqlite3 php7.2-xml php7.2-zip php7.2-mbstring php7.2-intl
      - curl -LsS https://getcomposer.org/download/1.4.1/composer.phar -o /usr/local/bin/composer
      - chmod a+x /usr/local/bin/composer
      install:
      - cd /app
      # NOTICE: Always use `composer install` command in real world environment!
      - su -c 'composer update' app
      setup:
      - "echo '#!/bin/bash' >> /app/start.sh"
      - echo 'php bin/console server:run 0.0.0.0:8000' >> /app/start.sh
      - echo `date` > /app/version.txt
      - chown app:app /app/start.sh /app/version.txt
      - chmod +x /app/start.sh
    git:
    - add: /
      to: /app
      owner: app
      group: app
    ```
    {% endraw %}
    </div>

## Шаг 2: Соберите и запустите приложение

Давайте соберем и запустим наше первое приложение

1.  Перейдите в корневую папку проекта.

2.  Соберите образ приложения:

    ```shell
    werf build --stages-storage :local
    ```

    > При работе с composer может возникать известная [ошибка](https://github.com/composer/composer/issues/945). Если вы получили при сборке ошибку `proc_open(): fork failed - Cannot allocate memory`, добавьте 1ГБ swap-файл. Как это сделать, например, читай [тут](https://www.digitalocean.com/community/tutorials/how-to-add-swap-space-on-ubuntu-16-04).

3.  Запустите контейнер из собранного образа:

    ```shell
    werf --stages-storage :local run --docker-options="-d -p 8000:8000" -- /app/start.sh
    ```

4.  Проверьте что приложение запустилось и отвечает:

    ```shell
    curl localhost:8000
    ```

## Шаг 3: Загрузите образ в Docker-registry

С помощью Werf можно пушить собранные образы в Docker-registry.

1. Запустите локальный Docker-registry:

    ```shell
    docker run -d -p 5000:5000 --restart=always --name registry registry:2
    ```

2. Загрузите образ в Docker-registry используя Werf с пользовательской моделью тэгирования, используя тэг `v0.1.0`:

    ```shell
    werf publish --stages-storage :local --images-repo localhost:5000/symfony-demo --tag-custom v0.1.0
    ```

## Что можно улучшить

В приведенном примере есть что улучшить:
* Набор комманд создания скрипта `start.sh` можно легко заменить на одну команду — git, а сам файл `start.sh` хранить в git-репозитории.
* Если хранить файл в git-репозитории, то при его копировании можно сразу же (в той-же команде) указывать необходимые права.
* Лучше использовать `composer install` вместо `composer update` чобы устанавливать зависимости согласно версий, закрепленных в файлах `composer.lock`, `package.json` и `yarn.lock`. Также, при сборке необходима проверка этих файлов и запуск `composer install` при их изменении. Чтобы добиться этого, в Werf есть директива `stageDependencies`.

Решение этих задач рассматривается в [соответствующем разделе]({{ site.baseurl }}/ru/documentation/configuration/stapel_image/git_directive.html) документации.
