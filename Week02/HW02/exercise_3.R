##-----------------------------------------------##
##    Author: Adela Sobotkova                    ##
##    Institute of Culture and Society           ##
##    Aarhus University, Aarhus, Denmark         ##
##    adela@cas.au.dk                             ##
##-----------------------------------------------##

#### Goals ####

# - Learn about Classification methods

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

# We will use a single data set:  `nz`. It is contained by the libraries
# It is an sf object with polygons representing the 16 regions of New Zealand.

#### Existing code ####

# Here are some examples of plotting population in  New Zealand.
# Your role is to create a map based on the suggestions below, 
# selecting the most meaningful classification style.

# Look at NZ population distribution
hist(nz$Population)

# This line of code applies the 'pretty' style rounding legend numbers. Try different numbers of classes.
pretty <- tm_shape(nz) + tm_polygons(col = "Population", style = "pretty", n = 4)

# "Jenks" style further smooths over the gaps
jenks <- tm_shape(nz) + tm_polygons(col = "Population", style = "jenks", n = 5)

# quantile style divides into 5 even groups
quantile <- tm_shape(nz) + tm_polygons(col = "Population", style = "quantile", n=5)

# Equal interval style divides the distribution into even groups
equal <- tm_shape(nz) + tm_polygons(col = "Population", style = "equal", n = 5)

# Write maps above to objects and plot them side by side 
# with tmap_arrange() for better comparison
tmap_arrange(pretty,jenks,quantile,equal)


#### Exercise I ####

# 1. What are the advantages and disadvantages of each classification method?
# 2. Choose the best classification and create a map with easily legible legend and all other essentials.
# (Select a suitable color palette from http://colorbrewer2.org/, north arrow, scale, map title, 
# legend title, reasonable number of breaks in the classification )
# 3. Which method and how many classes did you end up using to display
# your data? Why did you select that method?
# 4. What principles did you use in arranging the parts of your map layout the way you
# did and how did you apply these principles?

# Your solution

# /Start Code/ #
# 1.
pretty
# Pretty: A clear disadvantage here is that it does not manage to show the granularity of the population of New Zealand.
# An advantage is that the different legend divisions are easy to distinguish, and is linear.

jenks
# Jenks: Manages to show the granularity of the population as it nicely shows the distribution across New Zealand.
# However, as the legend is not linear, it difficult to assess the different location-percentages of the population.

quantile
# Quantile: Again - high granularity, but not as much as 'jenks'. It rates a lot of the areas as highly populated.
# Does however, manage to give a better view at the distribution than the 'pretty' style.

equal
# Equal: Manages to spread the distribution "equally" out, but it loses a lot of the granularity of the population.
# In that way it is very similar to 'pretty'

# 2.
  tm_shape(nz)  + 
    tm_polygons(col = "Population", 
                style = "jenks", 
                n = 8) + 
    tm_scale_bar(breaks = c(0, 50, 150, 300),
               text.size = 1,
               position = c("RIGHT", "bottom")) +
  tm_compass(position = c("RIGHT", "top"),
             type = "radar", 
             size = 2) +
  tm_credits(position = c("LEFT", "bottom"),
             text = "M. Højmark-Bertelsen, 20210209",
             size = 0.6) +
  tm_layout(main.title = "New Zealand",
            bg.color = "lightblue",
            inner.margins = c(0.08, 0, 0, 0),
            legend.position = c("left", "top"))
  
# 3. 
# I ended up with 'jenks' and i chose 8 classes, as i think that this divides the map nicely into different areas, and it is clear to see, where the majority of the population resides.

# 4. 
# I chose a lightblue background color to get that old school water feeling, and I tried to create a scalebar easy to use, when measuring distance. 
# /End Code/ #