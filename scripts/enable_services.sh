#!/bin/bash

### this file runs after the container starts ###

#!/bin/bash

# Находим процессы, которые используют порт 53
echo "Ищем процессы, занимающие порт 53..."
PROCESS_LIST=$(lsof -i :53 -sTCP:LISTEN -n -P | awk 'NR>1 {print $2}')

if [[ -z "$PROCESS_LIST" ]]; then
  echo "Нет процессов, слушающих порт 53."
  exit 0
fi

# Выводим найденные процессы
echo "Найдены следующие процессы, слушающие порт 53:"
lsof -i :53 -sTCP:LISTEN -n -P

# Завершаем процессы
echo "Завершаем процессы..."
for PID in $PROCESS_LIST; do
  echo "Завершаем процесс с PID $PID..."
  kill -9 "$PID" 2>/dev/null
  if [[ $? -eq 0 ]]; then
    echo "Процесс с PID $PID успешно завершён."
  else
    echo "Ошибка при завершении процесса с PID $PID."
  fi
done

echo "Все процессы, слушающие порт 53, завершены."

systemctl restart dnsmasq.service
systemctl enable dnscrypt-proxy.service
systemctl start dnscrypt-proxy.service
systemctl enable systemd-resolved.service
systemctl start systemd-resolved.service
systemctl restart squid

echo "services enabled and started"

exit 0