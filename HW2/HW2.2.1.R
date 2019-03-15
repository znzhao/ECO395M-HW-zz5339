library(tidyverse)
library(mosaic)
library(class)
library(FNN)

urlfile<-'https://raw.githubusercontent.com/jgscott/ECO395M/master/data/brca.csv'
brca<-read.csv(url(urlfile))

summary(brca)

rmse = function(y, yhat) {
  sqrt( mean( (y - yhat)^2 ) )
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
    sum(yhat_test != unlist(DF_test[as.character(fo[[2]])]))/n_test 
  }
  colMeans(rmse_vals)
}



c(
glm_C_error(recall~radiologist*(age+history+symptoms+menopause+density),data=brca,Ntimes=200),
glm_C_error(recall~radiologist+age+history+symptoms+menopause+density,data=brca,Ntimes=200),
glm_C_error(recall~(radiologist+age+history+symptoms+menopause+density)^2,data=brca,Ntimes=200)
)


A="recall~radiologist*(age+history+symptoms+menopause+density)"
B="recall~radiologist+age+history+symptoms+menopause+density"
C="recall~(radiologist+age+history+symptoms+menopause+density)^2"


List <- c(A,B,C)

for(i in List){
  modelselect=glm(i,data=brca)
  n = nrow(brca)
  pretest_cases = sample.int(n,100,replace=FALSE)
  brca_pretest = brca[pretest_cases,]
  brca_sample=data.frame(brca_pretest)
  brca_samplerepeat=brca_sample[rep(1:nrow(brca_sample),each=5),-1]
  brca_samplerepeat$radiologist=c("radiologist13","radiologist34","radiologist66","radiologist89","radiologist95")
  brca_samplerepeat
  
  yhat_recall = predict(modelselect, brca_samplerepeat)
  yhat_recall
  
  brca_samplerepeat=cbind(brca_samplerepeat,yhat_recall)
  
  brca_predict<-brca_samplerepeat%>%
    group_by(radiologist)%>%
    summarise(Prob_recall = mean(yhat_recall))
  print(brca_predict)
}



