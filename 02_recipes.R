# Setup pre-processing/recipes

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
  step_dummy(all_nominal_predictors()) |>
  step_zv(all_predictors()) |>
  step_impute_knn(all_predictors()) |>
  step_normalize(all_numeric_predictors() , all_factor_predictors())


prep(basic_recipe) |>
  bake(new_data = NULL)

## tuned recipe
engineered_recipe <- recipe(sqrt_ach_ct ~ . , data = fl_train) |>
  step_rm(ach_ct , site_of_origin_pedigree , insects , insects_note ,  
          cg_pla_id , basal_rosette_ct , longest_cauline_lf , measure_dt) |>
  step_interact(step_interact(terms = ~pos:row)) |>
    #create coordinate grid
  step_num2factor(yr_planted) |>
    #may work better as factor
  mutate(wht_indicator = as.factor(ifelse(wht_fuzzy == 1 | wht_scary == 1, "1", "0"))) |>
  step_rm(wht_fuzzy, wht_scary) |>
    #i feel like the difference is up to personal interpretation
  mutate(ant = as.factor(ifelse(ant1 == 1 | ant2to10 == 1 | ant_gt10 == 1 , "1", "0"))) |>
  mutate(aphid = as.factor(ifelse(aphid1 == 1 | aphid2to10 == 1 | aphid11to80 == 1 |ant_gt80 == 1 , "1", "0"))) |>
    #i think this one makes sense
  step_dummy(all_nominal_predictors()) |>
  step_zv(all_predictors()) |>
  step_impute_knn(all_predictors()) |>
  step_normalize(all_numeric_predictors() , all_factor_predictors())


prep(basic_recipe) |>
  bake(new_data = NULL)


## basic tree recipe
tree_recipe <- recipe(sqrt_ach_ct ~ . , data = fl_train) |>
  step_rm(ach_ct , site_of_origin_pedigree , insects , insects_note ,
          cg_pla_id , basal_rosette_ct , longest_cauline_lf , measure_dt) |>
  step_dummy(all_nominal_predictors() , one_hot = TRUE) |>
  step_zv(all_predictors()) |>
  step_impute_knn(all_predictors()) |>
  step_normalize(all_numeric_predictors() , all_factor_predictors())


prep(tree_recipe) |>
  bake(new_data = NULL)
## tuned tree recipe


## save everything
save(basic_recipe , fl_test , file = here("results/basic_recipe.rda"))
save(tree_recipe , fl_test , file = here("results/tree_recipe.rda"))

