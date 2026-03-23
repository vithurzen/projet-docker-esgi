#!/usr/bin/env bash
set -euo pipefail

TRIVY_VERSION="v0.69.3"
TRIVY_BIN_DIR="${HOME}/.local/bin"

install_trivy() {
  echo "Trivy not found. Installing ${TRIVY_VERSION}..."
  mkdir -p "${TRIVY_BIN_DIR}"
  curl -sfL https://raw.githubusercontent.com/aquasecurity/trivy/main/contrib/install.sh \
    | sh -s -- -b "${TRIVY_BIN_DIR}" "${TRIVY_VERSION}"
  export PATH="${TRIVY_BIN_DIR}:${PATH}"
}

if ! command -v trivy >/dev/null 2>&1; then
  install_trivy
fi

export PATH="${TRIVY_BIN_DIR}:${PATH}"

images=(
  "e-commerce-vue-main-frontend:latest"
  "e-commerce-vue-main-auth-service:latest"
  "e-commerce-vue-main-product-service:latest"
  "e-commerce-vue-main-order-service:latest"
)

for image in "${images[@]}"; do
  echo "Scanning $image ..."
  trivy image --scanners vuln --severity HIGH,CRITICAL "$image" || true
  echo
done