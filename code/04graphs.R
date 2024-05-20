## Analysis

# packages
library(tidyverse)
library(ggpubr)
library(vistime)

# data
load("data/cleandata/index_master.Rda")
load("data/cleandata/drought_master.Rda")

# graphs 

# drought graph
dt <- indexmas %>% 
  group_by(year)
  

dt
ggplot(dt) +
  geom_bar(aes(year, fill = drought))

# timeline of events
timeline <- data.frame(
  id      = 1:11,
  event   = c("Moderate Drought", "Abnormally Dry", "Normal Moisture", "Moderate Drought", "Severe Drought", "Extreme Drought", "Normal Moisture", "Abnormally Dry", "Normal Moisture", "Moderate Drought", "Extreme Drought"),
  start   = c("2008-01-01"      , "2009-01-01"    , "2010-01-01"     , "2012-01-01"      , "2013-01-01"    , "2014-01-01"     , "2017-01-01"     , "2018-01-01"    , "2019-01-01"     , "2020-01-01"      , "2021-01-01"),
  end     = c("2009-01-01"      , "2010-01-01"    , "2012-01-01"     , "2013-01-01"      , "2014-01-01"    , "2017-01-01"     , "2018-01-01"     , "2019-01-01"    , "2020-01-01"     , "2021-01-01"      , "2023-01-01")
)

gg_vistime(timeline) +
  theme(axis.text.x = element_text(angle=90, color='blue4',size=14))

g <- gg_vistime(timeline, col.event="event", col.start="start", col.end="end") + 
  theme(axis.text.x = element_text(angle=90, color='blue4',size=14) )

g.d <- ggplot_build(g)

g.d$data[[4]]$angle <- 90

rebuilt <- ggplot_gtable(g.d)

png(filename="img/timeline.png", width=240, height=960)
plot(rebuilt)
dev.off()

# full time period line chart
index_year <- indexmas %>% 
  group_by(year, treatment) %>% 
  summarize(mean_ndmi = mean(ndmi_mean),
            mean_ndvi = mean(ndvi_mean),
            mean_ndwi = mean(ndwi_mean))
# ndmi
yearlp <- ggplot(index_year, aes(x = year, y = mean_ndvi, color = treatment)) +
  geom_line()+
  theme_minimal()
yearlp
# ndvi
ggplot(index_year, aes(x = year, y = mean_ndvi, color = treatment)) +
  geom_line() +
  theme_minimal()

# month charts
index_month <- indexmas %>% 
  mutate(month = month(date)) %>% 
  group_by(year, month, treatment) %>% 
  summarize(mean_ndmi = mean(ndmi_mean),
            mean_ndvi = mean(ndvi_mean),
            mean_ndwi = mean(ndwi_mean))
index_july <- index_month %>% 
  filter(month == 7)
index_august <- index_month %>% 
  filter(month == 8)
index_september <- index_month %>% 
  filter(month == 9)
julylp <- ggplot(index_july, aes(x = year, y = mean_ndmi, color = treatment)) +
  geom_line()+
  theme_minimal()
auglp <- ggplot(index_august, aes(x = year, y = mean_ndmi, color = treatment)) +
  geom_line()+
  theme_minimal()
seplp <- ggplot(index_september, aes(x = year, y = mean_ndmi, color = treatment)) +
  geom_line()+
  theme_minimal()

# combine graphs
ggarrange(yearlp, julylp, auglp, seplp,
          nrow = 4,
          labels = c("Yearly Average", "July Average", "August Average", "September Average"))


# pre treatment
index_pre <- indexmas %>% 
  filter(year < 2011)

index_pre <- index_pre %>% 
  group_by(year, treatment) %>% 
  summarize(mean_ndmi = mean(ndmi_mean),
            mean_ndvi = mean(ndvi_mean),
            mean_ndwi = mean(ndwi_mean))

ggplot(index_pre, aes(x = year, y = mean_ndmi, color = treatment)) +
  geom_line()+
  theme_minimal()

#post treatment
index_post <- indexmas %>% 
  filter(year > 2012)

index_post <- index_post %>% 
  group_by(year, treatment) %>% 
  summarize(mean_ndmi = mean(ndmi_mean),
            mean_ndvi = mean(ndvi_mean),
            mean_ndwi = mean(ndwi_mean))

ggplot(index_post, aes(x = year, y = mean_ndmi, color = treatment)) +
  geom_line()+
  theme_minimal()

# bar chart of post treatment mean segregated by year
index_post <- indexmas %>% 
  filter(treatment_status == "Post-Treatment")

ggplot(data=index_post)+
  stat_summary(aes(x=year, fill=treatment, y=ndvi_mean),
               fun="mean", geom="bar", position="dodge", alpha=0.8)+
  ylab("ndmi mean")




