Task 1: Analyze burial mound health
-----------------------------------

### Loading packages

``` r
pacman::p_load(sf, raster, tidyverse, tmap)
```

Are robbers megalophobes?
-------------------------

Megalophobia is the fear of large objects, and it is therefore
interesting to investigate if this fear is something that robbers suffer
from, or if they on the contrary are fascinated by big stuff. This
initial analysis will thus see if mound height correlates with it being
robbed

``` r
mounds <- read_csv('data/KAZ_mdata.csv')  # Loading data
```

    ## 
    ## -- Column specification --------------------------------------------------------
    ## cols(
    ##   MoundID = col_double(),
    ##   Condition = col_double(),
    ##   Robbed = col_double(),
    ##   Height = col_double(),
    ##   LandUse = col_character()
    ## )

``` r
mounds <- na.omit(mounds)  # Removing NAs
mounds$Robbed <- as_factor(mounds$Robbed)  # Refactoring 'Robbed' column
```

### Exploring the data

First we need to see how the data looks:

``` r
summary(mounds)  # Summary
```

    ##     MoundID       Condition     Robbed      Height         LandUse         
    ##  Min.   :1000   Min.   :1.000   0:366   Min.   : 0.000   Length:760        
    ##  1st Qu.:3073   1st Qu.:2.000   1:394   1st Qu.: 0.400   Class :character  
    ##  Median :3322   Median :2.000           Median : 0.800   Mode  :character  
    ##  Mean   :3141   Mean   :2.618           Mean   : 1.761                     
    ##  3rd Qu.:3608   3rd Qu.:3.000           3rd Qu.: 2.000                     
    ##  Max.   :5008   Max.   :5.000           Max.   :20.000

Of interesting things in this data summary we can see that there are
approximately an equal number of mounds that was robbed and not robbed.
Furthermore the mean height of mounds is 1.761 with the tallest being at
20 and the lowest being at 0.

### Plotting the data

To get an easy look into the tendency between mound height and it being
robbed we can plot a boxplot.

``` r
# Calculating correlation
boxplot_robbed <- mounds %>% ggplot(aes(Robbed, Height))+
  geom_boxplot()+
  scale_x_discrete(labels = c("Not Robbed", "Robbed"))  # Changing X-labels
boxplot_robbed  # Plotting
```

![](Week05_mhb_files/figure-markdown_github/plotting%20data-1.png) It
seems that there is a tendency, namely, that robbed mounds are often
taller but further statistical analysis is needed.

### Statistical analysis

``` r
summary(glm(Robbed ~ Height, data = mounds, family = binomial))  # Statistical analysis
```

    ## 
    ## Call:
    ## glm(formula = Robbed ~ Height, family = binomial, data = mounds)
    ## 
    ## Deviance Residuals: 
    ##     Min       1Q   Median       3Q      Max  
    ## -4.5230  -0.9862   0.2270   1.1091   1.5043  
    ## 
    ## Coefficients:
    ##             Estimate Std. Error z value Pr(>|z|)    
    ## (Intercept) -0.74213    0.10655  -6.965 3.29e-12 ***
    ## Height       0.54855    0.05888   9.316  < 2e-16 ***
    ## ---
    ## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
    ## 
    ## (Dispersion parameter for binomial family taken to be 1)
    ## 
    ##     Null deviance: 1052.6  on 759  degrees of freedom
    ## Residual deviance:  917.2  on 758  degrees of freedom
    ## AIC: 921.2
    ## 
    ## Number of Fisher Scoring iterations: 5

As can be seen the p-value is significant and with β = 0.55 (SE = 0.06),
z = 9.32, p \< .05, it can be said that robbed mounds are on average
0.55 taller than non-robbed mounds. The results could therefore
probably, assumably, indicate that robbers might not suffer from
megalophobia, and instead might be intruiged by big stuff.

**Robber sees big temple = Robber robs**

Are robbers lazy?
-----------------

It is easy to understand and sympathesize with robbers not wanting to
climb large mountains or similar obstacles just to get a proper loot. It
is therefore interesting to see whether there is a correlation between
the elevation of a mound and it being robbed. If so it could indicate
that robbers are lazy.

