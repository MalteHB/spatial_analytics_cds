##-----------------------------------------------##
##    Author: Adela Sobotkova                    ##
##    Institute of Culture and Society           ##
##    Aarhus University, Aarhus, Denmark         ##
##    adela@cas.au.dk                             ##
##-----------------------------------------------##

#### Goals ####

# - Limit your data into an area of interest
# - Create a new map

# We highlighted all parts of the R script in which you are supposed to add your
# own code with: 

# /Start Code/ #

print("Hello World") # This would be your code contribution

# /End Code/ #

#### Required R libraries ####

# We will use the sf, raster, and tmap packages.
# Additionally, we will use the spData and spDataLarge packages that provide new datasets. 
# These packages have been preloaded to the worker2 workspace.

library(sf)
library(raster)
library(tmap)
library(spData)
library(spDataLarge)

#### Data sets #### 

# We will use two data sets: `srtm` and `zion`.
# The first one is an elevation raster object for the Zion National Park area, and the second one is an sf object with polygons representing borders of the Zion National Park.

srtm <- raster(system.file("raster/srtm.tif", package = "spDataLarge"))
zion <- read_sf(system.file("vector/zion.gpkg", package = "spDataLarge"))

# Additionally, the last exercise (IV) will used the masked version of the `lc_data` dataset.

study_area <- read_sf("data/study_area.gpkg")
lc_data <- raster("data/example_landscape.tif")
lc_data_masked <- mask(crop(lc_data, study_area), study_area)

# The exercises below represent a continuation of exercise 2 from Week 02

#### Exercise III ####

# 1. Use the `zion` and `srtm2` objects.
# Crop and mask the `srtm2` object to the borders of the `zion` object.

# Your solution

# /Start Code/ #
zion_crs <- crs(zion, asText = TRUE) # Get the CRS.
srtm2 <- projectRaster(srtm, crs = zion_crs) # Project 'srtm' to the CRS of 'zion'.
plot(srtm2)
tm_shape(srtm2)  + # Load the raster data
  tm_raster(title = "Elevation \n(MASL)", 
            style = "cont",
            palette = "-Greens", 
            breaks = c(1000, 1500, 2000, 2500, 3000) # Define the breaks of the legend
  ) +
  tm_shape(zion) + # Load the vector data
  tm_polygons(alpha = 0.05, # Using polygons to get transparency
              lwd = 1,
              border.col = "black") +
  tm_scale_bar(breaks = c(0, 2.5, 5, 10, 20),
               text.size = 1,
               position = c("LEFT", "bottom")) +
  tm_compass(position = c("RIGHT", "top"),
             type = "radar", 
             size = 2) +
  tm_credits(position = c("LEFT", "bottom"),
             text = "M. Højmark-Bertelsen, 20210209",
             size = 0.8) +
  tm_layout(main.title = "Zion National Park Area",
            bg.color = "lightblue",
            inner.margins = c(0.08, 0, 0, 0),
            legend.position = c("right", "top")) # Changing legend position.
# /End Code/ #


#### Exercise IV ####

# 1. Create a new map of the `lc_data_masked` dataset.
# 2. Save the obtained map to a new file "LC_YOURNAME.png".

# Your solution

# /Start Code/ #



# /End Code/ #




