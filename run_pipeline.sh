#!/bin/bash
# Convenience script to run the entire data generation pipeline
set -e


# Ensure dependencies are installed
bash ./setup.sh

if ! command -v Rscript >/dev/null 2>&1; then
  echo "Rscript not found. Please check your R installation." >&2
  exit 1
fi

Rscript generate_vignettes.R
Rscript create_participant_csvs.R

echo "All files generated in participant_csvs/"
