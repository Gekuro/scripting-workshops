#!/bin/bash

sudo docker compose up --force-recreate -d --no-deps --build

echo -e "\n> sudo docker ps"
sudo docker ps

echo -e "\nhttp://localhost:8080/health"