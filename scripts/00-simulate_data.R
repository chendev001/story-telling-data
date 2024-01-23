#### Preamble ####
# Purpose: Simulates Dummy Data
# Author: Junwei Chen
# Date: 23 January 2024
# Contact: junwei.chen@mail.utoronto.ca
# License: MIT
# Pre-requisites: R version 4.2.2 or higher, necessary R packages : tidyverse 
# Dummy data for TTC Subway Delay of Open Data Toronto

#### Load packages ####
library(tidyverse)


#### Reproducibility ####
# Set seed
set.seed(0)

#### Define function to simulate data ####
simulate_data <- function(size, values) {
    sample(values, size, replace = TRUE)
}

#### Simulate Subway Delay Data ####
sim_subway_delay <- tibble(
    Date = simulate_data(seq(as.Date("2023-01-01"), as.Date("2023-12-31"), by = "1 day"), size = 1000),
    Time = simulate_data(seq(as.POSIXct("2023-01-01 06:00:00"), as.POSIXct("2023-01-01 23:59:59"), by = "1 sec"), size = 1000),
    Day = simulate_data(c("Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"), size = 1000),
    Station = simulate_data(c("Central", "North", "South", "East", "West"), size = 1000),
    Code = simulate_data(c("A", "B", "C", "D", "E", "F", "G", "H", "I", "J"), size = 1000),
    Min_Delay = simulate_data(seq(0, 60, by = 1), size = 1000),
    Min_Gap = simulate_data(seq(0, 60, by = 1), size = 1000),
    Bound = simulate_data(c("North", "South", "East", "West"), size =1000),
    Line = simulate_data(c("YU", "BD", "SHP", "SRT"), size = 1000),
    Vehicle = simulate_data(seq(200, 300), size =1000)
) %>% 
    mutate(
        # define type of data
        across(c(Day, Station, Code, Bound, Line, Vehicle), as.factor),
        across(c(Min_Delay, Min_Gap), as.numeric),
        Date = as.Date(Date),
        Time = format(as.POSIXct(Time), "%H:%M:%S")
    ) %>%
    # arrange by date and time
    arrange(Date, Time)


#### Simulate Subway Station Data ####
print(head(sim_subway_delay))


### Save data ####
write_csv(sim_subway_delay, "inputs/data/raw_data.csv")

