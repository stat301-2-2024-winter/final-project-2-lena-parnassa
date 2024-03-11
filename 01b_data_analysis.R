# load packages ----
library(tidyverse)
library(tidymodels)
library(here)

set.seed(1995)
# handle common conflicts
tidymodels_prefer()

#load data
load(here("results/fl_split.rda"))


skimr::skim(fl_train)

fl_train |>
  ggplot(aes(x = wht_scary)) +
  geom_bar() +
  facet_wrap(~wht_fuzzy)

