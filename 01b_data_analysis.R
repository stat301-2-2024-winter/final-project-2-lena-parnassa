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
  ggplot(aes((ach_ct))) +
  geom_histogram(bins = 50) +
  theme_minimal()

fl_train |>
  ggplot(aes(x = wht_scary)) +
  geom_bar() +
  facet_wrap(~wht_fuzzy) +
  theme_minimal()
#shows no overlap

fl_train |>
  ggplot(aes(x = pos , y = sqrt_ach_ct)) +
  geom_point() +
  geom_smooth()
  theme_minimal()
  #slight parabolic relationship

fl_train |>
  ggplot(aes(x = row , y = sqrt_ach_ct)) +
  geom_point() +
  geom_smooth()
  theme_minimal()
  #slight linear relationship

fl_train |>
  ggplot(aes(x = min_hd_height , y = max_hd_height)) +
  geom_point() +
  theme_minimal()

fl_train |>
  ggplot(aes(x = flowering_rosette_ct , y = hd_ct)) +
  geom_point() +
  theme_minimal()
  #genuinely i am unsure as to how some plants have more flowering rosettes than heads
  #proportion of heads flowering might be indicitive of  effort towards producing achenes
    #strongly correlated regarldess of if this is true

fl_train |>
  ggplot(aes(x = longest_basal_lf, y = basal_lf_ct )) +
  geom_point() +
  theme_minimal()
#this interaction could be used as (very) rough estimate of total vegitative mass for a plant


