---
title: Приложение с несколькими образами
sidebar: documentation
permalink: ru/documentation/guides/advanced_build/multi_images.html
author: Artem Kladov <artem.kladov@flant.com>
ref: documentation_guides_advanced_build_multi_images
lang: ru
---

## Обзор задачи

Довольно часто, приложение не является монолитным, а состоит из нескольких микросервисов. Это могут быть микросервисы написанные с использованием разных технологий, фреймворков, языков программирования и т.д.
Сложившийся подход в таких случаях — положить Dockerfile для сборки образа каждого микросервиса в отдельную папку, т.к. в одном Dockerfile вы не можете описать все компоненты вашего приложения. И, т.к. вам нужно описывать сборку каждого образа микросервиса в отдельном файле, вы не можете использовать, например, какие-либо общие части конфигурации сборки.

Werf же, позволяет описать все образы проекта в одном конфигурационном файле, и это действительно удобно.

В данной статье рассматривается сборка тестового приложения [AtSea Shop](https://github.com
/dockersamples/atsea-sample-shop-app) и демонстрируется сборка нескольких образом компоннетов приложения в одном конфигурационном файле.

## Требования

* Установленные [зависимости Werf]({{ site.baseurl }}/ru/documentation/guides/installation.html#install-dependencies).
* Установленный [Multiwerf](https://github.com/flant/multiwerf).

### Выбор версии Werf

Перед началом работы с Werf, нужно выбрать версию Werf, которую вы будете использовать. Для выбора актуальной версии Werf в канале beta, релиза 1.0, выполните в вашей shell-сессии:

```shell
source <(multiwerf use 1.0 beta)
```

## Сборка приложения

В качестве тестового приложения будет рассматриваться приложение [AtSea Shop](https://github.com/dockersamples/atsea-sample-shop-app) из оффициального [репозитория примеров Docker](https://github.com/dockersamples). Это приложение — прототип небольшого интернет-магазина, оно состоит из нескольких компонентов — frontend (написан на ReactJS) и backend (Java Spring Boot). Также, для большей правдоподобности, в проект добавлены reverse-прокси на базе nginx и платежный шлюз.

## Компоненты приложения

### Backend

Образ с именем `app`. Контейнер с backend принимает HTTP-запросы от контейнера frontend. Исходный код приложения находится в папке `/app`, и состоит из приложения на Java и приложения на ReactJS. Для сборки образа backend, будем использовать два артефакта (читай подробней об артефактах [здесь]({{ site.baseurl }}/ru/documentation/configuration/stapel_artifact.html)) — `storefront` и `appserver`.

Образ самого backend основан на официальном образе Java. Он использует файлы из артефактов и не требует дополнительных шагов по скачиванию и сборке чего-либо.

```yaml
image: app
from: java:8-jdk-alpine
docker:
  ENTRYPOINT: ["java", "-jar", "/app/AtSea-0.0.1-SNAPSHOT.jar"]
  CMD: ["--spring.profiles.active=postgres"]
shell:
  beforeInstall:
  - mkdir /app
  - adduser -Dh /home/gordon gordon
import:
- artifact: storefront
  add: /usr/src/atsea/app/react-app/build
  to: /static
  after: install
- artifact: appserver
  add: /usr/src/atsea/target/AtSea-0.0.1-SNAPSHOT.jar
  to: /app
  after: install
```

#### Артефакт Storefront

В артефакте выполняется сборка asset'ов, после чего, ассет'ы импортируются в папку `/static` в backend-образ `app`. Для эффективности, сборка образа `storefront` разделена на две стадии — _install_ и _setup_.

```yaml
artifact: storefront
from: node:12.10-alpine
git:
- add: /app/react-app
  to: /usr/src/atsea/app/react-app
  stageDependencies:
    install:
    - package.json
    setup:
    - src
    - public
shell:
  install:
  - cd /usr/src/atsea/app/react-app
  - npm install
  setup:
  - cd /usr/src/atsea/app/react-app
  - npm run build
```

#### Артефакт Appserver

В артефакте выполняется сборка Java-кода, после чего результат — jar-файл `AtSea-0.0.1-SNAPSHOT.jar` импортируется в папку `/app` в backend-образ `app`. Для эффективности, сборка образа `appserver` разделена на две стадии — _install_ и _setup_. А также, папка `/usr/share/maven/ref/repository` монтируется с помощью инструкции `build_dir`, чтобы заработало кеширование (читай подробнее об инструкциях монтирования [здесь]({{ site.baseurl }}/ru/documentation/configuration/stapel_image/mount_directive.html)).

```yaml
artifact: appserver
from: maven:3.6.2-jdk-8
mount:
- from: build_dir
  to: /usr/share/maven/ref/repository
git:
- add: /app
  to: /usr/src/atsea
  stageDependencies:
    install:
    - pom.xml
    setup:
    - src
shell:
  install:
  - cd /usr/src/atsea
  - mvn -B -f pom.xml -s /usr/share/maven/ref/settings-docker.xml dependency:go-offline
  setup:
  - cd /usr/src/atsea
  - mvn -B -s /usr/share/maven/ref/settings-docker.xml package -DskipTests
```

### Frontend

Образ с именем `reverse_proxy`, базирующийся на оффициальном образе сервера [NGINX](https://www.nginx.com). Выступает в качестве точки приема входящего трафика в приложение (frontend) и настроен как реверсный прокси. Т.е. его роль — прием внешнего траффика, кеширование и передача соответствующего траффика на backend-контейнер.

{% raw %}
```yaml
image: reverse_proxy
from: nginx:1.17-alpine
ansible:
  install:
  - name: "Copy nginx.conf"
    copy:
      content: |
{{ .Files.Get "reverse_proxy/nginx.conf" | indent 8 }}
      dest: /etc/nginx/nginx.conf
  - name: "Copy SSL certificates"
    file:
      path: /run/secrets
      state: directory
      owner: nginx
  - copy:
      content: |
{{ .Files.Get "reverse_proxy/certs/revprox_cert" | indent 8 }}
      dest: /run/secrets/revprox_cert
  - copy:
      content: |
{{ .Files.Get "reverse_proxy/certs/revprox_key" | indent 8 }}
      dest: /run/secrets/revprox_key
```
{% endraw %}

### Database

Образ базы данных с именем `database`, базирующийся на официальном образе СУБД PostgreSQL. В образ добавлены инструкции и SQL-файлы для конфигурации сервера PostgreSQL. БД нужна, т.к. backend-контейнер использует её для хранения данных.

{% raw %}
```yaml
image: database
from: postgres:11
docker:
  ENV:
    POSTGRES_USER: gordonuser
    POSTGRES_DB: atsea
ansible:
  install:
  - raw: mkdir -p /images/
  - name: "Copy DB configs"
    copy:
      content: |
{{ .Files.Get "database/pg_hba.conf" | indent 8 }}
      dest: /usr/share/postgresql/11/pg_hba.conf
  - copy:
      content: |
{{ .Files.Get "database/postgresql.conf" | indent 8 }}
      dest:  /usr/share/postgresql/11/postgresql.conf
git:
- add: /database/docker-entrypoint-initdb.d/
  to:  /docker-entrypoint-initdb.d/
```
{% endraw %}

### Payment gateway

Образ с именем `payment_gw`, — образ демонстрационного приложения платежного шлюза. По сути он не делает ничего, кроме того, что пишет в stdout сообщения. Его роль в настоящем примере — быть еще одним компонентом (микросервисом) приложения.

{% raw %}
```yaml
image: payment_gw
from: alpine:3.9
docker:
  CMD: ["/home/payment/process.sh"]
ansible:
  beforeInstall:
  - name: "Create payment user"
    user:
      name: payment
      comment: "Payment user"
      shell: /bin/sh
      home: /home/payment
  - file:
      path: /run/secrets
      state: directory
      owner: payment
  - copy:
      content: |
        production
      dest: /run/secrets/payment_token
git:
- add: /payment_gateway/process.sh
  to: /home/payment/process.sh
  owner: payment
```
{% endraw %}

## Шаг 1: Клонирование репозитория кода приложения

Клонируйте репозиторий кода приложения [AtSea Shop](https://github.com/dockersamples/atsea-sample-shop-app):

```bash
git clone https://github.com/dockersamples/atsea-sample-shop-app.git
```

## Шаг 2: Создание конфигурации

Для сборки приложения со всеми его компонентами, в **корневой папке** репозитория создайте файл `werf.yaml` следующего содержания:

<div class="details active">
<a href="javascript:void(0)" class="details__summary">Полный файл <i>werf.yaml</i>...</a>
<div class="details__content" markdown="1">

{% raw %}
```yaml
project: atsea-shop
configVersion: 1
---

artifact: storefront
from: node:12.10-alpine
git:
- add: /app/react-app
  to: /usr/src/atsea/app/react-app
  stageDependencies:
    install:
    - package.json
    setup:
    - src
    - public
shell:
  install:
  - cd /usr/src/atsea/app/react-app
  - npm install
  setup:
  - cd /usr/src/atsea/app/react-app
  - npm run build
---
artifact: appserver
from: maven:3.6.2-jdk-8
mount:
- from: build_dir
  to: /usr/share/maven/ref/repository
git:
- add: /app
  to: /usr/src/atsea
  stageDependencies:
    install:
    - pom.xml
    setup:
    - src
shell:
  install:
  - cd /usr/src/atsea
  - mvn -B -f pom.xml -s /usr/share/maven/ref/settings-docker.xml dependency:go-offline
  setup:
  - cd /usr/src/atsea
  - mvn -B -s /usr/share/maven/ref/settings-docker.xml package -DskipTests
---
image: app
from: java:8-jdk-alpine
docker:
  ENTRYPOINT: ["java", "-jar", "/app/AtSea-0.0.1-SNAPSHOT.jar"]
  CMD: ["--spring.profiles.active=postgres"]
shell:
  beforeInstall:
  - mkdir /app
  - adduser -Dh /home/gordon gordon
import:
- artifact: storefront
  add: /usr/src/atsea/app/react-app/build
  to: /static
  after: install
- artifact: appserver
  add: /usr/src/atsea/target/AtSea-0.0.1-SNAPSHOT.jar
  to: /app
  after: install
---
image: reverse_proxy
from: nginx:1.17-alpine
ansible:
  install:
  - name: "Copy nginx.conf"
    copy:
      content: |
{{ .Files.Get "reverse_proxy/nginx.conf" | indent 8 }}
      dest: /etc/nginx/nginx.conf
  - name: "Copy SSL certificates"
    file:
      path: /run/secrets
      state: directory
      owner: nginx
  - copy:
      content: |
{{ .Files.Get "reverse_proxy/certs/revprox_cert" | indent 8 }}
      dest: /run/secrets/revprox_cert
  - copy:
      content: |
{{ .Files.Get "reverse_proxy/certs/revprox_key" | indent 8 }}
      dest: /run/secrets/revprox_key
---
image: database
from: postgres:11
docker:
  ENV:
    POSTGRES_USER: gordonuser
    POSTGRES_DB: atsea
ansible:
  install:
  - raw: mkdir -p /images/
  - name: "Copy DB configs"
    copy:
      content: |
{{ .Files.Get "database/pg_hba.conf" | indent 8 }}
      dest: /usr/share/postgresql/11/pg_hba.conf
  - copy:
      content: |
{{ .Files.Get "database/postgresql.conf" | indent 8 }}
      dest:  /usr/share/postgresql/11/postgresql.conf
git:
- add: /database/docker-entrypoint-initdb.d/
  to:  /docker-entrypoint-initdb.d/
---
image: payment_gw
from: alpine:3.9
docker:
  CMD: ["/home/payment/process.sh"]
ansible:
  beforeInstall:
  - name: "Install shadow utils"
    package:
      name: shadow
      state: present
  - name: "Create payment user"
    user:
      name: payment
      comment: "Payment user"
      shell: /bin/sh
      home: /home/payment
  - file:
      path: /run/secrets
      state: directory
      owner: payment
  - copy:
      content: |
        production
      dest: /run/secrets/payment_token
git:
- add: /payment_gateway/process.sh
  to: /home/payment/process.sh
  owner: payment
```
{% endraw %}

</div>
</div>

## Step 3: Создание SSL-сертификата

Т.к. в образе `reverse_proxy` NGINX принимает запросы по SSL — ему нужен соответствующий ключ и сертификат.

Для создания ключа и сертификата выполните следующую команду в корневой папке проекта:

```bash
mkdir -p reverse_proxy/certs && openssl req -newkey rsa:4096 -nodes -subj "/CN=atseashop.com;" -sha256 -keyout reverse_proxy/certs/revprox_key -x509 -days 365 -out reverse_proxy/certs/revprox_cert
```

## Step 4: Сборка образов

Для сборки всех образов проекта, выполните следующую команду в корневой папке проекта:

```bash
werf build --stages-storage :local
```

## Step 5: Добавление информации в файл /etc/hosts

Чтобы пример открывался в браузере по имени `http://atseashop.com`, добавьте в файл `etc/hosts` строку для `atseashop.com` с адресом локального интерфейса. Например вот так:
```bash
sudo sed -ri 's/^(127.0.0.1)(\s)+/\1\2atseashop.com /' /etc/hosts
```

## Step 6: Запуск приложения

Для запуска приложения, выполните следующие команды в корневой папке проекта:

```bash
werf run --stages-storage :local --docker-options="-d --name payment_gw" payment_gw  &&
werf run --stages-storage :local --docker-options="-d --name database -p 5432:5432" database &&
werf run --stages-storage :local --docker-options="-d --name app -p 8080:8080 --link database:database" app &&
werf run --stages-storage :local --docker-options="-d --name reverse_proxy -p 80:80 -p 443:443 --link app:appserver" reverse_proxy
```

Проверьте что все контейнеры запустились, выполнив:
```bash
docker ps
```

В выводе команды должны присутствовать запущенные контейнеры с именами: `reverse_proxy`, `app`, `database`, `payment_gw` и `registry`.

Подождите около 30 секунд, чтобы все контейнеры успели успели после старта перейти в режим готовности, затем откройте в браузере адрес [atseashop.com](http://atseashop.com). Произойдет перенаправление на адерс `https://atseashop.com` и вы получите предупреждение безопасности от браузера, — следствие использования самоподписанного SSL-сертификата. Добавьте в браузере исключение для `https://atseashop.com` page.

## Остановка приложения

Для остановки контейнеров приложения выполните следующую команду:

```bash
docker stop reverse_proxy app database payment_gw
```

## Выводы

Мы описали инструкции по сборке всех образов приложения в одном файле. Приведенный пример иллюстрирует следующие возможности:
* Если в вашем проекте есть схожие образы, вы можете обеспечить совместное использование каких либо частей в образах с помощью монтирования папок директивой  `build_dir` (читайте подробнее об этом [здесь]({{ site.baseurl }}/ru/documentation/configuration/stapel_image/mount_directive.html)).
* Вы можете использовать общие артефакты в разных образах, описав все это в одном файле конфигураций.
* Вы можете использовать шаблоны в файле конфигураций, для описания образов со схожими инструкциями.
