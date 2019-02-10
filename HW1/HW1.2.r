urlfile <- 'https://raw.githubusercontent.com/znzhao/ECO395M-HW-zz5339/master/HW1/ABIA.csv'
ABIA <- read.csv(url(urlfile), stringsAsFactors=FALSE)
urlfile2 = 'https://raw.githubusercontent.com/znzhao/ECO395M-HW-zz5339/master/HW1/airports.csv'
airports <- read.csv(url(urlfile2), stringsAsFactors=FALSE)
library(tidyverse)
library(maps)
library(RColorBrewer)
library(gganimate)
library(gifski)

myABIA = ABIA
USairports <- subset(airports,(airports$iso_country =="US"))

# Q1: What is the best time of day to fly to minimize delays?
# Calculate delaying departure time:
myABIA$TWindow = floor(myABIA$DepTime/100)
myABIA$CRSTWindow_D = floor(myABIA$CRSDepTime/100)
myABIA$CRSTWindow_A = floor(myABIA$CRSArrTime/100)
myABIA$INorOUT[myABIA$Dest == "AUS"] = "Arrival"
myABIA$INorOUT[myABIA$Origin == "AUS"] = "Departure"
myABIA_fly <- subset(myABIA,(myABIA$Cancelled == "0"))
myABIA_fly <- subset(myABIA_fly,!(myABIA_fly$Diverted == 1))
myABIA_cancel <- subset(myABIA,(myABIA$Cancelled == "1"))

# plot the summ for all the airline companies 
myABIA_CRSsumm_D_total <- myABIA_fly %>%
  group_by(CRSTWindow_D,INorOUT) %>%
  summarise(DepDelay_mean = mean(DepDelay))

myABIA_CRSsumm_A_total <- myABIA_fly %>%
  group_by(CRSTWindow_A,INorOUT) %>%
  summarise(ArrDelay_mean = mean(ArrDelay))

p1 = ggplot(data = subset(myABIA_CRSsumm_D_total,(myABIA_CRSsumm_D_total$INorOUT == "Departure")))+
  geom_bar(aes(x = CRSTWindow_D, y = DepDelay_mean),stat='identity',position='dodge')+
  labs(title = "CRS Time vs Average Departure Delay", x = "CRS Time", y = "Departure Delay")+
  theme_bw()+
  theme(plot.title = element_text(hjust = 0.5))
p1
p2 = ggplot(data = subset(myABIA_CRSsumm_A_total,(myABIA_CRSsumm_A_total$INorOUT == "Arrival")))+
  geom_bar(aes(x = CRSTWindow_A, y = ArrDelay_mean),stat='identity',position='dodge')+
  labs(title = "CRS Time vs Average Arrival Delay", x = "CRS Time", y = "Arrival Delay")+
  theme_bw()+
  theme(plot.title = element_text(hjust = 0.5))
p2
# Now for different airline companies
# myABIA_CRSsumm_Departure <- subset(myABIA_CRSsumm_Departure,(myABIA_CRSsumm_Departure$UniqueCarrier != "YV"))
myABIA_CRSsumm_Departure <- myABIA_fly %>%
  group_by(CRSTWindow_D,INorOUT,UniqueCarrier) %>%
  summarise(DepDelay_mean = mean(DepDelay))
myABIA_CRSsumm_Departure <- subset(myABIA_CRSsumm_Departure,(myABIA_CRSsumm_Departure$INorOUT == "Departure"))
myABIA_CRSsumm_Arrival <- myABIA_fly %>%
  group_by(CRSTWindow_A,INorOUT,UniqueCarrier) %>%
  summarise(ArrDelay_mean = mean(ArrDelay))
myABIA_CRSsumm_Arrival <- subset(myABIA_CRSsumm_Arrival,(myABIA_CRSsumm_Arrival$INorOUT == "Arrival"))

# calculate the max point for D
Delay_D_max = aggregate(myABIA_CRSsumm_Departure$DepDelay_mean,by=list(name=myABIA_CRSsumm_Departure$UniqueCarrier),FUN=max)
for (i in Delay_D_max$name) {
  x = myABIA_CRSsumm_Departure$CRSTWindow_D[which((myABIA_CRSsumm_Departure$DepDelay_mean == Delay_D_max$x[Delay_D_max$name == i]))]
  Delay_D_max$time[Delay_D_max$name == i] <- x
}
colnames(Delay_D_max)[1:3] <- c("UniqueCarrier", "Vmax", "CRSTWindow_D")
p3 = ggplot()+
  geom_bar(data = myABIA_CRSsumm_Departure, aes(x = CRSTWindow_D, y = DepDelay_mean),stat='identity')+
  facet_wrap(~UniqueCarrier) +
  geom_bar(data = Delay_D_max, aes(x = CRSTWindow_D, y = Vmax),stat='identity', fill = "red")+
  labs(title = "CRS Time vs Average Departure Delay for Different Airline Company", x = "CRS Time", y = "Departure Delay")+
  theme_bw()+
  theme(plot.title = element_text(hjust = 0.5))
