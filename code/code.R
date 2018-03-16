# we read the data from the CSV files
eudata <- read.csv("data/sistercities.tsv", header = T, sep = "\t")

# let's look at the structure of the dataframe 
str(eudata)

# we install and load the metapackage tidyverse
install.packages("tidyverse")
library(tidyverse)

# we create the new categorical column samecountry
eudata$samecountry <- ifelse(as.character(eudata$origincountry) ==
                             as.character(eudata$destination_countryLabel), "same", "different")
eudata$samecountry <- as.factor(eudata$samecountry)

# we create the new categorical column typecountry
# you need at least dplyr version > 0.7 for this code!
eudata <- eudata %>% dplyr::mutate(typecountry = case_when(samecountry == "same" & eu == "EU" ~ "same",
                                             samecountry == "different" & eu == "EU" ~ "EU",
                                             samecountry == "different" & eu == "Non-EU" ~ "Non-EU"))
eudata$typecountry <- factor(eudata$typecountry)

# we load ggplot2
library(ggplot2)

# we add a column with percentages per type of country
eudata.perc <- eudata %>%
    group_by(typecountry) %>%
    summarise(total = n()) %>%
    mutate(perc = total/sum(total))

ggplot(data = eudata.perc, aes(x = typecountry, y = perc)) +
    geom_bar(stat = "identity")

# we add a column with percentages per country  and per type of country
eudata.perc.country <- eudata %>%
    group_by(origincountry, typecountry) %>%
    summarise(total = n()) %>%
    mutate(perc = total/sum(total))

ggplot(data = eudata.perc.country, aes(x = typecountry, y = perc, fill = origincountry)) +
    geom_bar(stat = "identity", position="dodge")


# we extract a random sample of the data (15% of the total)
eudata.sample <- sample_frac(eudata, 0.15)

# this does not plot anything
ggplot(data = eudata.sample,
       aes(x = log(originpopulation),
           y = log(destinationpopulation)))

# this is plot1
ggplot(data = eudata.sample,
       aes(x = log(originpopulation),
           y = log(destinationpopulation))) +
       geom_point()

# we modify some aspects of the points
ggplot(data = eudata.sample,
       aes(x = log(originpopulation),
           y = log(destinationpopulation))) +
       geom_point(size = 3, color = "red")

# we add titles, caption, etc.
ggplot(data = eudata.sample,
       aes(x = log(originpopulation),
           y = log(destinationpopulation))) +
    geom_point(size = 3, color = "red") +
    labs(title = "Population data of origin and destination city",
         caption = "Data: www.wikidata.org",
         x = "Population of origin city (log)",
         y = "Population of destination city (log)")

# to save the plot
ggsave("eudata.png") # for a pdf file: ggsave("eudata.pdf")

  # using different colors according to the type
  # of country of the destination city
ggplot(data = eudata.sample,
       aes(x = log(originpopulation),
           y = log(destinationpopulation))) +
    geom_point(size = 3, aes( color = typecountry )) +
    labs(title = "Population data of origin and destination city",
         caption = "Data: www.wikidata.org",
         x = "Population of origin city (log)",
         y = "Population of destination city (log)")

  # the same, but with different shapes
ggplot(data = eudata.sample,
       aes(x = log(originpopulation),
           y = log(destinationpopulation))) +
    geom_point(size = 3, aes( shape = typecountry )) +
    labs(title = "Population data of origin and destination city",
         caption = "Data: www.wikidata.org",
         x = "Population of origin city (log)",
         y = "Population of destination city (log)")

# we put the plot into the variable p1
p1 <- ggplot(data = eudata.sample,
       aes(x = log(originpopulation),
           y = log(destinationpopulation))) +
    geom_point(size = 3, aes( color = typecountry )) +
    labs(title = "Population data of origin and destination city",
         caption = "Data: www.wikidata.org",
         x = "Population of origin city (log)",
         y = "Population of destination city (log)")

# we add a scale_colour
p1 + scale_colour_manual(values = c("red", "blue", "green"))

