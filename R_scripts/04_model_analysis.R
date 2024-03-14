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
load(here("results/fit_lm_1.rda"))
load(here("results/fit_lm_2.rda"))
load(here("results/fit_knn_1.rda"))
load(here("results/fit_knn_2.rda"))
load(here("results/fit_bt_1.rda"))
load(here("results/fit_bt_2.rda"))
load(here("results/fit_rf_1.rda"))
load(here("results/fit_rf_2.rda"))
load(here("results/fit_enet_1.rda"))
load(here("results/fit_enet_2.rda"))

### rmse plots
fit_rf_1 |>
  autoplot(metric = "rmse") +
  theme_minimal()
fit_rf_2 |>
  autoplot(metric = "rmse") +
  theme_minimal()

select_best(fit_rf_1 , metric = "rmse")
select_best(fit_rf_2 , metric = "rmse")

fit_knn_1 |>
  autoplot(metric = "rmse") +
  theme_minimal()
fit_knn_2 |>
  autoplot(metric = "rmse") +
  theme_minimal()

select_best(fit_knn_1 , metric = "rmse")
select_best(fit_knn_2 , metric = "rmse")

fit_bt_1 |>
  autoplot(metric = "rmse") +
  theme_minimal()
fit_bt_2 |>
  autoplot(metric = "rmse") +
  theme_minimal()

select_best(fit_bt_1 , metric = "rmse")
select_best(fit_bt_2 , metric = "rmse")

fit_enet_1 |>
  autoplot(metric = "rmse") +
  theme_minimal()
fit_enet_2 |>
  autoplot(metric = "rmse") +
  theme_minimal()

select_best(fit_enet_1 , metric = "rmse")
select_best(fit_enet_2 , metric = "rmse")

#create a workflow set
model_results <- as_workflow_set(
  lm_basic = fit_lm_1 ,
  lm_engineered = fit_lm_2 ,
  enet_basic = fit_enet_1 ,
  enet_engineered = fit_enet_2 ,
  knn_basic = fit_knn_1,
  knn_engineered = fit_knn_2 ,
  bt_basic = fit_bt_1 ,
  bt_engineered = fit_bt_2 ,
  rf_basic = fit_rf_1 ,
  rf_engineered = fit_rf_2
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
knitr::kable(digits = c(NA , 3 , 4 , 0))


model_results |>
  collect_metrics() |>
  filter(.metric == "rmse")|>
  slice_min(mean, by = wflow_id) |>
  arrange(mean) |>
  mutate(wflow_id = factor(wflow_id, levels = unique(wflow_id))) |>
  ggplot(aes(x = wflow_id, y = mean)) +
  geom_point() +
  geom_errorbar(aes(ymin = (mean - std_err), ymax = (mean + std_err)) , width = .2) + 
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, vjust = 0.5, hjust=1))
save(model_results , file = here("results/model_results.rda"))
