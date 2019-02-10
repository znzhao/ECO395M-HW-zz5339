urlfile<-'https://raw.githubusercontent.com/znzhao/ECO395M-HW-zz5339/master/HW1/greenbuildings.csv'
greenbuildings<-read.csv(url(urlfile))
library(tidyverse)
library(RColorBrewer)


summary(greenbuildings)
#data.frame(table(greenbuildings$cluster)) #group by cluster and count
#theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank())

greenbuildings$Green[greenbuildings$green_rating==0] <- "Non-Green"
greenbuildings$Green[greenbuildings$green_rating==1] <- "Green"

# Occupancy Rates & Rent Plot: NonGreen vs Green
NG <- subset(greenbuildings, (greenbuildings$green_rating == "0"))
f1 <- ggplot(data = greenbuildings) + 
  geom_point(mapping = aes(y = Rent, x = leasing_rate),alpha = 0.3, col = brewer.pal(6, "Greens")[5])+
  facet_wrap(~ Green)+
  geom_point(data = NG, mapping = aes(y = Rent, x = leasing_rate), alpha = 0.3, col = brewer.pal(6, "Reds")[5])+
  labs(title = "Occupancy Rate vs Rent", 
       y = "Rent",
       x = "Occupancy Rate")+
  theme_bw()+
  theme(plot.title = element_text(hjust = 0.5))
f1 

#Note: Occupancy rate as a function of rent, it seems like occupacy rate is positive proportional to the rent,
#Note:possibly suggesting higher occupancy rate -> higher demand -> higher rent

# clean data by deleting the data with occupacy rate equal to 0% and taller than 56 floor
GB_test <- subset(greenbuildings,(greenbuildings$stories > 56))
Clus = unique(GB_test$cluster)

GB_cleaned <- subset(greenbuildings,(greenbuildings$leasing_rate != 0))
for (i in 1:39){
  GB_cleaned <-subset(GB_cleaned,(GB_cleaned$cluster!= Clus[i]))
}


summary(GB_cleaned$leasing_rate)
summary(GB_cleaned$green_rating)
#count(greenbuildings, leasing_rate==0) : 152/7742, count(greenbuildings, leasing_rate<=10) : 215/7742
#Note:better explanation with 0% than 10%, we could just say the buildings are either underconstruction/operational 

# basic boxplot
NG_one <- subset(GB_cleaned, green_rating == "0")
f2 = ggplot(data = GB_cleaned, aes(x = Green, y = Rent)) + 
  geom_boxplot(fill = brewer.pal(6, "Greens")[5], alpha = 0.8)+
  geom_boxplot(data = NG_one, fill = brewer.pal(6, "Reds")[5], alpha= 0.9)+
  labs(title = "Green Rating vs Rent",
       x = "Green Rating",
       y = "Rent")+
  theme_bw()+
  theme(plot.title = element_text(hjust = 0.5))
f2

# Size & Rent Plot: NonGreen vs Green
#p3 = ggplot(data = GB_cleaned) + 
#  geom_point(mapping = aes(x = size, y = Rent, shape = Green, color = Green),alpha =0.8)+
#  labs(title = "Size & Density", 
#       x = "Size",
#       y = "Density")+
#  theme(plot.title = element_text(hjust = 0.5))
#p3


# Size density
#summary(GB_cleaned$size)
#p3 = ggplot(data = GB_cleaned, aes(x = size))+
  #geom_density(aes(fill=Green),alpha = 0.9)+
  #geom_vline(xintercept = 250000)+
  #geom_label(aes(x=400000, y=3e-06, label="Aim Project"),stat = "identity")+
  #scale_fill_manual( values = c(brewer.pal(6, "Greens")[5],brewer.pal(6, "Reds")[5]))+
  #labs(title = "Size vs Density Plot", x = "Size", y = "Density")+
  #theme_bw()+
  #theme(plot.title = element_text(hjust = 0.5))
#p3
# Building is concentrating in small size 


