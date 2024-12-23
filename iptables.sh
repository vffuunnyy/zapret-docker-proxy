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

# Обрабатываем домены
for domain in "${DOMAINS[@]}"; do
    ip_addresses=$(dig +short "$domain" | grep -E '^[0-9.]+$')
    for ip in $ip_addresses; do
        # Перенаправляем HTTP-трафик через прокси
        iptables -t nat -A OUTPUT -p tcp -d "$ip" --dport 80 -j REDIRECT --to-ports $PROXY_PORT
        iptables -t nat -A OUTPUT -p tcp -d "$ip" --dport 443 -j REDIRECT --to-ports $PROXY_PORT
    done
done

# Сохраняем правила iptables
iptables-save > /etc/iptables/rules.v4