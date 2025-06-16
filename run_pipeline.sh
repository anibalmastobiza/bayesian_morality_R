#!/bin/bash
# Convenience script to run the entire data generation pipeline
set -e

bash ./setup.sh

Rscript generate_vignettes.R
Rscript create_participant_csvs.R

echo "All files generated in participant_csvs/"
