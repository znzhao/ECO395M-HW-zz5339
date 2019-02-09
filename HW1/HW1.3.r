library(tidyverse)
library(FNN)

# read in the data: make sure to use the path name to
# wherever you'd stored the file
urlfile<-'https://raw.githubusercontent.com/znzhao/ECO395M-HW-zz5339/master/HW1/sclass.csv'
sclass<-read.csv(url(urlfile))

summary(sclass)
sclass_350 <- subset(sclass,(sclass$trim == "350"))
sclass_65AMG <- subset(sclass,(sclass$trim == "65 AMG"))

# define a helper function for calculating RMSE
rmse = function(y, ypred) {
  sqrt(mean(data.matrix((y-ypred)^2)))
}

###################################################################
# sclass_350
My_data = sclass_350

# plot the data
p_350 = ggplot(data = My_data) + 
  geom_point(mapping = aes(x = mileage, y = price), color='darkgrey')
p_350

# Make a train-test split
N = nrow(My_data)
N_train = floor(0.8*N)
N_test = N - N_train

#####
# Train/test split
#####

# randomly sample a set of data points to include in the training set
train_ind = sample.int(N, N_train, replace=FALSE)

# Define the training and testing set
D_train = My_data[train_ind,]
D_test = My_data[-train_ind,]

# optional book-keeping step:
# reorder the rows of the testing set by the KHOU (temperature) variable
# this isn't necessary, but it will allow us to make a pretty plot later
D_test = arrange(D_test, mileage)
head(D_test)

# Now separate the training and testing sets into features (X) and outcome (y)
X_train = select(D_train, mileage)
y_train = select(D_train, price)
X_test = select(D_test, mileage)
y_test = select(D_test, price)


#####
# Fit a few models
#####

# linear and quadratic models
#lm1 = lm(COAST ~ KHOU, data=D_train)
#lm2 = lm(COAST ~ poly(KHOU, 2), data=D_train)
KNN_result <- data.frame(K=c(), rsme=c())
# KNN
for(v in c(3:nrow(X_train))){
  # K = 2 generate some error?
  knn_K = knn.reg(train = X_train, test = X_test, y = y_train, k=v)
  ypred_knn = knn_K$pred
  KNN_rsme = rmse(y_test, ypred_knn)
  KNN_result <- rbind(KNN_result,c(v,KNN_rsme))
}

colnames(KNN_result) = c("K","RSME")
Kmin = KNN_result$K[which.min(KNN_result$RSME)]

P_KNNresult_350 = ggplot(data = KNN_result)+
  geom_line(aes(x = K, y = RSME))+
  geom_line(aes(x = Kmin, y = RSME), col = "red")
P_KNNresult_350

#####
# Compare the models by RMSE_out
#####

#ypred_lm1 = predict(lm1, X_test)
#ypred_lm2 = predict(lm2, X_test)
knn_K = knn.reg(train = X_train, test = X_test, y = y_train, k=Kmin)
ypred_knn = knn_K$pred

#rmse(y_test, ypred_lm1)
#rmse(y_test, ypred_lm2)
rmse(y_test, ypred_knn)


####
# plot the fit
####

# attach the predictions to the test data frame
#D_test$ypred_lm2 = ypred_lm2
D_test$ypred_knn = ypred_knn

p_test_350 = ggplot(data = D_test) + 
  geom_point(mapping = aes(x = mileage, y = price), color='lightgrey') + 
  geom_path(mapping = aes(x = mileage, y = ypred_knn), color='red') +
  theme_bw(base_size=18)
p_test_350

###################################################################
# sclass_63AMG
My_data = sclass_65AMG


# plot the data
p_63 = ggplot(data = My_data) + 
  geom_point(mapping = aes(x = mileage, y = price), color='darkgrey')
p_63

# Make a train-test split
N = nrow(My_data)
N_train = floor(0.8*N)
N_test = N - N_train

#####
# Train/test split
#####

# randomly sample a set of data points to include in the training set
train_ind = sample.int(N, N_train, replace=FALSE)

# Define the training and testing set
D_train = My_data[train_ind,]
D_test = My_data[-train_ind,]

# optional book-keeping step:
# reorder the rows of the testing set by the KHOU (temperature) variable
# this isn't necessary, but it will allow us to make a pretty plot later
D_test = arrange(D_test, mileage)
head(D_test)

# Now separate the training and testing sets into features (X) and outcome (y)
X_train = select(D_train, mileage)
y_train = select(D_train, price)
X_test = select(D_test, mileage)
y_test = select(D_test, price)


#####
# Fit a few models
#####

# linear and quadratic models
#lm1 = lm(COAST ~ KHOU, data=D_train)
#lm2 = lm(COAST ~ poly(KHOU, 2), data=D_train)
KNN_result <- data.frame(K=c(), rsme=c())
# KNN
for(v in c(3:nrow(X_train))){
  # K = 2 generate some error?
  knn_K = knn.reg(train = X_train, test = X_test, y = y_train, k=v)
  ypred_knn = knn_K$pred
  KNN_rsme = rmse(y_test, ypred_knn)
  KNN_result <- rbind(KNN_result,c(v,KNN_rsme))
}

colnames(KNN_result) = c("K","RSME")
Kmin = KNN_result$K[which.min(KNN_result$RSME)]

ggplot(data = KNN_result)+
  geom_line(aes(x = K, y = RSME))+
  geom_line(aes(x = Kmin, y = RSME), col = "red")


#####
# Compare the models by RMSE_out
#####

#ypred_lm1 = predict(lm1, X_test)
#ypred_lm2 = predict(lm2, X_test)
knn_K = knn.reg(train = X_train, test = X_test, y = y_train, k=Kmin)
ypred_knn = knn_K$pred

#rmse(y_test, ypred_lm1)
#rmse(y_test, ypred_lm2)
rmse(y_test, ypred_knn)


####
# plot the fit
####

# attach the predictions to the test data frame
#D_test$ypred_lm2 = ypred_lm2
D_test$ypred_knn = ypred_knn

p_test_63 = ggplot(data = D_test) + 
  geom_point(mapping = aes(x = mileage, y = price), color='lightgrey') + 
  geom_path(mapping = aes(x = mileage, y = ypred_knn), color='red') +
  theme_bw(base_size=18)
p_test_63 

