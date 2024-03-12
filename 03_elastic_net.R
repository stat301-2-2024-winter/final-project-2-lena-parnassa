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
enet_mod_1 <- linear_reg(penalty = tune(),
                         mixture = tune()) |> 
  set_engine("glmnet")

enet_parameters <- 
  parameters(enet_mod_1) |>
  update(mixture = mixture(range = c(0, 1)) ,
         penalty = penalty(range = c(0 ,1)))
         #lower penalties tend to be less-wrong so im going to leave it like that

enet_grid <- 
  grid_regular(enet_parameters, levels = 5)

# define workflows ----
enet_wflow_1 <- workflow() |>
  add_model(enet_mod_1) |>
  add_recipe(basic_recipe)

# fit workflows/models ----
fit_enet_1 <- enet_wflow_1 |>
  tune_grid(resamples = fl_fold, 
            grid = enet_grid ,
            control = control_grid(save_workflow = TRUE))

enet_wflow_1
# Save results 
save(fit_enet_1, file = here("results/fit_enet_1.rda"))