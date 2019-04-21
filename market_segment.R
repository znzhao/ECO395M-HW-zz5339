library(ggplot2)

social_marketing = read.csv("C:/Users/USER/Desktop/social_marketing.csv", row.names=1)

#delete users with spam
social_marketing = social_marketing[(social_marketing$spam==0),]

#delete uncategorized label "chatter"
social_marketing = subset(social_marketing, select = -c(chatter, uncategorized))

#add tweet sum & calculate adult ratio & delete adult ratio more than 20%
social_marketing = cbind(tweet_sum = rowSums(social_marketing), social_marketing)
social_marketing = cbind(adult_ratio = 1, social_marketing)
social_marketing$adult_ratio = social_marketing$adult/social_marketing$tweet_sum
social_marketing = social_marketing[(social_marketing$adult_ratio<0.2),]

#delete uncategorized label "unused attributes"
social_marketing = subset(social_marketing, select = -c(adult_ratio, tweet_sum, spam))

#center and scale the data
social_marketing = scale(social_marketing, center=TRUE, scale=TRUE)

# correlation
cor=cor(social_marketing)
cor

# PCA
pca = prcomp(social_marketing,scale=TRUE)
loadings = pca$rotation
scores = pca$x

# PVE
VE = pca$sdev^2
PVE = VE / sum(VE)
round(PVE, 2)

# scree Plot
PVEplot = qplot(c(1:34), PVE) + 
  geom_line() + 
  xlab("Principal Component") + 
  ylab("PVE") +
  ggtitle("Scree Plot") +
  ylim(0, 0.15)

# Cumulative PVE plot
cumPVE = qplot(c(1:34), cumsum(PVE)) + 
  geom_line() + 
  xlab("Principal Component") + 
  ylab(NULL) +
  ggtitle("Cumulative Scree Plot") +
  ylim(0,1)

# extract market segments
o1 = order(loadings[,1], decreasing=TRUE)
colnames(social_marketing)[head(o1,5)]

o2 = order(loadings[,2], decreasing=TRUE)
colnames(social_marketing)[head(o2,5)]

o3 = order(loadings[,3], decreasing=TRUE)
colnames(social_marketing)[head(o3,5)]

o4 = order(loadings[,4], decreasing=TRUE)
colnames(social_marketing)[head(o4,5)]

o5 = order(loadings[,5], decreasing=TRUE)
colnames(social_marketing)[head(o5,5)]

o6 = order(loadings[,6], decreasing=TRUE)
colnames(social_marketing)[head(o6,5)]

o7 = order(loadings[,7], decreasing=TRUE)
colnames(social_marketing)[head(o7,5)]

o8 = order(loadings[,8], decreasing=TRUE)
colnames(social_marketing)[head(o8,5)]
