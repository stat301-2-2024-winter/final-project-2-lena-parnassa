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
bt_mod_1 <- boost_tree(
  mode = "regression" ,
  learn_rate = tune(),
  mtry = tune(),
  min_n = tune()
) |>
  set_engine("xgboost") 

# Define workflows
bt_wkflow_1 <- workflow() |>
  add_model(bt_mod_1) |>
  add_recipe(tree_recipe)

# hyperparameter tuning values ----

bt_parameters <- extract_parameter_set_dials(bt_mod_1) |>
  update(mtry = mtry(range = c(1 , 42)) ,
         learn_rate = learn_rate(c(-1, -0.02)))

bt_grid <- grid_regular(bt_parameters , levels = 5)

# Fit workflows/models
fit_bt_1 <- tune_grid(
  bt_wkflow_1,
  fl_fold,
  grid = bt_grid ,
  control = control_grid(save_workflow = TRUE)
)

# Write out results (fitted/trained workflows)
save(fit_bt_1, file = here("results/fit_bt_1.rda"))

