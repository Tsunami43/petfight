#!/bin/bash

# Переходим в директорию выше текущей
cd "$(dirname "$0")/.."

# Переменная с путем к директории backend
backend_dir="./backend"

# Список папок для обхода
folders=("auth_service" "claimed_service" "tasks_service" "telegram_bot")

# Функция для создания venv и установки зависимостей
setup_venv() {
    local folder="$1"
    echo "Setting up venv for $folder"
    cd "$backend_dir/$folder" || exit 1
    python -m venv venv
    source venv/bin/activate
    pip install -r requirements.txt
    deactivate
}

# Функция для создания демонов
create_daemon() {
    local folder="$1"
    echo "Creating daemon for $folder"
}

# Основной цикл
for folder in "${folders[@]}"
do
    setup_venv "$folder"
done

echo "Setup complete!"