# Bayesian Morality Experiment

This repository contains R scripts to create randomized vignettes for an online moral judgment study. All materials are in English so they can be easily used with Prolific or other recruitment platforms.

Before generating any files, make sure the required R packages are installed. A helper script `setup.sh` is included for Ubuntu-based systems and will attempt to install everything with `apt-get`. You can optionally set `http_proxy`/`https_proxy` variables if you need to use a proxy.

## Files
1. `generate_vignettes.R` – creates `vignettes.csv` with 400 vignettes (100 per experimental cell).
2. `create_participant_csvs.R` – produces 200 CSV files `participant_001.csv` … `participant_200.csv`, each containing 12 vignettes in random order.

## Usage
After running `./setup.sh` once, generate the materials by running the following R scripts in order:

```R
source("generate_vignettes.R")      # creates vignettes.csv
source("create_participant_csvs.R")  # creates files in participant_csvs/
```

Each participant CSV can be uploaded to your survey software (e.g., Qualtrics or jsPsych) and linked to Prolific using their unique participant ID. Make sure to randomize presentation order if your platform allows.
