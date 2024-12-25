#!/bin/bash

# Пути к файлам
SUMMARY_FILE="./configuration/blockcheck_summary.txt"
CONFIG_FILE="./configuration/blockcheck"
TMP_SUMMARY="./configuration/tmp_summary.txt"

cp "$SUMMARY_FILE" "$TMP_SUMMARY"

sed -i '/tpws/d' "$TMP_SUMMARY"

# Удаляем подстроку "nfqws" из оставшихся строк
sed -i 's/nfqws//g' "$TMP_SUMMARY"

# Проверяем, что файлы существуют
if [[ ! -f "$TMP_SUMMARY" ]]; then
  echo "Ошибка: Файл summary не найден: $SUMMARY_FILE"
  exit 1
fi

if [[ ! -f "$CONFIG_FILE" ]]; then
  echo "Ошибка: Файл конфигурации не найден: $CONFIG_FILE"
  exit 1
fi

# Функция для извлечения параметров из summary, исключая строки с tpws
get_summary_option() {
  local protocol=$1
  grep -i "curl_test_$protocol" "$TMP_SUMMARY" | head -n 1 | awk -F':' '{print $2}' | xargs
}

# Извлекаем параметры для HTTP, HTTPS и UDP
HTTP_OPTION=$(get_summary_option "http")
HTTPS_OPTION=$(get_summary_option "https_tls12")
UDP_OPTION=$(get_summary_option "https_tls12")

if [[ -z "$HTTP_OPTION" || -z "$HTTPS_OPTION" || -z "$UDP_OPTION" ]]; then
  echo "Ошибка: Не удалось извлечь параметры для HTTP, HTTPS или UDP (возможно, строки содержат tpws)."
  exit 1
fi

# Формируем параметры для конфигурации
HTTP_CONF="--filter-tcp=80 $HTTP_OPTION <HOSTLIST> --new"
HTTPS_CONF="--filter-tcp=443 $HTTPS_OPTION <HOSTLIST> --new"
UDP_CONF="--filter-udp=443 $UDP_OPTION <HOSTLIST_NOAUTO>"

# Обновляем конфигурационный файл
sed -i -E "s|--filter-tcp=80.*<HOSTLIST>.*|$HTTP_CONF|" "$CONFIG_FILE"
sed -i -E "s|--filter-tcp=443.*<HOSTLIST>.*|$HTTPS_CONF|" "$CONFIG_FILE"
sed -i -E "s|--filter-udp=443.*<HOSTLIST_NOAUTO>.*|$UDP_CONF|" "$CONFIG_FILE"

echo "Конфигурация обновлена:"
echo "HTTP: $HTTP_CONF"
echo "HTTPS: $HTTPS_CONF"
echo "UDP: $UDP_CONF"

sudo rm "$TMP_SUMMARY"

sudo mv ./config "./config.old.$(date +%Y%m%d%H%M%S)"

sudo cp "$CONFIG_FILE" ./config 