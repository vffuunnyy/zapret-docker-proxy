#!/bin/bash

sudo ./stop.sh

sudo docker-compose build
sudo docker-compose up -d

# wait for the container to be ready
until docker exec zapret-proxy echo "Container is ready"; do
  echo "Waiting for container to start..."
  sleep 2
done

sudo docker exec -it zapret-proxy ./enable_serices.sh

echo "We are about to run configuration"

sudo docker exec -it zapret-proxy ./run_blockcheck_in_container.sh