NG <- subset(GB_cleaned, (GB_cleaned$Green == "Non-Green"))
f3 <- ggplot(data = GB_cleaned)+
  geom_point(mapping = aes(y = stories, x = size),alpha = 0.3, col = brewer.pal(6, "Greens")[5])+
  facet_wrap(~ Green)+
  geom_point(data = NG, mapping = aes(y = stories, x = size), alpha = 0.3, col = brewer.pal(6, "Reds")[5])+
  labs(title = "Size vs Story", 
       x = "Size",
       y = "Story")+
  theme_bw()+
  theme(plot.title = element_text(hjust = 0.5))
f3

  
#Stories Densities
#p5 = ggplot(data = GB_cleaned, aes(x = stories))+
  #geom_density(aes(fill = Green),alpha = 0.7)+
  #geom_vline(xintercept = 15)+
  #geom_label(aes(x=25, y=0.06, label="Aim Project"),stat = "identity")+
  #labs(title = "Stories vs Density Plot", x = "Stories", y = "Density",col="grey")+
  #theme_bw()+
  #theme(plot.title = element_text(hjust = 0.5)) + 
  #scale_fill_manual( values = c(brewer.pal(6, "Greens")[5],brewer.pal(6, "Reds")[5]))
#p5
# Building is concentrating in medium size 


# category: https://en.wikipedia.org/wiki/List_of_building_types
GB_cleaned$size_category = cut(GB_cleaned$size, breaks = c(0,125000,400000,800000,10000000000))
GB_cleaned$stories_category = cut(GB_cleaned$stories, breaks = c("0","7","25","150"))
GB_cleaned$stories_category <- factor(GB_cleaned$stories_category, labels = c(expression("Low Rise(<7)"), "Mid Rise (7-25)", expression("High Rise(>25)")))
GB_summ <- GB_cleaned %>%
  group_by(amenities,size_category,Green,stories_category) %>%
  summarise(Rent_median = median(Rent), Rent_mean = mean(Rent), leasing_rate = mean(leasing_rate))

# Plot of Different Size
# Comment_Chong: green is not pricier than non-green from the plot
# labels <- c("0" = "Non-Green", "1" = "Green")

# p6 = ggplot(GB_summ, aes(x=amenities, y=Rent_median)) + 
#   geom_bar(aes(fill = Green),stat='identity',position='dodge') +
#   facet_wrap(~ stories_category, labeller = label_parsed) +
#   #scale_fill_brewer(palette= "Greens",direction = -1)+
#   labs(title = "Median of Different Size Groups", x = "Size", y = "Rent")+
#   theme(plot.title = element_text(hjust = 0.5)) + 
#   scale_fill_manual( values = c(brewer.pal(9, "Greens")[3],brewer.pal(9, "Reds")[3]))
# p6

GB_summ_a = GB_cleaned %>%
  group_by(amenities,stories_category, Green) %>%
  summarise(Rent_mean = mean(Rent))
f4 = ggplot(GB_summ_a, aes(x=amenities, y=Rent_mean,fill=Green)) + 
  geom_bar(alpha = 0.8, stat='identity',position='dodge')+
  geom_text(aes(x=amenities,y=Rent_mean,label=round(Rent_mean)),vjust=-0.1,col="black",position = position_dodge(0.9))+
  #scale_fill_brewer(palette= "Greens",direction =-1)+
  facet_wrap(~ stories_category) +
  labs(title = "Amenity vs Rent", x = "Amenity", y = "Rent")+
  theme_bw()+
  theme(plot.title = element_text(hjust = 0.5)) + 
  scale_fill_manual( values = c(brewer.pal(6, "Greens")[5],brewer.pal(6, "Reds")[5]))
f4

# Age of the Building
p7 = ggplot(data = GB_cleaned, aes(x = age, y = Rent, col = Green)) + 
  geom_point(aes(x = age, y = Rent, col = Green), alpha =0.3)+
#  geom_smooth(se = TRUE)+
  scale_color_manual( values = c(brewer.pal(6, "Greens")[5],brewer.pal(6, "Reds")[5]))+
  labs(title = "Age vs Rent Plot", x = "Age", y = "Rent")+
  facet_wrap(~ Green, labeller = label_parsed)+
  theme_bw()+
  theme(plot.title = element_text(hjust = 0.5))
