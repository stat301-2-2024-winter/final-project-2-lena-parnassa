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
load(here("results/engineered_recipe.rda"))

set.seed(1995)
# model specifications ----
enet_mod_2 <- linear_reg(penalty = tune(),
                         mixture = tune()) |> 
  set_engine("glmnet")

enet_parameters_2 <- 
  parameters(enet_mod_2) |>
  update(mixture = mixture(range = c(0, 1)) ,
         penalty = penalty(range = c(0 ,1)))
         #lower penalties tend to be less-wrong so im going to leave it like that

enet_grid_2 <- 
  grid_regular(enet_parameters_2, levels = 5)

# define workflows ----
enet_wflow_2 <- workflow() |>
  add_model(enet_mod_2) |>
  add_recipe(engineered_recipe)

# fit workflows/models ----
fit_enet_2 <- enet_wflow_2 |>
  tune_grid(resamples = fl_fold, 
            grid = enet_grid_2 ,
            control = control_grid(save_workflow = TRUE))

# Save results 
save(fit_enet_2, file = here("results/fit_enet_2.rda"))