#### Preamble ####
# Purpose: Clean TTC Subway Delay Data From Toronto Open Data
# Author: Junwei Chen
# Date: 23 January 2024
# Contact: junwei.chen@mail.utoronto.ca
# License: MIT
# Pre-requisites: R version 4.2.2 or higher, necessary R packages : tidyverse
# Clean TTC Subway Delay of Open Data Toronto for analysis and modeling.

#### Load packages ####
library(tidyverse)

#### Clean Data ####
raw_data <- read_csv("inputs/data/subway_delay_data.csv")
head(raw_data, 10)

# get summary of data
summary(raw_data)

# get missing value
colSums(is.na(raw_data))

# Seems like we get missing in Bound and Line, referring to the metadata:
# Bound = Direction of train dependant on the line
# Line = TTC subway line i.e. YU, BD, SHP, and SRT
# Vehicle = TTC train number
# We then fill all missing valuee across these Bond and Line column with "Invalid"
# Convert 0 to Invalid on Vehicle and then convert it to string

# Clean data
clean_data <- function(data) {
  data$Bound[is.na(data$Bound)] <- "Invalid"
  data$Line[is.na(data$Line)] <- "Invalid"
  data$Vehicle <- as.character(ifelse(data$Vehicle == 0, "Invalid", data$Vehicle))
  data$Month <- format(data$Date, "%B") # create month
  data$Hour <- as.integer(substr(data$Time, 1, 2)) # get hour
  data <- distinct(data) # remove duplicate data
  data <- data[order(data$Date), ]
  return(data)
}

cleaned_data <- clean_data(raw_data)
head(cleaned_data)

#### Save data ####
write_csv(cleaned_data, "outputs/data/cleaned_data.csv")


#### Create Analysis Data (for Model) ####
# Check unique value to see whether it's worth it to do one hot encoding
character_columns <- sapply(cleaned_data, is.character)

# Loop for all character column
for (col in names(cleaned_data)[character_columns]) {
  unique_values_count <- length(unique(cleaned_data[[col]]))
  cat("Number of unique values in", col, ":", unique_values_count, "\n")
}

# We will only use Day as predictor for one hot encoding
# Select columns for model_data
model_data <- cleaned_data %>%
  select(Date, Day, `Min Delay`, `Min Gap`, Hour, Month)

head(model_data)

# One-hot encoding for 'Day'
model_data <- cbind(model_data, model.matrix(~Day - 1, data = model_data))
model_data <- model_data[, -which(names(model_data) == "Day")]
head(model_data)

#### Save data ####
write_csv(model_data, "outputs/data/analysis_data.csv")