# point + smooth charts
summary(indexmas$treatment)
## notes for future: try method = lm for pre and post graphs
# full time period
index <- indexmas %>% 
  group_by(date, treatment) %>% 
  summarize(mean_ndmi = mean(ndmi_mean),
            mean_ndvi = mean(ndvi_mean))
ndmi_facet_full <- ggplot(index, aes(date, mean_ndmi, color = treatment))+
  geom_point() +
  geom_smooth() +
  theme_minimal() +
  facet_wrap(~treatment) +
  labs(title = "NDMI Full Data Period")
ndvi_facet_full <- ggplot(index, aes(date, mean_ndvi, color = treatment))+
  geom_point() +
  geom_smooth() +
  theme_minimal() +
  facet_wrap(~treatment) +
  labs(title = "NDVI Full Data Period")

# post treatment
index_post <- indexmas %>% 
  filter(treatment_status == "Post-Treatment")
index_post <- index_post %>% 
  group_by(date, treatment) %>% 
  summarize(mean_ndmi = mean(ndmi_mean),
            mean_ndvi = mean(ndvi_mean))
ndmi_facet_post <- ggplot(index_post, aes(date, mean_ndmi, color = treatment))+
  geom_point() +
  geom_smooth() +
  theme_minimal() + 
  facet_wrap(~treatment) +
  labs(title = "NDMI Post-Treatment")
ndmi_facet_post_lm <- ggplot(index_post, aes(date, mean_ndmi, color = treatment))+
  geom_point() +
  geom_smooth(method = lm) +
  theme_minimal() + 
  facet_wrap(~treatment) +
  labs(title = "NDMI Post-Treatment LM")
ndvi_facet_post <- ggplot(index_post, aes(date, mean_ndvi, color = treatment))+
  geom_point() +
  geom_smooth() +
  theme_minimal() + 
  facet_wrap(~treatment) +
  labs(title = "NDVI Post-Treatment")
ndvi_facet_post_lm <- ggplot(index_post, aes(date, mean_ndvi, color = treatment))+
  geom_point() +
  geom_smooth(method = lm) +
  theme_minimal() + 
  facet_wrap(~treatment) +
  labs(title = "NDVI Post-Treatment LM")

# pre treatment
index_pre <- indexmas %>% 
  filter(treatment_status == "Pre-Treatment")
index_pre <- index_pre %>% 
  group_by(date, treatment) %>% 
  summarize(mean_ndmi = mean(ndmi_mean),
            mean_ndvi = mean(ndvi_mean))
ndmi_facet_pre <- ggplot(index_pre, aes(date, mean_ndmi, color = treatment))+
  geom_point() +
  geom_smooth() +
  theme_minimal() + 
  facet_wrap(~treatment) +
  labs(title = "NDMI Pre-Treatment")
ndmi_facet_pre_lm <- ggplot(index_pre, aes(date, mean_ndmi, color = treatment))+
  geom_point() +
  geom_smooth(method = lm) +
  theme_minimal() + 
  facet_wrap(~treatment) +
  labs(title = "NDMI Pre-Treatment LM")
ndvi_facet_pre <- ggplot(index_pre, aes(date, mean_ndvi, color = treatment))+
  geom_point() +
  geom_smooth() +
  theme_minimal() + 
  facet_wrap(~treatment) +
  labs(title = "NDVI Pre-Treatment")
ndvi_facet_pre_lm <- ggplot(index_pre, aes(date, mean_ndvi, color = treatment))+
  geom_point() +
  geom_smooth(method = lm) +
  theme_minimal() + 
  facet_wrap(~treatment) +
  labs(title = "NDVI Pre-Treatment LM")




# graphs
ndmi_facet_full
ndmi_facet_pre
ndmi_facet_post
ndmi_facet_post_lm
ndmi_facet_pre_lm

ndvi_facet_full
ndvi_facet_pre
ndvi_facet_post
ndvi_facet_post_lm
ndvi_facet_pre_lm


# drought stuff
# helpful colors
cbbPalette <- c("#000000", "#E69F00", "#56B4E9", "#009E73", "#F0E442", "#0072B2", "#D55E00", "#CC79A7")
index_drought <- indexmas %>% 
  group_by(date, treatment, drought) %>% 
  summarize(mean_ndmi = mean(ndmi_mean),
            mean_ndvi = mean(ndvi_mean))
ndmi_facet_drought <- ggplot(index_drought, aes(date, mean_ndmi, color = drought))+
  geom_point()+
  scale_colour_manual(values=cbbPalette) +
  theme_minimal() +
  facet_wrap(~treatment)+
  labs(title = "NDMI Full Period Drought Visualized")
