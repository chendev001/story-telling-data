#### Preamble ####
# Purpose: Download TTC Subway Delay Data From Toronto Open Data
# Author: Junwei Chen
# Date: 23 January 2024
# Contact: junwei.chen@mail.utoronto.ca
# License: MIT
# Pre-requisites: R version 4.2.2 or higher, necessary R packages : tidyverse and opendatatoronto
# Download data for TTC Subway Delay of Open Data Toronto

#### Load packages ####
library(tidyverse)
library(opendatatoronto)

#### Get Data ####
# Get List Packages
packages <- list_packages(limit = 100)
View(packages)

# Input Keywords
subway_ttc <- search_packages("ttc subway delay data")
print(subway_ttc)

# Get Resources
subway_ttc_r <- subway_ttc %>%
  list_package_resources()
print(subway_ttc_r)

# Get Latest Data
subway_data <- subway_ttc_r %>%
  tail(1) %>%
  get_resource()

# Print data
head(subway_data, 10)


#### Save Data Into Folder Data ####
# Create the directory if it does not exist
if (!dir.exists("inputs/data")) {
  dir.create("inputs/data", recursive = TRUE)
}
# Now you can write the CSV file
write_csv(subway_data, "inputs/data/subway_delay_data.csv")


### WRAP IT UP INTO ONE FUNCTION ####
# It's optional incase you want more modular approach

get_toronto_data <- function() {
  # Get List Packages
  packages <- list_packages(limit = 200)
  View(packages)
  
  # Input Keywords
  cat("\nEnter a keyword for data you want to download: ")
  keyword <- readline(prompt = "")
  
  keyword_o <- search_packages(keyword)
  print(keyword_o)
  
  # Get Resources
  resources <- keyword_o %>%
    list_package_resources()
  print(resources)
  
  # Get Data By Allowing user to input the row number
  cat("\nEnter the row number of resources to get data: ")
  row_number <- as.numeric(readline(prompt = ""))
  
  data <- resources %>%
    slice(row_number) %>%
    get_resource()
  
  # Print data
  cat("\nYour Data:\n")
  print(head(data, 20))
  
  # Save data
  
  # Create the directory if it does not exist
  if (!dir.exists("inputs/data")) {
    dir.create("inputs/data", recursive = TRUE)
  }
  
  # Write the CSV file
  write_csv(data, "inputs/data/raw_data.csv")
}

# Usage:
get_toronto_data()

