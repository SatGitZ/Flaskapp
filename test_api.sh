#!/bin/bash

IMAGE_NAME=test-flask-add
CONTAINER_NAME=test-flask-container

# Build image
docker build -t $IMAGE_NAME .

# Run container in background
docker run -d --rm -p 5001:5000 --name $CONTAINER_NAME $IMAGE_NAME

# Wait for the container to start responding (max 10 seconds)
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

# Check the response (assumes response is '5' or includes '5')
if [[ "$RESULT" = "5" ]]; then
  echo "Test passed"
  docker kill $CONTAINER_NAME >/dev/null
  exit 0
else
  echo "Test failed"

  echo "=== Container logs ==="
  docker logs $CONTAINER_NAME || echo "Container not running or already exited"

  docker kill $CONTAINER_NAME >/dev/null 2>&1
  exit 1
fi