ndvi_facet_drought <- ggplot(index_drought, aes(date, mean_ndvi, color = drought))+
  geom_point()+
  scale_colour_manual(values=cbbPalette) +
  theme_minimal() +
  facet_wrap(~treatment)+
  labs(title = "NDVI Full Period Drought Visualized")
ndmi_facet_drought
ndvi_facet_drought



# big one
index_full <- indexmas %>%
  group_by(year, treatment, treatment_status, drought) %>% 
  summarize(mean_ndmi = mean(ndmi_mean),
            mean_ndvi = mean(ndvi_mean))

ndmi_full <- ggplot(index_full) +
  geom_line(aes(year, mean_ndmi, color = treatment), linewidth = 2) +
  scale_shape_manual(name = "Treatment Type", values=c(15, 16, 17, 18)) +
  scale_color_discrete(name = "Treatment Type") +
  geom_point(aes(year, mean_ndmi, color = treatment, shape=treatment), size = 5) +
  scale_x_continuous(breaks = seq(2008,2022,1)) +
  geom_vline(xintercept = c(2011, 2013), linetype="dotted", size = 1) +
  geom_text(aes(x = 2008.5, y = .192, label = "Pre-Treatment")) +
  geom_text(aes(x = 2018, y = .19, label = "Post-Treatment")) +
  geom_segment(aes(x = 2011, y = .16, xend = 2006.5, yend = .16),
               arrow = arrow(length = unit(0.5, "cm"))) +
  geom_segment(aes(x = 2013, y = .16, xend = 2022, yend = .16),
               arrow = arrow(length = unit(0.5, "cm"))) +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = -30)) +
  xlab("Year") +
  ylab("Mean NDMI") +
  labs(title = "NDMI Average by Year", subtitle = "Moisture Content")

ndmi_full



ndvi_full <- ggplot(index_full) +
  geom_line(aes(year, mean_ndvi, color = treatment), linewidth = 2) +
  scale_shape_manual(name = "Treatment Type", values=c(15, 16, 17, 18)) +
  scale_color_discrete(name = "Treatment Type") +
  geom_point(aes(year, mean_ndvi, color = treatment, shape=treatment), size = 5) +
  scale_x_continuous(breaks = seq(2008,2022,1)) +
  geom_vline(xintercept = c(2011, 2013), linetype="dotted", size = 1) +
  geom_text(aes(x = 2008.5, y = .262, label = "Pre-Treatment")) +
  geom_text(aes(x = 2018, y = .262, label = "Post-Treatment")) +
  geom_segment(aes(x = 2011, y = .265, xend = 2006.5, yend = .265),
               arrow = arrow(length = unit(0.5, "cm"))) +
  geom_segment(aes(x = 2013, y = .265, xend = 2022, yend = .265),
               arrow = arrow(length = unit(0.5, "cm"))) +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = -30)) +
  xlab("Year") +
  ylab("Mean NDVI") +
  labs(title = "NDVI Average by Year", subtitle = "Vegetation Health")
ndvi_full

# combine
ggarrange(ndmi_full, ndvi_full, nrow = 2)


# trend analysis

# pre
index_pre <- indexmas %>% 
  filter(treatment_status == "Pre-Treatment")
index_pre <- index_pre %>% 
  group_by(date, treatment) %>% 
  summarize(mean_ndmi = mean(ndmi_mean),
            mean_ndvi = mean(ndvi_mean))
ndmi_pre_lm <- ggplot(index_pre, aes(date, mean_ndmi, color = treatment))+
  geom_point() +
  scale_color_discrete(name = "Treatment Type") +
  geom_smooth(method = lm) +
  theme_minimal() + 
  labs(title = "NDMI Pre-Treatment") +
  ylab("Mean NDMI") +
  xlab("Date")

# post treatment
index_post <- indexmas %>% 
  filter(treatment_status == "Post-Treatment")
index_post <- index_post %>% 
  group_by(date, treatment) %>% 
  summarize(mean_ndmi = mean(ndmi_mean),
            mean_ndvi = mean(ndvi_mean))
ndmi_post_lm <- ggplot(index_post, aes(date, mean_ndmi, color = treatment))+
  geom_point() +
  scale_color_discrete(name = "Treatment Type") +
  geom_smooth(method = lm) +
  theme_minimal() + 
  labs(title = "NDMI Post-Treatment") +
  ylab("Mean NDMI") +
  xlab("Date")
ndmi_pre_lm
ndmi_post_lm





## potential drought stuff
dt <- ggplot(index_full) +
  geom_raster(aes(year, fill = drought))+
  theme_minimal()
dt


ggarrange(ndmi_full, dt)