p3

Delay_A_max = aggregate(myABIA_CRSsumm_Arrival$ArrDelay_mean,by=list(name=myABIA_CRSsumm_Arrival$UniqueCarrier),FUN=max)
for (i in Delay_A_max$name) {
  x = myABIA_CRSsumm_Arrival$CRSTWindow_A[which((myABIA_CRSsumm_Arrival$ArrDelay_mean == Delay_A_max$x[Delay_A_max$name == i]))]
  Delay_A_max$time[Delay_A_max$name == i] <- x
}
colnames(Delay_A_max)[1:3] <- c("UniqueCarrier", "Vmax", "CRSTWindow_A")

p4 = ggplot()+
  geom_bar(data = myABIA_CRSsumm_Arrival, aes(x = CRSTWindow_A, y = ArrDelay_mean),stat='identity')+
  facet_wrap(~UniqueCarrier) +
  geom_bar(data = Delay_A_max, aes(x = CRSTWindow_A, y = Vmax),stat='identity', fill = "red")+
  labs(title = "CRS Time vs Average Arrival Delay for Different Airline Company", x = "CRS Time", y = "Arrival Delay")+
  theme_bw()+
  theme(plot.title = element_text(hjust = 0.5))
p4


# Q2: What is the best time of year to fly to minimize delays?
# plot the summ for all the airline companies 
myABIA_summ_Month <- myABIA_fly %>%
  group_by(Month,INorOUT) %>%
  summarise(DepDelay_mean = mean(DepDelay),ArrDelay_mean = mean(ArrDelay))

p5 = ggplot(data = subset(myABIA_summ_Month,(myABIA_summ_Month$INorOUT == "Departure")))+
  geom_bar(aes(x = Month, y = DepDelay_mean),stat='identity',position='dodge')+
  labs(title = "Month vs Average Departure Delay", x = "Month", y = "Departure Delay")+
  theme_bw()+
  scale_x_continuous(breaks = c(1,2,3,4,5,6,7,8,9,10,11,12),labels = c("1" = "Jan", "2" = "Feb", "3" = "Mar", "4" = "Apr", "5" = "May", "6" = "Jun", "7" = "Jul", "8" = "Aug", "9" = "Sep", "10" = "Oct", "11" = "Nov", "12" = "Dec"))+
  theme(plot.title = element_text(hjust = 0.5))
p5
p6 = ggplot(data = subset(myABIA_summ_Month,(myABIA_summ_Month$INorOUT == "Arrival")))+
  geom_bar(aes(x = Month, y = ArrDelay_mean),stat='identity',position='dodge')+
  labs(title = "Month vs Average Arrival Delay", x = "Month", y = "Arrival Delay")+
  scale_x_continuous(breaks = c(1,2,3,4,5,6,7,8,9,10,11,12),labels = c("1" = "Jan", "2" = "Feb", "3" = "Mar", "4" = "Apr", "5" = "May", "6" = "Jun", "7" = "Jul", "8" = "Aug", "9" = "Sep", "10" = "Oct", "11" = "Nov", "12" = "Dec"))+
  theme_bw()+
  theme(plot.title = element_text(hjust = 0.5))
p6


# Q3: How do patterns of flights to different destinations or parts of the country change over the course of the year?
# first get the location of the Destination and the Origin
USairportLocation = USairports[ , c("local_code","name","latitude_deg","longitude_deg")]
# add missing value:
USairportLocation <- rbind(USairportLocation, c("PHL","Philadelphia International Airport", 39.874400, -75.242400))
USairportLocation <- rbind(USairportLocation, c("PHX","Phoenix Sky Harbor International Airport", 33.448400, -112.07400))
# link airport location
myABIA2 = merge(myABIA_fly,USairportLocation,by.x = "Dest", by.y = "local_code", all.x = TRUE)
colnames(myABIA2)[34:36] <- c("DestAirport", "D_lat", "D_long")
myABIA3 = merge(myABIA2,USairportLocation,by.x = "Origin", by.y = "local_code", all.x = TRUE)
colnames(myABIA3)[37:39] <- c("OriginAirport", "O_lat", "O_long")

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

Air_summA = subset(Air_summ, Air_summ$INorOUT=="Arrival")
Air_summD = subset(Air_summ, Air_summ$INorOUT=="Departure")