### Preprocessing and visualizing the data

``` r
mounds_shp <- st_read('data/KAZ_mounds.shp')  # Loading shape data
```

    ## Reading layer `KAZ_mounds' from data source `C:\Users\z6hjb\OneDrive - KMD\projects\UNI\spatial_analytics_cds\Week05\HW05\data\KAZ_mounds.shp' using driver `ESRI Shapefile'
    ## Simple feature collection with 773 features and 5 fields
    ## geometry type:  POINT
    ## dimension:      XY
    ## bbox:           xmin: 352481.3 ymin: 4712325 xmax: 371282.4 ymax: 4730029
    ## projected CRS:  WGS 84 / UTM zone 35N

``` r
mounds <- left_join(mounds_shp, mounds, by = c('TRAP_Code' = 'MoundID'))  # Joining the data with equal identity columns

aster <- raster('data/Aster.tif')  # Loading raster data
aster <- reclassify(aster, cbind(-Inf, 0, NA), right = FALSE)  # Removing NAs

# Assert identical rasters
mounds_crs <- str_split(crs(mounds), ' ')[[1]][3]
aster_crs <- str_split(crs(aster), ' ')[[1]][3]
identical(mounds_crs, aster_crs)  # TRUE
```

    ## [1] TRUE

``` r
mounds_area <- crop(aster, st_bbox(mounds))  # Cropping the area of the mounds from the aster raster file

tm_shape(mounds_area)+
    tm_raster(style="cont")+  # Plotting with continous raster
tm_shape(mounds)+ 
    tm_dots()+
    tm_layout(title = 'Elevation of the mounds',
        title.position = c('right', 'bottom'),
        legend.position = c('left', 'bottom'))  # Plotting the mounds and the respective elevations
```

![](Week05_mhb_files/figure-markdown_github/loading,%20preprocessing%20and%20visualizing%20data-1.png)
It does not seem that there is much of a difference, but yet again, we
will turn to statistical methods.

### Preprocessing data for statistics

``` r
elevation <- raster::extract(mounds_area, mounds)  # Extracting elevation from the raster data
mounds$Elevation <- elevation  # Creating elevation column
mounds <- na.omit(mounds)  # Removing NAs
```

### Plotting data

``` r
boxplot_robbed <- mounds %>% ggplot(aes(Robbed, Elevation))+
  geom_boxplot()+
  scale_x_discrete(labels = c("Not Robbed", "Robbed"))  # Changing X-labels
boxplot_robbed  # Plotting
```

![](Week05_mhb_files/figure-markdown_github/plotting%20elevation%20data-1.png)
It is not easy to assess the laziness of robbers from this boxplot. But
it does seem that the mean elevation is slightly lower on robbed mounds.
We will now employ mystical GLM magic to create better inference.

### Statistical analysis

``` r
summary(glm(Robbed ~ Elevation, data = mounds, family = binomial))  # Statistical analysis
```

    ## 
    ## Call:
    ## glm(formula = Robbed ~ Elevation, family = binomial, data = mounds)
    ## 
    ## Deviance Residuals: 
    ##     Min       1Q   Median       3Q      Max  
    ## -1.4979  -1.1744   0.9086   1.1512   1.4169  
    ## 
    ## Coefficients:
    ##              Estimate Std. Error z value Pr(>|z|)    
    ## (Intercept)  2.850988   0.832563   3.424 0.000616 ***
    ## Elevation   -0.006281   0.001872  -3.355 0.000794 ***
    ## ---
    ## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
    ## 
    ## (Dispersion parameter for binomial family taken to be 1)
    ## 
    ##     Null deviance: 1051.2  on 758  degrees of freedom
    ## Residual deviance: 1039.6  on 757  degrees of freedom
    ## AIC: 1043.6
    ## 
    ## Number of Fisher Scoring iterations: 4

As can be seen the p-value is significant and with β = -0.006 (SE =
0.002), z = -3.36, p \< .05. It can, therefore, possibly be said that
robbed mounds are on average located 0.006 (meters?) lower than non
robbed taller than non-robbed mounds. The results could therefore
probably, assumably, indicate that robbers might be lazy. Question mark?

**Robbers are lazy ass bad people**
