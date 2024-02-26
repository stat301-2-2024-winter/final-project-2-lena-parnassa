# load packages ----
library(tidyverse)
library(tidymodels)
library(here)
library(janitor)
library(forcats)

# handle common conflicts
tidymodels_prefer()


### load in datasets
core_data <- read_csv(here("data/cg1CoreData.csv")) |>
  select(-contains(c("1996", "1997", "1998", "1999", "2000", "2001", "2002", "2003",
                            "2013", "2014", "2015", "2016", "2017", "2018", "2019", "2020",
                            "2021", "2022")))

insect_data <- read_csv(here("data/cg1PlantMeasureInsectsForKM.csv")) 


### work to join/tidy datasets
awful_join <- insect_data |>
  left_join(core_data , by = c("cgPlaId" , "row" , "pos")) 

data_2004 <- awful_join |>
  filter(measureYr == 2004) |>
  select(-contains(c("2005", "2006", "2007","2008", "2009", "2010", "2011", "2012"))) |>
  rename(ld = ld2004 ,
         fl = fl2004 ,
         hdCt = hdCt2004 ,
         achCt = achCt2004) |>
  mutate(ld = factor(ld) ,
         fl = factor(fl) ,
         hdCt = as.numeric(hdCt) ,
         achCt = as.numeric(hdCt))

data_2005 <- awful_join |>
  filter(measureYr == 2005) |>
  select(-contains(c("2004", "2006", "2007","2008", "2009", "2010", "2011", "2012"))) |>
  rename(ld = ld2005 ,
         fl = fl2005 ,
         hdCt = hdCt2005 ,
         achCt = achCt2005) |>
  mutate(ld = factor(ld) ,
         fl = factor(fl) ,
         hdCt = as.numeric(hdCt) ,
         achCt = as.numeric(hdCt))

data_2006 <- awful_join |>
  filter(measureYr == 2006) |>
  select(-contains(c("2005", "2004", "2007","2008", "2009", "2010", "2011", "2012"))) |>
  rename(ld = ld2006 ,
         fl = fl2006 ,
         hdCt = hdCt2006 ,
         achCt = achCt2006) |>
  mutate(ld = factor(ld) ,
         fl = factor(fl))

data_2007 <- awful_join |>
  filter(measureYr == 2007) |>
  select(-contains(c("2005", "2006", "2004","2008", "2009", "2010", "2011", "2012"))) |>
  rename(ld = ld2007 ,
         fl = fl2007 ,
         hdCt = hdCt2007 ,
         achCt = achCt2007) |>
  mutate(ld = factor(ld) ,
         fl = factor(fl))

data_2008 <- awful_join |>
  filter(measureYr == 2008) |>
  select(-contains(c("2005", "2006", "2007","2004", "2009", "2010", "2011", "2012"))) |>
  rename(ld = ld2008 ,
         fl = fl2008 ,
         hdCt = hdCt2008 ,
         achCt = achCt2008) |>
  mutate(ld = factor(ld) ,
         fl = factor(fl))

data_2009 <- awful_join |>
  filter(measureYr == 2009) |>
  select(-contains(c("2005", "2006", "2007","2008", "2004", "2010", "2011", "2012"))) |>
  rename(ld = ld2009 ,
         fl = fl2009 ,
         hdCt = hdCt2009 ,
         achCt = achCt2009)|>
  mutate(ld = factor(ld) ,
         fl = factor(fl))

data_2010 <- awful_join |>
  filter(measureYr == 2010) |>
  select(-contains(c("2005", "2006", "2007","2008", "2009", "2004", "2011", "2012"))) |>
  rename(ld = ld2010 ,
         fl = fl2010 ,
         hdCt = hdCt2010 ,
         achCt = achCt2010) |>
  mutate(ld = factor(ld) ,
         fl = factor(fl))