p7 = ggplot(data = Air_summA)+
  geom_point(aes(O_long,O_lat))+
  geom_point(aes(D_long,D_lat))+
  geom_segment(aes(x = O_long, y = O_lat, xend = D_long, yend = D_lat, col = airline),size = 0.8)+
  theme_gray()+
  theme(plot.title = element_text(hjust = 0.5), panel.grid.major = element_blank(),  panel.grid.minor = element_blank())+
  scale_x_discrete()+
  scale_y_discrete()+
  scale_colour_gradient2(low="green", high="Purple")+
  borders("state")+
  scale_size_area()+
  coord_quickmap()+
  transition_states(
    Month,
    transition_length = 0,
    state_length = 1
    ) + 

  labs(title = 'Arrival Flight Volume Heat Map by Month: {closest_state}', x = "", y = "") +

  ease_aes('sine-in-out')
p7

p8 = ggplot(data = Air_summD)+
  geom_point(aes(O_long,O_lat))+
  geom_point(aes(D_long,D_lat))+
  geom_segment(aes(x = O_long, y = O_lat, xend = D_long, yend = D_lat, col = airline),size = 0.8)+
  theme_gray()+
  theme(plot.title = element_text(hjust = 0.5), panel.grid.major = element_blank(),  panel.grid.minor = element_blank())+
  scale_x_discrete()+
  scale_y_discrete()+
  scale_colour_gradient2(low="green", high="Purple")+
  borders("state")+
  scale_size_area()+
  coord_quickmap()+
  transition_states(
    Month,
    transition_length = 0,
    state_length = 1
  ) + 

  labs(title = 'Departure Flight Volume Heat Map by Month: {closest_state}', x = "", y = "") +
  ease_aes('sine-in-out')
p8
# Mapping of all year
Air_summ2 <- myABIA3 %>%
  group_by(INorOUT, Origin, Dest) %>%
  summarise(O_long = mean(O_long),D_long = mean(D_long),O_lat = mean(O_lat),D_lat = mean(D_lat),airline = length(INorOUT), DepDelay = mean(DepDelay),ArrDelay = mean(ArrDelay))
Air_summ2$airport[Air_summ2$INorOUT == "Arrival"] <- Air_summ2$Origin[Air_summ2$INorOUT == "Arrival"]
Air_summ2$airport[Air_summ2$INorOUT == "Departure"] <- Air_summ2$Dest[Air_summ2$INorOUT == "Departure"]
Air_summ2$Delay[Air_summ2$INorOUT == "Departure"] <- Air_summ2$DepDelay[Air_summ2$INorOUT == "Arrival"]
Air_summ2$Delay[Air_summ2$INorOUT == "Arrival"] <- Air_summ2$ArrDelay[Air_summ2$INorOUT == "Departure"]
# num of flight
p9 = ggplot(data = Air_summ2)+
  geom_point(aes(O_long,O_lat))+
  geom_point(aes(D_long,D_lat))+
  geom_segment(aes(x = O_long, y = O_lat, xend = D_long, yend = D_lat, col = airline),size = 0.8)+
  facet_wrap(~ INorOUT)+
  labs(title = "Flight Count Heat Map", x = " ", y = " ")+
  theme_gray()+
  theme(plot.title = element_text(hjust = 0.5), panel.grid.major = element_blank(),  panel.grid.minor = element_blank())+
  scale_x_discrete()+
  scale_y_discrete()+
  scale_colour_gradient2(low="green", high="Purple")+
  borders("state")+
  scale_size_area()+
  coord_quickmap()
p9

# Q4: 
# delay of flight

Air_delay_departure = subset(Air_summ2, (Air_summ2$INorOUT == "Departure"))
p10 = ggplot(data = Air_delay_departure)+
  geom_bar(aes(x = reorder(airport, Delay), y = Delay),stat='identity',position='dodge')+
  coord_flip()+
  labs(title = "Average Departure Delay for Different Airport", y = "Departure Delay", x = "Airport")+
  theme_bw()+
  theme(plot.title = element_text(hjust = 0.5))
p10
Air_delay_arrival = subset(Air_summ2, (Air_summ2$INorOUT == "Arrival"))
p11 = ggplot(data = Air_delay_arrival)+
  geom_bar(aes(x = reorder(airport, Delay), y = Delay),stat='identity',position='dodge')+
  coord_flip()+
  labs(title = "Average Arrival Delay for Different Airport", y = "Arrival Delay", x = "Airport")+
  theme_bw()+
  theme(plot.title = element_text(hjust = 0.5))
p11
# delay of flight: mapping
p12 = ggplot(data = Air_summ2)+
  geom_point(aes(O_long,O_lat))+
  geom_point(aes(D_long,D_lat))+
  geom_segment(aes(x = O_long, y = O_lat, xend = D_long, yend = D_lat, col = Delay),size = 0.8)+
  facet_wrap(~ INorOUT)+
  scale_colour_gradient2(low="white", high="red")+
  borders("state")+
  labs(title = "Flight Count Heat Map", x = " ", y = " ")+
  scale_size_area()+
  theme(plot.title = element_text(hjust = 0.5), panel.grid.major = element_blank(),  panel.grid.minor = element_blank())+
  scale_x_discrete()+
  scale_y_discrete()+
  coord_quickmap()
p12
