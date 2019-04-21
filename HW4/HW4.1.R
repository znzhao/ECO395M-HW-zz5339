library(tidyverse)
library(LICORS)
library(ISLR)
library(foreach)
library(mosaic)
library(GGally)
myurl <- "https://raw.githubusercontent.com/znzhao/ECO395M-HW-zz5339/master/HW4/wine.csv"
wine <- read.csv(url(myurl))

# Q1: cluster into 2 categories

# Center and scale the data, data visualization
X = wine[,1:11]
X = scale(X, center=TRUE, scale=TRUE)
mu = attr(X,"scaled:center")
sigma = attr(X,"scaled:scale")
corrplot(res, method = "color", tl.cex = 0.5, tl.col="black")
# distribution plot
XX = subset(wine,select = c("total.sulfur.dioxide","density","pH","volatile.acidity"))
ggpairs(XX,aes(col = wine$color, alpha = 0.8))

# First do clusting
clust1 = kmeans(X, 2, nstart=20)
qplot(wine$density,wine$total.sulfur.dioxide, data=wine, shape=factor(clust1$cluster), col=factor(wine$color))
res <- cor(X)


# table for the correctly clustering
xtabs(~clust1$cluster + wine$color)
table1 = xtabs(~clust1$cluster + wine$color)

# Next try PCA
pc = prcomp(X, scale=TRUE)
summary(pc)
loadings = pc$rotation
scores = pc$x
# PCA for clustering
clustPCA = kmeans(scores[,1:4], 2, nstart=20)
qplot(scores[,1], scores[,2], color=factor(wine$color), shape=factor(clustPCA$cluster), xlab='Component 1', ylab='Component 2')

# table for the correctly clustering
xtabs(~clustPCA$cluster + wine$color)
tablePCA = xtabs(~clustPCA$cluster + wine$color)

# The top characteristics associated with each component
o1 = order(loadings[,1], decreasing=TRUE)
colnames(X)[o1]
o2 = order(loadings[,2], decreasing=TRUE)
colnames(X)[o2]
o3 = order(loadings[,3], decreasing=TRUE)
colnames(X)[o3]
o4 = order(loadings[,4], decreasing=TRUE)
colnames(X)[o4]

# Q2: cluster into 7 categories
# it seems very hard to cluster them into 7 categories
ggpairs(XX,aes(col = factor(wine$quality),alpha = 0.6))
# by the barplot we can see that most wines' quality is 6
ggplot(wine)+
  geom_bar(aes(x = quality))
# First do clusting
clust2 = kmeans(X, 7, nstart=20)

# table for the correctly clustering
xtabs(~clust2$cluster + wine$quality)
table2 = xtabs(~clust2$cluster + wine$quality)
ggplot(wine)+ geom_density(aes(x = clust2$cluster, col = factor(wine$quality), fill = factor(wine$quality)), alpha = 0.3)
ggplot(wine)+ geom_density(aes(x = wine$quality, col = factor(wine$quality), fill = factor(wine$quality)), alpha = 0.3)

# Next try PCA
pc = prcomp(X, scale=TRUE)
loadings = pc$rotation
scores = pc$x

# PCA for clustering
clustPCA2 = kmeans(scores[,1:4], 7, nstart=20)
qplot(scores[,1], scores[,2], color=factor(wine$quality), shape = factor(clustPCA2$cluster) , xlab='Component 1', ylab='Component 2')

# table for the correctly clustering
xtabs(~clustPCA2$cluster + wine$quality)
tablePCA = xtabs(~clustPCA2$cluster + wine$quality)
ggplot(wine)+ geom_density(aes(x = clustPCA2$cluster, col = factor(wine$quality), fill = factor(wine$quality)), alpha = 0.3)
