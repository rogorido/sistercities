---
title: Analyzing data with SPARQL, R and ggplot2
authors:
- Igor Sosa Mayor 
date: 2016-07-15
reviewers:
- 
layout: default
difficulty: 1
---

# Introduction

Getting data and analyzing them is one of the most important tasks a historian has to face. Data are nowadays becoming omnipresent, but it is not always easy to know how to extract them from the different places we can find them on/in the web. Databases are the most obvious place where huge amounts of data are stored. Usual databases have however one problem (and many advantages): they are very rigid in their structure. For this reason in the last years a new type of database has appeared which tries to overcome (esto está muy rollo). 

The so-called *semantic web* is a very schillernd concept. The idea behind it is to categorise concepts and data and, above all, put all them in relationship.

citar lo del tiop este... for specific issues in wikidata you can read this [general friendly introduction](https://www.wikidata.org/wiki/Wikidata:A_beginner-friendly_course_for_SPARQL) and the more [technichal description](https://www.wikidata.org/wiki/Wikidata:SPARQL_query_service/queries). 

# Lesson Goals

By the end of this lesson you will be able:

1. to extract data from XXX using the query language  SPARQL
2. to make different queries to
3. to import the extracted data to R
4. to analyze the data using R
5. to plot the data using 'normal plot' the package ggplot
6. to plot the data in maps with ggplot

# Semantic web: qué más 

There are many ontologies??? in the wildlife of the internet. But among them one of the most impressive ones is [Wikidata](https://www.wikidata.org/wiki/Wikidata:Main_Page), which is a free and open knowledge base. A crucial aspect of this kind of databases?? is the fact that their structure is not fixed??? at the beginning of the xxxx. On the contrary the structure of the data is very flexible. 

Think of an article of wikipedia, for instance [London](https://en.wikipedia.org/wiki/London). As you can see in this article you can find an incredibly huge amount of information about London (economic, historic, climatic, and so on). But the question is: how to get this information out of the article? Unfortunately this is very complicated. This is one of the reasons why Wikidata was created. We can look at the page in Wikidata dealing with [London](https://www.wikidata.org/wiki/Q84) (by the way: in every wikipedia page you can find on the left side a link to the wikidata object of the item explained in the article). 

As you can see the wikidata page of London is completely different. In
it you can find different kind of data structured as a kind of table. mejorar!!! Unfortunately not all data in the wikipedia page are already present in the wikidata page. But many of them will slowly be incorporated. 

The most important aspect of this (at the first sight very boring) page is the fact that this data **can be queried** using a query language. In other words: the data can be extracted and eventually??? used for different analyses. 

# Cities and sister cities in Europe 

The analysis behind this tutorial is a very simple one. I was always fascinating by the fact that many cities have sistercities around the world. As a historian a lot of more or less relevant questions arise out of this empirical fact. This is a very modern phenomenon which probably began in the 19th century. The existence of this relationships has maybe to do with strong economic relations or with the fact that many immigrants of one of the cities migrated to the other one.

or for instance: are many German cities related to French cities? This could maybe be interpreted (as far as these relationships began after the II World War) as an attempt to  

With the data we can find in Wikidata a great deal of empirical questions can be posed. 

unfortunately the data in Wikidata do not enable us to ask an important question for historians: the temporal question. In other words: since when are two cities sister cities? 

The question is therefore: how do we get the data of the sistercities of European cities? Wikidata has already this information. We only have to query it. 

## SPARQL: querying semantic data???



# R

There are several ways to get the data into R for further analysis: 

1. exporting the results as CSV/TSV (comma/tab separated values) or JSON, which is what I will cover in this lesson;
2. using one of the different R packages which are able to connect to a SPARQL endpoint and get the data (a more general one, [SPARQL](https://cran.r-project.org/web/packages/SPARQL/index.html), and a specific package for using with wikidata, [WikidataR](WikidataR)).
3. downloading?? the data to your computer with one of the available programs for doing this (I can recommend [wikidata-cli](https://github.com/maxlath/wikidata-cli)).

In the present tutorial we will use only the data of six EU-countries: Germany, France, Poland, Hungary, Portugal, Bulgaria (three of so-called Western Europe and three of so-called Eastern Europe). But if you want to play with the data of all EU-countries you can find it here. 

Let's get the data into R: 

```{r}
bulgaria <- read.csv("/home/igor/geschichte/projekte/proghistorian/sparql/data/bulgaria.tsv", header = T, sep = "\t")
france <- read.csv("/home/igor/geschichte/projekte/proghistorian/sparql/data/france.tsv", header = T, sep = "\t")
germany <- read.csv("/home/igor/geschichte/projekte/proghistorian/sparql/data/germany.tsv", header = T, sep = "\t")
hungary <- read.csv("/home/igor/geschichte/projekte/proghistorian/sparql/data/hungary.tsv", header = T, sep = "\t")
poland <- read.csv("/home/igor/geschichte/projekte/proghistorian/sparql/data/poland.tsv", header = T, sep = "\t")
portugal <- read.csv("/home/igor/geschichte/projekte/proghistorian/sparql/data/portugal.tsv", header = T, sep = "\t")

# we create a dataframe with the countries
eudata <- rbind(bulgaria, france, germany,
                  hungary, poland, portugal)

# we remove the previous variables
rm(bulgaria, france, germany,
     hungary, poland, portugal)
```

Doing so, we have a dataframe `eudata` with the data of the six countries. There are 13081 rows with 15 variables.

In order to analyze this data, we have to add some information: is the sister city in the same country? And following this: we create a column (`typecountry`) with a categorical variable with three values according to the fact of the sister city is in the same country, in a EU-country or in a non-EU-country.

I will not explain the details of these transformations. 
If you want to know how to manipulate data in R, the best option nowadays is to use the package [dplyr](https://cran.r-project.org/web/packages/dplyr/index.html) created by [Hadley Wickham ](http://hadley.nz/), which is included in the metapackage `tidyverse` we have already loaded. You can find a good tutorial to using dplyr written by Nabeel Siddiqui. 

```{r}
eudata$samecountry <- ifelse(as.character(eudata$origincountry) == as.character(eudata$destination_countryLabel), "same", "different")
eudata$samecountry <- as.factor(eudata$samecountry)

# you need at least dplyr version > 0.7 for this code!
eudata <- eudata %>% dplyr::mutate(typecountry = case_when(samecountry == "same" & eu == "EU" ~ "same",
                                             samecountry == "different" & eu == "EU" ~ "EU",
                                             samecountry == "different" & eu == "Non-EU" ~ "Non-EU"))
eudata$typecountry <- factor(eudata$typecountry)
```

If you do not want to follow these steps, you can download this dataframe from here and load it into R in this way:

```{r}
load("sistercities.Rdata")
```

# Graphics with ggplot2

There are several ways to analyze the data we have prepared, but in this tutorial we will concentrate on their/its? graphical representation. In R there are three main possibilities to create graphs: the [plotting functions](https://stat.ethz.ch/R-manual/R-devel/library/graphics/html/plot.html) provided by the standard installation of R, the package [lattice](https://cran.r-project.org/web/packages/lattice/index.html), and finally [ggplot2](http://ggplot2.org/), which is the system we will learn here.

## ggplot2: General aspects 

ggplot2 has many advantages:

1. it is very powerful, but at the same time relatively simple, 
2. it has a lot of [extensions](http://www.ggplot2-exts.org/) which are increasingly being developed by the community. They enhance the possibilities of ggplot2 adding new functions, new types of graphs, new themes, etc.
3. it also has the possibility to create maps.

Creating good graphics is a complicated issue, because you have to take into account different aspects: the information you want to convey, the many possibilities of showing this information (scatterplots, boxplots, histogramms, and so on), the many aspects of a plot which can be adapted (axes, transformation of variable, etc.). 
But how does ggplot2 cope with this complexity? ggplot2 is based on a theoretical book which proposes a so-called
*grammar of graphics* (hence the *gg* in ggplot2) written by [Leland Wilkinson](https://en.wikipedia.org/wiki/Leland_Wilkinson). But, *don't panic*:
you don't have to know anything about grammar. The main idea is that a
plot is made up of a set of independent components that can be
composed in many different ways. In brief we will see how to do it.

There is plenty of information about ggplot2 on the web, but I recommend you:

1. the best source of information is of course the book written by the author himself which has been recently [published](http://www.springer.com/br/book/9783319242750). The book is also available [online](https://github.com/hadley/ggplot2-book),
2. for a general overview of the package you can visit the [documentation](http://docs.ggplot2.org/current/) of the package,
3. very useful are also the webpage [Cookbook for R](http://www.cookbook-r.com/Graphs/) and  the cheatsheet you can find [here](https://www.rstudio.com/resources/cheatsheets/).

But, first of all, in order to use ggplot we have of course to install it. Actually I recommend to install the metapackage `tidyverse` which is a collection of packages written mainly by Wickham for doing most of the most useful operations with dataframes ([dplyr](http://dplyr.tidyverse.org/), [readr](http://readr.tidyverse.org/), [tidyr](http://tidyr.tidyverse.org/), [forcats](http://forcats.tidyverse.org/), etc.). ggplot is among the packages contained in the [metapackage `tidyverse`](http://tidyverse.org/). 

```{r}
install.packages("tidyverse")
# or only ggplot2
# install.packages("ggplot2")
```

## A first example: a scatterplot of population data

But, let's begin with a small example which we will slowly modify. In our data we have the population of the origin city and the destination city. We could be interested in knowing whether population is a related variable, that is: are small/big cities more often related to cities in their population range? We could do this using a [scatterplot](https://en.wikipedia.org/wiki/Scatter_plot) showing both population data. In ggplot this coud be done as follows (we use the natural log of the population data to overcome the skewness of the data):

```{r}
library(ggplot2)

ggplot(data=eudata, aes(x=log(originpopulation), y=log(destinationpopulation)))
```

A small trick to learn ggplot2 is to think about the creation of plots like the construction of sentences. We are telling R the following: "create a ggplot graph using the
dataframe cities and map the variable originpopulation to x and destinationpopulation to y". As you can see, the
structure is very straightforward, except for the use of *aes*, which
means in ggplot parlance *aesthetics*. It is maybe a not very telling
expression, but the idea is very simple: we tell R that it has to map
the variables in the graph with these columns of the dataframe.

If you press return now, you will be surprised: you will get an empty
plot! Axes and plot area are there, but the data are not represented.
This is however the expected behaviour. We have to tell R/ggplot2
which type of plot we want to create. That means: we need to add a layer to plot. Adding different layers is the way to construct plots with ggplot. 

In ggplot there are different types of layers [cómo coño poner esto?].
One crucial type of them is the so-called  *geom* (from *geometries*) layer. As we will see, there are plenty of different layers (and many more in packages which extend ggplot2 functionality). Since we want to create a scatterplot, we need the `geom_point()` layer. Therefore we add a layer to our plot using the command `+`:

```{r}
ggplot(data=eudata, aes(x=log(originpopulation), y=log(destinationpopulation))) + geom_point()
```

Now we have a scatterplot relating both variables (if you're using the data I gathered, you will get a message that ggplot2 removed 6429 rows containing missing values, because some cities do not have information about their population). Nevertheless, I think you would like to improve the quality and appearance of the plot, since some aspects are not very convincing: the labels of the axes, the plot's background, the overplotting (too many points), and so on. As you see, ggplot2 makes several different decisions for you in terms of plot appearance. They are often not bad, but we want to be able to adapt plots to our needs. 

Every single plot's aspect can be manipulated. There are three different elements which are worth looking at:

1. every ggplot2 function (eg. `geom_point()`) can take arguments to modify concrete
   aspects, 
2. *scales* control the way variables are mapped from the data to the
   plot. This affects axes, legends, etc.
3. *themes* refer to the 'static' elements of the plot: the
   background's elements (color, lines, etc.), the fontsize, etc. 

We will begin with the most simple transformation: we want to change the color
of the points and since we have a lot of points we want to add some transparency to the points:

```{r}
ggplot(data=eudata, aes(x=log(originpopulation), y=log(destinationpopulation))) + geom_point(color="red", alpha=0.4)
```

As you can see, this can be easily done: every function can get
arguments with which you can influence how the functions makes its
job. The function `geom_point()` can take different arguments which
are very straightforward. You can see them under the section
*Aesthetics* in the help of `geom_point()` by typing `?geom_point` in
R or [here](http://ggplot2.tidyverse.org/reference/geom_point.html)
online. As expected, you can manipulated things like the color, the size, the shape, etc. of the points by using the corresponding argument. 

The graph shows a very clear pattern of lineal relationship between cities' populations: the more population a city has, the bigger the sistercities it has. 

But we want also to add titles to the axes. Manipulating axes (and
legends) is done by using the corresponding `scales` functions. We
will see it later on. But since changing the titles is a very common action, ggplot has shorter commands to do it: `xlab()` and `ylab` (*lab* stands for *label*):

```{r}
ggplot(data=eudata, aes(x=log(originpopulation), y=log(destinationpopulation))) +
    geom_point(color="red", alpha=0.4) +
    xlab("Population of origin city (log)") +
    ylab("Population of destination city (log)")
```

![basic3](images/basic3.png)

For the time being, we will let our graph such it is, without making
any other changes. Before explaining how to change other elements, let us try another graph with another `geom`.

## Adding information to graphs (colors, shapes, etc.). The use of `scales`

In many cases we want to add information to a graph using different
colors (or shapes) for every group. Taking our dataset we could color
the points of our previous scatterplot using different colors for the
different types of cities (in the same country, in a EU-country or in
a non-EU-country). Let's  create a first version of this new graph
using the previous code: 

```{r}
ggplot(eudata, aes(log(originpopulation), log(destinationpopulation))) +
    geom_point(alpha=0.4, aes(color=typecountry)) +
    xlab("Population of origin city (log)") +
    ylab("Population of destination city (log)")
```

![scatter3](images/scatter3.png)

Three aspects are here relevant:

1. I remove the name of some parameters (`data`, `x`, `y`), since
   ggplot2 is intelligent enough to figure them out.
2. most important: we modify `geom_point()` adding an argument: `aes(color=typecountry)`. Why do we use `aes()` and not just `color=typecountry` without putting it inside of `aes()`? You can try it (you will get an error). The reason is very easy: using `aes()` we are telling ggplot2 that it has to map the argument `color` to the variable `typecountry`. In other words: we are telling ggplot that `typecountry` is a variable of the data we are using. 
3. ggplot has made some decisions for us: it selects colors on its own
   and it puts automatically a legend. 

Let's say you want to use different shapes for the country's types.
You could try this code: 

```{r}
ggplot(eudata, aes(log(originpopulation), log(destinationpopulation))) +
    geom_point(alpha=0.4, aes(shape=typecountry)) +
    xlab("Population of origin city (log)") +
    ylab("Population of destination city (log)")
```

### Scales: XXXXX ###

But: how can we modify colors and legend? The so-called `scales` are
your friend. Citing the ggplot2 book: "scales control the mapping from
data to aesthetics. They take your data and turn it into something
that you can see, like size, colour, position or shape". And at the
same time, scales provide the tools that let you read the plot: the
axes and legends. Actually ggplot is always using per default scales when you create a graph.

Nevertheless I have to admit scales are maybe the least intuitive
element in ggplot2. There
are
[many different scales](http://ggplot2.tidyverse.org/reference/#section-scales) you
can use. But let's take a look at it with our previous graph.

In our graph we can control 3 different scales: 

1. `scales_x_continuous()` which controls the x-axes,
2. `scales_y_continuous()` which controls the y-axes,
3. `scales_colour`: which controls the color(s) used. 

We will take a look at the possibilities of changing colors.
(Nevertheless I have to warn you: the selection of colors for graphs
is by no means an easy task; there is a lot of theoretical work done
on this). We could do several things: manually passing some colors,
using a color scala, 

[atención: aquí hay el problema que la puta leyenda sale con alpha!]

First of all we store our graph in a varible to use it several times, changing only some aspects. This is a very convenient way of ggplot2 to make different versions of the same graph:

```{r}
p2 <- ggplot(data=eudata, aes(x=log(originpopulation), y=log(destinationpopulation))) +
    geom_point(alpha=0.4, aes(color=typecountry))
```

Now we can add manually the colors we want using `scale_colour_manual()`.

```{r}
p2 + scale_colour_manual(values = c("red", "blue", "green"))
```

As you see, `scale_colour_manual()` takes a compulsory argument, namely a vector with the names of colors. This could also be a vector of HTML color codes.

In this way we can create graphs with our preferred colors. But often it is more recommendable to use already defined colors scalas, such as the [color brewer palettes](http://colorbrewer2.org/). ggplot has already these palettes [integreated](http://ggplot2.tidyverse.org/reference/scale_brewer.html) and a specific `scale` for using them. For instance: 

```{r}
p2 + scale_colour_brewer()
```

`scale_colour_brewer()` has different [palettes](http://ggplot2.tidyverse.org/reference/scale_brewer.html#palettes). You can try for instance: 

```{r}
p2 + scale_colour_brewer(palette = "Greens")
p2 + scale_colour_brewer(palette = "Set1")
p2 + scale_colour_brewer(palette = "Pastel1")
```

But let's look at another slightly different example. In the last graph we used a qualitative variable (`typecountry`) with different colors. But what about a continuous variable? Let's say we want to represent with a red scale the distance between the cities. 

```{r}
p3 <- ggplot(eudata, aes(log(originpopulation), log(destinationpopulation))) +
    geom_point(alpha=0.4, aes(color=dist))

p3
```

![scales3](images/scales3.png)

As you can see, there are two problems with this graph: blue is the used color and not red; the scala is not convincing since null is represented by the more oscuro??? Again we need to use scales, but in this case another command. As you can see, ggplot does not use in this case discrete colors (that is, one color per every value in the qualitative varible, for every factor in R parlance), but only one color which is graduated[???]. For this reason the scale we have to use is one  deals with gradients. There are [several for doing this](http://ggplot2.tidyverse.org/reference/scale_gradient.html). We will use `scale_colour_gradient`. We can define the low and the high value of the gradient. For instance: 

```{r}
p3 + scale_colour_gradient(low = "white", high = "red")
```

Other scales with gradients (`scales_colour_gradient2` and `scales_colour_gradientn`) have other possibilities. I encourage you to explore them looking at the [documentation page](http://ggplot2.tidyverse.org/reference/scale_gradient.html).


## Bar graphs 

Now we are interested in another aspect of our data. We want to know  which percentage of destination cities are in the same country, how many in other EU-country and how many outside the EU. And we want to split the graph so that every EU-country has its own graph.

Let's begin with the most simple one. we need another `geom`, namely
`geom_bar()`. Actually this can be simply done with this code: 

```{r}
ggplot(eudata, aes(x=typecountry)) + geom_bar() 
```
![nosé](images/bargraph1.png)

But this is not want we exactly want. Percentages would convey more
information than raw data. There are several ways for doing this. One
of them is transforming the data. One way of achieving it, is as
follows (I do not want to explain this code since this is not a
tutorial about `dplyr`). What we get is a dataframe with percentages. We can represent it so:

```{r}
eudata.perc <- eudata %>%
    group_by(typecountry) %>%
    summarise(total=n()) %>%
    mutate(freq= total/sum(total))

print(eudata.perc)

ggplot(eudata.perc, aes(x=typecountry, y=freq)) +
    geom_bar(stat="identity")
```
![bargraph2](images/bargraph2.png)

There is an important difference between the first barplot and this
one. In the first plot ggplot2 counted itself the number of cities in every group (in the original dataframe this information is not present). But in this case our dataframe already contains the value ggplot must use for plotting the bars. In this case, we need to tell ggplot where it can find the value by setting `y=freq` and (this is the tricky point) by using the `stat` argument of `geom_bar()`: per default `geom_bar()` uses internally `stat="count"`, which means, that it counts the number of ocurrences. But now we tell it that it has to use the number found in `y`.

Nevertheless this graph is still not convincing to me. I would like to
improve it by making the following changes: change the y axis to range
from 0 to 1 and show a percentage symbol (%) in the y axis. Let's see
the code and then I will explain it: 

```{r}
p4 <- ggplot(eudata.perc, aes(x=typecountry, y=freq)) +
    geom_bar(stat="identity") +
    scale_y_continuous(lim=c(0,1), labels = scales::percent_format())

p4
```

![bargraph3](images/bargraph3.png)

 As already mentioned, axes are changed using the `scales` functions. I have to admit this is in ggplot a little bit confusing since there are many different `scales` functions [as you can see etc.]. [añadir tal vez lo que dice el manual]

But let us see it with an example: 

Since we want to change the y-axis we use a `scale_y` function and since the y-axis in our plot is a continuous variable we use `scale_y_continuous`. 


## Faceting a graph 

But imagine that we would like to represent the same data, but in separated graphs per country. For doing this ggplot2 has powerful possibilities, which are summarised under the label *facetting*. The most simple facetting function is `facet_wrap()`, but you can also take a look at the richer `facet_grid()` (see [here](http://ggplot2.tidyverse.org/reference/facet_grid.html) the doc).

For doing this, we have to calculate the percentage per country into a new variable (`eudata.perc.country`) and then we create the graph: 
```{r}
eudata.perc.country <- eudata %>%
    group_by(origincountry, typecountry) %>%
    summarise(total=n()) %>%
    mutate(freq= total/sum(total))

p5 <- ggplot(eudata.perc.eu, aes(x=typecountry, y=freq)) +
    geom_bar(stat="identity") +
    scale_y_continuous(lim=c(0,1), labels = scales::percent_format()) +
    facet_wrap(~origincountry)

p5
```

We have only added the function `facet_wrap(~origincountry)` to the previous command. By doing so, we tell ggplot2 to create one graph per country. Important is the use of the operator `~` which is very often used in R for the so-called formulae. [añadir!] The result is as follows: 

![bargraph4](images/bargraph4.png)

ggplot2 also provides a function `facet_grid()` which is more powerful. You can see some examples [here](http://ggplot2.tidyverse.org/reference/facet_grid.html). 

## Themes: changing elements of the XXXX

Modifying the appearance of the graph is also one of the most frequent requirements. This can be achieved in ggplot2 with the use of `themes`. Themes give you control over things like fonts, ticks, panel strips, and backgrounds. ggplot2 comes with a number of built-in themes. The most important are `theme_grey()`, `theme_bw()`, `theme_dark()`, `theme_void()`, etc. Moreover the most important point is that you can easily create you own themes and use them in your plots. 

ggplot2 uses per default `theme_grey()`.  It is very easy to use another theme. Using the last graph: 

```{r}
p5 + theme_bw()
```

![bargraph5](images/bargraph5.png)

Several packages add additional themes to ggplot2. You can for instance install [`ggthemes`](https://github.com/jrnold/ggthemes) where you will find themes such as `theme_excel` (a theme replicating the classic ugly gray charts in Excel), `theme_wsj` (a theme based on the plots in the *The Wall Street Journal*), etc. For instance using this last theme: 

```{r}
install.packages("ggthemes")
library(ggthemes)

p5 + theme_wsj()
```

![bargraph6](images/bargraph6.png)

But more interesting is of course the possibility to modify yourself some aspects of the graph. There are two main possibilities: 

1. create your own theme, taking for instance the code of the existing ones and modifying the concrete aspects you are interested in. The definition of the default themes can be found [here](https://github.com/tidyverse/ggplot2/blob/master/R/theme-defaults.r). 
2. modify concrete aspects of the theme we are using. This is the approach we will follow here. 

Modifying concrete aspects of a theme can be achieved by means of the function `theme()`. Unfortunately it is not possible in such a lesson to get into every single aspect which can be manipulated by using `theme()`. [Here](http://ggplot2.tidyverse.org/reference/theme.html) you can find how many different arguments can be used (and see some examples): panel.grid.major, panel.grid.minor, plot.background, legend.background, legend.margin, and many others. Relevant is however the fact that by using `theme()` actually we are modifying the default theme we are using. That means: we modify some aspects. 

For instance, let say we want to put the legend of the previous scatterplot in the bottom of the graph. This can be achieved by means of the following code:

```{r}
p2 + theme(legend.position = "bottom")

```

We could also for instance remove the lines of the grid in one of the previous bargraphs modifying the white/black-theme (`theme_light()`):

```{r}
p5 + theme_light() +
    theme(panel.grid.major.x = element_blank(),
          panel.grid.minor.x = element_blank())

```

![bargraph7](images/bargraph7.png)


[tal vez añadir ref a esto: http://ggplot2.tidyverse.org/reference/element.html]

## Extending ggplot2 with other geoms

As already mentioned, one of the strengths of ggplot2 is that is increasingly becoming a standard for plotting in R. For this reason, a lot of [extensions](http://www.ggplot2-exts.org/) are being added to R. Their use is incredibly easy. Let's see an example. 

Imagine that we want to plot the number of countries a EU-contry has relationships with. That means: with how many countries do for instance german cities have relationships? Or: which is the EU country with the most (least) connections? 
We could do this with a barplot, but instead of a barplot we can construct a so called lollipop graph. This can be achieved with the package `ggalt` (see [here](https://github.com/hrbrmstr/ggalt)). 

First of all we need to install the package, then we create a dataframe which summarises the information we want to show in the graph and, finally, we plot the graph. This can be done for instance in the following way:

```{r}
# if you do not have the package, install it 
# install.packages("ggalt")
library(ggalt)

# we summarise the data
eudata.percity <- group_by(eudata, origincityLabel) %>%
    summarise(total = n()) %>%
    arrange(-total)

# we filter the first 25 Cities
eudata.percity.filtered <- slice(eudata.percity, 1:25)

# we plot the data 
ggplot(eudata.percity.filtered, aes(x=reorder(origincityLabel, total), total)) +
    geom_lollipop(point.colour = "red", point.size = 2.75) +
    coord_flip() +
    theme_pander() +   # you need library(ggthemes)
    theme(panel.grid.major.x = element_line(color="black")) +
    labs(x=NULL, y=NULL,
         title="Cities with most relationships",
         caption="Data: wikidata.org")
    
```

![graph8](images/graph8.png)

Some aspects are relevant here:

1. we have to order the data using the function `reorder` to get a descendent order of the Cities,
2. we use some arguments in the `geom_lollipop()` such as size, colour, etc. You can get a list by looking at `?geom_lollipop`. 
  * finally we use a new command: `coord_flip()` with which we can "rotate" the graph. 




# Otros 

as you can see all countries have more relationships to countries in the EU than with non-EU countries. With only one exception: Bulgaria.. 

tal vez mostra r que cmabiando muy poco se puede hacer un gráfico de barras, uno lollipop de esos, etc. 

# Maps 

Representing geographical information is becoming increasingly useful and demanded. In the opensource world you can find several rich programs to deal with geographical information: [QGIS](http://www.qgis.org/), [gvSIG](http://www.gvsig.com/), [GRASS](https://grass.osgeo.org/), and also R. 

As always in R, there are several ways to create maps. You can use:
the ggplot2 package which is the method we learn here. But there are
also the very powerful
package [sp](https://cran.r-project.org/web/packages/sp/index.html).
You can find a very informative site about spatial methods in
R [here](https://cran.r-project.org/web/views/Spatial.html). Spatial
analysis and cartography are very much en vogue. New packags are also
getting developed. (o algo así: the cartographical abilities of R are
continously increasing). New packages are always appearing, such
as [cartography](https://github.com/Groupe-ElementR/cartography). 

Honestly speaking, this richness implies also some complications, since every package has its own syntax. We will stick with ggplot, but I encourage you to make experiments with packages such as the very promising new package `cartography`. 

We need the following packages: 
```{r}
install.packages(rgeos)
install.packages(rgdal)
library(rgeos)
library(rgdal)
```
These two packages are useful for read a wide range of geographical formats (shapefiles, raster data, etc.). 

## Points 

We will begin with a simple map to show where are the german cities of our data. The most simple way to do this is to show a point for every city. But first we need to get a map to operate with. Again we find here two possibilities [o dejarlo?]. We will 

But first of all we need maps. There are several open sources to get maps: 

1. in [GADM](http://gadm.org/) you will find maps in different formats for every land of the world (but not bigger )

aquí hay una buena expolicación: https://github.com/Robinlovelace/Creating-maps-in-R tal vez coger eso...


[comment] # Local Variables:
[comment] # eval: (auto-fill-mode -1)
[comment] # eval: (visual-line-mode)
[comment] # eval: (visual-fill-column-mode)
[comment] # End:
