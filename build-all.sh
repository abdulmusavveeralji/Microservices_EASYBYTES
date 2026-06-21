#!/bin/bash

set -e

SERVICES=(
  "accounts"
  "cards"
  "loans"
  "configserver"
)

for service in "${SERVICES[@]}"
do
  echo "==================================="
  echo "Building $service..."
  echo "==================================="

  cd "$service"

  mvn clean compile jib:build

  cd ..
done

echo "==================================="
echo "All Docker images built successfully!"
echo "==================================="