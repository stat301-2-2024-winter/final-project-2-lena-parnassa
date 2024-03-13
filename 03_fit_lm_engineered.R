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
load(here("results/engineered_recipe.rda"))


set.seed(1995)
# model specifications ----
lm_mod_2 <-  linear_reg() |> 
  set_engine("lm") |> 
  set_mode("regression") 

# define workflows ----
lm_wflow_2 <- workflow() |>
  add_model(lm_mod_2) |>
  add_recipe(engineered_recipe)

# fit workflows/models ----
fit_lm_2 <- fit_resamples(
  lm_wflow_2 ,
  resamples = fl_fold ,
  control = control_resamples(save_workflow = TRUE)
)

# Save results 
save(fit_lm_2, file = here("results/fit_lm_2.rda"))