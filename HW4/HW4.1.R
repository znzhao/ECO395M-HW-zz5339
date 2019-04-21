library(tidyverse)
library(LICORS)
library(foreach)
library(mosaic)

myurl <- "https://raw.githubusercontent.com/znzhao/ECO395M-HW-zz5339/master/HW4/wine.csv"
wine <- read.csv(url(myurl))


# Center and scale the data
X = wine[,1:11]
X = scale(X, center=TRUE, scale=TRUE)
mu = attr(X,"scaled:center")
sigma = attr(X,"scaled:scale")

# First do clusting
clust1 = kmeans(X, 2, nstart=20)
qplot(wine$fixed.acidity,wine$pH, data=wine, color=factor(clust1$cluster), shape=factor(wine$color))

# Next try PCA
pc = prcomp(X, scale=TRUE)
loadings = pc$rotation
scores = pc$x
qplot(scores[,1], scores[,2], color=factor(clust1$cluster), shape=factor(wine$color), xlab='Component 1', ylab='Component 2')
