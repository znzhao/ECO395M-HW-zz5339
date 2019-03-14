library(tidyverse)
library(mosaic)
library(class)
library(FNN)

urlfile<-'https://raw.githubusercontent.com/znzhao/ECO395M-HW-zz5339/master/HW2/brca.csv'
brca<-read.csv(url(urlfile))

n = nrow(brca)
xtabs(~brca$recall + brca$cancer)
table2 = xtabs(~recall + cancer, data=brca)
# prop.table(table2, margin=1)
sum(brca$recall != brca$cancer)/n


dev_out = function(ml, y, dataset) {
  probhat = predict(ml, newdata=dataset, type='response')
  p0 = 1-probhat
  phat = data.frame(P0 = p0, p1 = probhat)
  rc_pairs = cbind(seq_along(y), y)
  -2*sum(log(phat[rc_pairs]))
}



Err1 = do(50)*{
  data = brca
  n = nrow(data)
  n_train = round(0.8*n)  # round to nearest integer
  n_test = n - n_train
  train_cases = sample.int(n, n_train, replace=FALSE)
  test_cases = setdiff(1:n, train_cases)
  DF_train = data[train_cases,]
  DF_test = data[test_cases,]
  
  glm_modelA = glm(cancer~ recall, data = DF_train)
  #summary(glm_modelA)
  glm_modelB = glm(cancer~ .-radiologist, data = DF_train)
  #summary(glm_modelB)
  glm_modelC = glm(cancer~ recall + (age + history + symptoms + menopause + density)^2, data = DF_train)
  #summary(glm_modelC)
  glm_modelD = glm(cancer~ recall + history + symptoms + menopause, data = DF_train)
  #summary(glm_modelD)
  glm_modelE = glm(cancer~ .-radiologist-recall, data = DF_train)
  #summary(glm_modelD)
  glm_model1 = glm(cancer~ recall + age, data = DF_train)
  #summary(glm_model1)
  glm_model2 = glm(cancer~ recall + history, data = DF_train)
  #summary(glm_model2)
  glm_model3 = glm(cancer~ recall + symptoms, data = DF_train)
  #summary(glm_model3)
  glm_model4 = glm(cancer~ recall + menopause, data = DF_train)
  #summary(glm_model4)
  glm_model5 = glm(cancer~ recall + density, data = DF_train)
  #summary(glm_model5)
  
  phat_testA = predict(glm_modelA, DF_test, type='response')
  #threshold = (max(phat_testA)-min(phat_testA))/2+min(phat_testA)
  #threshold = max(phat_testA)
  threshold = sum(brca$cancer == 1)/n+0.001

  
  yhat_testA = ifelse(phat_testA >= threshold, 1, 0)
  tA = xtabs(~DF_test$cancer+yhat_testA)
  
  
  phat_testB = predict(glm_modelB, DF_test, type='response')
  yhat_testB = ifelse(phat_testB >= threshold, 1, 0)
  tB = xtabs(~DF_test$cancer+yhat_testB)
  
  
  phat_testC = predict(glm_modelC, DF_test, type='response')
  yhat_testC = ifelse(phat_testC >= threshold, 1, 0)
  tC = xtabs(~DF_test$cancer+yhat_testC)
  
  
  phat_testD = predict(glm_modelD, DF_test, type='response')
  yhat_testD = ifelse(phat_testD >= threshold, 1, 0)
  tD = xtabs(~DF_test$cancer+yhat_testD)
  
  phat_testE = predict(glm_modelE, DF_test, type='response')
  yhat_testE = ifelse(phat_testE >= threshold, 1, 0)
  tE = xtabs(~DF_test$cancer+yhat_testE) 
  
  phat_test1 = predict(glm_model1, DF_test, type='response')
  yhat_test1 = ifelse(phat_test1 >= threshold, 1, 0)
  t1 = xtabs(~DF_test$cancer+yhat_test1) 
  
  phat_test2 = predict(glm_model2, DF_test, type='response')
  yhat_test2 = ifelse(phat_test2 >= threshold, 1, 0)
  t2 = xtabs(~DF_test$cancer+yhat_test2)
  
  phat_test3 = predict(glm_model3, DF_test, type='response')
  yhat_test3 = ifelse(phat_test3 >= threshold, 1, 0)
  t3 = xtabs(~DF_test$cancer+yhat_test3)
  
  phat_test4 = predict(glm_model4, DF_test, type='response')
  yhat_test4 = ifelse(phat_test4 >= threshold, 1, 0)
  t4 = xtabs(~DF_test$cancer+yhat_test4)
  
  phat_test5 = predict(glm_model5, DF_test, type='response')
  yhat_test5 = ifelse(phat_test5 >= threshold, 1, 0)
  t5 = xtabs(~DF_test$cancer+yhat_test5)
  
  c(
    dev_out(ml = glm_modelA,dataset = DF_test,y = DF_test$cancer),
    dev_out(ml = glm_modelB,dataset = DF_test,y = DF_test$cancer),
    dev_out(ml = glm_modelC,dataset = DF_test,y = DF_test$cancer),
    dev_out(ml = glm_modelD,dataset = DF_test,y = DF_test$cancer)
#    dev_out(ml = glm_modelE,dataset = DF_test,y = DF_test$cancer)
#    dev_out(ml = glm_model1,dataset = DF_test,y = DF_test$cancer),
#    dev_out(ml = glm_model2,dataset = DF_test,y = DF_test$cancer),
#    dev_out(ml = glm_model3,dataset = DF_test,y = DF_test$cancer),
#    dev_out(ml = glm_model4,dataset = DF_test,y = DF_test$cancer),
#    dev_out(ml = glm_model5,dataset = DF_test,y = DF_test$cancer)
  )
  }

colnames(Err1) <- c("Baseline", "Model 1", "Model 2", "Model 3")
colMeans(Err1)

tA
tB
tC
tD
tE

glm_modelA = glm(cancer ~ recall, data = brca)
summary(glm_modelA)
phatA = predict(glm_modelA, brca, type='response')
yhatA = ifelse(phatA >= threshold, 1, 0)
t1 = xtabs(~brca$cancer+yhatA) 
t1

glm_modelB = glm(cancer ~ recall + history + symptoms + menopause, data = brca)
summary(glm_modelB)
phatB = predict(glm_modelB, brca, type='response')
yhatB = ifelse(phatB >= threshold, 1, 0)
t2 = xtabs(~brca$cancer+yhatB) 
t2

glm_modelE = glm(cancer~ .-radiologist-recall, data = brca)
summary(glm_modelE)
phatE = predict(glm_modelE, brca, type='response')
yhatE = ifelse(phatE >= threshold, 1, 0)
t3 = xtabs(~brca$cancer+yhatE) 
t3
