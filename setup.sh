#!/bin/bash
# Install R package dependencies for the experiment

set -e

# Optionally configure an HTTP(S) proxy by setting environment variables
# e.g. export http_proxy=http://proxy.example.com:3128
# e.g. export https_proxy=$http_proxy

# Update package lists only if not done recently
sudo apt-get update

# Install minimal R base and required packages from Ubuntu repositories
packages=(r-base-core r-cran-dplyr r-cran-readr r-cran-stringr r-cran-tibble)
for pkg in "${packages[@]}"; do
  if ! dpkg -s "$pkg" >/dev/null 2>&1; then
    missing+=("$pkg")
  fi
done
if [ ${#missing[@]} -gt 0 ]; then
  sudo apt-get install -y --no-install-recommends "${missing[@]}"
fi

echo "Setup complete."
