# we read and load all data into variables
bulgaria <- read.csv("/home/igor/geschichte/projekte/proghistorian/sparql/data/bulgaria.tsv", header = T, sep = "\t")
france <- read.csv("/home/igor/geschichte/projekte/proghistorian/sparql/data/france.tsv", header = T, sep = "\t")
germany <- read.csv("/home/igor/geschichte/projekte/proghistorian/sparql/data/germany.tsv", header = T, sep = "\t")
hungary <- read.csv("/home/igor/geschichte/projekte/proghistorian/sparql/data/hungary.tsv", header = T, sep = "\t")
poland <- read.csv("/home/igor/geschichte/projekte/proghistorian/sparql/data/poland.tsv", header = T, sep = "\t")
portugal <- read.csv("/home/igor/geschichte/projekte/proghistorian/sparql/data/portugal.tsv", header = T, sep = "\t")

# we create a dataframe with all EU countries
eudata <- rbind(bulgaria, france, germany,
                hungary, poland, portugal)

# we remove the previous variables
rm(bulgaria, france, germany,
   hungary, poland, portugal)

eudata$samecountry <- ifelse(as.character(eudata$origincountry) == as.character(eudata$destination_countryLabel), "same", "different")
eudata$samecountry <- as.factor(eudata$samecountry)

eudata <- eudata %>% dplyr::mutate(typecountry = case_when(samecountry == "same" & eu == "EU" ~ "same",
                                             samecountry == "different" & eu == "EU" ~ "EU",
                                             samecountry == "different" & eu == "Non-EU" ~ "Non-EU"))
eudata$connections <- factor(eudata$typecountry)

eudata.percity <- group_by(eudata, origincityLabel) %>% summarise(total = n()) %>% arrange(-total)
eudata.percity.filtered <- slice(eudata.percity, 1:25)
ggplot(eudata.percity.filtered, aes(x=reorder(origincityLabel, total), total)) +
    geom_lollipop(point.colour = "red", point.size = 2.75) +
    coord_flip() + theme_light()

eudata.perdestinationcity <- group_by(eudata, sistercityLabel) %>% summarise(total = n()) %>% arrange(-total)
eudata.perdestinationcity.filtered <- slice(eudata.perdestinationcity, 1:25)
ggplot(eudata.perdestinationcity.filtered, aes(x=reorder(sistercityLabel, total), total)) +
    geom_lollipop(point.colour = "red", point.size = 2.75) + coord_flip() + theme_light()
ggplot(eudata.perdestinationcity.filtered, aes(x=reorder(sistercityLabel, total), total)) +
      geom_bar(stat="identity", fill="red") + coord_flip() + theme_minimal()

eudata.percountry <- group_by(eudata, origincountry) %>% summarise(total = n()) %>% arrange(-total)
eudata.percountry.filtered <- slice(eudata.percountry, 1:25)
ggplot(eudata.percountry.filtered, aes(x=reorder(origincountry, total), total)) +
    geom_lollipop(point.colour = "red", point.size = 2.75) +
    coord_flip() + theme_light()

ggplot(eudata, aes(x=factor(1), fill=factor(eu))) + geom_bar(width=1) + coord_polar(theta="y") + facet_wrap(~origincountry, scales="free_y")
