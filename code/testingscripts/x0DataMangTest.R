## Individual CSV to Year CSV
# produces a single csv file from many individual ones
# zonal statistic csv files must be produced in QGIS prior to running this script
# intended to run multiple times for each year in dataset
# parts of this script were produced using chat-GPT and then edited to work with this data


# load packages
library(tidyverse)

# set the working directory to the folder containing the CSV files
setwd("C:/Users/leafTop/Documents/School Documents/QAC Summer Apprenticeship/stanisgee/data/zonalstats/2019")

# get a list of all csv files in the folder
csv_files <- list.files(pattern = "*.csv")

# Initialize an empty data frame to store the merged data
merged_data <- data.frame()

file <- csv_files[1]
date <- str_sub(file,
                start = str_locate(file, "_")[1]+1,
                end = nchar(file)-4)
print(date)
date <- ymd(date)
print(date)

