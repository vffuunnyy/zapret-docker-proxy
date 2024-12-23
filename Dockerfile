FROM ubuntu:20.04

# Установка необходимых пакетов
RUN apt-get update && \
    apt-get install -y sudo curl iptables dnsmasq dnscrypt-proxy systemd && \
    apt-get clean

# Устанавливаем переменные окружения для работы systemd
ENV container docker
STOPSIGNAL SIGRTMIN+3

# Создаем необходимые временные файловые системы
VOLUME [ "/sys/fs/cgroup", "/tmp", "/run" ]

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

# Включаем службы
RUN systemctl enable dnscrypt-proxy.service && \
    systemctl enable systemd-resolved.service

# Проверяем содержимое resolv.conf (опционально)
RUN cat /etc/resolv.conf

# Копируем файл config в директорию /zapret
COPY config /opt/zapret/config

# Установка и запуск zapret
RUN ./install_easy.sh | echo "" 

# Указываем команду запуска systemd
CMD ["/lib/systemd/systemd"]
