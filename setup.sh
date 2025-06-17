#!/bin/bash
# Install R package dependencies for the experiment

set -e

# Optionally configure an HTTP(S) proxy by setting environment variables
# e.g. export http_proxy=http://proxy.example.com:3128
# e.g. export https_proxy=$http_proxy

# Determine whether we can run apt-get directly or need sudo
apt_get=apt-get
if ! command -v "$apt_get" >/dev/null 2>&1; then
  echo "apt-get not found. Please install the required R packages manually." >&2
  exit 1
fi
if [ "$(id -u)" -ne 0 ]; then
  apt_get="sudo $apt_get"
fi

# Update package lists
$apt_get update

# Install minimal R base and required packages from Ubuntu repositories
packages=(r-base-core r-cran-dplyr r-cran-readr r-cran-stringr r-cran-tibble)
for pkg in "${packages[@]}"; do
  if ! dpkg -s "$pkg" >/dev/null 2>&1; then
    missing+=("$pkg")
  fi
done
if [ ${#missing[@]} -gt 0 ]; then
  $apt_get install -y --no-install-recommends "${missing[@]}"
fi

echo "Setup complete."
