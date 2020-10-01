##Assignment 4
library(tidyverse)
library(rvest)


##upload data 
timeplan<- "http://timeplan.uit.no/emne_timeplan.php?sem=20h&module%5B%5D=BED-2056-1&View=list"

scraped <- Sys.time()  ##when did download happen
webpag <- read_html(timeplan)

##checking if its working
html_session("http://timeplan.uit.no/emne_timeplan.php?sem=20h&module%5B%5D=BED-2056-1&View=list")

##there are 
x<-html_table(html_nodes(webpag, "div table")[1:14])

##making variables of the list 
timeplan <- as.data.frame(matrix(unlist(x), nrow =14, byrow=T),stringsAsFactors=FALSE)
colnames(timeplan)<-c("Dato","Dato","Tid","Klokkeslett","Rom","x","Emnekode","Fag","Beskrivelse","Fag","Lærer","Lærer")


view(timeplan)
