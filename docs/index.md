# Bayesian Morality Study

This site provides instructions for generating the materials used in the experiment and links to the resulting CSV files.

## Prerequisites

* R version 4.0 or later
* The packages listed at the top of the scripts (dplyr, stringr, readr, purrr, tibble)

## Generating the Vignettes

Run the following command from the repository root:

```R
source("generate_vignettes.R")
```

This creates `vignettes.csv`, which contains all 200 vignettes used in the study.

## Creating Participant CSVs

After `vignettes.csv` has been generated, run:

```R
source("create_participant_csvs.R")
```

This script creates a `participant_csvs/` directory containing 200 files named `participant_001.csv` through `participant_200.csv`.

## Data Files

Once the above scripts have been executed, the following data files will be available:

- [`vignettes.csv`](../vignettes.csv)
- [participant CSVs](../participant_csvs/)

You can download these files directly or use them for further analysis.
