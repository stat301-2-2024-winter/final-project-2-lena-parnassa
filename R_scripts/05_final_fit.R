rm(list = ls())

# load packages ----
library(tidyverse)
library(tidymodels)
library(here)
library(glmnet)

# handle common conflicts
tidymodels_prefer()
###load everything in
load(here("results/fl_split.rda"))
load(here("results/basic_recipe.rda"))
load(here("results/engineered_recipe.rda"))
load(here("results/fit_lm_2.rda"))
load(here("results/fit_bt_1.rda"))
load(here("results/fit_rf_1.rda"))
load(here("results/fit_rf_2.rda"))

set.seed(1995)

# finalize workflow(s)----
final_rf_1 <- fit_rf_1 |> 
  extract_workflow(fit_rf_1) |>  
  finalize_workflow(select_best(fit_rf_1, metric = "rmse"))

final_bt_1 <- fit_bt_1 |> 
  extract_workflow(fit_bt_1) |>  
  finalize_workflow(select_best(fit_bt_1, metric = "rmse"))

final_rf_2 <- fit_rf_2 |> 
  extract_workflow(fit_rf_2) |>  
  finalize_workflow(select_best(fit_rf_2, metric = "rmse"))

final_lm_2 <- fit_lm_2 |> 
  extract_workflow( fit_lm_2)

# train final model(s) ----
final_fit_rf_1  <- fit(final_rf_1 , fl_train)
final_fit_bt_1  <- fit(final_bt_1 , fl_train)
final_fit_rf_2  <- fit(final_rf_2 , fl_train)
final_fit_lm_2  <- fit(final_lm_2 , fl_train)

# test final models
final_pred_rf_1 <- fl_test |>
  select(sqrt_ach_ct , ach_ct) |>
  bind_cols(predict(final_fit_rf_1 , fl_test)) |>
  mutate(.pred_sqr = (.pred)^2)

final_pred_bt_1 <- fl_test |>
  select(sqrt_ach_ct , ach_ct) |>
  bind_cols(predict(final_fit_bt_1 , fl_test))|>
  mutate(.pred_sqr = (.pred)^2)

final_pred_rf_2 <- fl_test |>
  select(sqrt_ach_ct , ach_ct) |>
  bind_cols(predict(final_fit_rf_2 , fl_test)) |>
  mutate(.pred_sqr = (.pred)^2)

final_pred_lm_2 <- fl_test |>
  select(sqrt_ach_ct , ach_ct) |>
  bind_cols(predict(final_fit_lm_2 , fl_test)) |>
  mutate(.pred_sqr = (.pred)^2)

# evaluate models:
rmse(final_pred_rf_1 , sqrt_ach_ct , .pred)
  #RMSE 2.51 - tied but also second
rmse(final_pred_bt_1 , sqrt_ach_ct , .pred)
  #RMSE 2.49 - WINNER
rmse(final_pred_rf_2 , sqrt_ach_ct , .pred)
  #RMSE 2.58
rmse(final_pred_lm_2 , sqrt_ach_ct , .pred)
  #RMSE 2.56


# RMSE on actual
rmse(final_pred_rf_1 , ach_ct , .pred_sqr)
  # RMSE 92.6 :(

rmse(final_pred_bt_1 , ach_ct , .pred_sqr)
  # RMSE 88.1 :(

rmse(final_pred_rf_2 , ach_ct , .pred_sqr)
  # RMSE 97.1 :(

rmse(final_pred_lm_2 , ach_ct , .pred_sqr)
  # RMSE 92.0

## save best models
save(final_pred_rf_1, file = here("results/final_pred_rf_1.rda"))
save(final_pred_bt_1, file = here("results/final_pred_bt_1.rda"))