p7


# Gas and Electricity Price
#GB_cleaned$Gas_category = cut(GB_cleaned$Gas_Costs, 4)
#GB_cleaned$E_category = cut(GB_cleaned$Electricity_Costs,3)

# GB_summ1 <- GB_cleaned %>%
#   group_by(Gas_category,E_category, Green) %>%
#   summarise(Rent_median = median(Rent), Rent_mean = mean(Rent), leasing_rate = mean(leasing_rate))
# p8 = ggplot(GB_summ1, aes(x=Gas_category, y=Rent_median)) + 
#   geom_bar(aes(fill = Green),stat='identity',position='dodge')+
#   facet_wrap(~ E_category)+
#   scale_fill_brewer(palette= "Greens",direction = -1)+
#   labs(title = "Median of Different Electricity and Gas Cost Groups")+
#   theme(plot.title = element_text(hjust = 0.5))
# p8


# p9 = ggplot(GB_summ1, aes(x=Gas_category, y=Rent_mean)) + 
#   geom_bar(aes(fill = Green),stat='identity',position='dodge')+
#   facet_wrap(~ E_category)+
#   scale_fill_brewer(palette= "Greens",direction = -1)+
#   labs(title = "Median of Different Electricity and Gas Cost Groups")+
#   theme(plot.title = element_text(hjust = 0.5))
# p9
###############################
# need to seperate data by net
###############################





# Which occupancy rate should be chosen?

# Stories & Occupancy Rate Plot
  GB_summ2 <- GB_cleaned %>%
  group_by(stories_category,Green) %>%
  summarise(Rent_median = median(Rent), Rent_mean = mean(Rent), leasing_rate = mean(leasing_rate)/100)


p8 = ggplot(GB_summ2,aes(x = stories_category, y = leasing_rate, fill = Green))+
  scale_y_continuous(labels = scales::percent)+
  geom_bar(alpha = 0.8,stat='identity',position= position_dodge())+
  geom_text(aes(x=stories_category,y=leasing_rate,label=scales::percent(round(leasing_rate,2))),vjust=-0.1,col="black",position = position_dodge(0.9))+
  scale_fill_manual(values = c(brewer.pal(6, "Greens")[5], brewer.pal(6, "Reds")[5]))+
  labs(title = "Stories & Occupancy Rate Plot",
       y = "Occupancy Rate",
       x = "Stories")+
  theme_bw()+
  theme(plot.title = element_text(hjust = 0.5))
p8


# Occupancy Rate and rich area
GB_summ3 <-GB_cleaned %>%
  group_by(cluster) %>%
  summarise(building_num = length(cluster), leasing_rate = mean(leasing_rate))
# # ???? do you think there is any corelation?
# p9 = ggplot()+
#   geom_point(data = GB_summ3, aes(x = building_num, y = leasing_rate))
# p9

# Age of the Building and leasing rate
GB_summ4 <-GB_cleaned %>%
  group_by(age, Green) %>%
  summarise(leasing_rate = mean(leasing_rate)/100)
GB_summ4$age <- as.numeric(GB_summ4$age)
GB_summ4 <- subset(GB_summ4, (GB_summ4$age<30))

p9 = ggplot(GB_summ4,aes(x = age, y = leasing_rate, fill = Green))+
  scale_y_continuous(labels = scales::percent,limits = c(0,1))+
  geom_point(data = GB_summ4, aes(x = age, y = leasing_rate, col = Green))+
  geom_line(data = GB_summ4, aes(x = age, y = leasing_rate, col = Green))+
  #geom_text(aes(x=age,y=leasing_rate,col = Green, label=scales::percent(round(leasing_rate,2))), vjust = -0.5,check_overlap = TRUE)+
  scale_color_manual( values = c(brewer.pal(6, "Greens")[5],brewer.pal(6, "Reds")[5]))+
  labs(title = "Age vs Occupancy Rate Plot",
       y = "Occupancy rate",
       x = "Age of the building")+
  theme_bw()+
  theme(plot.title = element_text(hjust = 0.5))
p9
###############################
# first three years, use P12
# after that use P10 to calculate leasing rate
###############################
