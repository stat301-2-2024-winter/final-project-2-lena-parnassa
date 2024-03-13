rm(list = ls())

# load packages ----
library(tidyverse)
library(tidymodels)
library(here)
library(glmnet)

# run background jobs
library(doMC)
registerDoMC(cores = parallel::detectCores(logical = TRUE))

# handle common conflicts
tidymodels_prefer()

# Load data
load(here("results/fl_split.rda"))
load(here("results/tree_recipe.rda"))

set.seed(1995)

# Model specifications
rf_mod_1 <- rand_forest(mode = "regression" ,
                        trees = 1000 ,
                        min_n = tune() ,
                        mtry = tune()) |>
  set_engine("ranger")

# Define workflows
rf_wkflow_1 <- workflow() |>
  add_model(rf_mod_1) |>
  add_recipe(tree_recipe)

# hyperparameter tuning values ----
rf_parameters_1 <- extract_parameter_set_dials(rf_mod_1) |>
  update(mtry = mtry(range = c(1 , 41)))
    # update to go higher

rf_grid_1 <- grid_regular(rf_parameters_1 , levels = 10)

# Fit workflows/models
fit_rf_1 <- tune_grid(rf_wkflow_1 ,
                       fl_fold ,
                       grid = rf_grid_1 ,
                       control = control_grid(save_workflow = TRUE))


# write out results (fitted/trained workflows) ----
save(fit_rf_1 , file = here("results/fit_rf_1.rda"))