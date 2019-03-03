library(tidyverse)
library(mosaic)
library(class)
library(FNN)

urlfile<-'https://raw.githubusercontent.com/znzhao/ECO395M-HW-zz5339/master/HW2/brca.csv'
brca<-read.csv(url(urlfile))

n = nrow(brca)
xtabs(~brca$recall + brca$cancer)
table2 = xtabs(~recall + cancer, data=brca)
prop.table(table2, margin=1)
sum(brca$recall != brca$cancer)/n

Err1 = do(100)*{
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
  glm_modelC = glm(cancer~ recall+(.-recall-radiologist)^2, data = DF_train)
  #summary(glm_modelC)
  glm_modelD = glm(cancer~ recall+ age + menopause + density, data = DF_train)
  #summary(glm_modelD)
  glm_modelE = glm(cancer~ age*(density+menopause) +  symptoms*density+ recall, data = DF_train)
  #summary(glm_modelE)
  glm_modelF = glm(cancer~ (. -radiologist -recall)^2, data = DF_train)
  #summary(glm_modelF)
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
  threshold = sum(brca$cancer == 1)/n+0.002
  
  
  yhat_testA = ifelse(phat_testA >= threshold, 1, 0)
  t1 = xtabs(~DF_test$cancer+yhat_testA)
  
  
  phat_testB = predict(glm_modelB, DF_test, type='response')
  yhat_testB = ifelse(phat_testB >= threshold, 1, 0)
  t2 = xtabs(~DF_test$cancer+yhat_testB)
  
  
  phat_testC = predict(glm_modelC, DF_test, type='response')
  yhat_testC = ifelse(phat_testC >= threshold, 1, 0)
  t3 = xtabs(~DF_test$cancer+yhat_testC)
  
  
  phat_testD = predict(glm_modelD, DF_test, type='response')
  yhat_testD = ifelse(phat_testD >= threshold, 1, 0)
  t4 = xtabs(~DF_test$cancer+yhat_testD) 
  
  phat_testE = predict(glm_modelE, DF_test, type='response')
  yhat_testE = ifelse(phat_testE >= threshold, 1, 0)
  t5 = xtabs(~DF_test$cancer+yhat_testE) 
  
  phat_testF = predict(glm_modelF, DF_test, type='response')
  yhat_testF = ifelse(phat_testF >= threshold, 1, 0)
  t6 = xtabs(~DF_test$cancer+yhat_testF) 
  
  phat_test1 = predict(glm_model1, DF_test, type='response')
  yhat_test1 = ifelse(phat_test1 >= threshold, 1, 0)
  phat_test2 = predict(glm_model2, DF_test, type='response')
  yhat_test2 = ifelse(phat_test2 >= threshold, 1, 0)
  phat_test3 = predict(glm_model3, DF_test, type='response')
  yhat_test3 = ifelse(phat_test3 >= threshold, 1, 0)
  phat_test4 = predict(glm_model4, DF_test, type='response')
  yhat_test4 = ifelse(phat_test4 >= threshold, 1, 0)
  phat_test5 = predict(glm_model5, DF_test, type='response')
  yhat_test5 = ifelse(phat_test5 >= threshold, 1, 0)
  
  # accuracy
  # c(
  #   sum(DF_test$cancer != yhat_testA)/n_test ,
  #   sum(DF_test$cancer != yhat_testB)/n_test ,
  #   sum(DF_test$cancer != yhat_testC)/n_test ,
  #   sum(DF_test$cancer != yhat_testD)/n_test ,
  #   sum(DF_test$cancer != yhat_testE)/n_test ,
  #   sum(DF_test$cancer != yhat_testF)/n_test ,
  #   sum(DF_test$cancer != yhat_test1)/n_test ,
  #   sum(DF_test$cancer != yhat_test2)/n_test ,
  #   sum(DF_test$cancer != yhat_test3)/n_test ,
  #   sum(DF_test$cancer != yhat_test4)/n_test ,
  #   sum(DF_test$cancer != yhat_test5)/n_test )
  # recall
  # c(
  #   sum(DF_test$cancer == 1 & yhat_testA == 1)/sum(yhat_testA == 1),
  #   sum(DF_test$cancer == 1 & yhat_testB == 1)/sum(yhat_testB == 1),
  #   sum(DF_test$cancer == 1 & yhat_testC == 1)/sum(yhat_testC == 1),
  #   sum(DF_test$cancer == 1 & yhat_testD == 1)/sum(yhat_testD == 1),
  #   sum(DF_test$cancer == 1 & yhat_testE == 1)/sum(yhat_testE == 1),
  #   sum(DF_test$cancer == 1 & yhat_testF == 1)/sum(yhat_testE == 1),
  #   sum(DF_test$cancer == 1 & yhat_test1 == 1)/sum(yhat_test1 == 1),
  #   sum(DF_test$cancer == 1 & yhat_test2 == 1)/sum(yhat_test2 == 1),
  #   sum(DF_test$cancer == 1 & yhat_test3 == 1)/sum(yhat_test3 == 1),
  #   sum(DF_test$cancer == 1 & yhat_test4 == 1)/sum(yhat_test4 == 1),
  #   sum(DF_test$cancer == 1 & yhat_test5 == 1)/sum(yhat_test5 == 1))
  #precise
  # c(
  #   sum(DF_test$cancer == 1 & yhat_testA == 1)/sum(DF_test$cancer == 1),
  #   sum(DF_test$cancer == 1 & yhat_testB == 1)/sum(DF_test$cancer == 1),
  #   sum(DF_test$cancer == 1 & yhat_testC == 1)/sum(DF_test$cancer == 1),
  #   sum(DF_test$cancer == 1 & yhat_testD == 1)/sum(DF_test$cancer == 1),
  #   sum(DF_test$cancer == 1 & yhat_testE == 1)/sum(DF_test$cancer == 1),
  #   sum(DF_test$cancer == 1 & yhat_testF == 1)/sum(DF_test$cancer == 1),
  #   sum(DF_test$cancer == 1 & yhat_test1 == 1)/sum(DF_test$cancer == 1),
  #   sum(DF_test$cancer == 1 & yhat_test2 == 1)/sum(DF_test$cancer == 1),
  #   sum(DF_test$cancer == 1 & yhat_test3 == 1)/sum(DF_test$cancer == 1),
  #   sum(DF_test$cancer == 1 & yhat_test4 == 1)/sum(DF_test$cancer == 1),
  #   sum(DF_test$cancer == 1 & yhat_test5 == 1)/sum(DF_test$cancer == 1))
  }




