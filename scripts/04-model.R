#### Preamble ####
# Purpose: TTC Subway Delay Model
# Author: Junwei Chen
# Date: 23 January 2024
# Contact: junwei.chen@mail.utoronto.ca
# License: MIT
# Pre-requisites: R version 4.2.2 or higher, necessary R packages : tidyverse and randomForest
# TTC Subway delay prediction model

#### Load packages ####
library(tidyverse)
library(randomForest)

#### Get Data ####
train_data <- read_csv("outputs/data/train_data.csv")
head(train_data, 10)

# drop unused column
train_data <- subset(train_data, select = -c(Date,Month))
head(train_data)

#### Create Random Forest Model ####
target <- 'Min Delay'

rf_model <- 
  randomForest(
    train_data[, -which(names(train_data) == target)], 
    train_data[[target]], 
    ntree = 250)

#### Save Model ####
saveRDS(rf_model, 
        "outputs/models/random_forest_model v1.rds"
        )


#### Test Model ####
# get model
rf_models <- readRDS("outputs/models/random_forest_model v1.rds")

# get test data
test_data <- read_csv("outputs/data/test_data.csv")
test_data <- subset(test_data, select = -c(Date,Month))
head(test_data, 10)

# get predictions on the test data
predictions <- predict(rf_models, test_data[, -which(names(test_data) == target)])

# Print or analyze the predictions
print(predictions)

#### Evaluate Performance ####
mae <- mean(abs(predictions - test_data[[target]]))
rmse <- sqrt(mean((predictions - test_data[[target]])^2))
cat("Mean Absolute Error (MAE):", mae, "\n")
cat("Root Mean Squared Error (RMSE):", rmse, "\n")

