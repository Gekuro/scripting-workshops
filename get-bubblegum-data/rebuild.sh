#!/bin/zsh

echo "\nRebuilding image\n"
sudo docker build -t get-bubblegum-data .

echo "\nCleaning existing develompent container\n"
sudo docker container stop /bubble-pop-dev > /dev/null
sudo docker rm /bubble-pop-dev > /dev/null

echo "Running container 'bubble-pop-dev'\n"
sudo docker run -d --name bubble-pop-dev -p 8080:8080 get-bubblegum-data