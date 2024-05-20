## Data Management


# packages
library(tidyverse)
library(qacBase)


# read in aggregated datafile
ndwim <- read_csv("C:\\Users\\leafTop\\Documents\\School Documents\\QAC Summer Apprenticeship\\stanisgee\\data\\rawdata\\zonalstats\\ndwimultiyearaggregate.csv")


# explore data
str(ndwim)
contents(ndwim)


# remove missing data using list wise deletion
mdf <- na.omit(ndwim)
contents(mdf)


# remove unnecessary columns
mdf$Perimeter <- NULL
mdf$Hectares <- NULL
mdf$...1 <- NULL


# set blocktypes to factor vars
mdf$Blocktype <- factor(mdf$Blocktype)
summary(mdf)
str(mdf)

# save as csv and Rda
write.csv(mdf, "data/cleandata/master2019-2021.csv")
save(mdf, file = "data/cleandata/master2019-2021.Rda")
