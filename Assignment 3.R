##Assignment 3 
library(tidyverse)
library(rvest)
library(tidyr)


##link to webpage
#browseURL("https://www.datacamp.com/courses/tech:r")
#browseURL("https://www.datacamp.com/courses/tech:python")

##uploading data
r.datacamp <- "https://www.datacamp.com/courses/tech:r"
python.datacamp<- "https://www.datacamp.com/courses/tech:python"
## when did I download the data
scraped <- Sys.time()
r.datacamp <- read_html(r.datacamp)
python.datacamp<- read_html(python.datacamp)

##checking if it uploded corectly by seeing if status is 2xx, and here it was 200 so it is working
r.datacamp<-html_session("https://www.datacamp.com/courses/tech:r")
python.datacamp<-html_session("www.datacamp.com/courses/tech:python")


## .course-block__title is the node for R.datacamp, and for python .course-block__title
r.node<-as.data.frame(html_text(html_nodes(r.datacamp, ".course-block__title")))
r<-cbind(r.node, "R")

#naming the column
colnames(r)<-c("Tech","Language")

##adding node to python also
python.node<-as.data.frame(html_text(html_nodes(python.datacamp,".course-block__title")))
p<-cbind(python.node,"Python")
p
##naming the colomn
colnames(p)<- c("Tech", "Language")


##gather both in same long data frame
x<-bind_rows(r,p)
#colnames(x)<-c("Tech","")
view(x)









