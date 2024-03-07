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
load(here("results/tree_recipe.rda"))

set.seed(1995)
# model specifications ----
knn_mod_1 <- nearest_neighbor(mode = "regression" ,
                              neighbors = tune()) |>
  set_engine("kknn")

# define workflows ----
knn_wkflow_1 <- workflow() |>
  add_model(knn_mod_1) |>
  add_recipe(tree_recipe)

# hyperparameter tuning values ----
knn_parameters <- extract_parameter_set_dials(knn_mod_1) 

knn_grid_1 <- grid_regular(knn_parameters , levels = 10)

# fit workflows/models ----
fit_knn_1 <- tune_grid(knn_wkflow_1 ,
                        fl_fold ,
                        grid = knn_grid_1 ,
                        control = control_grid(save_workflow = TRUE))


# write out results (fitted/trained workflows) ----
save(fit_knn_1 , file = here("results/fit_knn_1.rda"))