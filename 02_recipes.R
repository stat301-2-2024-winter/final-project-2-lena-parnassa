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
basic_recipe <- recipe(ach_ct ~ . , data = fl_train) |>
  step_rm(site_of_origin_pedigree , insects , insects_note , row  , pos , 
          cg_pla_id , basal_rosette_ct , longest_cauline_lf) |>
  #need to remove some other steps
  step_dummy(all_nominal_predictors()) |>
  step_zv(all_predictors()) |>
  step_impute_knn(all_predictors()) |>
  step_normalize(all_numeric_predictors() , all_factor_predictors())


prep(basic_recipe) |>
  bake(new_data = NULL)
## tuned recipe


## basic tree recipe
tree_recipe <- recipe(ach_ct ~ . , data = fl_train) |>
  step_rm(site_of_origin_pedigree , insects , insects_note ,
          cg_pla_id , basal_rosette_ct , longest_cauline_lf) |>
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

