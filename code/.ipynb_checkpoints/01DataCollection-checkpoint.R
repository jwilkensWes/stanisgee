## dataset collection

# load packages and check install
library(reticulate)
library(rgee)
ee_check()

# authenticate
ee_Initialize()

# data collection 2015
dd <- ee$ImageCollection('LANDSAT/LC08/C01/T1_8DAY_NDWI')$filterDate('2015-05-01', '2015-06-01')
ee_print(dataset)


