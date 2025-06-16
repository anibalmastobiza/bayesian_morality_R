library(dplyr)
library(stringr)
library(readr)
library(purrr)
library(tibble)

# Template texts for the vignettes (all English)
templates <- list(
  intentionalist_low = "In {Setting}, {Agent} knowingly performed an action with a {Prob} chance that exactly {Damage} innocent people would be harmed. {Agent}'s main reason was {Motivation}, and they were fully aware of the outcome.",
  intentionalist_high = "In {Setting}, {Agent} acted under uncertainty, facing a {ProbRange} chance that between {DamageRange} innocents could be harmed. {Agent} intended {Motivation} but did not know the exact consequences.",
  consequentialist_low = "In {Setting}, {Agent}'s decision guaranteed exactly {Damage} victims with probability {Prob}. The moral evaluation considers only the outcome, not {Agent}'s intentions.",
  consequentialist_high = "In {Setting}, {Agent} chose a risky path with a {ProbRange} chance that between {DamageRange} people would be harmed. The emphasis is on expected harm; {Agent}'s thoughts remain unknown."
)

# Elements for random generation
Agents <- c("Alex", "Taylor", "Jordan", "Morgan", "Casey", "Riley", "Quinn", "Avery", "Jamie", "Chris", "Pat")
Motivations <- c("to prevent a greater harm", "to obey orders", "to protect a loved one", "to follow company policy", "to save resources")
Settings <- c("during a medical emergency", "on a spaceship", "in a military mission", "at an AI control center")
Prob_low <- c(0.5, 0.7, 0.9)
Prob_high_ranges <- list(c(0.2, 0.5), c(0.5, 0.9))
Damage_low <- c(1, 2, 4, 6)
Damage_high_ranges <- list(c(2, 5), c(5, 9))
num_per_cell <- 100

# Format probability as a percentage string
format_pct <- function(p) {
  str_c(as.character(round(p * 100)), "%")
}

# Generate a single vignette row
generate_row <- function(framework, ambiguity, idx) {
  agent <- sample(Agents, 1)
  motivation <- sample(Motivations, 1)
  setting <- sample(Settings, 1)
  template <- templates[[str_c(framework, "_", ambiguity)]]

  if (ambiguity == "low") {
    prob_val <- sample(Prob_low, 1)
    damage_val <- sample(Damage_low, 1)
    text <- template %>%
      str_replace_all("\\{Agent\\}", agent) %>%
      str_replace_all("\\{Prob\\}", format_pct(prob_val)) %>%
      str_replace_all("\\{Damage\\}", as.character(damage_val)) %>%
      str_replace_all("\\{Motivation\\}", motivation) %>%
      str_replace_all("\\{Setting\\}", setting)
    tibble(
      ID = idx,
      Framework = framework,
      Ambiguity = ambiguity,
      Agent = agent,
      Setting = setting,
      Prob = format_pct(prob_val),
      ProbRange = NA_character_,
      Damage = damage_val,
      DamageRange = NA_character_,
      Motivation = motivation,
      Text = text
    )
  } else {
    prob_range <- sample(Prob_high_ranges, 1)[[1]]
    damage_range <- sample(Damage_high_ranges, 1)[[1]]
    prob_range_str <- str_c(format_pct(prob_range[1]), "–", format_pct(prob_range[2]))
    damage_range_str <- str_c(damage_range[1], " to ", damage_range[2])
    text <- template %>%
      str_replace_all("\\{Agent\\}", agent) %>%
      str_replace_all("\\{ProbRange\\}", prob_range_str) %>%
      str_replace_all("\\{DamageRange\\}", damage_range_str) %>%
      str_replace_all("\\{Motivation\\}", motivation) %>%
      str_replace_all("\\{Setting\\}", setting)
    tibble(
      ID = idx,
      Framework = framework,
      Ambiguity = ambiguity,
      Agent = agent,
      Setting = setting,
      Prob = NA_character_,
      ProbRange = prob_range_str,
      Damage = NA_real_,
      DamageRange = damage_range_str,
      Motivation = motivation,
      Text = text
    )
  }
}

# Create all rows
rows <- list()
idx <- 1
for (i in seq_len(num_per_cell)) {
  rows[[idx]] <- generate_row("intentionalist", "low", idx)
  idx <- idx + 1
}
for (i in seq_len(num_per_cell)) {
  rows[[idx]] <- generate_row("intentionalist", "high", idx)
  idx <- idx + 1
}
for (i in seq_len(num_per_cell)) {
  rows[[idx]] <- generate_row("consequentialist", "low", idx)
  idx <- idx + 1
}
for (i in seq_len(num_per_cell)) {
  rows[[idx]] <- generate_row("consequentialist", "high", idx)
  idx <- idx + 1
}
all_rows <- bind_rows(rows)

# Write to CSV
write_csv(all_rows, "vignettes.csv")
