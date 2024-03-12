# Load packages
library(tidyverse)
library(tidymodels)
library(here)
library(beepr)

# Run background jobs
library(doMC)
registerDoMC(cores = parallel::detectCores(logical = TRUE))

# Handle common conflicts
tidymodels_prefer()

# Load data
load(here("results/fl_split.rda"))
load(here("results/engineered_tree_recipe.rda"))

set.seed(1995)

# Model specifications
rf_mod_2 <- rand_forest(mode = "regression" ,
                        trees = 1000 ,
                        min_n = tune() ,
                        mtry = tune()) |>
  set_engine("ranger")

# Define workflows
rf_wkflow_2 <- workflow() |>
  add_model(rf_mod_2) |>
  add_recipe(engineered_tree_recipe)

# hyperparameter tuning values ----
rf_parameters_2 <- extract_parameter_set_dials(rf_mod_2) |>
  update(mtry = mtry(range = c(1 , 41)))
    # update to go higher

rf_grid_2 <- grid_regular(rf_parameters_2 , levels = 10)

# Fit workflows/models
fit_rf_2 <- tune_grid(rf_wkflow_2 ,
                       fl_fold ,
                       grid = rf_grid_2 ,
                       control = control_grid(save_workflow = TRUE))


# write out results (fitted/trained workflows) ----
save(fit_rf_2 , file = here("results/fit_rf_2.rda"))

beep(5)