# we can also use other scales: for instance
# the brewer colors: http://colorbrewer2.org/
p1 + scale_colour_brewer(palette = "Dark2")
# p1 + scale_colour_brewer(palette = "Set1")
# p1 + scale_colour_brewer(palette = "Accent")

# we put this other plot into a new variable p2
p2 <- ggplot(data = eudata.sample,
       aes(x = log(originpopulation),
           y = log(destinationpopulation))) +
    geom_point(size = 3, aes( color = log(dist) )) +
    labs(title = "Population data of origin and destination city",
         subtitle = "Colored by distance between cities",
         caption = "Data: www.wikidata.org",
         x = "Population of origin city (log)",
         y = "Population of destination city (log)")
		 
p2

# and modify the gradient scale 
p2 + scale_colour_gradient(low = "white", high = "red3")

# we also adapt the legend
p2 <- p2 + scale_colour_gradient(low = "white",
                           high = "red3",
                           guide = guide_colorbar(title = "Distance in log(km)",
                                                  direction = "horizontal",
                                                  title.position = "top"))
												  
p2

# using another geom: geom_bar 
ggplot(eudata, aes(x = typecountry)) + geom_bar() 

# we calculate the % of types of countries
eudata.perc <- eudata %>%
    group_by(typecountry) %>%
    summarise(total = n()) %>%
    mutate(frequency = total/sum(total))

print(eudata.perc)

# we plot them with a bargraph. Important is the use
# of stat = "identity"
ggplot(eudata.perc, aes(x = typecountry, y = frequency)) +
    geom_bar(stat = "identity")


# we modify the scale which control the y-axis
ggplot(eudata.perc, aes(x = typecountry, y = frequency)) +
    geom_bar(stat = "identity") +
    scale_y_continuous(lim = c(0,1), labels = scales::percent_format())

## Faceting
# we calculate % of the type of coutnries per country
eudata.perc.country <- eudata %>%
    group_by(origincountry, typecountry) %>%
    summarise(total = n()) %>%
    mutate(frequency = total / sum(total))

# we plot it 
p4 <- ggplot(eudata.perc.country, aes(x = typecountry, y = frequency)) +
    geom_bar(stat = "identity") +
    scale_y_continuous(lim = c(0,1), labels = scales::percent_format()) +
    facet_wrap(~origincountry)
	
p4

## Themes 
# we put the previous plot into a variable 
p3 <- ggplot(eudata.perc.country, aes(x = typecountry, y = frequency)) +
    geom_bar(stat = "identity") +
    scale_y_continuous(lim = c(0,1), labels = scales::percent_format()) +
    facet_wrap(~origincountry)

# we plot it with a new theme 
p3 + theme_bw()

# other themes are available in some packages
install.packages("ggthemes")
library(ggthemes)

p3 + theme_wsj()

# we can also modify where the legend is shown
p2 + theme(legend.position = "bottom")

# and specific elements of the panel grid 
p4 + theme_light() +
    theme(panel.grid.major.x = element_blank(),
          panel.grid.minor.x = element_blank())


## Extensions 
# lollipop graphs with the package ggalt
install.packages("ggalt")
library(ggalt)

# we summarise the data
eudata.percity <- group_by(eudata, origincityLabel) %>%
    summarise(total = n()) %>%
    arrange(-total)

# we filter the first 25 Cities
eudata.percity.filtered <- slice(eudata.percity, 1:25)

# we plot the data 
ggplot(eudata.percity.filtered, aes(x = reorder(origincityLabel, total), total)) +
    geom_lollipop(point.colour = "red", point.size = 2.75) +
    coord_flip() +
    theme_pander() +   # you need library(ggthemes)
    theme(panel.grid.major.x = element_line(color = "black")) +
    labs(x = NULL, y = NULL,
         title = "Cities with most relationships",
         caption = "Data: wikidata.org")

# ggrides

ggplot(eudata, aes(x=log(originpopulation), y = origincountry)) +
    geom_density_ridges() +
    theme_ridges() +
    labs(title = "Population (log) of the origin cities",
         caption = "Data: www.wikidata.org",
         x = "Population of destination city (log)",
         y = "Country")

