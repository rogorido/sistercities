---
title: Analyzing data with R and ggplot2
authors:
- Igor Sosa Mayor 
date: 2018-03-15
reviewers:
- 
layout: default
difficulty: 2
---


# Introduction and lesson goals 

Getting data and analyzing them is one of the most important tasks a historian has to face. Data are nowadays becoming omnipresent, but it
is not always easy to know how to extract them from the different
places we can find them on/in the web. In the last years the so-called
*semantic web* has been developped. The idea behind it is to
categorise concepts and data and, above all, put all them in
relationship. Once you have the data you can analyze them and plot
them with R. 

By the end of this lesson you will be able:

1. to extract data from wikidata using the query language SPARQL,
2. to import the extracted data into R,
3. to plot the data using the package ggplot2,
4. to plot the data in maps with ggplot2.

# Maps 

Representing geographical information is becoming increasingly useful and demanded. In the opensource world you can find several rich programs to deal with geographical information (both creating maps and making geostatistical analysis) [QGIS](http://www.qgis.org/), [gvSIG](http://www.gvsig.com/), [GRASS](https://grass.osgeo.org/), and also R. As for R, you can find a very informative site about spatial methods [here](https://cran.r-project.org/web/views/Spatial.html).

As always in R, there are several ways to create maps. You can use:
the ggplot2 package which is the method we will learn here. But there are also the very powerful
package [sp](https://cran.r-project.org/web/packages/sp/index.html). New packages are also
being developed, such
as [cartography](https://github.com/Groupe-ElementR/cartography) and [tmap](https://cran.r-project.org/web/packages/tmap/vignettes/tmap-nutshell.html) to create thematic. Honestly speaking, this richness implies also some complications, since every package has its own syntax and its own specifities. In the present lesson we will stick with ggplot2, but I encourage you to make experiments with other packages, such as the very promising new packages `cartography` or `tmap`.

Spatial information can be stored in a huge variety of formats ([shapefiles](https://en.wikipedia.org/wiki/Shapefile), [raster data](https://en.wikipedia.org/wiki/Raster_graphics), etc.). In order to deal with spatial data in R, the packages [`rgeos`](https://cran.r-project.org/web/packages/rgeos/index.html) and [`rgdal`](https://cran.r-project.org/web/packages/rgdal/index.html) are very convenient, since they enable us to read a wide range of these formats. We install and load them so:
```{r}
install.packages(c("rgeos", "rgdal"))
```
While the possibilities of presenting spatial information are manifold, we will restrict us in the present lesson to a basic example of create a map with the city data we have collected. I will  stress the fact that creating maps with ggplot2 follows exactly the same principles we have seen so far for other graphs created with ggplot2. 


## Points 

We will begin with a simple map. We want to see a map in which some simple information is conveyed: where are the bulgarian cities which have sister Cities. The most simple way to do this is to show a point for every city. But first we need to get a map to operate with. There are several open sources to get maps. For political or administrative maps of countries you can use [GADM](http://gadm.org/) where you will find maps in different formats for every land of the world. We will [download the map for Bulgaria](http://gadm.org/country) as shapefile (there is also a format for R and its package `sp`, but we will not use it). You get a zip file with the name `BGR_adm_shp.zip`. After unzipping it, you will get a lot of files, but we are interested only in the `BGR_adm1` files (`BGR_adm1_shp`, `BGR_adm1_dbf`, etc.), which represent Bulgaria and its provinces. You also can find the files [here](maps/).

Now we will create the map. First of all, we have to read the spatial data, then we read again the data about the german cities (we could also filter our dataframe `eudata`) and finally we make the plot. 
```{r}
library(rgdal)

# we put the shapefile into a variable 
bulgaria.map <- readOGR("BGR_adm1.shp") # change the path accordingly

# we get the data of the bulgarian cities again
bulgaria.cities <- read.csv("data/bulgaria.tsv", header = T, sep = "\t")

# we plot the map
ggplot() +
      geom_polygon(data = bulgaria.map, aes(x = long, y = lat, group = group), fill="grey80") +
      geom_point(data = bulgaria.cities, aes(x = originlong, y = originlat), color = "red") +
      coord_map() +
      theme_light()
```

![plot19](images/plot19.png)

Following aspects are relevant here: 
  * we read the spatial data with the function `readOGR()` of the package `rgdal` which is a kind of swiss knife, since it reads a lot of spatial formats, 
  * we create a complete void ggplot with `ggplot()` and add to it different layers, 
  * as you see the first layer is a new `geom` of ggplot2: [`geom_polygon()`](http://ggplot2.tidyverse.org/reference/geom_polygon.html) which permits us to plot spatial data; and we pass to it the parameter `grey70` as fill color,
  * maybe you are astonished by the `aes()` we use in `geom_polygon()`: `x`, `y` and `group` are variables which are inside the variable `bulgaria.map`. This is a convention for shapefiles. Do not worry too much about it. 
  * important is the fact that we add a new layer (remember: plots are created adding layers) with the data in the form of a `geom_point()` in which we pass the arguments for the coordinates (which are in our dataframe `bulgaria.cities`). 
  * then we use another new function of ggplot2: `coord_map()`. This is necessary for getting a map which has the usual shape we are accustomed. Try to plot the map without this function. It works, but the projection is strange. All this is related to one of the most complicated areas in the creation of maps: the [projection](https://en.wikipedia.org/wiki/Map_projection). This is a wide topic I do not want to deal here with. In ggplot2 you can use [`coord_map()`](http://ggplot2.tidyverse.org/reference/coord_map.html) with different arguments to cope with this issue.  

But I think we could enhance a little bit the graph. Again: what we have already learnt about ggplot2 is still relevant for maps (which is of course very useful). 

Let's say we want to plot some relevant aspects of our data. For instance, it could be interesting to add to the plot information about the population of the cities and the number of relationships it has. That is: one could expect that bigger cities has more sister cities (which is not always the case) and it could be interesting to make a plot to see it. 

First of all we calculate the number of sister cities per bulgarian city: 
```{r}
bulgaria.mod <- bulgaria %>%
      group_by(origincityLabel, originlat, originlong, originpopulation) %>%
      summarise(total = n())
```

Now we will create a rather complex map using most of the features of ggplot2 we have learnt in this lesson. Do not panic about the long code. We will explain it line by line: 

```{r}
bp1 <-
      ggplot() +
      geom_polygon(data = bulgaria.map,
                   aes(x = long, y = lat, group = group),
                   fill = NA, color = "grey80") +
      geom_point(data =  bulgaria.mod,
                 aes( x = originlong, y = originlat, size = originpopulation, color = total)) +
      coord_map() + theme_void() +
      scale_size_continuous(breaks = c(50000, 100000, 250000, 500000, 1000000),
                            labels = NULL, 
                            range = c(3, 10),
                            guide  =  guide_legend(title = "Population",
                                                   title.position  =  "top" )) +
      scale_colour_gradient(name  = "Number of connexions",
                            low  =  "lightblue3", high  =  "blue4",
                            guide = guide_colorbar(draw.ulim  =  FALSE,
                                                 draw.llim  =  FALSE,
                                                 title.position  =  "top")) +
    theme( legend.position  =  "bottom")

bp1
```

![plot20](images/plot20.png)

What we are doing is the following: 

  1. we put the graph in a variable, because we will add some elements later on,
  2. we use the same structure as in the previous graph, but we add two parameters to `geom_point()`, namely `size` and `color` and map them to two variables (`originpopulation` and `total`),
  3. we use two scales (`scale_size_continuous` and `scale_colour_gradient`) to control how these two variables are represented and how this is explained in the legend (this is not compulsory; ggplot2 uses by itself both functions with default values),
  4. more precisely, with `scale_size_continuous` we control several things: 
	 * how many symbol (and with which values) should be represented for the population (the parameter `breaks`)
	 * that it should not show labels for them (the parameter `labels`)
	 * the range of the symbols (how big they should be)
	 * and the appearance of the legend (`guide`): that it should have a title and the position of this title. 
 5. with `scale_colour_gradient` we control several things: 
     * both colors for the lowest and the highest range 
	 * again the legend (`guide`): but in this case we select a colorbar (`guide_colorbar`) with title, position, and the parameters `draw.ulim` and `draw.llim` which control some ticks of the colorbar. 
  6. finally we put the legends in the bottom. 
  
We could even improve more the map by adding the name of the most relevant cities. Let's do it by using one of the new extensions of ggplot2: [`ggrepel`](https://github.com/slowkow/ggrepel). First we install the package, We will label the cities which have more than seven sister cities. We will create a new dataframe with this information. 

```{r}
# we install the package ggrepel
install.packages("ggrepel")
library(ggrepel)

# we select only cities with more than 7 connections 
bulgaria.mod2 <- filter(bulgaria.mod, total>7)

# we plot the map
bp2 <- bp1 +
      geom_text_repel(data  =  bulgaria.mod2,
                      aes(x = originlong, y = originlat, label = origincityLabel),
                      point.padding  =  unit(1, "lines"))

bp2
```

![plot21](images/plot21.png)

As you can see, we reuse the previous variable `bp1` in which we put our bulgarian graph and add a new layer, the labels, by means of the function `geom_text_repel`. It is also a `geom` and has the usual parameters: `data`, `aes`, etc. What do we need another dataframe for this geom? We could use the `bulgaria.mod`, but in this case `geom_text_repel` will use every city's name as label. `geom_text_repel` has a lot of parameters which control the appearance of the labels. In this case we used `point.padding`, but you can explore [other possibilities](https://cran.r-project.org/web/packages/ggrepel/vignettes/ggrepel.html) and in the help page (with `?geom_text_repel`). 


