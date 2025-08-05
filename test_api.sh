#!/bin/bash

IMAGE_NAME=test-flask-add
CONTAINER_NAME=test-flask-container

# Build image
docker build -t $IMAGE_NAME .

# Run container in background
docker run -d --rm -p 5001:5000 --name $CONTAINER_NAME $IMAGE_NAME

# Wait for the container to be ready (timeout after 10 seconds)
for i in {1..10}; do
  if curl -s "http://localhost:5001/add?num1=2&num2=3" >/dev/null; then
    break
  fi
  echo "Waiting for container to start..."
  sleep 1
done

# Call the /add endpoint
RESULT=$(curl -s "http://localhost:5001/add?num1=2&num2=3")
echo "API response: $RESULT"

# Extract numeric value (assuming JSON or raw number)
VALUE=$(echo "$RESULT" | grep -o '[0-9]\+')

if [[ "$VALUE" = "5" ]]; then
  echo "Test passed"
  docker kill $CONTAINER_NAME >/dev/null
  exit 0
else
  echo "Test failed"
  docker kill $CONTAINER_NAME >/dev/null
  exit 1
fi
