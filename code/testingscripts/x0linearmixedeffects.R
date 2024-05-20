## Linear Mixed Effects modeling


# packages
library(lme4)


# data
load("~/School Documents/QAC Summer Apprenticeship/stanisgee/data/cleandata/master2019-2021.Rda")
str(mdf)

# mixed effects model
md <- lmer(ndwi_mean ~ Blocktype, data = mdf)
summary(md)
