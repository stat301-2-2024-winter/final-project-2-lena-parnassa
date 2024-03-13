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
load(here("results/engineered_tree_recipe.rda"))

set.seed(1995)

# Model specifications
bt_mod_2 <- boost_tree(
  mode = "regression" ,
  learn_rate = tune(),
  mtry = tune(),
  min_n = tune()
) |>
  set_engine("xgboost") 

# Define workflows
bt_wkflow_2 <- workflow() |>
  add_model(bt_mod_2) |>
  add_recipe(engineered_tree_recipe)

# hyperparameter tuning values ----

bt_parameters_2 <- extract_parameter_set_dials(bt_mod_2) |>
  update(mtry = mtry(range = c(1 , 42)) ,
         learn_rate = learn_rate(c(-1, -0.02)))

bt_grid_2 <- grid_regular(bt_parameters_2 , levels = 5)

# Fit workflows/models
fit_bt_2 <- tune_grid(
  bt_wkflow_2,
  fl_fold,
  grid = bt_grid_2 ,
  control = control_grid(save_workflow = TRUE)
)

# Write out results (fitted/trained workflows)
save(fit_bt_2, file = here("results/fit_bt_2.rda"))
