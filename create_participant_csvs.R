library(dplyr)
library(readr)

# Read vignettes.csv
vigs <- read_csv("vignettes.csv", show_col_types = FALSE)

# Create output directory if it doesn't exist
out_dir <- "participant_csvs"
if (!dir.exists(out_dir)) {
  dir.create(out_dir)
}

# Generate CSV for each participant
for (pid in seq_len(200)) {
  set.seed(pid)

  ilow <- vigs %>%
    filter(Framework == "intentionalist", Ambiguity == "low") %>%
    slice_sample(n = 3)

  ihigh <- vigs %>%
    filter(Framework == "intentionalist", Ambiguity == "high") %>%
    slice_sample(n = 3)

  clow <- vigs %>%
    filter(Framework == "consequentialist", Ambiguity == "low") %>%
    slice_sample(n = 3)

  chigh <- vigs %>%
    filter(Framework == "consequentialist", Ambiguity == "high") %>%
    slice_sample(n = 3)

  out <- bind_rows(ilow, ihigh, clow, chigh) %>%
    slice_sample(n = nrow(.))

  file_name <- file.path(out_dir, sprintf("participant_%03d.csv", pid))
  write_csv(out, file_name)
}
