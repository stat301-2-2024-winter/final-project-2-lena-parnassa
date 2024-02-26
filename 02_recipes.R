# Setup pre-processing/recipes

# load packages ----
library(tidyverse)
library(tidymodels)
library(here)
set.seed(1995)
# handle common conflicts
tidymodels_prefer()

#load data
load(here("results/fl_split.rda"))

## basic recipe
basic_recipe <- recipe(ach_ct ~ . , data = fl_train) |>
  step_dummy(all_nominal_predictors() , one_hot = TRUE) |>
  step_zv(all_predictors()) |>
  step_impute_knn() |>
  step_normalize(all_predictors())

## tuned recipe


## basic tree recipe
tree_recipe <- recipe(ach_ct ~ . , data = fl_train) |>
  step_dummy(all_nominal_predictors(), one_hot = TRUE) |>
  step_zv(all_predictors()) |>
  step_impute_knn() |>
  step_normalize(all_predictors())

## tuned tree recipe