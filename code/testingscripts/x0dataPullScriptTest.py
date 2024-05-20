# -*- coding: utf-8 -*-
"""
Created on Tue Jun 20 14:46:15 2023

@author: leafTop
"""

## testing script for gee


# Initalize Earth Engine Client

# import earth engine package
import ee
# initialize the library.
ee.Initialize()

# import geetools to facilitate image export
import geetools # may need to install


# Define Collection Parameters

# start of desired collection
startDate = ('2021-06-01')
# end of desired collection
endDate = ('2021-10-31')
# area to be collected
interestArea = ee.FeatureCollection('projects/poulos-gee/assets/Stanislaus_Area_Polygon').geometry()
# naming pattern for eventual output
npattern = 'L8NDWI_{id}' # make sure to update L8 or L7 based on year


## Image Collection

# pull full image collection and sort by desired dats
ndwicol = ee.ImageCollection('LANDSAT/LC08/C01/T1_8DAY_NDWI').filter(ee.Filter.date(startDate, endDate))


## Image Export

# send an export task to google earth engine and save files in image collection to google drive
task = geetools.batch.Export.imagecollection.toDrive(collection = ndwicol,
                                                     folder = 'stan', # make sure to rename folder 
                                                     region = interestArea,
                                                     namePattern = npattern,
                                                     scale = 30,
                                                     crs = 'EPSG:4326',
                                                     fileFormat = 'GeoTIFF')