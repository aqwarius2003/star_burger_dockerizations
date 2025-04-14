# Сайт доставки еды Star Burger

Это сайт сети ресторанов Star Burger. Здесь можно заказать превосходные бургеры с доставкой на дом.

![скриншот сайта](https://dvmn.org/filer/canonical/1594651635/686/)
Сеть Star Burger объединяет несколько ресторанов, действующих под единой франшизой. У всех ресторанов одинаковое меню и одинаковые цены. Просто выберите блюдо из меню на сайте и укажите место доставки. Мы сами найдём ближайший к вам ресторан, всё приготовим и привезём.

На сайте есть три независимых интерфейса. Первый — это публичная часть, где можно выбрать блюда из меню, и быстро оформить заказ без регистрации и SMS.

Второй интерфейс предназначен для менеджера. Здесь происходит обработка заказов. Менеджер видит поступившие новые заказы и первым делом созванивается с клиентом, чтобы подтвердить заказ. После оператор выбирает ближайший ресторан и передаёт туда заказ на исполнение. Там всё приготовят и сами доставят еду клиенту.

Третий интерфейс — это админка. Преимущественно им пользуются программисты при разработке сайта. Также сюда заходит менеджер, чтобы обновить меню ресторанов Star Burger.

## Запуск prod верисии сайта

## Подготовка к развертыванию

### 1. Требования к системе
- Docker
- Docker Compose
- Git
- Bash (для скрипта автодеплоя)

### 2. Настройка переменных окружения
Создайте файл `.env` в корневой директории проекта:

```env
# Django
SECRET_KEY=your-secret-key
DEBUG=False
ALLOWED_HOSTS=your-domain.com,www.your-domain.com

# База данных
POSTGRES_USER=your_db_user
POSTGRES_PASSWORD=your_secure_password
POSTGRES_DB=starburger_db
DATABASE_URL=postgres://your_db_user:your_secure_password@db:5432/starburger_db

# Rollbar (опционально)
ROLLBAR_ACCESS_TOKEN=your_rollbar_token
ROLLBAR_ENVIRONMENT=production
ROLLBAR_LOCAL_USERNAME=your_username
```

## Развертывание

### 1. Клонирование репозитория
```bash
git clone https://github.com/aqwarius2003/star_burger_dockerizations.git
cd star_burger_dockerizations
```

### 2. Запуск в production режиме
```bash
# Запуск автодеплоя
./deploy.sh
```

### 3. Первоначальная настройка
```bash
# Создание суперпользователя Django
docker-compose exec backend python manage.py createsuperuser

# Загрузка начальных данных (если необходимо)
docker-compose exec backend python manage.py loaddata starburger_db.json
```

## Обновление приложения

### 1. Обновление кода
```bash
git pull origin main
```

### 2. Запуск автодеплоя
```bash
./deploy.sh
```

## Мониторинг и обслуживание

### 1. Просмотр логов
```bash
# Все сервисы
docker-compose logs

# Конкретный сервис
docker-compose logs backend
docker-compose logs frontend
docker-compose logs db
```

### 2. Резервное копирование базы данных
```bash
# Создание бэкапа
docker-compose exec db pg_dump -U $POSTGRES_USER $POSTGRES_DB > backup.sql

# Восстановление из бэкапа
cat backup.sql | docker-compose exec -T db psql -U $POSTGRES_USER -d $POSTGRES_DB
```

## Структура проекта

star-burger/
├── backend/          # Django приложение
├── frontend/         # React/JS фронтенд
├── docker-compose.yaml
├── .env             # Переменные окружения
└── README.md        # Этот файл
```


## Как запустить dev-версию сайта

Для запуска сайта нужно запустить **одновременно** бэкенд и фронтенд, в двух терминалах.

### Как собрать бэкенд

Скачайте код:
```sh
git clone https://github.com/devmanorg/star-burger.git
```

Перейдите в каталог проекта:
```sh
cd star-burger
```

[Установите Python](https://www.python.org/), если этого ещё не сделали.

Проверьте, что `python` установлен и корректно настроен. Запустите его в командной строке:
```sh
python --version
```
**Важно!** Версия Python должна быть не ниже 3.6.

Возможно, вместо команды `python` здесь и в остальных инструкциях этого README придётся использовать `python3`. Зависит это от операционной системы и от того, установлен ли у вас Python старой второй версии.

В каталоге проекта создайте виртуальное окружение:
```sh
python -m venv venv
```
Активируйте его. На разных операционных системах это делается разными командами:

- Windows: `.\venv\Scripts\activate`
- MacOS/Linux: `source venv/bin/activate`


Установите зависимости в виртуальное окружение:
```sh
pip install -r requirements.txt
```

Определите переменную окружения `SECRET_KEY`. Создать файл `.env` в каталоге `star_burger/` и положите туда такой код:
```sh
SECRET_KEY=django-insecure-0if40nf4nf93n4
```

Создайте файл базы данных SQLite и отмигрируйте её следующей командой:

```sh
python manage.py migrate
```

Запустите сервер:

```sh
python manage.py runserver
```

Откройте сайт в браузере по адресу [http://127.0.0.1:8000/](http://127.0.0.1:8000/). Если вы увидели пустую белую страницу, то не пугайтесь, выдохните. Просто фронтенд пока ещё не собран. Переходите к следующему разделу README.

### Собрать фронтенд

**Откройте новый терминал**. Для работы сайта в dev-режиме необходима одновременная работа сразу двух программ `runserver` и `parcel`. Каждая требует себе отдельного терминала. Чтобы не выключать `runserver` откройте для фронтенда новый терминал и все нижеследующие инструкции выполняйте там.

[Установите Node.js](https://nodejs.org/en/), если у вас его ещё нет.

Проверьте, что Node.js и его пакетный менеджер корректно установлены. Если всё исправно, то терминал выведет их версии:

```sh
nodejs --version
# v16.16.0
# Если ошибка, попробуйте node:
node --version
# v16.16.0

npm --version
# 8.11.0
```

Версия `nodejs` должна быть не младше `10.0` и не старше `16.16`. Лучше ставьте `16.16.0`, её мы тестировали. Версия `npm` не важна. Как обновить Node.js читайте в статье: [How to Update Node.js](https://phoenixnap.com/kb/update-node-js-version).

Перейдите в каталог проекта и установите пакеты Node.js:

```sh
cd star-burger
npm ci --dev
```

Команда `npm ci` создаст каталог `node_modules` и установит туда пакеты Node.js. Получится аналог виртуального окружения как для Python, но для Node.js.

Помимо прочего будет установлен [Parcel](https://parceljs.org/) — это упаковщик веб-приложений, похожий на [Webpack](https://webpack.js.org/). В отличии от Webpack он прост в использовании и совсем не требует настроек.

Теперь запустите сборку фронтенда и не выключайте. Parcel будет работать в фоне и следить за изменениями в JS-коде:

```sh
./node_modules/.bin/parcel watch bundles-src/index.js --dist-dir bundles --public-url="./"
```

Если вы на Windows, то вам нужна та же команда, только с другими слешами в путях:

```sh
.\node_modules\.bin\parcel watch bundles-src/index.js --dist-dir bundles --public-url="./"
```

Дождитесь завершения первичной сборки. Это вполне может занять 10 и более секунд. О готовности вы узнаете по сообщению в консоли:

```
✨  Built in 10.89s
```

Parcel будет следить за файлами в каталоге `bundles-src`. Сначала он прочитает содержимое `index.js` и узнает какие другие файлы он импортирует. Затем Parcel перейдёт в каждый из этих подключенных файлов и узнает что импортируют они. И так далее, пока не закончатся файлы. В итоге Parcel получит полный список зависимостей. Дальше он соберёт все эти сотни мелких файлов в большие бандлы `bundles/index.js` и `bundles/index.css`. Они полностью самодостаточны, и потому пригодны для запуска в браузере. Именно эти бандлы сервер отправит клиенту.

Теперь если зайти на страницу  [http://127.0.0.1:8000/](http://127.0.0.1:8000/), то вместо пустой страницы вы увидите:

![](https://dvmn.org/filer/canonical/1594651900/687/)

Каталог `bundles` в репозитории особенный — туда Parcel складывает результаты своей работы. Эта директория предназначена исключительно для результатов сборки фронтенда и потому исключёна из репозитория с помощью `.gitignore`.

**Сбросьте кэш браузера <kbd>Ctrl-F5</kbd>.** Браузер при любой возможности старается кэшировать файлы статики: CSS, картинки и js-код. Порой это приводит к странному поведению сайта, когда код уже давно изменился, но браузер этого не замечает и продолжает использовать старую закэшированную версию. В норме Parcel решает эту проблему самостоятельно. Он следит за пересборкой фронтенда и предупреждает JS-код в браузере о необходимости подтянуть свежий код. Но если вдруг что-то у вас идёт не так, то начните ремонт со сброса браузерного кэша, жмите <kbd>Ctrl-F5</kbd>.


## Как запустить prod-версию сайта

Собрать фронтенд:

```sh
./node_modules/.bin/parcel build bundles-src/index.js --dist-dir bundles --public-url="./"
```

Настроить бэкенд: создать файл `.env` в каталоге `star_burger/` со следующими настройками:

- `DEBUG` — дебаг-режим. Поставьте `False`.
- `SECRET_KEY` — секретный ключ проекта. Он отвечает за шифрование на сайте. Например, им зашифрованы все пароли на вашем сайте.
- `ALLOWED_HOSTS` — [см. документацию Django](https://docs.djangoproject.com/en/3.1/ref/settings/#allowed-hosts)
- `ROLLBAR_ACCESS_TOKEN` - токен Rollbar. Получить можно на официальном [сайте](https://rollbar.com/)
- `ROLLBAR_ENVIRONMENT` - название окружения Rollbar. По умолчанию `production`
- `DATABASE_URL` — URL для подключения к PostgreSQL в формате:
  `postgresql://<пользователь>:<пароль>@<хост>:<порт>/<название_базы>`


## Рекомендации
Для production-среды рекомендуется использовать PostgreSQL как надежное и масштабируемое решение для работы с данными.


## Установка и настройка PostgreSQL

1. Установите необходимые компоненты:
```bash
sudo apt install postgresql postgresql-contrib
```

```bash
sudo su - postgres
psql

-- Создание базы данных
CREATE DATABASE mydb_name;

-- Создание пользователя с правами
CREATE USER mydb_user WITH PASSWORD 'password';

-- Настройка параметров пользователя
ALTER ROLE mydb_user SET client_encoding TO 'utf8';
ALTER ROLE mydb_user SET default_transaction_isolation TO 'read committed';
ALTER ROLE mydb_user SET timezone TO 'UTC';

-- Выдача привилегий (для версий PostgreSQL <15)
GRANT ALL PRIVILEGES ON DATABASE mydb_name TO mydb_user;

-- Для версий 15+
\connect mydb_name;
CREATE SCHEMA myschema AUTHORIZATION mydb_user; -- Замените 'myschema' на нужное название

-- Выход из консоли
\q
exit
```

### Миграция данных

Экспортируйте данные из SQLite в JSON:

```bash
python3 manage.py dumpdata --exclude contenttypes > starburger_db.json
```
Обновите конфигурацию в settings.py:

```python

DATABASES = {
    'default': dj_database_url.parse(DATABASE_URL)
}

# Для версий PostgreSQL 15+ укажите схему
DATABASES['default']['OPTIONS'] = {
    'options': '-c search_path=starburger_db_schema'  # Замените на ваше название схемы
}
```

Примените миграции и загрузите данные:

```bash

python3 manage.py migrate
python3 manage.py loaddata starburger_db.json
```
Примечания

- Для работы с dj_database_url убедитесь, что пакет установлен:
```pip install dj-database-url```
- Сохраните актуальные параметры подключения в переменных окружения
- Убедитесь, что название схемы совпадает с указанным при создании

# Автоматизация процесса обновления кода на сервере

В репозитории размещен скрипт ***`autodeploy.sh`***, предназначенный для упрощения процесса деплоя. Данный скрипт автоматически выполняет обновление кода на сервере при каждом изменении в репозитории.

Для запуска скрипта выполните следующую команду в терминале:

```sh
./autodeploy.sh
```

## Актуальная версия веб-сайта

Ознакомиться с рабочей версией сайта можно по следующей ссылке:

- [Starburger](https://starburger.victor-r.online/)




## Цели проекта

Код написан в учебных целях — это урок в курсе по Python и веб-разработке на сайте [Devman](https://dvmn.org). За основу был взят код проекта [FoodCart](https://github.com/Saibharath79/FoodCart).

Где используется репозиторий:

- Второй и третий урок [учебного курса Django](https://dvmn.org/modules/django/)
