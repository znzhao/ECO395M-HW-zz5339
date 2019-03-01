library(tidyverse)
library(mosaic)
library(class)
library(FNN)
data(SaratogaHouses)

summary(SaratogaHouses)

# 11 main effects
lm_medium = lm(price ~ lotSize + age + livingArea + pctCollege + bedrooms + 
		fireplaces + bathrooms + rooms + heating + fuel + centralAir, data=SaratogaHouses)
coef(lm_medium)

# All interactions
# the ()^2 says "include all pairwise interactions"
lm_big = lm(price ~ (. - sewer - waterfront - landValue - newConstruction)^2, data=SaratogaHouses)
coef(lm_big)

####
# Compare out-of-sample predictive performance
####
rmse = function(y, yhat) {
  sqrt( mean( (y - yhat)^2 ) )
}

# performance check
rmse_vals = do(100)*{
  n = nrow(SaratogaHouses)
  # re-split into train and test cases
  n_train = round(0.8*n)  # round to nearest integer
  n_test = n - n_train
  train_cases = sample.int(n, n_train, replace=FALSE)
  test_cases = setdiff(1:n, train_cases)
  saratoga_train = SaratogaHouses[train_cases,]
  saratoga_test = SaratogaHouses[test_cases,]
  
  # fit to this training set
  lm_baseline = lm(price ~ . - sewer - waterfront - landValue - newConstruction, data=saratoga_train)
  
  lm_boom = lm(price ~ lotSize + age + pctCollege + 
                 fireplaces + rooms + heating + fuel + centralAir +
                 bedrooms*rooms + bathrooms*rooms + 
                 bathrooms*livingArea, data=saratoga_train)
 
  # predict on this testing set
  yhat_test_baseline = predict(lm_baseline, saratoga_test)
  yhat_testboom = predict(lm_boom, saratoga_test)
  c(rmse(saratoga_test$price, yhat_test_baseline),
    rmse(saratoga_test$price, yhat_testboom))
}

colMeans(rmse_vals)


SaratogaHouses$n_heating = as.numeric(SaratogaHouses$heating)
SaratogaHouses$n_fuel = as.numeric(SaratogaHouses$fuel)
SaratogaHouses$n_centralAir = as.numeric(SaratogaHouses$centralAir)

KNN_result <- data.frame(K=c(), rsme=c())

X = select(SaratogaHouses,lotSize , age , livingArea , pctCollege , bedrooms , fireplaces , bathrooms , rooms , n_heating , n_fuel , n_centralAir )
y = select(SaratogaHouses, price)

for(v in c(3:20)){
rmse_vals_K = do(50)*{
n = nrow(SaratogaHouses)
# re-split into train and test cases
n_train = round(0.8*n)  # round to nearest integer
n_test = n - n_train
train_cases = sample.int(n, n_train, replace=FALSE)
test_cases = setdiff(1:n, train_cases)
saratoga_train = SaratogaHouses[train_cases,]
saratoga_test = SaratogaHouses[test_cases,]


# get the data
X_train = select(saratoga_train,lotSize , age , livingArea , pctCollege , bedrooms , fireplaces , bathrooms , rooms , n_heating , n_fuel , n_centralAir )
y_train = select(saratoga_train, price)
X_test = select(saratoga_test,lotSize , age , livingArea , pctCollege , bedrooms , fireplaces , bathrooms , rooms , n_heating , n_fuel , n_centralAir )
y_test = select(saratoga_test, price)

# scaling
scale_factors = apply(X_train, 2, sd)
X_train_sc = scale(X_train, scale=scale_factors)
# scale the test set features using the same scale factors
X_test_sc = scale(X_test, scale=scale_factors)


# Fit the KNN model (notice the odd values of K)
knn_K = FNN::knn.reg(train=X_train_sc, test= X_test_sc, y = y_train, k=v)
ypred_knn = knn_K$pred
rmse(y_test, ypred_knn)
}

KNN_result <- rbind(KNN_result,c(v,colMeans(rmse_vals_K)))
}

KNN_result
