#!/bin/bash

sudo docker stop get-bubblegum-data-db-1 &> /dev/null;
sudo docker rm -v get-bubblegum-data-db-1 &> /dev/null;

sudo docker volume ls;
