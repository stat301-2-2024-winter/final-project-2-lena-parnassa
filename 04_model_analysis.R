# load packages ----
library(tidyverse)
library(tidymodels)
library(here)

# handle common conflicts
tidymodels_prefer()

###load everything in
load(here("results/fl_split.rda"))
load(here("results/basic_recipe.rda"))
load(here("results/fit_lm_1.rda"))
load(here("results/fit_enet_1.rda"))
load(here("results/fit_knn_1.rda"))

#create a workflow set
model_results <- as_workflow_set(
  lm_basic = fit_lm_1 ,
  knn_basic = fit_knn_1 
)

model_results |>
  collect_metrics() |>
  filter(.metric == "rmse") |>
  slice_min(mean , by = wflow_id) |>
  arrange(mean) |>
  select("Model Type" = wflow_id ,
         "RMSE" = mean ,
         "Standard Error" = std_err ,
         "Num Computations" = n) |>
knitr::kable(digits = c(NA , 2 , 4 , 0))

save(model_results , file = here("results/model_results.rda"))
