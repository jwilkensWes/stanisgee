library(lme4)
library(sjPlot)
library(sjstats)
library(merTools)
# model building

index <- indexmas %>%
  filter(year > 2012 & year < 2019)

ggplot(index, aes(x = date, y = ndmi_mean, color = treatment)) +
  geom_point()

md <- lm(ndmi_mean ~ treatment + year + ndvi_mean, data = index)
summary(md)

# random effects intercept
hlm1 <- lmer(ndmi_mean ~ 1 + (1|year), index, REML=F)
summary(hlm1)
tab_model(hlm1)


# design effect
nbar <- 1017/6
deseff<-design_effect(nbar, icc=0.03)
deft=sqrt(deseff)
print(deft)
# 2.5 times smaller st. errors without grouping

effsize=1017/deseff
print(effsize)
# 167 effective sample size

# plot unit level random effects
randoms1 <- REsim(hlm1, n.sims = 500)
plotREsim(randoms1)

hlmy <- lmer(ndmi_mean ~ 1 + treatment + (1+treatment|year), index, REML = F)
tab_model(hlmy)

randoms2 <- REsim(hlmy, n.sims = 500)
plotREsim(randoms2)
