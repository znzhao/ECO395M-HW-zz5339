urlfile <- 'https://raw.githubusercontent.com/znzhao/ECO395M-HW-zz5339/master/HW1/ABIA.csv'
ABIA <- read.csv(url(urlfile), stringsAsFactors=FALSE)
urlfile2 = 'https://raw.githubusercontent.com/znzhao/ECO395M-HW-zz5339/master/HW1/airports.csv'
airports <- read.csv(url(urlfile2), stringsAsFactors=FALSE)
library(tidyverse)
library(maps)
library(RColorBrewer)

myABIA = ABIA
USairports <- subset(airports,(airports$iso_country =="US"))

# Q1: What is the best time of day to fly to minimize delays?
# Calculate delaying departure time:
myABIA$TWindow = floor(myABIA$DepTime/100)
myABIA$CRSTWindow = floor(myABIA$CRSDepTime/100)
myABIA$INorOUT[myABIA$Dest == "AUS"] = "Arrival"
myABIA$INorOUT[myABIA$Origin == "AUS"] = "Departure"
myABIA_fly <- subset(myABIA,(myABIA$Cancelled == "0"))
myABIA_fly <- subset(myABIA_fly,!(myABIA_fly$Diverted == 1))
myABIA_cancel <- subset(myABIA,(myABIA$Cancelled == "1"))
myABIA_Tsumm <- myABIA_fly %>%
  group_by(TWindow,INorOUT) %>%
  summarise(DepDelay_mean = mean(DepDelay),ArrDelay_mean = mean(ArrDelay))
myABIA_CRSsumm <- myABIA_fly %>%
  group_by(CRSTWindow,INorOUT) %>%
  summarise(DepDelay_mean = mean(DepDelay),ArrDelay_mean = mean(ArrDelay))
# P1 and P2 looks weird.
# 1:00AM - 5:00AM looks abnormal, because sample size in this range is too small.
p1 = ggplot(data = myABIA_Tsumm)+
  geom_bar(aes(x = TWindow, y = DepDelay_mean, fill = INorOUT),stat='identity',position='dodge')
p1
p2 = ggplot(data = myABIA_Tsumm)+
  geom_bar(aes(x = TWindow, y = ArrDelay_mean, fill = INorOUT),stat='identity',position='dodge')
p2
# This is much better:
p3 = ggplot(data = myABIA_CRSsumm)+
  geom_bar(aes(x = CRSTWindow, y = DepDelay_mean, fill = INorOUT),stat='identity',position='dodge')
p3
p4 = ggplot(data = myABIA_CRSsumm)+
  geom_bar(aes(x = CRSTWindow, y = ArrDelay_mean, fill = INorOUT),stat='identity',position='dodge')
p4

# Q2: What is the best time of year to fly to minimize delays?

myABIA_summ3 <- myABIA_fly %>%
  group_by(Month,INorOUT) %>%
  summarise(DepDelay_mean = mean(DepDelay),ArrDelay_mean = mean(ArrDelay))

p3 = ggplot(data = myABIA_summ3)+
  geom_bar(aes(x = Month, y = DepDelay_mean, fill = INorOUT),stat='identity',position='dodge')
p3
p4 = ggplot(data = myABIA_summ3)+
  geom_bar(aes(x = Month, y = ArrDelay_mean, fill = INorOUT),stat='identity',position='dodge')
p4


# Q3: How do patterns of flights to different destinations or parts of the country change over the course of the year?
# first get the location of the Destination and the Origin
USairportLocation = USairports[ , c("local_code","name","latitude_deg","longitude_deg")]
myABIA2 = merge(myABIA_fly,USairportLocation,by.x = "Dest", by.y = "local_code", all.x = TRUE)
colnames(myABIA2)[33:35] <- c("DestAirport", "D_lat", "D_long")
myABIA3 = merge(myABIA2,USairportLocation,by.x = "Origin", by.y = "local_code", all.x = TRUE)
colnames(myABIA3)[36:38] <- c("OriginAirport", "O_lat", "O_long")

myABIA3$D_lat <- as.numeric(myABIA3$D_lat)
myABIA3$O_lat <- as.numeric(myABIA3$O_lat)
myABIA3$D_long <- as.numeric(myABIA3$D_long)
myABIA3$O_long <- as.numeric(myABIA3$O_long)

