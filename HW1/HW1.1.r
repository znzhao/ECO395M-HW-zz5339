urlfile<-'https://raw.githubusercontent.com/jgscott/ECO395M/master/data/greenbuildings.csv'
greenbuildings<-read.csv(url(urlfile))
library(tidyverse)
library(RColorBrewer)


summary(greenbuildings)
#data.frame(table(greenbuildings$cluster)) #group by cluster and count

# Occupancy Rates & Rent Plot: NonGreen vs Green
labels <- c("0" = "Non-Green", "1" = "Green")
NG <- subset(data = greenbuildings, greenbuildings$green_rating == "0")
p1 <- ggplot(data = greenbuildings) + 
  geom_point(mapping = aes(x = Rent, y = leasing_rate),alpha = 0.3, col = brewer.pal(6, "Greens")[5])+
  facet_wrap(~ green_rating, labeller=labeller(green_rating = labels))+
  labs(title = "Occupancy Rates vs Rent", 
       x = "Rent",
       y = "Occupancy Rates")+
  theme(plot.title = element_text(hjust = 0.5)) 
p1 + geom_point(data = NG, mapping = aes(x = Rent, y = leasing_rate), alpha = 0.3, col = brewer.pal(6, "Reds")[5])
#Note: Occupancy rate as a function of rent, it seems like occupacy rate is positive proportional to the rent,
#Note:possibly suggesting higher occupancy rate -> higher demand -> higher rent

# clean data by deleting the data with occupacy rate equal to 0% and taller than 56 floor
GB_test <- subset(greenbuildings,(greenbuildings$stories > 56))
Clus = unique(GB_test$cluster)

GB_cleaned <- subset(greenbuildings,(greenbuildings$leasing_rate != 0))
for (i in 1:39){
  GB_cleaned <-subset(GB_cleaned,(GB_cleaned$cluster!= Clus[i]))
}

GB_cleaned$Green[GB_cleaned$green_rating==0] <- "Non-Green"
GB_cleaned$Green[GB_cleaned$green_rating==1] <- "Green"
summary(GB_cleaned$leasing_rate)
summary(GB_cleaned$green_rating)
#count(greenbuildings, leasing_rate==0) : 152/7742, count(greenbuildings, leasing_rate<=10) : 215/7742
#Note:better explanation with 0% than 10%, we could just say the buildings are either underconstruction/operational 

# basic boxplot
NG_one <- subset(GB_cleaned, green_rating == "0")
NG_one$Green[NG_one$green_rating==0] <- "Non-Green"
NG_one$Green[NG_one$green_rating==1] <- "Green"
p2 = ggplot(data = GB_cleaned, aes(x = Green, y = Rent)) + 
  geom_boxplot(fill = brewer.pal(9, "Greens")[3])+
  labs(title = "Rent vs Green Rating",
       x = "",
       y = "Rent")+
  theme(plot.title = element_text(hjust = 0.5))
p2 + geom_boxplot(data = NG_one, fill = brewer.pal(9, "Reds")[3])

# Size & Rent Plot: NonGreen vs Green
#p3 = ggplot(data = GB_cleaned) + 
#  geom_point(mapping = aes(x = size, y = Rent, shape = Green, color = Green),alpha =0.8)+
#  labs(title = "Size & Rent Plot", 
#       x = "Size",
#       y = "Rent")+
#  theme(plot.title = element_text(hjust = 0.5))
#p3

# Size density
summary(GB_cleaned$size)
p3 = ggplot(data = GB_cleaned, aes(x = size))+
  geom_density(aes(fill=factor(Green)),alpha = 0.5)+
  #scale_fill_brewer(palette= "Greens",direction = -1)+
  labs(title = "Density of Size", x = "Size", y = "Density")+
  theme(plot.title = element_text(hjust = 0.5))
p3 + scale_fill_manual( values = c(brewer.pal(9, "Greens")[3],brewer.pal(9, "Reds")[3]))

#Stories Densities
p4 = ggplot(data = GB_cleaned, aes(x = stories))+
  geom_density(aes(fill=factor(Green)),alpha = 0.5)+
  labs(title = "Density of Stories", x = "Story", y = "Density")+
  theme(plot.title = element_text(hjust = 0.5))
p4 + scale_fill_manual( values = c(brewer.pal(9, "Greens")[3],brewer.pal(9, "Reds")[3]))

# category: https://en.wikipedia.org/wiki/List_of_building_types
GB_cleaned$size_category = cut(GB_cleaned$size, breaks = c(0,125000,400000,800000,10000000000))
GB_cleaned$stories_category = cut(GB_cleaned$stories, breaks = c("0","7","25","150"))
GB_cleaned$stories_category <- factor(GB_cleaned$stories_category, labels = c(expression("Low Rise("<"7)"), "Mid~Rise (7-25)", expression("High Rise(">"25)")))
GB_summ <- GB_cleaned %>%
  group_by(size_category,Green,stories_category) %>%
  summarise(Rent_median = median(Rent), Rent_mean = mean(Rent), leasing_rate = mean(leasing_rate))

# Plot of Different Size
# Comment_Chong: green is not pricier than non-green from the plot
# labels <- c("0" = "Non-Green", "1" = "Green")

