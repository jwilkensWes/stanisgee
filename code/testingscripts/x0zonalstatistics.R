## zonal statistics calculations in r
  # inputs: folder of tif files for a single year of ndwi observations
  #         filepath of shapefile polygon to do zonal statistics over
  # outputs: dataframe of zonal statistics 
  # make sure to create function first before input

# input parameters
raster_folder <- "C:\\Users\\leafTop\\Documents\\School Documents\\QAC Summer Apprenticeship\\stanisgee\\data\\rawdata\\ndwi\\2019"
shapefile_path <- "C:\\Users\\leafTop\\Documents\\School Documents\\QAC Summer Apprenticeship\\stanisgee\\data\\rawdata\\study polygons\\Variable Density Study"

# create  zonal stats function
ndwi_zonal_stats <- function(raster_folder, shapefile_path){
  # packages
  library(tidyverse)
  library(terra)
  
  # initialize dataframe
  output_file <- data.frame()
  
  # import necessary files
  # import shapefile
  stanpoly <- vect(shapefile_path)
  # create an id column
  stanpoly[["ID"]] <- 1:nrow(stanpoly)
  
  # get list of tif files
  setwd(raster_folder)
  tifs <- list.files(pattern = "*.tif")
  tifs <- grep("aux.xml", tifs, value = TRUE, invert = TRUE)
  
  # iterate over tifs
  for(file in tifs){
    # import raster layer
    stanrast <- rast(paste(getwd(), "\\", file, sep = ""))
    # convert shapefile crs to raster crs
    stanpoly <- project(stanpoly, crs(stanrast))
    
    
    # extract values from raster by the shapefile
    
    zmean <- terra::extract(stanrast, stanpoly, fun = mean) # mean
    zmean$ndwi_mean <- zmean$NDWI
    zmean$NDWI <- NULL
    zmedian <- terra::extract(stanrast, stanpoly, fun = median) # median
    zmedian$ndwi_median <- zmedian$NDWI
    zmedian$NDWI <- NULL
    zsum <- terra::extract(stanrast, stanpoly, fun = sum) # sum
    zsum$ndwi_sum <- zsum$NDWI
    zsum$NDWI <- NULL
    
    
    # combine into one dataframe
    
    # create ID values
    zonal <- values(stanpoly)
    zonal <- zonal %>% 
      full_join(zmean, by = "ID") %>% 
      full_join(zmedian, by = "ID") %>% 
      full_join(zsum, by = "ID")
    
    # create date variables
    date <- str_sub(file,
                    start = str_locate(file, "_")[1]+1,
                    end = nchar(file)-4)
    date <- ymd(date)
    zonal <- zonal %>% 
      mutate(year = year(date), 
             month = month(date), 
             day = day(date))
    
    # add to master data frame
    output_file <- bind_rows(output_file, zonal)
  }
  return(output_file)
}

# run function
zs2019 <- ndwi_zonal_stats(raster_folder, shapefile_path)
zs2020




