library(foreach)
library(cluster)
library(corrplot)
library(plotly)
urlfile<-'https://raw.githubusercontent.com/jgscott/ECO395M/master/data/social_marketing.csv'
##protein <- read.csv(url(urlfile), row.names=1)
#36 different categories
SocialMarket <- read.csv(url(urlfile), row.names=1)
head(SocialMarket, 10)

#delete users with spam
SocialMarket<-SocialMarket[(SocialMarket$spam==0),]

#delete uncategorized label "chatter"
SocialMarket <- subset(SocialMarket, select = -c(chatter, uncategorized))

#add tweet sum & calculate adult ratio & delete adult ratio more than 20%
SocialMarket <- cbind(tweet_sum = rowSums(SocialMarket), SocialMarket)
SocialMarket <- cbind(adult_ratio = 1, SocialMarket)
SocialMarket$adult_ratio <- SocialMarket$adult/SocialMarket$tweet_sum
SocialMarket<-SocialMarket[(SocialMarket$adult_ratio<0.2),]

#delete uncategorized label "unused attributes"
SocialMarket <- subset(SocialMarket, select = -c(adult_ratio, tweet_sum, spam))

# Center/scale the data
#SocialMarket = SocialMarket[,-(1,35)]
SocialMarket_scaled <- scale(SocialMarket, center=TRUE, scale=TRUE) 

#K-grid to find the optimal K
k_grid = seq(2, 20, by=1)
SSE_grid = foreach(k = k_grid, .combine='c') %do% {
  cluster_k = kmeans(SocialMarket_scaled, k, nstart=50)
  cluster_k$tot.withinss
}
graphics.off()
par("mar")
par(mar=c(4,4,4,4))

plot(k_grid, SSE_grid, xlab="K",ylab="SSE Grid", sub="SSE Grid vs K")

#CH-grid to find the optimal K
CH_grid = foreach(k = k_grid, .combine='c') %do% {
  cluster_k = kmeans(SocialMarket_scaled, k, nstart=50)
  W = cluster_k$tot.withinss
  B = cluster_k$betweenss
  CH = (B/W)*((N-k)/(k-1))
  CH
}

plot(k_grid, CH_grid, xlab="K",
     ylab="CH Grid",
     sub="CH Grid vs K")

#Gap statistics
Market_gap = clusGap(SocialMarket_scaled, FUN = kmeans, nstart = 20, K.max = 10, B = 10)
plot(Market_gap)

# k-means analysis
clust1 = kmeans(SocialMarket_scaled, centers=7, nstart=25)

#visualization by 2D
qplot(photo_sharing, politics, data=SocialMarket, color=factor(clust1$cluster))

#visualization by 3D
#group1
plot_ly(x=SocialMarket$personal_fitness, y=SocialMarket$health_nutrition, z=SocialMarket$outdoors, data=SocialMarket, type="scatter3d", mode="markers", color=factor(clust1$cluster))%>%
  layout(
    title = "Market Sagement in 3D",
    scene = list(
      xaxis = list(title = "personal_fitness"),
      yaxis = list(title = "health_nutrition"),
      zaxis = list(title = "outdoors")
    ))

#group2
plot_ly(x=SocialMarket$fashion, y=SocialMarket$cooking, z=SocialMarket$beauty, data=SocialMarket, type="scatter3d", mode="markers", color=factor(clust1$cluster))%>%
  layout(
    title = "Market Sagement in 3D",
    scene = list(
      xaxis = list(title = "fashion"),
      yaxis = list(title = "cooking"),
      zaxis = list(title = "beauty")
    ))
#group3
plot_ly(x=SocialMarket$online_gaming, y=SocialMarket$college_uni, z=SocialMarket$sports_playing, data=SocialMarket, type="scatter3d", mode="markers", color=factor(clust1$cluster))%>%
  layout(
    title = "Market Sagement in 3D",
    scene = list(
      xaxis = list(title = "online_gaming"),
      yaxis = list(title = "college_uni"),
      zaxis = list(title = "sports_playing")
    ))
#group4
plot_ly(x=SocialMarket$sports_fandom, y=SocialMarket$food, z=SocialMarket$family, data=SocialMarket, type="scatter3d", mode="markers", color=factor(clust1$cluster))%>%
  layout(
    title = "Market Sagement in 3D",
    scene = list(
      xaxis = list(title = "sports_fandom"),
      yaxis = list(title = "food"),
      zaxis = list(title = "family")
    ))
plot_ly(x=SocialMarket$sports_fandom, y=SocialMarket$parenting, z=SocialMarket$school, data=SocialMarket, type="scatter3d", mode="markers", color=factor(clust1$cluster))%>%
  layout(
    title = "Market Sagement in 3D",
    scene = list(
      xaxis = list(title = "sports_fandom"),
      yaxis = list(title = "parenting"),
      zaxis = list(title = "school")
    ))
#group5
plot_ly(x=SocialMarket$politics, y=SocialMarket$news, z=SocialMarket$computers, data=SocialMarket, type="scatter3d", mode="markers", color=factor(clust1$cluster))%>%
  layout(
    title = "Market Sagement in 3D",
    scene = list(
      xaxis = list(title = "politics"),
      yaxis = list(title = "news"),
      zaxis = list(title = "computers")
    ))
#group6
plot_ly(x=SocialMarket$tv_film, y=SocialMarket$art, z=SocialMarket$music, data=SocialMarket, type="scatter3d", mode="markers", color=factor(clust1$cluster))%>%
  layout(
    title = "Market Sagement in 3D",
    scene = list(
      xaxis = list(title = "tv_film"),
      yaxis = list(title = "art"),
      zaxis = list(title = "music")
    ))


#correlation and visualization
res <- cor(SocialMarket_scaled)
corrplot(res, method = "color", tl.cex = 0.5, tl.col="black")

#corrplot(res, order = "AOE", cl.pos = "b", tl.pos = "d", tl.srt = 60, tl.cex = 0.5)
#corrplot(res, order = "AOE",
#         tl.pos = "td", tl.cex = 0.5, method = "color", type = "upper")
#corrplot(res, diag = FALSE, order = "FPC",
#         tl.pos = "td", tl.cex = 0.5, method = "color", type = "upper")