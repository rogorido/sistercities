library(tidyverse)

austria <- read.csv("/home/igor/geschichte/projekte/proghistorian/sparql/data/austria.tsv", header = T, sep = "\t")
belgium <- read.csv("/home/igor/geschichte/projekte/proghistorian/sparql/data/belgium.tsv", header = T, sep = "\t")
bulgaria <- read.csv("/home/igor/geschichte/projekte/proghistorian/sparql/data/bulgaria.tsv", header = T, sep = "\t")
croatia <- read.csv("/home/igor/geschichte/projekte/proghistorian/sparql/data/croatia.tsv", header = T, sep = "\t")
cyprus <- read.csv("/home/igor/geschichte/projekte/proghistorian/sparql/data/cyprus.tsv", header = T, sep = "\t")
czech <- read.csv("/home/igor/geschichte/projekte/proghistorian/sparql/data/czech.tsv", header = T, sep = "\t")
denmark <- read.csv("/home/igor/geschichte/projekte/proghistorian/sparql/data/denmark.tsv", header = T, sep = "\t")
estonia <- read.csv("/home/igor/geschichte/projekte/proghistorian/sparql/data/estonia.tsv", header = T, sep = "\t")
finland <- read.csv("/home/igor/geschichte/projekte/proghistorian/sparql/data/finland.tsv", header = T, sep = "\t")
france <- read.csv("/home/igor/geschichte/projekte/proghistorian/sparql/data/france.tsv", header = T, sep = "\t")
germany <- read.csv("/home/igor/geschichte/projekte/proghistorian/sparql/data/germany.tsv", header = T, sep = "\t")
#greece <- read.csv("/home/igor/geschichte/projekte/proghistorian/sparql/data/greece.tsv", header = T, sep = "\t")
hungary <- read.csv("/home/igor/geschichte/projekte/proghistorian/sparql/data/hungary.tsv", header = T, sep = "\t")
ireland <- read.csv("/home/igor/geschichte/projekte/proghistorian/sparql/data/ireland.tsv", header = T, sep = "\t")
italy <- read.csv("/home/igor/geschichte/projekte/proghistorian/sparql/data/italy.tsv", header = T, sep = "\t")
latvia <- read.csv("/home/igor/geschichte/projekte/proghistorian/sparql/data/latvia.tsv", header = T, sep = "\t")
lithuania <- read.csv("/home/igor/geschichte/projekte/proghistorian/sparql/data/lithuania.tsv", header = T, sep = "\t")
netherlands <- read.csv("/home/igor/geschichte/projekte/proghistorian/sparql/data/netherlands.tsv", header = T, sep = "\t")
poland <- read.csv("/home/igor/geschichte/projekte/proghistorian/sparql/data/poland.tsv", header = T, sep = "\t")
portugal <- read.csv("/home/igor/geschichte/projekte/proghistorian/sparql/data/portugal.tsv", header = T, sep = "\t")
romania <- read.csv("/home/igor/geschichte/projekte/proghistorian/sparql/data/romania.tsv", header = T, sep = "\t")
slovakia <- read.csv("/home/igor/geschichte/projekte/proghistorian/sparql/data/slovakia.tsv", header = T, sep = "\t")
slovenia <- read.csv("/home/igor/geschichte/projekte/proghistorian/sparql/data/slovenia.tsv", header = T, sep = "\t")
spain <- read.csv("/home/igor/geschichte/projekte/proghistorian/sparql/data/spain.tsv", header = T, sep = "\t")
sweden <- read.csv("/home/igor/geschichte/projekte/proghistorian/sparql/data/sweden.tsv", header = T, sep = "\t")
uk <- read.csv("/home/igor/geschichte/projekte/proghistorian/sparql/data/uk.tsv", header = T, sep = "\t")

eudata <- rbind(austria, belgium, bulgaria, croatia, cyprus, czech, denmark,
                estonia, finland, france, germany, hungary, ireland, italy, latvia,
                lithuania, netherlands, poland, portugal, romania, slovakia, slovenia,
                spain, sweden, uk)

rm(austria, belgium, bulgaria, croatia, cyprus, czech, denmark,
   estonia, finland, france, germany, hungary, ireland, italy, latvia,
   lithuania, netherlands, poland, portugal, romania, slovakia, slovenia,
   spain, sweden, uk)

eudata$samecountry <- ifelse(as.character(eudata$origincountry) == as.character(eudata$destination_countryLabel), "same", "different")
eudata$samecountry <- as.factor(eudata$samecountry)

eudata <- eudata %>% dplyr::mutate(typecountry = case_when(samecountry == "same" & eu == "EU" ~ "same",
                                             samecountry == "different" & eu == "EU" ~ "EU",
                                             samecountry == "different" & eu == "Non-EU" ~ "Non-EU"))
eudata$typecountry <- factor(eudata$typecountry)

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
