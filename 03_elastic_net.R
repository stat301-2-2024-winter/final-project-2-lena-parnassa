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
lm_mod_1 <-  linear_reg() |> 
  set_engine("lm") |> 
  set_mode("regression") 

# define workflows ----
lm_wflow_1 <- workflow() |>
  add_model(lm_mod_1) |>
  add_recipe(basic_recipe)

# fit workflows/models ----
fit_lm_1 <- fit_resamples(
  lm_wflow_1 ,
  resamples = fl_fold ,
  control = control_resamples(save_workflow = TRUE)
)

# save results 
save(fit_lm_1, file = here("results/fit_lm_1.rda"))