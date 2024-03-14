### R Scripts:
01_data_wrangling.R: data cleaning, creation of dataset, data splitting/folding
 
01b_data_analysis.R: analysis of correlations in data to determine feature engineering in recipes
 
02_recipes.R: creation of simple and complex recipes to be used by the models in following R scripts 
  
03_fit_btree.R: work for boosted tree modeling, including defining a model/workflow, tuning the model hyperparameters, and fitting the models. Uses a basic recipe

03_fit_btree_engineered.R: work for boosted tree modeling, including defining a model/workflow, tuning the model hyperparameters, and fitting the models. Uses a complex recipe

03_fit_knn.R: work for KNN modeling, including defining a model/workflow, tuning the model hyperparameters, and fitting the models. Uses a basic recipe

03_fit_knn_engineered.R: work for KNN modeling, including defining a model/workflow, tuning the model hyperparameters, and fitting the models. Uses a complex recipe
     
03_fit_rforest.R: work for random forest modeling, including defining a model/workflow, tuning the model hyperparameters, and fitting the models. Uses a basic recipe

03_fit_rforest_engineered.R: work for random forest modeling, including defining a model/workflow, tuning the model hyperparameters, and fitting the models. Uses a complex recipe
 
03_fit_lm.R: work for linear regression modeling, including defining a model/workflow, tuning the model hyperparameters, and fitting the models. Uses a basic recipe

03_fit_lm_engineered.R: work for linear regression modeling, including defining a model/workflow, tuning the model hyperparameters, and fitting the models. Uses a complex recipe
 
03_fit_enet.R: work for elastic net modeling, including defining a model/workflow, tuning the model hyperparameters, and fitting the models. Uses a basic recipe

03_fit_enet_engineered.R: work for elastic net modeling, including defining a model/workflow, tuning the model hyperparameters, and fitting the models. Uses a complex recipe 

04_model_analysis.R: comparing performances of the 10 models from the previous R scripts.

05_final_fit.R: training and fitting best performing models

06_final_analysis: assessment of best performing models
