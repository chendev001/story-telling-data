#### Preamble ####
# Purpose: Get Test Data TTC Subway Delay Model
# Author: Junwei Chen
# Date: 23 January 2024
# Contact: junwei.chen@mail.utoronto.ca
# License: MIT
# Pre-requisites: R version 4.2.2 or higher, necessary R packages : tidyverse
# Get test data forTTC Subway delay prediction model

#### Load packages ####
library(tidyverse)

#### Split Test Data ####
data_model <- read_csv("outputs/data/analysis_data.csv")
head(data_model, 10)

# Split December as test data and the rest as training data
train_data <- model_data[model_data$Month != "December", ]
test_data <- model_data[model_data$Month == "December", ]

# Print the resulting data frames
print(head(train_data))
print(head(test_data))

#### Save data ####
write_csv(train_data, "outputs/data/train_data.csv")
write_csv(test_data, "outputs/data/test_data.csv")