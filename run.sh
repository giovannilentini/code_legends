#!/bin/bash

# Variables
IMAGE_NAME="code_legends_web"
CONTAINER_NAME="code_legends_app"
DB_CONTAINER_NAME="code_legends_db"
REDIS_CONTAINER_NAME="code_legends_redis"

# Check if Docker is running
if (! docker stats --no-stream > /dev/null 2>&1); then
  echo "Docker is not running. Starting Docker..."
  sudo systemctl start docker
  if [ $? -ne 0 ]; then
    echo "Failed to start Docker. Please check your Docker installation."
    exit 1
  fi
else
  echo "Docker is running."
fi

# Check if the image already exists
if [[ "$(docker images -q $IMAGE_NAME 2> /dev/null)" == "" ]]; then
  echo "Building the Docker image..."
  docker compose build
else
  echo "Docker image $IMAGE_NAME already exists. Skipping build."
fi

# Check if the PostgreSQL container is running
if [ "$(docker ps -q -f name=$DB_CONTAINER_NAME)" ]; then
  echo "PostgreSQL container $DB_CONTAINER_NAME is already running."
else
  if [ "$(docker ps -aq -f status=exited -f name=$DB_CONTAINER_NAME)" ]; then
    # Start the stopped container
    echo "Starting existing PostgreSQL container..."
    docker start $DB_CONTAINER_NAME
  else
    echo "No PostgreSQL container found. Starting a new one..."
    docker compose up -d db
  fi
fi

# Check if the Redis container is running
if [ "$(docker ps -q -f name=$REDIS_CONTAINER_NAME)" ]; then
  echo "Redis container $REDIS_CONTAINER_NAME is already running."
else
  if [ "$(docker ps -aq -f status=exited -f name=$REDIS_CONTAINER_NAME)" ]; then
    # Start the stopped container
    echo "Starting existing Redis container..."
    docker start $REDIS_CONTAINER_NAME
  else
    echo "No Redis container found. Starting a new one..."
    docker compose up -d redis
  fi
fi

# Check if the Rails app container is running
if [ "$(docker ps -q -f name=$CONTAINER_NAME)" ]; then
  echo "Rails app container $CONTAINER_NAME is already running."
else
  if [ "$(docker ps -aq -f status=exited -f name=$CONTAINER_NAME)" ]; then
    # Start the stopped container
    echo "Starting existing Rails app container..."
    docker start $CONTAINER_NAME
  else
    echo "No Rails app container found. Starting a new one..."
    docker compose up -d web
  fi
fi

# Output the status of the running containers
docker compose ps

# Attach to the app container's logs (optional)
echo "Attaching to Rails app logs..."
docker logs -f $CONTAINER_NAME
