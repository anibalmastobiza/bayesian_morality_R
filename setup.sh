#!/bin/bash
# Install R package dependencies for the experiment

set -e

# Optionally configure an HTTP(S) proxy by setting environment variables
# e.g. export http_proxy=http://proxy.example.com:3128
# e.g. export https_proxy=$http_proxy

# Update package lists
sudo apt-get update

# Install minimal R base and required CRAN packages from Ubuntu repositories
sudo apt-get install -y r-base-core r-cran-dplyr r-cran-readr r-cran-purrr r-cran-stringr r-cran-tibble

# Attempt to install missing packages from CRAN as a fallback
Rscript - <<'RSCRIPT'
packages <- c('dplyr','readr','purrr','stringr','tibble')
missing <- packages[!packages %in% installed.packages()[, 'Package']]
if (length(missing)) {
  repos <- getOption('repos')
  if (is.null(repos) || repos['CRAN'] == '@CRAN@') {
    repos['CRAN'] <- 'https://cloud.r-project.org'
  }
  install.packages(missing, repos = repos)
}
RSCRIPT

echo "Setup complete."
