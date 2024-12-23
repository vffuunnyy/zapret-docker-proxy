FROM ubuntu:20.04

# Обновление системы и установка необходимых пакетов
RUN apt-get update && \
    apt-get install -y sudo curl iptables dnsmasq squid && \
    apt-get clean

# Копируем конфигурацию zapret в контейнер
COPY zapret /opt/zapret

# Установка прав на выполнение скриптов
WORKDIR /opt/zapret
RUN chmod +x install_easy.sh

# Запуск установки zapret и его сервисов
RUN yes "" | sudo ./install_easy.sh

# Копируем конфигурацию Squid
COPY squid.conf /etc/squid/squid.conf

# Открытие порта для прозрачного прокси
EXPOSE 3128

# Команда запуска контейнера
CMD ["bash", "-c", "squid -N & /bin/bash"]