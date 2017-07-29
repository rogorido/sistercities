# we install the packages
install.packages(c("rgeos", "rgdal"))
library(rgdal)

# we put the shapefile into a variable 
bulgaria.map <- readOGR("BGR_adm1.shp") # change the path accordingly

# we get the data of the bulgarian cities again
bulgaria.cities <- read.csv("data/bulgaria.tsv", header = T, sep = "\t")

# we plot the map
  ggplot() +
      geom_polygon(data = bulgaria.map,
                   aes(x = long,
                       y = lat,
                       group = group),
                   fill="grey70") +
      geom_point(data = bulgaria.cities,
                 aes(x = originlong,
                     y = originlat),
                 color = "red") +
      coord_map() +
      theme_light()

# we put the map into a variable bp1
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

# we install the package ggrepel
install.packages("ggrepel")
library(ggrepel)

# we select only cities with more than 7 connections 
bulgaria.mod2 <- filter(bulgaria.mod, total>7)

# we plot the map
# we install the package ggrepel
bp2 <- bp1 +
      geom_text_repel(data  =  bulgaria.mod2,
                      aes(x = originlong, y = originlat, label = origincityLabel),
                      point.padding  =  unit(1, "lines"))
