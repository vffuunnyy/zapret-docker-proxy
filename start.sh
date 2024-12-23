docker-compose build
docker-compose up -d
echo "./start.sh" | docker exec -it zapret-proxy bash