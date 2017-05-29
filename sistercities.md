---
title: XXX with SPARQL and plot maps with ggplot(2)
authors:
- Igor Sosa Mayor 
date: 2016-01-15
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

By the end of this lesson you will:

1. be able to extract data from XXX using the query language  SPARQL
2. be able to make different queries to
3. be able to import the extracted data to R
4. be able to analyze the data using R
5. be able to plot the data using 'normal plot' the package ggplot
6. be able to plot the data in maps with ggplot

# Semantic web: qué más 

There are many ontologies??? in the wildlife of the internet. But among them one of the most impressive ones is [Wikidata](https://www.wikidata.org/wiki/Wikidata:Main_Page), which is a free and open knowledge base. A crucial aspect of this kind of databases?? is the fact that their structure is not fixed??? at the beginning of the xxxx. On the contrary the structure of the data is very flexible. 

Think of an article of wikipedia, for instance [London](https://en.wikipedia.org/wiki/London). As you can see in this article you can find an incredibly huge amount of information about London (economic, historic, climatic, and so on). But the question is: how to get this information out of the article? Unfortunately this is very complicated. This is one of the reasons why Wikidata was created. We can look at the page in Wikidata dealing with [London](https://www.wikidata.org/wiki/Q84) (by the way: in every wikipedia page you can find on the left side a link to the wikidata object of the item explained in the article). 

As you can see the wikidata page of London is completely different. In
it you can find different kind of data structured as a kind of table. mejorar!!! Unfortunately not all data in the wikipedia page are already present in the wikidata page. But many of them will slowly be incorporated. 

The most important aspect of this (at the first sight very boring) page is the fact that this data **can be queried** using a query language. In other words: the data can be extracted and eventually??? used for different analyses. 

# Cities and sistercities in Europe 

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




If you want to know how to manipulate data in R, the best option nowadays is to use the package [dplyr](https://cran.r-project.org/web/packages/dplyr/index.html) created by [Hadley Wickham ](http://hadley.nz/). You can find a good tutorial to using dplyr written by Nabeel Siddiqui. 

# Graphics with ggplot2

In R there are several possibilities to create graphs: the packages provided by the standard installation of R, the package [lattice](https://cran.r-project.org/web/packages/lattice/index.html), and [ggplot2](http://ggplot2.org/) which is the system we will learn in this lesson.

ggplot2 has many advantages:

1. it is very powerful, but at the same time quite simple, 
2. it has a lot of extensions which are increasingly being developed by the community. They add new functions, new types of graphs, new themes and enhance the possibilities of ggplot2. You can find them in [this site](http://www.ggplot2-exts.org/).
3. it also has the possibility of create maps.

ggplot2 is based on a theoretical book dealing with a so-called *grammar of graphics* (hence the *gg* in ggplot2). But, don't panic: you don't have to know anything about grammar. 

There is plenty of information about ggplot2 on the web, but I recommend you:

1. for a general overview of the package you can visit the [docs](http://docs.ggplot2.org/current/) about the package 
2. very useful is also for tips the webpage [Cookbook for R](http://www.cookbook-r.com/Graphs/)
3. but the best source of information is of course the book written by Wickham which has been recently [published](http://www.springer.com/br/book/9783319242750) (be careful! this is the 2nd edition which deals with important new features of the last versions of ggplot2).
4. very useful is also the cheatsheet you can find [here](https://www.rstudio.com/resources/cheatsheets/).

A small trick to learn ggplot2 is to think about the creation of plots like the construction of sentences. 

```{R}
ggplot(cities, aes())
```

We are telling R the following: "create a ggplot graph using the
dataframe cities and map the variables ". As you can see, the
structure is very straightforward, except for the use of *aes*, which
means in ggplot parlance *aesthetics*. It is maybe a not very telling
expression, but the idea is very simple: we tell R that it has to map
the variables with this columns of the dataframe. That means
(oversimplifying): it is a way to tell R that we are passing some variables of the dataframe.

If you press return now you will be surprised: you will get an empty plot. Axes and plot area are there, but the data are not represented. However this is the expected behaviour. We have to tell R/ggplot2 which plot we want to create. This is done in ggplot2 by means of the so-called *geom*s (from *geometries*). There are 

[comment] # Local Variables:
[comment] # eval: (auto-fill-mode -1)
[comment] # eval: (visual-line-mode)
[comment] # eval: (visual-fill-column-mode)
[comment] # End:
