#!/bin/bash

IMAGE_NAME=test-flask-add
CONTAINER_NAME=test-flask-container

# Build image
docker build -t $IMAGE_NAME .

# Run container in background
docker run -d --rm -p 5001:5000 --name $CONTAINER_NAME $IMAGE_NAME


# Call the /add endpoint
RESULT=$(curl -s "http://localhost:5001/add?num1=2&num2=3")

if [[ "$RESULT" = "5" ]]; then
  echo "Test passed"
  docker kill $CONTAINER_NAME >/dev/null
  exit 0
else
  echo "Test failed"
  docker kill $CONTAINER_NAME >/dev/null
  exit 1
fi
