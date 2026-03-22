#!/usr/bin/env bash
set -e

images=(
  "ecommerce/frontend:latest"
  "ecommerce/auth-service:latest"
  "ecommerce/product-service:latest"
  "ecommerce/order-service:latest"
)

for image in "${images[@]}"; do
  trivy image "$image" || true
done