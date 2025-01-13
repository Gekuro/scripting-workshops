#!/bin/bash

sudo docker build --no-cache -t tic-tac-toe .
sudo docker stop tic-tac-toe-dev &> /dev/null
sudo docker rm tic-tac-toe-dev &> /dev/null
sudo docker run -it --name tic-tac-toe-dev tic-tac-toe