p5 = ggplot(GB_summ, aes(x=size_category, y=Rent_median)) + 
  geom_bar(aes(fill = Green),stat='identity',position='dodge') +
  facet_wrap(~ stories_category, labeller = label_parsed) +
  #scale_fill_brewer(palette= "Greens",direction = -1)+
  labs(title = "Median of Different Size Groups", x = "Size", y = "Rent")+
  theme(plot.title = element_text(hjust = 0.5))
p5  + scale_fill_manual( values = c(brewer.pal(9, "Greens")[3],brewer.pal(9, "Reds")[3]))

p6 = ggplot(GB_summ, aes(x=size_category, y=Rent_mean)) + 
  geom_bar(aes(fill = Green),stat='identity',position='dodge')+
  #scale_fill_brewer(palette= "Greens",direction = -1)+
  facet_wrap(~ stories_category, labeller = label_parsed) +
  labs(title = "Mean of Different Size Groups", x = "Size", y = "Rent")+
  theme(plot.title = element_text(hjust = 0.5))
p6 + scale_fill_manual( values = c(brewer.pal(9, "Greens")[3],brewer.pal(9, "Reds")[3]))

# Age of the Building
p7 = ggplot(data = GB_cleaned, aes(x = age, y = Rent, col = Green)) + 
  geom_point(aes(x = age, y = Rent, col = Green), alpha =0.7)+
  geom_smooth(se = TRUE)+
  scale_colour_brewer(palette= "Accent",direction = 1)+
  labs(title = "Age & Rent Plot")+
  theme(plot.title = element_text(hjust = 0.5))
p7
# Gas and Electricity Price
GB_cleaned$Gas_category = cut(GB_cleaned$Gas_Costs, 4)
GB_cleaned$E_category = cut(GB_cleaned$Electricity_Costs,3)

GB_summ1 <- GB_cleaned %>%
  group_by(Gas_category,E_category, Green) %>%
  summarise(Rent_median = median(Rent), Rent_mean = mean(Rent), leasing_rate = mean(leasing_rate))
p8 = ggplot(GB_summ1, aes(x=Gas_category, y=Rent_median)) + 
  geom_bar(aes(fill = Green),stat='identity',position='dodge')+
  facet_wrap(~ E_category)+
  scale_fill_brewer(palette= "Greens",direction = -1)+
  labs(title = "Median of Different Electricity and Gas Cost Groups")+
  theme(plot.title = element_text(hjust = 0.5))
p8

p9 = ggplot(GB_summ1, aes(x=Gas_category, y=Rent_mean)) + 
  geom_bar(aes(fill = Green),stat='identity',position='dodge')+
  facet_wrap(~ E_category)+
  scale_fill_brewer(palette= "Greens",direction = -1)+
  labs(title = "Median of Different Electricity and Gas Cost Groups")+
  theme(plot.title = element_text(hjust = 0.5))
p9





# Which occupancy rate should be chosen?

# Size & Occupancy Rate Plot
GB_summ2 <- GB_cleaned %>%
  group_by(size_category,Green) %>%
  summarise(Rent_median = median(Rent), Rent_mean = mean(Rent), leasing_rate = mean(leasing_rate))

p10 = ggplot(GB_summ2,aes(x = size_category, y = leasing_rate))+
  geom_bar(aes(fill = Green),stat='identity',position='dodge')+
  scale_fill_brewer(palette= "Greens",direction = -1)+
  labs(title = "Size & Occupancy Rate Plot",
       y = "Occupancy rate",
       x = "size")+
  theme(plot.title = element_text(hjust = 0.5))
p10

# Occupancy Rate and rich area
GB_summ3 <-GB_cleaned %>%
  group_by(cluster) %>%
  summarise(building_num = length(cluster), leasing_rate = mean(leasing_rate))
# ???? do you think there is any corelation?
p11 = ggplot()+
  geom_point(data = GB_summ3, aes(x = building_num, y = leasing_rate))
p11

# Age of the Building and leasing rate
GB_summ4 <-GB_cleaned %>%
  group_by(age, Green) %>%
  summarise(leasing_rate = mean(leasing_rate))
GB_summ4$age <- as.numeric(GB_summ4$age)
GB_summ4 <- subset(GB_summ4, (GB_summ4$age<30))

p12 = ggplot()+
  geom_bar(data = subset(GB_summ4,(GB_summ4$Green == "Green")), aes(x = age, y = leasing_rate),stat='identity', fill = brewer.pal(9, "Greens")[6], alpha = 0.5)+
  geom_bar(data = subset(GB_summ4,(GB_summ4$Green == "Non-Green")), aes(x = age, y = leasing_rate),stat='identity', fill = brewer.pal(9, "Greens")[3], alpha = 0.5)+
  geom_point(data = GB_summ4, aes(x = age, y = leasing_rate, col = Green))+
  geom_line(data = GB_summ4, aes( x = age, y = leasing_rate, col = Green))+
  scale_colour_brewer(palette= "Accent",direction = 1)+
  labs(title = "Age & Occupancy Rate Plot",
       y = "Occupancy rate",
       x = "Age of the building")+
  theme(plot.title = element_text(hjust = 0.5))
p12

