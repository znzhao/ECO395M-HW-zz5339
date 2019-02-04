ABIA <- read.csv("E:/Homework/DataMining/ECO395M-HW-zz5339/HW1/ABIA.csv", stringsAsFactors=FALSE)
airports <- read.csv("E:/Homework/DataMining/ECO395M-HW-zz5339/HW1/airports.csv", stringsAsFactors=FALSE)
library(tidyverse)
library(maps)
library(rgeos)
library(maptools)
library(ggthemes)
myABIA = ABIA
USairports <- subset(airports,(airports$iso_country =="US"))
# 
# map("state", fill = TRUE, col = terrain.colors(5))
# USairports <- subset(airports,(airports$iso_country =="US"))
# sample <- subset(USairports,(USairports$scheduled_service =="yes"))
# sample2 <- subset(sample,(sample$type =="heliport"))
# sample2$latitude_deg <- as.numeric(sample2$latitude_deg)
# sample2$longitude_deg <- as.numeric(sample2$longitude_deg)
# 
# ggplot(data = sample2,aes(longitude_deg,latitude_deg))+
#   geom_point()+
#   borders("state")
 
# Q1: What is the best time of day to fly to minimize delays?
# Calculate delaying departure time:
myABIA$TWindow = floor(myABIA$CRSDepTime/100)
myABIA$INorOUT[myABIA$Dest == "AUS"] = "Arrival"
myABIA$INorOUT[myABIA$Origin == "AUS"] = "Departure"
myABIA[is.na(myABIA)]<-0
myABIA_summ <- myABIA %>%
  group_by(TWindow,INorOUT) %>%
  summarise(DepDelay_mean = mean(DepDelay),ArrDelay_mean = mean(ArrDelay))

ggplot(data = myABIA_summ)+
  geom_bar(aes(x = TWindow, y = DepDelay_mean, fill = INorOUT),stat='identity',position='dodge')
ggplot(data = myABIA_summ)+
  geom_bar(aes(x = TWindow, y = ArrDelay_mean, fill = INorOUT),stat='identity',position='dodge')


# Q2:



# Q3: How do patterns of flights to different destinations or parts of the country change over the course of the year?
# first get the location of the Destination and the Origin
USairportLocation = USairports[ , c("local_code","name","latitude_deg","longitude_deg")]
myABIA2 = merge(myABIA,USairportLocation,by.x = "Dest", by.y = "local_code", all.x = TRUE)
colnames(myABIA2)[32:34] <- c("DestAirport", "D_lat", "D_long")
myABIA3 = merge(myABIA2,USairportLocation,by.x = "Origin", by.y = "local_code", all.x = TRUE)
colnames(myABIA3)[35:37] <- c("OriginAirport", "O_lat", "O_long")

myABIA3$D_lat <- as.numeric(myABIA3$D_lat)
myABIA3$O_lat <- as.numeric(myABIA3$O_lat)
myABIA3$D_long <- as.numeric(myABIA3$D_long)
myABIA3$O_long <- as.numeric(myABIA3$O_long)


Air_summ <- myABIA3 %>%
  group_by(Month, INorOUT, Origin, Dest) %>%
  summarise(O_long = mean(O_long),D_long = mean(D_long),O_lat = mean(O_lat),D_lat = mean(D_lat),airline = length(INorOUT), Delay = mean(DepDelay))
Air_summ2 <- myABIA3 %>%
  group_by(INorOUT, Origin, Dest) %>%
  summarise(O_long = mean(O_long),D_long = mean(D_long),O_lat = mean(O_lat),D_lat = mean(D_lat),airline = length(INorOUT), Delay = mean(DepDelay))


# Mapping

ggplot(data = Air_summ2)+
  geom_point(aes(O_long,O_lat))+
  geom_point(aes(D_long,D_lat))+
  geom_segment(aes(x = O_long, y = O_lat, xend = D_long, yend = D_lat, col = airline),size = 0.8)+
  facet_wrap(~ INorOUT)+
  scale_colour_gradient2(low="white", high="blue")+
  borders("state")

ggplot(data = Air_summ2)+
  geom_point(aes(O_long,O_lat))+
  geom_point(aes(D_long,D_lat))+
  geom_segment(aes(x = O_long, y = O_lat, xend = D_long, yend = D_lat, col = Delay),size = 0.8)+
  facet_wrap(~ INorOUT)+
  scale_colour_gradient2(low="white", high="red")+
  borders("state")