# Mapping of different month
Air_summ <- myABIA3 %>%
  group_by(Month, INorOUT, Origin, Dest) %>%
  summarise(O_long = mean(O_long),D_long = mean(D_long),O_lat = mean(O_lat),D_lat = mean(D_lat),airline = length(INorOUT), Delay = mean(DepDelay))
Air_summ$airport[Air_summ$INorOUT == "Arrival"] <- Air_summ$Origin[Air_summ$INorOUT == "Arrival"]
Air_summ$airport[Air_summ$INorOUT == "Departure"] <- Air_summ$Dest[Air_summ$INorOUT == "Departure"]

p5 = ggplot(data = Air_summ)+
  geom_bar(aes(x = airport, y = Delay, fill = INorOUT),stat='identity',position='dodge')+
  facet_wrap(~ Month)
p5


# Mapping of all year
Air_summ2 <- myABIA3 %>%
  group_by(INorOUT, Origin, Dest) %>%
  summarise(O_long = mean(O_long),D_long = mean(D_long),O_lat = mean(O_lat),D_lat = mean(D_lat),airline = length(INorOUT), Delay = mean(DepDelay), Delay_sum = sum(DepDelay))
Air_summ2$airport[Air_summ2$INorOUT == "Arrival"] <- Air_summ2$Origin[Air_summ2$INorOUT == "Arrival"]
Air_summ2$airport[Air_summ2$INorOUT == "Departure"] <- Air_summ2$Dest[Air_summ2$INorOUT == "Departure"]

# num of flight
p6 = ggplot(data = Air_summ2)+
  geom_point(aes(O_long,O_lat))+
  geom_point(aes(D_long,D_lat))+
  geom_segment(aes(x = O_long, y = O_lat, xend = D_long, yend = D_lat, col = airline),size = 0.8)+
  facet_wrap(~ INorOUT)+
  scale_colour_gradient2(low="green", high="Purple")+
  borders("state")+
  scale_size_area()+
  coord_quickmap()
p6


# delay of flight
Air_delay_arrival = subset(Air_summ2, (Air_summ2$INorOUT == "Arrival"))
p7 = ggplot(data = Air_delay_arrival)+
  geom_bar(aes(x = reorder(airport, Delay), y = Delay),stat='identity',position='dodge', fill = brewer.pal(9, "Greens")[3])+
  coord_flip()
p7
Air_delay_departure = subset(Air_summ2, (Air_summ2$INorOUT == "Departure"))
p8 = ggplot(data = Air_delay_departure)+
  geom_bar(aes(x = reorder(airport, Delay), y = Delay),stat='identity',position='dodge', fill = brewer.pal(9, "Greens")[3])+
  coord_flip()
p8

# Sum of Delay
Air_delay_arrival = subset(Air_summ2, (Air_summ2$INorOUT == "Arrival"))
p7 = ggplot(data = Air_delay_arrival)+
  geom_bar(aes(x = reorder(airport, Delay_sum), y = Delay_sum),stat='identity',position='dodge', fill = brewer.pal(9, "Greens")[3])+
  coord_flip()
p7
Air_delay_departure = subset(Air_summ2, (Air_summ2$INorOUT == "Departure"))
p8 = ggplot(data = Air_delay_departure)+
  geom_bar(aes(x = reorder(airport, Delay_sum), y = Delay_sum),stat='identity',position='dodge', fill = brewer.pal(9, "Greens")[3])+
  coord_flip()
p8

# delay of flight: mapping
p9 = ggplot(data = Air_summ2)+
  geom_point(aes(O_long,O_lat))+
  geom_point(aes(D_long,D_lat))+
  geom_segment(aes(x = O_long, y = O_lat, xend = D_long, yend = D_lat, col = Delay),size = 0.8)+
  facet_wrap(~ INorOUT)+
  scale_colour_gradient2(low="white", high="red")+
  borders("state")+
  scale_size_area()+
  coord_quickmap()
p9
# delay_summ of flight: mapping
p9 = ggplot(data = Air_summ2)+
  geom_point(aes(O_long,O_lat))+
  geom_point(aes(D_long,D_lat))+
  geom_segment(aes(x = O_long, y = O_lat, xend = D_long, yend = D_lat, col = Delay_sum),size = 0.8)+
  facet_wrap(~ INorOUT)+
  scale_colour_gradient2(low="white", high="red")+
  borders("state")+
  scale_size_area()+
  coord_quickmap()
p9
