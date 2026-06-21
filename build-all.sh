#!/bin/bash

set -e

SERVICES=(
  "accounts"
  "cards"
  "loans"
  "configserver"
  "eurekaserver"
)

for service in "${SERVICES[@]}"
do
  echo "==================================="
  echo "Building $service..."
  echo "==================================="

  cd "$service"

  mvn clean compile jib:dockerBuild

  cd ..
done

echo "==================================="
echo "All Docker images built successfully!"
echo "==================================="