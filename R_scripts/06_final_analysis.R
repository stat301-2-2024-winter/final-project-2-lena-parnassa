rm(list = ls())

# load packages ----
library(tidyverse)
library(tidymodels)
library(here)
library(glmnet)
library(patchwork)

# handle common conflicts
tidymodels_prefer()

###load everything in
load(here("results/final_pred_rf_1.rda"))
load(here("results/final_pred_bt_1.rda"))

### create plots
results_plot_bt_original <- ggplot(final_pred_bt_1, aes(x = ach_ct, y = (.pred)^2)) + 
  geom_abline(lty = 2) + 
  geom_point(alpha = 0.5) + 
  labs(y = "Predicted Achene Count" , 
       x = "Achene Count" ,
       title = "Boosted Tree Results on Original Scale") +
  coord_obs_pred() +
  theme_minimal()

results_plot_bt_sqrt <- ggplot(final_pred_bt_1, aes(x = sqrt_ach_ct, y = .pred)) + 
  geom_abline(lty = 2) + 
  geom_point(alpha = 0.5) + 
  labs(y = "Predicted Square Root of Achene Count" , 
       x = "Square Root of Achene Count" ,
       title = "Boosted Tree Results on Transformed Scale") +
  coord_obs_pred() +
  theme_minimal()

results_plot_bt <- (results_plot_bt_sqrt + results_plot_bt_original)

results_plot_rf_original <- ggplot(final_pred_rf_1, aes(x = ach_ct, y = (.pred)^2)) + 
  geom_abline(lty = 2) + 
  geom_point(alpha = 0.5) + 
  labs(y = "Predicted Achene Count" , 
       x = "Achene Count" ,
       title = "Random Forest Results on Original Scale") +
  coord_obs_pred() +
  theme_minimal()

results_plot_rf_sqrt <- ggplot(final_pred_rf_1, aes(x = sqrt_ach_ct, y = .pred)) + 
  geom_abline(lty = 2) + 
  geom_point(alpha = 0.5) + 
  labs(y = "Predicted Square Root of Achene Count" , 
       x = "Square Root of Achene Count" ,
       title = "Random Forest Results on Transformed Scale") +
  coord_obs_pred() +
  theme_minimal()

results_plot_rf <- (results_plot_rf_sqrt + results_plot_rf_original)

### save plots
ggsave(here("results/results_plot_bt.png"), results_plot_bt , width = 10, height = 6)
ggsave(here("results/results_plot_rf.png"), results_plot_rf , width = 10, height = 6)