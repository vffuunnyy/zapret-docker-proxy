#!/bin/bash

sudo ./stop.sh

# sudo docker-compose build
sudo docker-compose up --build -d

# wait for the container to be ready
until docker exec zapret-proxy echo "Container is ready"; do
  echo "Waiting for container to start..."
  sleep 2
done

sudo docker exec zapret-proxy ./enable_services.sh

sudo docker exec zapret-proxy ./run_blockcheck_in_container.sh

sudo ./scripts/form_config.sh

sudo docker exec zapret-proxy ./start_zapret.sh