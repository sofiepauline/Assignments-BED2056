rm(list = ls())

#install.packages("PxWebApiData")
library(PxWebApiData)

?ApiData

county <- ApiData("http://data.ssb.no/api/v0/dataset/95274.json?lang=no",
                  getDataByGET = TRUE)

whole_country <- ApiData("http://data.ssb.no/api/v0/dataset/95276.json?lang=no",
                         getDataByGET = TRUE)

# two similar lists, different labels and coding
head(county[[1]])
head(county[[2]])

head(whole_country[[1]])

# Use first list, rowbind both data
dframe <- bind_rows(county[[1]], whole_country[[1]])


# new names, could have used dplyr::rename()
names(dframe)
names(dframe) <- c("region", "date", "variable", "value")
str(dframe)

# Split date
dframe <- dframe %>% separate(date, 
                              into = c("year", "month"), 
                              sep = "M")
head(dframe)

# Make a new proper date variable
library(lubridate)
dframe <- dframe %>%  mutate(date = ymd(paste(year, month, 1)))
str(dframe)

# And how many levels has the variable?
dframe %>% select(variable) %>% unique()

# car::recode()
dframe <- dframe %>%  mutate(variable1 = car::recode(dframe$variable,
                                                     ' "Utleigde rom"="rentedrooms";
"Pris per rom (kr)"="roomprice";
"Kapasitetsutnytting av rom (prosent)"="roomcap";
"Kapasitetsutnytting av senger (prosent)"="bedcap";
"Losjiomsetning (1 000 kr)"="revenue";
"Losjiomsetning per tilgjengeleg rom (kr)"="revperroom";
"Losjiomsetning, hittil i Ã¥r (1 000 kr)"="revsofar";
"Losjiomsetning per tilgjengeleg rom, hittil i Ã¥r (kr)"="revroomsofar";
"Pris per rom hittil i Ã¥r (kr)"="roompricesofar";
"Kapasitetsutnytting av rom hittil i Ã¥r (prosent)"="roomcapsofar";
"Kapasitetsutnytting av senger, hittil i Ã¥r (prosent)"="bedcapsofar" '))

dframe %>% select(variable1) %>% unique()
with(dframe, table(variable, variable1))

# dplyr::recode()
dframe <- dframe %>% mutate(variable2 = dplyr::recode(variable,
                                                      "Utleigde rom"="rentedrooms",
                                                      "Pris per rom (kr)"="roomprice",
                                                      "Kapasitetsutnytting av rom (prosent)"="roomcap",
                                                      "Kapasitetsutnytting av senger (prosent)"="bedcap",
                                                      "Losjiomsetning (1 000 kr)"="revenue",
                                                      "Losjiomsetning per tilgjengeleg rom (kr)"="revperroom",
                                                      "Losjiomsetning, hittil i Ã¥r (1 000 kr)"="revsofar",
                                                      "Losjiomsetning per tilgjengeleg rom, hittil i Ã¥r (kr)"="revroomsofar",
                                                      "Pris per rom hittil i Ã¥r (kr)"="roompricesofar",
                                                      "Kapasitetsutnytting av rom hittil i Ã¥r (prosent)"="roomcapsofar",
                                                      "Kapasitetsutnytting av senger, hittil i Ã¥r (prosent)"="bedcapsofar"))

dframe %>% select(variable2) %>% unique()
with(dframe, table(variable, variable2))



# recode region
dframe <- dframe %>% mutate(region = 
                              ifelse(region == "Hele landet",
                                     "Whole country", region))

mosaic::tally(~region, data = dframe)

##giving the countys differente names so looks tidy 
dframe <- dframe %>% mutate(region = dplyr::recode(region,
                                                   "Troms og Finnmark - Romsa ja Finnmárku"="Troms Finnmark",
                                                   "Trøndelag - Trööndelage"="Trøndelag"))

### Plotting for variable region over time (all counties and the whole country)
library(ggplot2)

dframe %>%
  filter(variable2=="roomcap") %>%
  ggplot(aes(x=date,y=value,group= region)) +
  geom_line(aes(color= region)) +
  ylab(expression("Ledig romkapasitet"))+
  xlab(expression("Månder"))+
  ggtitle("Ledig romkapasitet i norske fylker")
theme_linedraw()