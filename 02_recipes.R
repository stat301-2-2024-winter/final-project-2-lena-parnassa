# Setup pre-processing/recipes
rm(list = ls())
# load packages ----
library(tidyverse)
library(tidymodels)
library(here)

set.seed(1995)
# handle common conflicts
tidymodels_prefer()

#load data
load(here("results/fl_split.rda"))

#check data:
skimr::skim(fl_train)

## basic recipe
basic_recipe <- recipe(sqrt_ach_ct ~ . , data = fl_train) |>
  step_rm(ach_ct , site_of_origin_pedigree , insects , insects_note ,  
          cg_pla_id , basal_rosette_ct , longest_cauline_lf , measure_dt) |>
  #need to remove some other steps
  step_zv(all_predictors()) |>
  step_dummy(all_nominal_predictors()) |>
  step_impute_knn(all_predictors()) |>
  step_normalize(all_numeric_predictors() , all_factor_predictors())


prep(basic_recipe) |>
  bake(new_data = NULL)

## tuned recipe
engineered_recipe <- recipe(sqrt_ach_ct ~ . , data = fl_train) |>
  step_rm(ach_ct , site_of_origin_pedigree , insects , insects_note ,  
          cg_pla_id , basal_rosette_ct , longest_cauline_lf , measure_dt) |>
  step_poly(row, degree = 2) |>
  step_interact(terms = ~ pos:row) |>
    #create coordinate grid
  step_interact(terms = ~ min_head_height:max_head_height) |>
    #total range of head heights
  step_interact(terms = ~ flowering_rosette_ct:head_ct) |>
    #ratio of flowering to all heads
  step_interact(terms = ~ longest_basal_lf:basal_lf_ct) |>
    #additional proxy for vegetative mass
  step_num2factor(yr_planted , levels = c("1996" , "1997" , "1998" , "1999")) |>
    #may work better as factor
  step_mutate(hd_ct = case_when(
    hd_ct %in% 1:5 ~ as.character(hd_ct),
    hd_ct %in% 6:9 ~ "6 to 9",
    hd_ct >= 10 ~ "10+"
  )) |>
  step_string2factor(hd_ct) |>
    #small enough range that it could work as factor
  step_mutate(wht_indicator = as.factor(ifelse(wht_fuzzy == 1 | wht_scary == 1, "1", "0"))) |>
  step_rm(wht_fuzzy, wht_scary) |>
    #i feel like the difference is up to personal interpretation
  step_mutate(ant = as.factor(ifelse(ant1 == 1 | ant2to10 == 1 | ant_gt10 == 1 , "1", "0"))) |>
  step_mutate(aphid = as.factor(ifelse(aphid1 == 1 | aphid2to10 == 1 | aphid11to80 == 1 |aphid_gt80 == 1 , "1", "0"))) |>
    #i think these two make sense
  step_interact(terms = ~ ant:aphid) |>
  step_dummy(all_nominal_predictors()) |>
  step_zv(all_predictors()) |>
  step_impute_knn(all_predictors()) |>
  step_normalize(all_numeric_predictors() , all_factor_predictors())


prep(engineered_recipe) |>
  bake(new_data = NULL)


## basic tree recipe
tree_recipe <- recipe(sqrt_ach_ct ~ . , data = fl_train) |>
  step_rm(ach_ct , site_of_origin_pedigree , insects , insects_note ,
          cg_pla_id , basal_rosette_ct , longest_cauline_lf , measure_dt) |>
  step_zv(all_predictors()) |>
  step_dummy(all_nominal_predictors() , one_hot = TRUE) |>
  step_impute_knn(all_predictors()) |>
  step_normalize(all_numeric_predictors() , all_factor_predictors())


prep(tree_recipe) |>
  bake(new_data = NULL)

## tuned tree recipe
engineered_tree_recipe <- recipe(sqrt_ach_ct ~ . , data = fl_train) |>
  step_rm(ach_ct , site_of_origin_pedigree , insects , insects_note ,
          cg_pla_id , basal_rosette_ct , longest_cauline_lf , measure_dt) |>
  step_poly(row, degree = 2) |>
  step_num2factor(yr_planted , levels = c("1996" , "1997" , "1998" , "1999")) |>
  step_mutate(hd_ct = case_when(
    hd_ct %in% 1:5 ~ as.character(hd_ct),
    hd_ct %in% 6:9 ~ "6 to 9",
    hd_ct >= 10 ~ "10+"
  )) |>
  step_string2factor(hd_ct) |>
  step_mutate(wht_indicator = as.factor(ifelse(wht_fuzzy == 1 | wht_scary == 1, "1", "0"))) |>
  step_rm(wht_fuzzy, wht_scary) |>
  step_mutate(ant = as.factor(ifelse(ant1 == 1 | ant2to10 == 1 | ant_gt10 == 1 , "1", "0"))) |>
  step_mutate(aphid = as.factor(ifelse(aphid1 == 1 | aphid2to10 == 1 | aphid11to80 == 1 |aphid_gt80 == 1 , "1", "0"))) |>
  step_dummy(all_nominal_predictors() , one_hot = TRUE) |>
  step_zv(all_predictors()) |>
  step_impute_knn(all_predictors()) |>
  step_normalize(all_numeric_predictors() , all_factor_predictors())


prep(engineered_tree_recipe) |>
  bake(new_data = NULL)

## save everything
save(basic_recipe , fl_test , file = here("results/basic_recipe.rda"))
save(tree_recipe , fl_test , file = here("results/tree_recipe.rda"))
save(engineered_tree_recipe , fl_test , file = here("results/engineered_tree_recipe.rda"))
