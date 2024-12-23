#!/bin/bash

# Очистка старых правил iptables
iptables -F
iptables -t nat -F
iptables -X

# Перенаправление трафика к определённым доменам через локальный прокси (порт 3128)
PROXY_PORT=3128

# Добавляем IP-адреса для проксирования
DOMAINS=(
    "googlevideo.com"
    "youtu.be"
    "youtube.com"
    "youtubei.googleapis.com"
    "youtubeembeddedplayer.googleapis.com"
    "ytimg.l.google.com"
    "ytimg.com"
    "jnn-pa.googleapis.com"
    "youtube-nocookie.com"
    "youtube-ui.l.google.com"
    "yt-video-upload.l.google.com"
    "wide-youtube.l.google.com"
    "youtubekids.com"
    "ggpht.com"
    "discord.com"
    "gateway.discord.gg"
    "cdn.discordapp.com"
    "discordapp.net"
    "discordapp.com"
    "discord.gg"
    "media.discordapp.net"
    "images-ext-1.discordapp.net"
    "discord.app"
    "discord.media"
    "discordcdn.com"
    "discord.dev"
    "discord.new"
    "discord.gift"
    "discordstatus.com"
    "dis.gd"
    "discord.co"
    "discord-attachments-uploads-prd.storage.googleapis.com"
    "7tv.app"
    "7tv.io"
    "10tv.app"
    "cloudflare-ech.com"
)

# Функция добавления правил для IP-адреса
add_iptables_rules() {
    local ip="$1"
    echo "Добавление правил для $ip"
    for port in 80 443; do
        iptables -t nat -A OUTPUT -p tcp -d "$ip" --dport "$port" -j REDIRECT --to-ports $PROXY_PORT
    done
}

# Обрабатываем домены
for domain in "${DOMAINS[@]}"; do
    echo "Обработка домена: $domain"
    ip_addresses=$(dig +short "$domain" | grep -E '^[0-9.]+$')
    if [[ -z "$ip_addresses" ]]; then
        echo "⚠️  Не удалось разрешить домен: $domain"
        continue
    fi

    for ip in $ip_addresses; do
        add_iptables_rules "$ip"
    done
done

# Сохраняем правила iptables
iptables-save > /etc/iptables/rules.v4

echo "✅ Правила iptables успешно обновлены!"