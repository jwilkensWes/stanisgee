Adaptive Mangement Effects on Drought Reslience in the Stanislaus National Forest


Start Date: June 2nd 2023
End Date: July 24th


Description:
In 2011 Eric Knapp and fellows in the Forest Service conducted thinning and burning treatments on an area of the Stanislaus National Forest. This project aims to analyze the effects of these different treatments on drought resiliency and forest health using Landsat 7 and 8 imagry over a wide time period(2006-2022).


Software, Languages, and Packages used
Google Earth Engine
Anaconda Navigator
Rstudio
jupyterLab

Python
->earthengine-api
R
->tidyverse
->qacBase
->GGally
->ggplot2


** This project intially used the canned NDWI product from Google Earth Engine as its primary data source but was changed about halfway through to the Surface Reflectance Data from Landsat inorder to calculate more indexes. All data and code made for the orginial GEE NDWI data source have been moved to folders called "old"


Code:
Note that scripts and notebooks denoted by 00, 01, etc are the finished code for this project. 
The old folder contains code used for the old data


Data:
rawdata:

old/augustfiles:
 contains a selection of imagry from August over many years. Used for intial 	exploration and proof of concept
old/ndwi:
 contains the raw ndwi imagry downloaded using 01DataCollection
old/zonalstats:
 contains the zonal statistics produced by batch process in QGIS
studypolygons:
 contains shapefiles of the study area in Stanislaus National Forest.
index collection:
 cotains collection of indexs made using 01multiIndexDataCollection

cleandata:
old:
contains aggregated and cleaned zonal statistic data made from old ndwi data




Contibutors:
Dr. Helen Poulos
Johnny Wilkens


Project Timeline:
June 2nd Project Start
Set up GEE client and Python API
Pull 2019-2021 Data and compare with Ecostress data
	Generate Zonal Statistics for 2019-2021 data
	Linear Mixed Models for data
Pull Full Record
	zonal and mixed models
June 26th
 Reorient to use surface reflectance and calculated multiple indexes
July 12th
 Multi index dataset collected and ready for analysis
Poster


Citations
Imagry Courtsey of US Geological Survey
