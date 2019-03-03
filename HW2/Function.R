library(tidyverse)
library(mosaic)
library(class)
library(FNN)

rmse = function(y, yhat) {
  sqrt( mean( (y - yhat)^2 ) )
}




lm_avgrmse = function(fo, data, Ntimes = 50){
  n = nrow(data)
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
    lm_result = lm(fo, data=DF_train)
    
    # predict on this testing set
    yhat_test = predict(lm_result, DF_test)
    c(rmse(DF_test[as.character(fo[[2]])], yhat_test))
  }
  
  colMeans(rmse_vals)
}



glm_C_error = function(fo, data, Family = binomial, threshold = 0.5, Ntimes = 50){
  n = nrow(data)
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
    glm_result = glm(fo, data=DF_train, family=Family)
    
    # predict on this testing set
    phat_test = predict(glm_result, DF_test, type='response')
    yhat_test = ifelse(phat_test > threshold, 1, 0)
    sum(yhat_test != DF_test[as.character(fo[[2]])])/n_test 
  }
  colMeans(rmse_vals)
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


KNN_C_error = function(data_X, data_y, K = 2, Ntimes = 50){
  n = length(data_y)
  C_error = do(Ntimes)*{
    # re-split into train and test cases
    n_train = round(0.8*n)  # round to nearest integer
    n_train = round(0.8*n)
    n_test = n - n_train
    train_ind = sample.int(n, n_train)
    X_train = X[train_ind,]
    X_test = X[-train_ind,]
    y_train = y[train_ind]
    y_test = y[-train_ind]
    
    # scaling
    scale_factors = apply(X_train, 2, sd)
    X_train_sc = scale(X_train, scale=scale_factors)
    # scale the test set features using the same scale factors
    X_test_sc = scale(X_test, scale=scale_factors)
    
    
    # Fit the KNN model (notice the odd values of K)
    knn_K = class::knn(train=X_train_sc, test= X_test_sc, cl = y_train, k=K)
    #classification errors
    sum(knn_K != y_test)/n_test 
  }
  colMeans(C_error)
}

