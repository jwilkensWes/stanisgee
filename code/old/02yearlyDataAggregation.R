## Individual CSV to Year CSV
  # produces a single csv file from many individual ones
  # zonal statistic csv files must be produced in QGIS prior to running this script
  # intended to run multiple times for each year in dataset
  # parts of this script were produced using chat-GPT and then edited to work with this data
  

# load packages
library(tidyverse)

# **edit this parameter**
setwd("C:/Users/leafTop/Documents/School Documents/QAC Summer Apprenticeship/stanisgee/data/rawdata/zonalstats/2020")

# get a list of all csv files in the folder
csv_files <- list.files(pattern = "*.csv")

# Initialize an empty data frame to store the merged data
merged_data <- data.frame()

# Loop through each CSV file and append its contents to the merged data frame
for (file in csv_files) {
    # create date object from file name
  date <- str_sub(file,
                  start = str_locate(file, "_")[1]+1,
                  end = nchar(file)-4)
  date <- ymd(date)
  csv_data <- read_csv(file_path)
  csv_data <- csv_data %>% 
    mutate(year = year(date), 
           month = month(date), 
           day = day(date))
  merged_data <- bind_rows(merged_data, csv_data)
  }
setwd("..")

# Write the merged data frame to a new CSV file ** and this one **
write_csv(merged_data, "multiyear/ndwi2020.csv")

