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

# load data
load(here("results/fl_split.rda"))
load(here("results/basic_recipe.rda"))

set.seed(1995)

# model specifications ----
enet_mod_1 <- linear_reg(mode = "regression" ,
                         alpha = tune(),
                         lambda = tune(),
                         standardize = tune()) |> 
  set_engine("glmnet")

# define workflows ----
enet_wflow_1 <- workflow() |>
  add_model(enet_mod_1) |>
  add_recipe(basic_recipe)

# hyperparameter tuning values ----
enet_parameters <- extract_parameter_set_dials(enet_mod_1)

enet_grid <- grid_regular(enet_parameters , levels = 5)

# fit workflows/models ----
fit_enet_1 <- fit_resamples(
  enet_wflow_1,
  grid = enet_grid
  resamples = fl_fold,
  control = control_resamples(save_workflow = TRUE)
)

# Save results 
save(fit_enet_1, file = here("results/fit_enet_1.rda"))