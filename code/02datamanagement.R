## Data Management

#this is a kind of messy and round about way of doing the datamangement, as I 
#switched from deciding to have 3 different data frames for each index to 
#only having one dataframe, but it works

# packages
library(tidyverse)
library(qacBase)


# import dataset
ndvi8 <- read_csv("data/rawdata/index collection/ndvi8.csv")
ndvi7 <- read_csv("data/rawdata/index collection/ndvi7.csv")
ndmi8 <- read_csv("data/rawdata/index collection/ndmi8.csv")
ndmi7 <- read_csv("data/rawdata/index collection/ndmi7.csv")
ndwi8 <- read_csv("data/rawdata/index collection/ndwi8.csv")
ndwi7 <- read_csv("data/rawdata/index collection/ndwi7.csv")


# make a master datasets
ndvimas <- bind_rows(ndvi7, ndvi8)
ndmimas <- bind_rows(ndmi7, ndmi8)
ndwimas <- bind_rows(ndwi7, ndwi8)

 
# explore data
contents(ndvi8)

# add and remove desirable variables

# functions
get_date <- function(image_id){ # get date from system:index
  date <- str_sub(image_id, 13, 20)
  date <- ymd(date)
  return(date)
}
get_sat <- function(image_id){ # get satelite type from system:index
  sat <- str_sub(image_id, 1, 4)
  return(sat)
}
simplify_treatment <- function(index){ # reduce the treatment levels to Control, Burn, Thin, and Thin & Burn
  df <- index %>%
    mutate(treatment = case_when(
      Blocktype == "UB-Control" ~ "Control",
      Blocktype == "UB-Even" ~ "Thin",
      Blocktype == "UB-Variable" ~ "Thin",
      Blocktype == "B-Control" ~ "Burn",
      Blocktype == "B-Even" ~ "Thin & Burn",
      Blocktype == "B-Variable" ~ "Thin & Burn"))
  return(df)
}
make_drought <- function(index){
  df <- index %>% 
    mutate(drought = case_when(
      year == 2010 | year == 2011 | year == 2017 | year == 2019 ~ "Normal",
      year == 2008 | year == 2018 ~ "Abnormally Dry",
      year == 2009 | year == 2012 | year == 2020 ~ "Moderate Drought",
      year == 2013 ~ "Severe Drought",
      year == 2014 | year == 2015 | year == 2016 | year == 2021 | year == 2022 ~ "Extreme or Exceptional Drought"
    ))
}
make_treatment_status <- function(index){
  df <- index %>% 
    mutate(treatment_status = case_when(
      year < 2011 ~ "Pre-Treatment",
      year > 2010 & year < 2013 ~ "During Treatment",
      year > 2012 ~ "Post-Treatment"
    ))
}


# make date columns
ndvimas <- ndvimas %>% 
  mutate(date = get_date(`system:index`))
ndmimas <- ndmimas %>% 
  mutate(date = get_date(`system:index`))
ndwimas <- ndwimas %>% 
  mutate(date = get_date(`system:index`))

# make year column
ndvimas <- ndvimas %>% 
  mutate(year = year(date))
ndmimas <- ndmimas %>% 
  mutate(year = year(date))
ndwimas <- ndwimas %>% 
  mutate(year = year(date))


# make sat label columns
ndvimas <- ndvimas %>% 
  mutate(sat = get_sat(`system:index`))
ndmimas <- ndmimas %>% 
  mutate(sat = get_sat(`system:index`))
ndwimas <- ndwimas %>% 
  mutate(sat = get_sat(`system:index`))

# make simplified treatment column
ndvimas <- simplify_treatment(ndvimas)
ndmimas <- simplify_treatment(ndmimas)
ndwimas <- simplify_treatment(ndwimas)

# create ID column
ndvimas <- ndvimas %>% 
  mutate(id = row_number())
ndmimas <- ndmimas %>% 
  mutate(id = row_number())
ndwimas <- ndwimas %>% 
  mutate(id = row_number())

# make treatment_status variable
ndvimas <- make_treatment_status(ndvimas)
ndmimas <- make_treatment_status(ndmimas)
ndwimas <- make_treatment_status(ndwimas)

# make drought variable
ndvimas <- make_drought(ndvimas)
ndmimas <- make_drought(ndmimas)
ndwimas <- make_drought(ndwimas)


