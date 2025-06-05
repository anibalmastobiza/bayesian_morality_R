generate_vignettes.R
+101-0
library(dplyr)
library(stringr)
library(readr)
library(purrr)
library(tibble)

# Template texts for the vignettes
templates <- list(
  intentionalist_low = "Agent {Agent} deliberately performed an action knowing there was a {Prob} chance that exactly {Damage} innocent individuals would be harmed. {Agent}’s primary motivation was {Motivation}, and {Agent} was certain of the outcome.",
  intentionalist_high = "Agent {Agent} took an action under uncertain conditions: there was a {ProbRange} chance that between {DamageRange} innocents might suffer harm. Although {Agent} intended {Motivation}, their knowledge was not fully clear.",
  consequentialist_low = "Agent {Agent} made a decision that would result in exactly {Damage} victims with probability {Prob}. The focus is on the outcome; nothing is known about {Agent}’s intentions.",
  consequentialist_high = "Agent {Agent} chose a course of action with an uncertain outcome: there was a {ProbRange} chance of harming between {DamageRange} individuals. {Agent}’s mental states remain opaque; emphasis is solely on expected harm."
)

# Elements for random generation
Agents <- c("Alex", "Taylor", "Jordan", "Morgan", "Casey", "Riley", "Quinn", "Avery")
Motivations <- c("to prevent a greater harm", "to obey orders", "to protect a loved one")
Prob_low <- c(0.6, 0.8, 0.95)
Prob_high_ranges <- list(c(0.4, 0.6), c(0.6, 0.8))
Damage_low <- c(1, 3, 5)
Damage_high_ranges <- list(c(1, 3), c(3, 7))
num_per_cell <- 50

# Format probability as a percentage string
format_pct <- function(p) {
  str_c(as.character(round(p * 100)), "%")
}

# Generate a single vignette row
generate_row <- function(framework, ambiguity, idx) {
  agent <- sample(Agents, 1)
  motivation <- sample(Motivations, 1)
  template <- templates[[str_c(framework, "_", ambiguity)]]

  if (ambiguity == "low") {
    prob_val <- sample(Prob_low, 1)
    damage_val <- sample(Damage_low, 1)
    text <- template %>%
      str_replace_all("\\{Agent\\}", agent) %>%
      str_replace_all("\\{Prob\\}", format_pct(prob_val)) %>%
      str_replace_all("\\{Damage\\}", as.character(damage_val)) %>%
      str_replace_all("\\{Motivation\\}", motivation)
    tibble(
      ID = idx,
      Framework = framework,
      Ambiguity = ambiguity,
      Agent = agent,
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
      str_replace_all("\\{Motivation\\}", motivation)
    tibble(
      ID = idx,
      Framework = framework,
      Ambiguity = ambiguity,
      Agent = agent,
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