Err2 = do(100)*{
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
  glm_modelC = glm(cancer~ recall+(.-recall-radiologist)^2, data = DF_train)
  #summary(glm_modelC)
  glm_modelD = glm(cancer~ recall+ age + menopause + density, data = DF_train)
  #summary(glm_modelD)
  glm_modelE = glm(cancer~ age*(density+menopause) +  symptoms*density+ recall, data = DF_train)
  #summary(glm_modelE)
  glm_modelF = glm(cancer~ (. -radiologist -recall)^2, data = DF_train)
  #summary(glm_modelF)
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
  threshold = sum(brca$cancer == 1)/n+0.02
  
  
  yhat_testA = ifelse(phat_testA >= threshold, 1, 0)
  t1 = xtabs(~DF_test$cancer+yhat_testA)
  
  
  phat_testB = predict(glm_modelB, DF_test, type='response')
  yhat_testB = ifelse(phat_testB >= threshold, 1, 0)
  t2 = xtabs(~DF_test$cancer+yhat_testB)
  
  
  phat_testC = predict(glm_modelC, DF_test, type='response')
  yhat_testC = ifelse(phat_testC >= threshold, 1, 0)
  t3 = xtabs(~DF_test$cancer+yhat_testC)
  
  
  phat_testD = predict(glm_modelD, DF_test, type='response')
  yhat_testD = ifelse(phat_testD >= threshold, 1, 0)
  t4 = xtabs(~DF_test$cancer+yhat_testD) 
  
  phat_testE = predict(glm_modelE, DF_test, type='response')
  yhat_testE = ifelse(phat_testE >= threshold, 1, 0)
  t5 = xtabs(~DF_test$cancer+yhat_testE) 
  
  phat_testF = predict(glm_modelF, DF_test, type='response')
  yhat_testF = ifelse(phat_testF >= threshold, 1, 0)
  t6 = xtabs(~DF_test$cancer+yhat_testF) 
  
  phat_test1 = predict(glm_model1, DF_test, type='response')
  yhat_test1 = ifelse(phat_test1 >= threshold, 1, 0)
  phat_test2 = predict(glm_model2, DF_test, type='response')
  yhat_test2 = ifelse(phat_test2 >= threshold, 1, 0)
  phat_test3 = predict(glm_model3, DF_test, type='response')
  yhat_test3 = ifelse(phat_test3 >= threshold, 1, 0)
  phat_test4 = predict(glm_model4, DF_test, type='response')
  yhat_test4 = ifelse(phat_test4 >= threshold, 1, 0)
  phat_test5 = predict(glm_model5, DF_test, type='response')
  yhat_test5 = ifelse(phat_test5 >= threshold, 1, 0)
  
  # accuracy
  c(
    sum(DF_test$cancer != yhat_testA)/n_test ,
    sum(DF_test$cancer != yhat_testB)/n_test ,
    sum(DF_test$cancer != yhat_testC)/n_test ,
    sum(DF_test$cancer != yhat_testD)/n_test ,
    sum(DF_test$cancer != yhat_testE)/n_test ,
    sum(DF_test$cancer != yhat_testF)/n_test ,
    sum(DF_test$cancer != yhat_test1)/n_test ,
    sum(DF_test$cancer != yhat_test2)/n_test ,
    sum(DF_test$cancer != yhat_test3)/n_test ,
    sum(DF_test$cancer != yhat_test4)/n_test ,
    sum(DF_test$cancer != yhat_test5)/n_test )
  # recall
  # c(
  #   sum(DF_test$cancer == 1 & yhat_testA == 1)/sum(yhat_testA == 1),
  #   sum(DF_test$cancer == 1 & yhat_testB == 1)/sum(yhat_testB == 1),
  #   sum(DF_test$cancer == 1 & yhat_testC == 1)/sum(yhat_testC == 1),
  #   sum(DF_test$cancer == 1 & yhat_testD == 1)/sum(yhat_testD == 1),
  #   sum(DF_test$cancer == 1 & yhat_testE == 1)/sum(yhat_testE == 1),
  #   sum(DF_test$cancer == 1 & yhat_testF == 1)/sum(yhat_testE == 1),
  #   sum(DF_test$cancer == 1 & yhat_test1 == 1)/sum(yhat_test1 == 1),
  #   sum(DF_test$cancer == 1 & yhat_test2 == 1)/sum(yhat_test2 == 1),
  #   sum(DF_test$cancer == 1 & yhat_test3 == 1)/sum(yhat_test3 == 1),
  #   sum(DF_test$cancer == 1 & yhat_test4 == 1)/sum(yhat_test4 == 1),
  #   sum(DF_test$cancer == 1 & yhat_test5 == 1)/sum(yhat_test5 == 1))
  #precise
  # c(
  #   sum(DF_test$cancer == 1 & yhat_testA == 1)/sum(DF_test$cancer == 1),
  #   sum(DF_test$cancer == 1 & yhat_testB == 1)/sum(DF_test$cancer == 1),
  #   sum(DF_test$cancer == 1 & yhat_testC == 1)/sum(DF_test$cancer == 1),
  #   sum(DF_test$cancer == 1 & yhat_testD == 1)/sum(DF_test$cancer == 1),
  #   sum(DF_test$cancer == 1 & yhat_testE == 1)/sum(DF_test$cancer == 1),
  #   sum(DF_test$cancer == 1 & yhat_testF == 1)/sum(DF_test$cancer == 1),
  #   sum(DF_test$cancer == 1 & yhat_test1 == 1)/sum(DF_test$cancer == 1),
  #   sum(DF_test$cancer == 1 & yhat_test2 == 1)/sum(DF_test$cancer == 1),
  #   sum(DF_test$cancer == 1 & yhat_test3 == 1)/sum(DF_test$cancer == 1),
  #   sum(DF_test$cancer == 1 & yhat_test4 == 1)/sum(DF_test$cancer == 1),
  #   sum(DF_test$cancer == 1 & yhat_test5 == 1)/sum(DF_test$cancer == 1))
}
#sum(DF_test$cancer == 1 & yhat_testA == 1)/sum(yhat_testA == 1)
colMeans(Err1)
#sum(DF_test$cancer == 1 & yhat_testA == 1)/sum(DF_test$cancer == 1)
colMeans(Err2)
