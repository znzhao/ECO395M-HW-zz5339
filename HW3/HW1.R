library(tidyverse)
library(mosaic)
library(foreach)
library(gamlr) 

urlfile<-'https://raw.githubusercontent.com/znzhao/ECO395M-HW-zz5339/master/HW1/greenbuildings.csv'
greenbuildings<-read.csv(url(urlfile))
greenbuildings =na.omit(greenbuildings)
greenbuildings$size = greenbuildings$size/1000

# clean data by deleting the data with occupacy rate equal to 0% 

GB_cleaned <- subset(greenbuildings,(greenbuildings$leasing_rate != 0))

## stepwise model 1.1 LEED & Energy
full = lm(Rent ~ .-CS_PropertyID-green_rating, data=GB_cleaned)
null = glm(Rent~1, data=GB_cleaned)
fwd = step(null, scope=formula(full), dir="forward")

length(coef(fwd))
big  = lm(Rent ~ (.-CS_PropertyID-green_rating)^2, data=GB_cleaned)
stepwise = step(null, scope=formula(big), dir="both")

#45 used, null = Forward, then stepwise 
length(coef(stepwise))
model1 = formula(stepwise)


## stepwise model 1.2 Green-rating
full = lm(Rent ~ .-CS_PropertyID-LEED-Energystar, data=GB_cleaned)
null = glm(Rent~1, data=GB_cleaned)
fwd = step(null, scope=formula(full), dir="forward")

length(coef(fwd))
#big1  = lm(Rent ~ (.-CS_PropertyID-LEED-Energystar)^2 + log(empl_gr) + log(age) + log(Electricity_Costs), data=GB_cleaned)
big1  = lm(Rent ~ (.-CS_PropertyID-LEED-Energystar)^2 + poly(age,2) + poly(empl_gr,2) + poly(Electricity_Costs,2)+ poly(Gas_Costs,2)+ poly(total_dd_07,2)+ poly(size,2), data=GB_cleaned)
stepwise1 = step(null, scope=formula(big1), dir="both")

#44 used, null = Forward, then stepwise 
length(coef(stepwise1))
model1_2 = formula(stepwise1)

## Gamma Lasso model 2.1 LEED & Energy
gbx = sparse.model.matrix(Rent ~ (.-CS_PropertyID-green_rating)^2, data=GB_cleaned)[,-1] 
gby = GB_cleaned$Rent
gblasso = gamlr(gbx, gby, lambda.min.ratio=0.000001)
plot(gblasso) # the path plot!
gbbeta = coef(gblasso)
log(gblasso$lambda[which.min(AICc(gblasso))])
#184 used in Lasso
sum(gbbeta!=0)

p1 <- dimnames(gbbeta)[[1]]
p2 <- c()
for (i in c(1:length(gbbeta))){
  p2 <- c(p2, as.list(gbbeta)[[i]])
}

model2 = c("Rent ~ ")
for (i in c(2:length(gbbeta))){
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

## Gamma Lasso model 2.2 Green-rating
gbx = sparse.model.matrix(Rent ~ (.-CS_PropertyID-LEED-Energystar)^2, data=GB_cleaned)[,-1] 
gby = GB_cleaned$Rent
gblasso = gamlr(gbx, gby, lambda.min.ratio=0.000001)
plot(gblasso) # the path plot!
gbbeta2 = coef(gblasso)
log(gblasso$lambda[which.min(AICc(gblasso))])
#168 used in Lasso
sum(gbbeta2!=0)

p1 <- dimnames(gbbeta2)[[1]]
p2 <- c()
for (i in c(1:length(gbbeta2))){
  p2 <- c(p2, as.list(gbbeta2)[[i]])
}

model22 = c("Rent ~ ")
for (i in c(2:length(gbbeta2))){
  if (p2[i] != 0){
    if (model22 == "Rent ~ "){
      model22 = paste(model22, p1[i])
    }
    else{
      model22 = paste(model22,"+", p1[i])
    }
  }
}
model22 <- as.formula(model22)

N = nrow(GB_cleaned)
# Create a vector of fold indicators
K = 10
fold_id = rep_len(1:K, N)  # repeats 1:K over and over again
fold_id = sample(fold_id, replace=FALSE) # permute the order randomly
step_err_save = rep(0, K)
step_err_save1 = rep(0, K)
lasso_err_save = rep(0, K)
lasso_err_save1 = rep(0, K)
for(i in 1:K) {
  train_set = which(fold_id != i)
  y_test = GB_cleaned$Rent[-train_set]
  step_model = lm(model1, data=GB_cleaned[train_set,])
  step_model_1 = lm(model1_2, data=GB_cleaned[train_set,])
  lasso_model = lm(model2, data=GB_cleaned[train_set,])
  lasso_model_1 = lm(model22, data=GB_cleaned[train_set,])
  
  yhat_test1 = predict(step_model, newdata=GB_cleaned[-train_set,])
  step_err_save[i] = mean((y_test - yhat_test1)^2)
  
  yhat_test2 = predict(step_model_1, newdata=GB_cleaned[-train_set,])
  step_err_save1[i] = mean((y_test - yhat_test2)^2)
  
  yhat_test3 = predict(lasso_model, newdata=GB_cleaned[-train_set,])
  lasso_err_save[i] = mean((y_test - yhat_test3)^2)
  
  yhat_test4 = predict(lasso_model_1, newdata=GB_cleaned[-train_set,])
  lasso_err_save1[i] = mean((y_test - yhat_test4)^2)
}
# RMSE
c(sqrt(mean(step_err_save)),sqrt(mean(step_err_save1)),sqrt(mean(lasso_err_save)),sqrt(mean(lasso_err_save1)))

