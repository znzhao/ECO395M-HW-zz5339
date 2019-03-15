library(tidyverse)
library(mosaic)
library(class)
library(FNN)
data(SaratogaHouses)

rmse = function(y, yhat) {
  sqrt( mean( (y - yhat)^2 ) )
}

KNN_avgrmse = function(data_X, data_y, K = 2, Ntimes = 50){
  n = nrow(data_X)
  rmse_vals_K = do(Ntimes)*{
    # re-split into train and test cases
    n_train = round(0.8*n)  # round to nearest integer
    n_test = n - n_train
    train_cases = sample.int(n, n_train, replace=FALSE)
    test_cases = setdiff(1:n, train_cases)
    X_train = data_X[train_cases,]
    X_test = data_X[test_cases,]
    y_train = data_y[train_cases,]
    y_test = data_y[test_cases,]
    
    # scaling
    scale_factors = apply(X_train, 2, sd)
    X_train_sc = scale(X_train, scale=scale_factors)
    # scale the test set features using the same scale factors
    X_test_sc = scale(X_test, scale=scale_factors)
    
    
    # Fit the KNN model (notice the odd values of K)
    knn_K = FNN::knn.reg(train=X_train_sc, test= X_test_sc, y = y_train, k=K)
    ypred_knn = knn_K$pred
    rmse(y_test, ypred_knn)
  }
  colMeans(rmse_vals_K)
}

summary(SaratogaHouses)

# 11 main effects
lm_medium = lm(price ~ lotSize + age + livingArea + pctCollege + bedrooms + 
		fireplaces + bathrooms + rooms + heating + fuel + centralAir, data=SaratogaHouses)
summary(lm_medium)

lm_improve = lm(price ~ landValue+ livingArea + pctCollege + bedrooms + 
                 fireplaces + bathrooms + rooms + heating + fuel + centralAir, data=SaratogaHouses)
summary(lm_improve)

# All interactions
# the ()^2 says "include all pairwise interactions"
lm_big = lm(price ~ (. - sewer - waterfront - landValue - newConstruction)^2, data=SaratogaHouses)
summary(lm_big)

####
# Compare out-of-sample predictive performance
####

# performance check
temp = model.matrix( ~ heating-1,SaratogaHouses)
colnames(temp)<- c("heatinghotair", "heatingwatersteam", "heatingelectric")
SaratogaHouses = cbind(SaratogaHouses,temp)
temp = model.matrix( ~ fuel-1,SaratogaHouses)
SaratogaHouses = cbind(SaratogaHouses,temp)
temp = model.matrix( ~ centralAir-1,SaratogaHouses)
SaratogaHouses = cbind(SaratogaHouses,temp)

data = SaratogaHouses

n = nrow(SaratogaHouses)
Ntimes = 100
# performance check
rmse_vals = do(Ntimes)*{
  # re-split into train and test cases
  n_train = round(0.8*n)  # round to nearest integer
  n_test = n - n_train
  train_cases = sample.int(n, n_train, replace=FALSE)
  test_cases = setdiff(1:n, train_cases)
  DF_train = data[train_cases,]
  DF_test = data[test_cases,]
  
  # fit to this training set
  lm_result1 = lm(price ~ lotSize + age + livingArea + pctCollege + bedrooms + fireplaces + bathrooms + rooms + heating + fuel + centralAir, data=DF_train)
  lm_result2 = lm(price ~ lotSize + age + livingArea + pctCollege*fireplaces + bedrooms  + bathrooms + rooms + heating + centralAir, data=DF_train)
  lm_result3 = lm(price ~ landValue + livingArea + pctCollege + bedrooms + fireplaces + bathrooms + rooms + heating + fuel + centralAir, data=DF_train)
  lm_result4 = lm(price ~ landValue + livingArea + bedrooms + bathrooms + rooms + heating + fuel + centralAir, data=DF_train)
  # the best regression
  lm_result5 = lm(price ~ landValue + lotSize*(bedrooms + bathrooms) + livingArea*(fuel+ heating + centralAir) + pctCollege*(fireplaces+age) + rooms, data=DF_train)
  lm_result6 = lm(price ~ landValue + lotSize*bedrooms + livingArea*fuel + pctCollege*(fireplaces+age) + bathrooms + rooms + heating + centralAir, data=DF_train)
  lm_result7 = lm(price ~ landValue + lotSize*bedrooms + livingArea*fuel + pctCollege*(fireplaces+age) + centralAir, data=DF_train)
  
  # predict on this testing set
  yhat_test1 = predict(lm_result1, DF_test)
  yhat_test2 = predict(lm_result2, DF_test)
  yhat_test3 = predict(lm_result3, DF_test)
  yhat_test4 = predict(lm_result4, DF_test)
  yhat_test5 = predict(lm_result5, DF_test)
  yhat_test6 = predict(lm_result6, DF_test)
  yhat_test7 = predict(lm_result7, DF_test)
  
  c(rmse(unlist(DF_test$price), yhat_test1), rmse(unlist(DF_test$price), yhat_test2), rmse(unlist(DF_test$price), yhat_test3), rmse(unlist(DF_test$price), yhat_test4), rmse(unlist(DF_test$price), yhat_test5), rmse(unlist(DF_test$price), yhat_test6), rmse(unlist(DF_test$price), yhat_test7))
}

colMeans(rmse_vals)
t = as.data.frame(colMeans(rmse_vals))
rownames(t) <- c("AVG RMSE")
t1 = summary(lm(price ~ landValue + lotSize*(bedrooms + bathrooms) + livingArea*(fuel+ heating + centralAir) + pctCollege*(fireplaces+age) + rooms, data=data))
as.data.frame(t1["coefficients"])

X = subset(SaratogaHouses, select=c(-price,-waterfront,-sewer,-newConstruction,-heating, -fuel, -centralAir, -centralAirNo, -fuelgas, -heatinghotair))
y = subset(SaratogaHouses, select=c(price))

k_grid = seq(3, 30, by=1)

data_X = X
data_y = y
Ntimes = 200
n = nrow(data_X)
KNN_result = do(Ntimes)*{
  # re-split into train and test cases
  n_train = round(0.8*n)  # round to nearest integer
  n_test = n - n_train
  train_cases = sample.int(n, n_train, replace=FALSE)
  test_cases = setdiff(1:n, train_cases)
  X_train = data_X[train_cases,]
  X_test = data_X[test_cases,]
  y_train = data_y[train_cases,]
  y_test = data_y[test_cases,]
  
  # scaling
  scale_factors = apply(X_train, 2, sd)
  X_train_sc = scale(X_train, scale=scale_factors)
  # scale the test set features using the same scale factors
  X_test_sc = scale(X_test, scale=scale_factors)
  temp = c()
  for(v in k_grid){
    # Fit the KNN model (notice the odd values of K)
    knn_K = FNN::knn.reg(train=X_train_sc, test= X_test_sc, y = y_train, k=v)
    ypred_knn = knn_K$pred
    temp = c(temp, rmse(y_test, ypred_knn))
  }
  temp
}
KNN_result =  KNN_result %>% colMeans() %>% as.data.frame()

ggplot(data = KNN_result, aes(x = c(3:30), y = .)) + 
  geom_point(shape = "O") +
  geom_line(col = "red")

