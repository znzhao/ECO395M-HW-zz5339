library(tidyverse)
library(arules)
library(arulesViz)
# get the data
myurl <- "https://raw.githubusercontent.com/znzhao/ECO395M-HW-zz5339/master/HW4/groceries.txt"
my_data <- read.delim(url(myurl),header = FALSE)
colnames(x = my_data) <- c("goods")
my_data$goods = my_data$goods %>% as.character() 
# formalize the data set
# initialization
buyer <- c()
goods <- c()
# for loop to generate a 1-1 projection on users and goods
for(i in c(1:nrow(my_data))){
  n = length(goods)
  for(x in strsplit(my_data$goods[i], ",")){
    goods <- c(goods, x)
  }
  for(j in c(1:(length(goods)-n))){
    buyer <- c(buyer, as.character(i))
  }
}
# final good dataset
groceries <- data.frame(buyer, goods)

# statistics of the goods
groceries$goods %>%
  summary(maxsum=Inf) %>%
  sort(decreasing=TRUE) %>%
  head(20) %>%
  barplot(las=2, cex.names=0.6)

# First create a list of baskets: vectors of items by consumer

# apriori algorithm expects a list of baskets in a special format
# In this case, one "basket" of goods per user
# First split data into a list of artists for each user
basket = split(x=groceries$goods, f=groceries$buyer)

## Remove duplicates ("de-dupe")
# lapply says "apply a function to every element in a list"
basket = lapply(basket, unique)

## Cast this variable as a special arules "transactions" class.
baskettrans = as(basket, "transactions")

# Now run the 'apriori' algorithm
# Look at rules with support > .01 & confidence >.1 & length (# artists) <= 5
consumerrules = apriori(baskettrans, 
                     parameter=list(support = 0.01, confidence=.1, maxlen=5))
## summary
summary(consumerrules)
## Choose a subset
inspect(subset(consumerrules, lift >= 3))
inspect(subset(consumerrules, confidence > 0.5))
inspect(subset(consumerrules, lift > 2 & confidence > 0.3))

plot(consumerrules)

# graph-based visualization
# export a graph
saveAsGraph(subset(consumerrules, subset=confidence > 0.3 & lift > 2), file = "consumerrules.graphml",type="items")
