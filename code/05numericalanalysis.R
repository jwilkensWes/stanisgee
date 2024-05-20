## numerical analysis

# packages
library(Kendall)
library(sjPlot)

# data
load("data/cleandata/index_master.Rda")
data(PrecipGL)
PrecipGL

# make time series objects ----

index_year <- indexmas %>% 
  group_by(year, treatment) %>% 
  summarize(mean_ndmi = mean(ndmi_mean),
            mean_ndvi = mean(ndvi_mean))

# filter pre and post
summary(indexmas$treatment_status)
index_pre <- indexmas %>% 
  filter(treatment_status == "Pre-Treatment") %>% 
  group_by(year, treatment) %>% 
  summarize(mean_ndmi = mean(ndmi_mean),
            mean_ndvi = mean(ndvi_mean))
index_post <- indexmas %>% 
  filter(treatment_status == "Post-Treatment") %>% 
  group_by(year, treatment) %>% 
  summarize(mean_ndmi = mean(ndmi_mean),
            mean_ndvi = mean(ndvi_mean))

# filter for treatment type full time period 
index_control <- index_year %>% 
  filter(treatment == "Control")
index_burn <- index_year %>% 
  filter(treatment == "Burn")
index_thin <- index_year %>% 
  filter(treatment == "Thin")
index_thinburn <- index_year %>% 
  filter(treatment == "Thin & Burn")

# filter for treatment type pre time period
index_precontrol <- index_pre %>% 
  filter(treatment == "Control")
index_preburn <- index_pre %>% 
  filter(treatment == "Burn")
index_prethin <- index_pre %>% 
  filter(treatment == "Thin")
index_prethinburn <- index_pre %>% 
  filter(treatment == "Thin & Burn")

# filter for treatment type post time period
index_postcontrol <- index_post %>% 
  filter(treatment == "Control")
index_postburn <- index_post %>% 
  filter(treatment == "Burn")
index_postthin <- index_post %>% 
  filter(treatment == "Thin")
index_postthinburn <- index_post %>% 
  filter(treatment == "Thin & Burn")

# drop unnecessary variables
index_postcontrol$year <- NULL
index_postcontrol$treatment <- NULL
index_postcontrol$mean_ndvi <- NULL

index_postthin$year <- NULL
index_postthin$treatment <- NULL
index_postthin$mean_ndvi <- NULL

index_postthinburn$year <- NULL
index_postthinburn$treatment <- NULL
index_postthinburn$mean_ndvi <- NULL

index_postburn$year <- NULL
index_postburn$treatment <- NULL
index_postburn$mean_ndvi <- NULL


index_prethin$year <- NULL
index_prethin$treatment <- NULL
index_prethin$mean_ndvi <- NULL

index_precontrol$year <- NULL
index_precontrol$treatment <- NULL
index_precontrol$mean_ndvi <- NULL

index_prethinburn$year <- NULL
index_prethinburn$treatment <- NULL
index_prethinburn$mean_ndvi <- NULL

index_preburn$year <- NULL
index_preburn$treatment <- NULL
index_preburn$mean_ndvi <- NULL




# create time series objects
# full
index_cts <- ts(index_control, start = 2008, end = 2022, frequency = 1)
index_bts <- ts(index_burn, start = 2008, end = 2022, frequency = 1)
index_tts <- ts(index_thin, start = 2008, end = 2022, frequency = 1)
index_tbts <- ts(index_thinburn, start = 2008, end = 2022, frequency = 1)
# pre
index_prects <- ts(index_precontrol, start = 2008, end = 2010, frequency = 1)
index_prebts <- ts(index_preburn, start = 2008, end = 2010, frequency = 1)
index_pretts <- ts(index_prethin, start = 2008, end = 2010, frequency = 1)
index_pretbts <- ts(index_prethinburn, start = 2008, end = 2010, frequency = 1)
# post
index_postcts <- ts(index_postcontrol, start = 2014, end = 2022, frequency = 1)
index_postbts <- ts(index_postburn, start = 2014, end = 2022, frequency = 1)
index_posttts <- ts(index_postthin, start = 2014, end = 2022, frequency = 1)
index_posttbts <- ts(index_postthinburn, start = 2014, end = 2022, frequency = 1)


# mann kendall ------

MannKendall(index_cts)
MannKendall(index_bts)
MannKendall(index_tts)
MannKendall(index_tbts)

MannKendall(index_prects)
MannKendall(index_prebts)
MannKendall(index_pretts)
MannKendall(index_pretbts)

MannKendall(index_postcts)
MannKendall(index_postbts)
MannKendall(index_posttts)
md <- MannKendall(index_posttbts)
summary(md)



  plot(index_posttts)
plot(index_postcts)
plot(index_posttbts)

