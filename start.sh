docker-compose build
docker-compose up -d
echo "./start.sh" | docker exec -it zapret-proxy ./start_zapret.sh