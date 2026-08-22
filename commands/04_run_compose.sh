#!/bin/bash


docker compose up --build -d

echo "Docker compose started, press enter to enter the chat..."

docker compose attach bash-gpt

echo "Ending compose"
echo "-------------------------------------------------------------------"