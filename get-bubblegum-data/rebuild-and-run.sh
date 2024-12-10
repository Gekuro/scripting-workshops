#!/bin/zsh

sudo docker compose up --force-recreate -d --no-deps --build

echo "\n> sudo docker ps"
sudo docker ps

echo "\nhttp://localhost:8080/health"