data_2011 <- awful_join |>
  filter(measureYr == 2011) |>
  select(-contains(c("2005", "2006", "2007","2008", "2009", "2010", "2004", "2012"))) |>
  rename(ld = ld2011 ,
         fl = fl2011 ,
         hdCt = hdCt2011 ,
         achCt = achCt2011) |>
  mutate(ld = factor(ld) ,
         fl = factor(fl))

data_2012 <- awful_join |>
  filter(measureYr == 2012) |>
  select(-contains(c("2005", "2006", "2007","2008", "2009", "2010", "2011", "2004"))) |>
  rename(ld = ld2012 ,
         fl = fl2012 ,
         hdCt = hdCt2012 ,
         achCt = achCt2012) |>
  mutate(ld = factor(ld) ,
         fl = factor(fl))

semi_usable_data <- bind_rows(data_2004 , data_2005 , data_2006 , data_2007 , data_2008 , 
                          data_2009 , data_2010 , data_2011 , data_2012) |>
  clean_names() 

semi_usable_data <- semi_usable_data |>
  mutate(pla_status_desc = factor(pla_status_desc) ,
         # go through and figure out what the levels are bc there shouldn't be 13 
         wrinkled_lvs_pres = factor(wrinkled_lvs_pres) ,
         ant1 = factor(ant1) ,
         ant2to10 = factor(ant2to10) ,
         ant_gt10 = factor(ant_gt10) ,
         aphid1 = factor(aphid1) ,
         aphid2to10 = factor(aphid2to10) ,
         aphid11to80 = factor(aphid11to80) ,
         aphid_gt80 = factor(aphid_gt80) ,
         lf_miner = factor(lf_miner) ,
         lf_rolled = factor(lf_rolled) ,
         pupa = factor(pupa) ,
         egg_sac = factor(egg_sac) ,
         beetle = factor(beetle) ,
         grasshopper = factor(grasshopper) ,
         spittle = factor(spittle) ,
         wht_fuzzy = factor(wht_fuzzy) ,
         wht_scary = factor (wht_scary) , 
         other_note = factor(other_note))
semi_usable_data$wrinkled_lvs_pres <- as.factor(ifelse(is.na(semi_usable_data$wrinkled_lvs_pres), 0,
                                                       semi_usable_data$wrinkled_lvs_pres))


### clean up data for project
fl_data <- semi_usable_data |>
  filter(fl == 1) |>
  filter(ach_ct >= 0) |>
  mutate(across(c(longest_basal_lf, longest_cauline_lf, basal_lf_ct), ~na_if(., -777))) |>
  mutate(any_bug = case_when(
    !is.na(insects) ~ "1",
    is.na(insects) ~ "0")) |>
  mutate(any_bug = as_factor(any_bug)) |>
  mutate(flowering_rosette_ct = case_when(
    is.na(flowering_rosette_ct) ~ 0,
    TRUE ~ flowering_rosette_ct)) |>
    #im reasonably certain NA values should be 0s, 
    #the lowest value originally in the dataset is a 1, and manually skimming data showed other values for datapoints with NA values for flowering_rosette_ct are consistent with what is expected for plants without flowering rosettes
  select(-c(hdct , exp_nm))
    #variables are duplicates of other columns, I kept the ones with higher completion rates

skimr::skim(fl_data)

set.seed(1995)
#initial split:
fl_split <- fl_data |>
  initial_split(prop = 0.7 , strata = ach_ct)

fl_train <- fl_split |>
  training()
fl_test <- fl_split |>
  testing()


# fold
fl_fold <- vfold_cv(fl_train, v = 5, repeats = 3,
                          strata = ach_ct)


### save everything
save(fl_train, fl_test, fl_fold , file = here("results/fl_split.rda"))
write_csv(semi_usable_data , here("data/semi_usable_data.csv"))
write_csv(fl_data , here("data/fl_data.csv"))
write_rds(fl_split , "data/fl_split.rds")
write_rds(fl_train , "data/fl_training.rds")
write_rds(fl_test , "data/fl_testing.rds")

