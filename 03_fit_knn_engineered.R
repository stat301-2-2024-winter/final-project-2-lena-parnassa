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
load(here("results/engineered_tree_recipe.rda"))

set.seed(1995)
# model specifications ----
knn_mod_2 <- nearest_neighbor(mode = "regression" ,
                              neighbors = tune()) |>
  set_engine("kknn")

# define workflows ----
knn_wkflow_2 <- workflow() |>
  add_model(knn_mod_2) |>
  add_recipe(engineered_tree_recipe)

# hyperparameter tuning values ----
knn_parameters_2 <- extract_parameter_set_dials(knn_mod_2) 

knn_grid_2 <- grid_regular(knn_parameters_2 , levels = 10)

# fit workflows/models ----
fit_knn_2 <- tune_grid(knn_wkflow_2 ,
                        fl_fold ,
                        grid = knn_grid_2 ,
                        control = control_grid(save_workflow = TRUE))


# write out results (fitted/trained workflows) ----
save(fit_knn_2 , file = here("results/fit_knn_2.rda"))