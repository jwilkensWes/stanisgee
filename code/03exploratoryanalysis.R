## exploratory analysis


# packages
library(tidyverse)
library(qacBase)
library(ggplot2)

# load data
load("data/cleandata/index_master.Rda")


# exploratory
contents(indexmas)
df_plot(indexmas)
barcharts(indexmas)

univariate_plot(indexmas, ndvi_mean)
univariate_plot(indexmas, ndmi_mean)
univariate_plot(indexmas, ndwi_mean)

cor_plot(indexmas)

ggplot(indexmas, aes(treatment, ndmi_median)) +
  geom_boxplot()

ggplot(indexmas, aes(year, ndmi_median, color = treatment)) +
  geom_point()

# look at all data
ggplot(indexmas, aes(date, ndmi_mean, color = treatment)) +
  geom_point()

# look at during drought years
ndwi_drought <- ndwimas %>% 
  filter(year >= 2014 & year <= 2018)

ggplot(ndwi_drought, aes(treatment, ndwi_median)) +
  geom_boxplot()

