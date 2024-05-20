## Multiyear Data Management
  # used to join year csv to one master csv datafile
  # returns one csv file with all years of data aggregated


# packages
library(tidyverse)
library(qacBase)

# import yearly csv files

# set working directory to folder containing year csv's
setwd("C:/Users/leafTop/Documents/School Documents/QAC Summer Apprenticeship/stanisgee/data/rawdata/zonalstats/multiyear")
# create file list
csv_files <- list.files(pattern = "*.csv")
# create empty dataframe to store final data
merged_data <- data.frame()

# for loop to import csv files and merge them
for(file in csv_files){
  file_path <- paste(getwd(), "/", file, sep="")
  temp <- read_csv(file_path)
  merged_data <- bind_rows(merged_data, temp)
}

# write csv to master csv
setwd("..")
write.csv(merged_data, "ndwimultiyearaggregate.csv")