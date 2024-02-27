# load packages ----
library(tidyverse)
library(tidymodels)
library(here)


#run background jobs
library(doMC)
registerDoMC(cores = parallel::detectCores(logical = TRUE))

# handle common conflicts
tidymodels_prefer()

#load data
load(here("results/fl_split.rda"))
load(here("results/basic_recipe.rda"))


set.seed(1995)
# model specifications ----
enet_mod_1 <-  linear_reg(penalty = tune()) |> 
  set_engine("glmnet") |> 
  set_mode("regression") 

# grid for penalty value
penalty_grid <- tibble(penalty = seq(0, 1, by = 0.1))

# define workflows ----
enet_wflow_1 <- workflow() |>
  add_model(enet_mod_1) |>
  add_recipe(basic_recipe)

# fit workflows/models ----
fit_enet_1 <- fit_resamples(
  enet_wflow_1,  # Corrected variable name
  resamples = fl_fold,
  control = control_resamples(save_workflow = TRUE),
  grid = penalty_grid
)

# save results 
save(fit_lm_1, file = here("results/fit_lm_1.rda"))