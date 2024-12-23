FROM ubuntu:20.04

# Обновление системы и установка необходимых пакетов
RUN apt-get update && \
    apt-get install -y sudo curl iptables dnsmasq dnscrypt-proxy systemd && \
    apt-get clean

# Копируем директорию zapret в контейнер
COPY zapret /opt/zapret

# Установка прав на выполнение скриптов
WORKDIR /opt/zapret
RUN chmod +x install_bin.sh install_prereq.sh install_easy.sh

# Запуск установки zapret
RUN ./install_bin.sh && \
    echo "1" | ./install_prereq.sh

# Копируем конфигурационные файлы
COPY dnscrypt-proxy.toml /etc/dnscrypt-proxy/dnscrypt-proxy.toml
COPY resolv.conf /etc/resolv.conf

# Устанавливаем атрибут только для чтения для resolv.conf
RUN chattr +i /etc/resolv.conf

# Включаем и запускаем службы
RUN systemctl enable dnscrypt-proxy.service && \
    systemctl start dnscrypt-proxy.service && \
    systemctl enable systemd-resolved.service && \
    systemctl start systemd-resolved.service

# Копируем файл config в директорию /zapret
COPY config /opt/zapret/config

# Установка и запуск zapret
RUN yes "" | ./install_easy.sh

# Команда запуска контейнера
CMD ["/bin/bash"]
