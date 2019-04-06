library(tidyverse)
library(mosaic)
library(foreach)
library(gamlr) 

urlfile<-'https://raw.githubusercontent.com/znzhao/ECO395M-HW-zz5339/master/HW1/greenbuildings.csv'
greenbuildings<-read.csv(url(urlfile))
greenbuildings =na.omit(greenbuildings)
greenbuildings$size = greenbuildings$size/1000

# clean data by deleting the data with occupacy rate equal to 0% and taller than 56 floor
GB_test <- subset(greenbuildings,(greenbuildings$stories > 56))
Clus = unique(GB_test$cluster)
GB_cleaned <- subset(greenbuildings,(greenbuildings$leasing_rate != 0))
for (i in 1:39){
  GB_cleaned <-subset(GB_cleaned,(GB_cleaned$cluster!= Clus[i]))
}

## stepwise model
full = lm(Rent ~ .-CS_PropertyID-green_rating, data=GB_cleaned)
null = glm(Rent~1, data=greenbuildings)
fwd = step(null, scope=formula(full), dir="forward")
length(coef(fwd))
big  = lm(Rent ~ (.-CS_PropertyID-green_rating)^2, data=GB_cleaned)
stepwise = step(null, scope=formula(big), dir="both")

length(coef(stepwise))
model1 = formula(stepwise)

## Gamma Lasso model
gbx = sparse.model.matrix(Rent ~ (.-CS_PropertyID-green_rating)^2, data=GB_cleaned)[,-1] 
gby = GB_cleaned$Rent
gblasso = gamlr(gbx, gby, lambda.min.ratio=0.000001)
plot(gblasso) # the path plot!
gbbeta = coef(gblasso)
log(gblasso$lambda[which.min(AICc(gblasso))])
sum(gbbeta!=0)

p1 <- dimnames(gbbeta)[[1]]
p2 <- c()
for (i in c(1:sum(gbbeta))){
  p2 <- c(p2, as.list(gbbeta)[[i]])
}

model2 = c("Rent ~ ")
for (i in c(2:sum(gbbeta))){
  if (p2[i] != 0){
    if (model2 == "Rent ~ "){
      model2 = paste(model2, p1[i])
    }
    else{
      model2 = paste(model2,"+", p1[i])
    }
  }
}
model2 <- as.formula(model2)

N = nrow(GB_cleaned)
# Create a vector of fold indicators
K = 10
fold_id = rep_len(1:K, N)  # repeats 1:K over and over again
fold_id = sample(fold_id, replace=FALSE) # permute the order randomly
step_err_save = rep(0, K)
lasso_err_save = rep(0, K)
for(i in 1:K) {
  train_set = which(fold_id != i)
  y_test = GB_cleaned$Rent[-train_set]
  step_model = lm(model1, data=GB_cleaned[train_set,])
  lasso_model = lm(model2, data=GB_cleaned[train_set,])
  
  yhat_test1 = predict(step_model, newdata=GB_cleaned[-train_set,])
  step_err_save[i] = mean((y_test - yhat_test1)^2)
  
  yhat_test2 = predict(lasso_model, newdata=GB_cleaned[-train_set,])
  lasso_err_save[i] = mean((y_test - yhat_test2)^2)
}
# RMSE
c(sqrt(mean(step_err_save)),sqrt(mean(lasso_err_save)))

