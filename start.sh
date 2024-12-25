#!/bin/bash

./stop.sh

docker-compose build
docker-compose up -d

# wait for the container to be ready
until docker exec zapret-proxy echo "Container is ready"; do
  echo "Waiting for container to start..."
  sleep 2
done

docker exec -it zapret-proxy ./scripts/start_zapret.sh