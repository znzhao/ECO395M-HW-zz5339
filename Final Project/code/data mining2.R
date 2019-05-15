library(cluster)
library(corrplot)
library(plotly)
library(tidyverse)
library(ggplot2)
library(GGally)
library(LICORS) 
library(gamlr)
library(gbm)
library(randomForest)

myurl <- "https://raw.githubusercontent.com/znzhao/ECO395M-HW-zz5339/master/Final%20Project/data/sounddata_2018.csv"
sounddata_2018 <- read.csv(url(myurl), row.names=1)
sounddata_2018 = subset(sounddata_2018,is.na(sounddata_2018$valence)==FALSE)
sounddata_2018$key = sounddata_2018$key %>% as.factor()
temp = model.matrix( ~ key-1,sounddata_2018)
sounddata_2018 = cbind(sounddata_2018,temp)
sounddata_2018$time_signature = sounddata_2018$time_signature %>% as.factor()
temp = model.matrix( ~ time_signature-1,sounddata_2018)
sounddata_2018 = cbind(sounddata_2018,temp)
temp = model.matrix( ~ explicit-1,sounddata_2018)
sounddata_2018 = cbind(sounddata_2018,temp)
relseaseDuration = as.Date(sounddata_2018$releaseDate)
temp = c()
for (i in c(1:length(relseaseDuration))) {
  temp = c(temp,as.Date("2019/1/1", origin = "1990/1/1"))
}
relseaseDuration = as.numeric(as.Date(temp, origin = "1990/1/1")-relseaseDuration)
sounddata_2018 = cbind(sounddata_2018, relseaseDuration)
#delete uncategorized label "unused attributes"
Clean_data <- subset(sounddata_2018, select = -c(releaseDate, artist_name, album_name, explicit, is_local, name, popularity, key0, key, time_signature, time_signature1, explicitFALSE))
Clean_data$acousticness <- Clean_data$acousticness %>% as.numeric()


#Streams as an dependent variable
#stepwise
null1 = lm(Streams~1, data=Clean_data)
medium1 = lm(Streams ~ ., data=Clean_data)
big1 = lm(Streams ~ (.)^2, data=Clean_data)
stepwise1 = step(null1, scope=formula(medium1), dir="both", trace = FALSE)
stepwise2 = step(medium1, scope=formula(big1), dir="both", trace = FALSE)
model1 = formula(stepwise1)
model2 = formula(stepwise2)
length(coef(stepwise1))
AICc(stepwise1)
length(coef(stepwise2))
AICc(stepwise2)

#Lasso
Stx1 = sparse.model.matrix(Streams ~ ., data=Clean_data)[,-1] 
Sty1 = Clean_data$Streams
Stlasso1 = gamlr(Stx1, Sty1, lambda.min.ratio=0.000001)
plot(log(Stlasso1$lambda), AICc(Stlasso1))
which.min(AICc(Stlasso1))
plot(Stlasso1)
Stbeta1 = coef(Stlasso1)

p1 <- dimnames(Stbeta1)[[1]]
p2 <- c()
for (i in c(1:length(Stbeta1))){
  p2 <- c(p2, as.list(Stbeta1)[[i]])
}
model3 = c("Streams ~ ")
for (i in c(2:length(Stbeta1))){
  if (p2[i] != 0){
    if (model3 == "Streams ~ "){
      model3 = paste(model3, p1[i])
    }
    else{
      model3 = paste(model3,"+", p1[i])
    }
  }
}
model3 <- as.formula(model3)
model3


Stx2 = sparse.model.matrix(Streams ~ (.)^2, data=Clean_data)[,-1] 
Sty2 = Clean_data$Streams
Stlasso2 = gamlr(Stx2, Sty2, lambda.min.ratio=0.00000001)
plot(log(Stlasso2$lambda), AICc(Stlasso2))
which.min(AICc(Stlasso2))
plot(Stlasso2)
Stbeta2 = coef(Stlasso2)

p1 <- dimnames(Stbeta2)[[1]]
p2 <- c()
for (i in c(1:length(Stbeta2))){
  p2 <- c(p2, as.list(Stbeta2)[[i]])
}
model4 = c("Streams ~ ")
for (i in c(2:length(Stbeta2))){
  if (p2[i] != 0){
    if (model4 == "Streams ~ "){
      model4 = paste(model4, p1[i])
    }
    else{
      model4 = paste(model4,"+", p1[i])
    }
  }
}
model4 <- as.formula(model4)
model4


#optimal lambda
log(Stlasso1$lambda[which.min(AICc(Stlasso1))])
sum(Stbeta1!=0)
log(Stlasso2$lambda[which.min(AICc(Stlasso2))])
sum(Stbeta2!=0)


