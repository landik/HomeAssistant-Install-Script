#!/bin/bash

echo -en "\n"
echo "==============================================================="
echo "          Установка Home Assistant и его зависимостей"
echo "==============================================================="

echo -en "\n"
echo "# # Установка необходимых зависимостей"
sudo apt-get install python3 python3-dev python3-venv python3-pip libffi-dev libssl-dev -y

echo -en "\n"
echo "# # Создание аккаунта под названием homeassistant"
sudo useradd -rm homeassistant -G dialout,gpio,i2c

echo -en "\n"
echo "# # Создание каталога homeassistant с передачей прав новому аккаунту"
cd /srv
sudo mkdir homeassistant
sudo chown homeassistant:homeassistant homeassistant

echo -en "\n"
echo "# # Создание виртуальной среды для нового аккаунта"
sudo rm -rf /srv/homeassistant/nohup.out
sudo rm -rf /srv/homeassistant/seaech_install.sh
sleep 2
sudo su homeassistant -c "cd /srv/homeassistant ; python3 -m venv . ; source bin/activate ; python3 -m pip install wheel ; echo -en '\n' ; echo '# # Устновка Home Assistant...' ; pip3 install homeassistant ; nohup hass &"
echo -en "\n"
echo "# # Первый запуск Home Assistant и его настройка..."

sudo tee -a /srv/homeassistant/seaech_install.sh > /dev/null <<_EOF_
until grep "Setting up config" /srv/homeassistant/nohup.out
  do
  sleep 10
  done
echo "         Настройка конфигурации..."
until grep "Starting Home Assistant" /srv/homeassistant/nohup.out
  do
  sleep 10
  done
echo "         Первый запуск Home Assistant и его настройка завершена..."
_EOF_
sleep 1

echo -en "\n"
echo "         это займет некоторое время... ждем завершения..."
sudo su homeassistant -c "bash /srv/homeassistant/seaech_install.sh"

echo -en "\n"
echo "# # Убывание процесса hass"
sudo killall  -w -s 9 -u homeassistant

echo -en "\n"
echo "# # Удаление хвостов..."
sudo rm -rf /srv/homeassistant/nohup.out
sudo rm -rf /srv/homeassistant/seaech_install.sh

echo -en "\n"
echo "# # тест 1!"
htop
