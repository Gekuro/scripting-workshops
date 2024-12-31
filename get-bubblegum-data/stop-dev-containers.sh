#!/bin/bash

sudo docker stop get-bubblegum-data-api-1 &> /dev/null;
sudo docker stop get-bubblegum-data-db-1 &> /dev/null;

sudo docker ps -a;