# rename statistics to add index prefix
ndvimas <- ndvimas %>% 
  rename(ndvi_mean = mean,
         ndvi_median = median,
         ndvi_stdDev = stdDev)

ndmimas <- ndmimas %>% 
  rename(ndmi_mean = mean,
         ndmi_median = median,
         ndmi_stdDev = stdDev)

ndwimas <- ndwimas %>% 
  rename(ndwi_mean = mean,
         ndwi_median = median,
         ndwi_stdDev = stdDev)




# drop unnecessary columns

# .geo
ndvimas$.geo <- NULL
ndmimas$.geo <- NULL
ndwimas$.geo <- NULL

# Area, Acres, Perimeter
ndvimas$Area <- NULL
ndvimas$Acres <- NULL
ndvimas$Perimeter <- NULL

ndmimas$Area <- NULL
ndmimas$Acres <- NULL
ndmimas$Perimeter <- NULL

ndwimas$Area <- NULL
ndwimas$Acres <- NULL
ndwimas$Perimeter <- NULL

# system:index
ndvimas$`system:index` <- NULL
ndmimas$`system:index` <- NULL
ndwimas$`system:index` <- NULL


# correct variable types, name and order

# set factors
summary(ndvimas)
ndvimas$Blocktype <- factor(ndvimas$Blocktype)
ndvimas$UnitNo <- factor(ndvimas$UnitNo)
ndvimas$sat <- factor(ndvimas$sat)
ndvimas$treatment <- factor(ndvimas$treatment)
ndvimas$treatment_status <- factor(ndvimas$treatment_status)
ndvimas$drought <- factor(ndvimas$drought)

ndmimas$Blocktype <- factor(ndmimas$Blocktype)
ndmimas$UnitNo <- factor(ndmimas$UnitNo)
ndmimas$sat <- factor(ndmimas$sat)
ndmimas$treatment <- factor(ndmimas$treatment)
ndmimas$treatment_status <- factor(ndmimas$treatment_status)
ndmimas$drought <- factor(ndmimas$drought)

ndwimas$Blocktype <- factor(ndwimas$Blocktype)
ndwimas$UnitNo <- factor(ndwimas$UnitNo)
ndwimas$sat <- factor(ndwimas$sat)
ndwimas$treatment <- factor(ndwimas$treatment)
ndwimas$treatment_status <- factor(ndwimas$treatment_status)
ndwimas$drought <- factor(ndwimas$drought)

summary(ndmimas)

# rename uppercase columns to lowercase
ndvimas <- ndvimas %>% 
  rename(blocktype = Blocktype,
         hectares = Hectares,
         unitno = UnitNo)
ndmimas <- ndmimas %>% 
  rename(blocktype = Blocktype,
         hectares = Hectares,
         unitno = UnitNo)
ndwimas <- ndwimas %>% 
  rename(blocktype = Blocktype,
         hectares = Hectares,
         unitno = UnitNo)

# change order of columns
ndvimas <- ndvimas %>% 
  select(id, date, year, treatment, treatment_status, drought, 
         ndvi_mean, ndvi_median, ndvi_stdDev, 
         blocktype, unitno, sat)

ndmimas <- ndmimas %>% 
  select(id, ndmi_mean, ndmi_median, ndmi_stdDev)

ndwimas <- ndwimas %>% 
  select(id, ndwi_mean, ndwi_median, ndwi_stdDev)
summary(ndvimas$year)

ndvimas
ndmimas
ndwimas
contents(ndwimas)
# combine index dfs into one df
indexmas <- ndvimas %>% 
  full_join(ndmimas, join_by(id)) %>% 
  full_join(ndwimas, join_by(id))

contents(indexmas)

# remove missing observations
indexmas <- na.omit(indexmas)
# set id to factor
indexmas$id <- NULL
# make month column
indexmas <- indexmas %>% 
  mutate(month = month(date))

# save data in clean data
save(indexmas, file = "data/cleandata/index_master.Rda")
write.csv(indexmas, file = "data/cleandata/index_master.csv")


# drought data
drought <- read_csv("data/rawdata/tuoldrought.csv")
drought
save(drought, file = "data/cleandata/drought_master.Rda")
