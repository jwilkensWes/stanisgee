## exploratory dataset analysis


# packages
library(qacBase)
library(GGally)
library(ggplot2)

# data
load("~/School Documents/QAC Summer Apprenticeship/stanisgee/data/cleandata/master2019-2021.Rda")
str(mdf)

# exploratory data analysis
contents(mdf)
df_plot(mdf)
densities(mdf)
histograms(mdf)
densities(mdf)
ggpairs(mdf, columns = c("Blocktype", 
                         "Acres", 
                         "ndwi_count", 
                         "ndwi_median",
                         "ndwi_mean",
                         "ndwi_stdev", 
                         "month",
                         "year"))
# univariate descriptive statistics
univariate_plot(mdf, ndwi_median)

# boxplot median
ggplot(mdf, aes(Blocktype, ndwi_median)) +
  geom_boxplot()
# mean


# basic linear mixed effects modeling
library(lme4)
library(afex)

# werid test
m <- lm(ndwi_median~Blocktype, data = mdf)
summary(m)

