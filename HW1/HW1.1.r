#By Chong test again
greenbuildings <- read.csv("E:/Homework/DataMining/ECO395M-HW-zz5339/HW1/greenbuildings.csv")
library(tidyverse)

summary(greenbuildings)

# Occupancy Rates & Rent Plot: NonGreen vs Green
labels <- c("0" = "Non-Green", "1" = "Green")
p1 = ggplot(data = greenbuildings) + 
  geom_point(mapping = aes(x = leasing_rate, y = Rent),alpha = 0.6)+
  facet_wrap(~ green_rating, labeller=labeller(green_rating = labels))+
  labs(title = "Occupancy Rates & Rent Plot", 
       x = "Occupancy Rates",
       y = "Rent")+
  theme(plot.title = element_text(hjust = 0.5))
p1

# clean data by deleting the data with occupacy rate lower than or equal to 10%
GB_cleaned <- subset(greenbuildings,(greenbuildings$leasing_rate > 10))
GB_cleaned$Green[GB_cleaned$green_rating==0] <- "Non-Green"
GB_cleaned$Green[GB_cleaned$green_rating==1] <- "Green"
summary(GB_cleaned$leasing_rate)
summary(GB_cleaned$green_rating)

# basic boxplot
p2 = ggplot(data = GB_cleaned, aes(x = Green, y = Rent)) + 
  geom_boxplot()+
  labs(title = "Rent Plot",
       x = "",
       y = "Rent")+
  theme(plot.title = element_text(hjust = 0.5))
p2

# Size & Rent Plot: NonGreen vs Green
p3 = ggplot(data = GB_cleaned) + 
  geom_point(mapping = aes(x = size, y = Rent, shape = Green, color = Green),alpha =0.8)+
  labs(title = "Size & Rent Plot", 
       x = "Size",
       y = "Rent")+
  theme(plot.title = element_text(hjust = 0.5))
p3

# summary size
summary(GB_cleaned$size)
p4 = ggplot(data = GB_cleaned, aes(x = size))+
  geom_density(aes(fill=factor(Green)),alpha = 0.6)+
  labs(title = "Density of Size")+
  theme(plot.title = element_text(hjust = 0.5))
p4

GB_cleaned$size_category = cut(GB_cleaned$size, 9)
GB_summ <- GB_cleaned %>%
  group_by(size_category,Green) %>%
  summarise(Rent_median = median(Rent), leasing_rate = mean(leasing_rate))

# Plot of Different Size
# Comment_Chong: green is not pricier than non-green from the plot
p5 = ggplot(GB_summ, aes(x=size_category, y=Rent_median)) + 
  geom_bar(aes(fill = Green),stat='identity',position='dodge')+
  coord_flip()+
  labs(title = "Median of Different Size Groups")+
  theme(plot.title = element_text(hjust = 0.5))
p5

# Age of the Building
p6 = ggplot(data = GB_cleaned, aes(x = age, y = Rent, color = Green)) + 
  geom_point(alpha =0.8)+
  geom_smooth(se = TRUE)+
  labs(title = "Age & Rent Plot")+
  theme(plot.title = element_text(hjust = 0.5))
p6


# Which occupancy rate should be chosen?

p7 = ggplot(GB_summ,aes(x = size_category, y = leasing_rate))+
  geom_bar(aes(fill = Green),stat='identity',position='dodge')+
  coord_flip()+
  labs(title = "Size & Occupancy Rate Plot",
       x = "Occupancy rate",
       y = "size")+
  theme(plot.title = element_text(hjust = 0.5))
p7



