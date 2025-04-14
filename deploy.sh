#!/bin/bash

# Включаем вывод команд и прерывание при ошибках
set -e
# Переходим в директорию проекта
PROJECT_DIR="/opt/star_burger_dockerizations"
cd $PROJECT_DIR

echo "Начало деплоя..."

echo "Подтягивание проекта..."
git pull

if [ -f .env ]; then
    source .env
fi

echo "Остановка контейнеров..."
docker-compose down

echo "Сборка Docker образов..."
docker-compose build

echo "Запуск контейнеров..."
docker-compose up -d

echo "Ждем готовности базы данных..."
sleep 10

echo "Применение миграций..."
docker-compose exec -T backend python manage.py migrate --noinput

echo "Сборка статических файлов..."
docker-compose exec -T backend python manage.py collectstatic --noinput

# Проверяем статус контейнеров
echo "Проверка статуса контейнеров..."
docker-compose ps

if [ ! -z "$ROLLBAR_ACCESS_TOKEN" ]; then
    echo "Отправка уведомления в Rollbar..."
    curl -s -H "X-Rollbar-Access-Token: $ROLLBAR_ACCESS_TOKEN" \
         -H "Content-Type: application/json" \
         -X POST 'https://api.rollbar.com/api/1/deploy' \
         -d "{
              \"environment\": \"${ROLLBAR_ENVIRONMENT:-production}\",
              \"revision\": \"$(git rev-parse HEAD)\",
              \"rollbar_name\": \"star_burger\",
              \"local_username\": \"$ROLLBAR_USERNAME\",
              \"status\": \"succeeded\"
            }" > /dev/null
fi

echo "Проверка логов на наличие ошибок..."
docker-compose logs --tail=20

echo "Деплой завершен!" 