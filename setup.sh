#!/bin/bash
# Install R package dependencies for the experiment

set -e

# Optionally configure an HTTP(S) proxy by setting environment variables
# e.g. export http_proxy=http://proxy.example.com:3128
# e.g. export https_proxy=$http_proxy

# Update package lists
sudo apt-get update

# Install minimal R base and required packages from Ubuntu repositories
sudo apt-get install -y --no-install-recommends \
  r-base-core r-cran-dplyr r-cran-readr r-cran-stringr r-cran-tibble

echo "Setup complete."