#trees and random forests
# split into a training and testing set
N = nrow(Clean_data)
train_frac = 0.8
N_train = floor(train_frac*N)
N_test = N - N_train
train_ind = sample.int(N, N_train, replace=FALSE) %>% sort
Clean_data_train = Clean_data[train_ind,]
Clean_data_test = Clean_data[-train_ind,]


# 1. bagging:
rmse_forest = c()
for (K in c(1:27)){
  forest1 = randomForest(Streams ~ ., mtry=K, nTree=100, data=Clean_data_train)
  yhat_forest_test = predict(forest1, Clean_data_test)
  rmse_foresttemp = mean((Clean_data_test$Streams - yhat_forest_test)^2) %>% sqrt
  rmse_forest = c(rmse_forest, rmse_foresttemp)
}
a=which.min(rmse_forest)
model5=randomForest(Streams ~ ., mtry=a, nTree=100, data=Clean_data_train)


# 2. Boosting:
library(gbm)
boost1 = gbm(Streams ~ ., data=Clean_data_train, 
             interaction.depth=2, n.trees=500, shrinkage=.05)
#plot(Streams ~ energy, data=Clean_data_train)
points(predict(boost1, n.trees=500) ~ energy, data=Clean_data_train, pch=19, col='red')
model6 = boost1


#k-fold cross validation
N = nrow(Clean_data)
# Create a vector of fold indicators
K = 10
fold_id = rep_len(1:K, N)  # repeats 1:K over and over again
fold_id = sample(fold_id, replace=FALSE) # permute the order randomly
step_err_save1 = rep(0, K)
step_err_save2 = rep(0, K)
lasso_err_save1 = rep(0, K)
lasso_err_save2 = rep(0, K)
bag_err_save = rep(0,K)
boost_err_save = rep(0,K)
for(i in 1:K) {
  train_set = which(fold_id != i)
  y_test = Clean_data$Streams[-train_set]
  step_model1 = lm(model1, data=Clean_data[train_set,])
  step_model2 = lm(model2, data=Clean_data[train_set,])
  lasso_model1 = lm(model3, data=Clean_data[train_set,])
  lasso_model2 = lm(model4, data=Clean_data[train_set,])
  bag_model = randomForest(Streams ~ ., mtry=a, nTree=100, data=Clean_data[train_set,])
  boost_model = gbm(Streams ~ ., data=Clean_data[train_set,], interaction.depth=2, n.trees=500, shrinkage=.05)
  yhat_test1 = predict(step_model1, newdata=Clean_data[-train_set,])
  step_err_save1[i] = mean((y_test - yhat_test1)^2)
  yhat_test2 = predict(step_model2, newdata=Clean_data[-train_set,])
  step_err_save2[i] = mean((y_test - yhat_test2)^2)
  yhat_test3 = predict(lasso_model1, newdata=Clean_data[-train_set,])
  lasso_err_save1[i] = mean((y_test - yhat_test3)^2)
  yhat_test4 = predict(lasso_model2, newdata=Clean_data[-train_set,])
  lasso_err_save2[i] = mean((y_test - yhat_test4)^2)
  yhat_test5 = predict(bag_model, newdata=Clean_data[-train_set,])
  bag_err_save[i] = mean((y_test - yhat_test5)^2)
  yhat_test6 = predict(boost_model, newdata=Clean_data[-train_set,], n.trees=500)
  boost_err_save[i] = mean((y_test - yhat_test6)^2)
}

# RMSE
c(sqrt(mean(step_err_save1)), sqrt(mean(step_err_save2)), sqrt(mean(lasso_err_save1)), sqrt(mean(lasso_err_save2)), sqrt(mean(bag_err_save)), sqrt(mean(boost_err_save)))

table1 = summary(step_model2)
kable(as.data.frame(table1["coefficients"]))



library(pdp)

# partial dependence plot: temp
p1 = bag_model %>%
  partial(pred.var = "danceability") %>% autoplot


# partial dependence plot: temp
p2 = bag_model %>%
  partial(pred.var = "energy") %>% autoplot

# partial dependence plot: hour
p3 = bag_model %>%
  partial(pred.var = "liveness") %>% autoplot

# partial dependence plot: day
p4 = bag_model %>%
  partial(pred.var = "loudness") %>% autoplot

# partial dependence plot: PC1
p5 = bag_model %>%
  partial(pred.var = "speechiness") %>% autoplot


# partial dependence plot: PC5
p6 = bag_model %>%
  partial(pred.var = "key6") %>% autoplot
multiplot(p1, p2, p3, p4, p5, p6, cols=2)

