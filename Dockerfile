FROM ubuntu:20.04

# Обновление системы и установка необходимых пакетов
RUN apt-get update && \
    apt-get install -y sudo curl iptables dnsmasq && \
    apt-get clean

# Копируем конфигурацию zapret в контейнер
COPY zapret /opt/zapret

# Установка прав на выполнение скриптов
WORKDIR /opt/zapret
RUN chmod +x install_easy.sh

# Запуск установки zapret и его сервисов
RUN yes "" | sudo ./install_easy.sh

# Команда запуска контейнера
CMD ["/bin/bash"]
