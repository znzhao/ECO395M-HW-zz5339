library(tidyverse)
library(mosaic)
library(class)
library(FNN)
data(brca)

summary(brca)
c(
glm_C_error(recall~radiologist+age,data=brca,Ntimes=200),
glm_C_error(recall~radiologist+history,data=brca,Ntimes=200),
glm_C_error(recall~radiologist+symptoms,data=brca,Ntimes=200),
glm_C_error(recall~radiologist+menopause,data=brca,Ntimes=200),
glm_C_error(recall~radiologist+density,data=brca,Ntimes=200),

glm_C_error(recall~radiologist+age+history+symptoms+menopause+density,data=brca,Ntimes=200),
glm_C_error(recall~(radiologist+age+history+symptoms+menopause+density)^2,data=brca,Ntimes=200),

glm_C_error(recall~radiologist+age+history+symptoms+menopause,data=brca,Ntimes=200),
glm_C_error(recall~(radiologist+age+history+symptoms+menopause)^2,data=brca,Ntimes=200),
glm_C_error(recall~radiologist+age+history+symptoms+density,data=brca,Ntimes=200),
glm_C_error(recall~(radiologist+age+history+symptoms+density)^2,data=brca,Ntimes=200),
glm_C_error(recall~radiologist+age+history+menopause+density,data=brca,Ntimes=200),
glm_C_error(recall~(radiologist+age+history+menopause+density)^2,data=brca,Ntimes=200),
glm_C_error(recall~radiologist+age+symptoms+menopause+density,data=brca,Ntimes=200),
glm_C_error(recall~(radiologist+age+symptoms+menopause+density)^2,data=brca,Ntimes=200),
glm_C_error(recall~radiologist+history+symptoms+menopause+density,data=brca,Ntimes=200),
glm_C_error(recall~(radiologist+history+symptoms+menopause+density)^2,data=brca,Ntimes=200),

glm_C_error(recall~radiologist+age+history+symptoms,data=brca,Ntimes=200),
glm_C_error(recall~(radiologist+age+history+symptoms)^2,data=brca,Ntimes=200),
glm_C_error(recall~radiologist+age+history+menopause,data=brca,Ntimes=200),
glm_C_error(recall~(radiologist+age+history+menopause)^2,data=brca,Ntimes=200),
glm_C_error(recall~radiologist+age+history+density,data=brca,Ntimes=200),
glm_C_error(recall~(radiologist+age+history+density)^2,data=brca,Ntimes=200),
glm_C_error(recall~radiologist+age+symptoms+menopause,data=brca,Ntimes=200),
glm_C_error(recall~(radiologist+age+symptoms+menopause)^2,data=brca,Ntimes=200),
glm_C_error(recall~radiologist+age+symptoms+density,data=brca,Ntimes=200),
glm_C_error(recall~(radiologist+age+symptoms+density)^2,data=brca,Ntimes=200),
glm_C_error(recall~radiologist+age+menopause+density,data=brca,Ntimes=200),
glm_C_error(recall~(radiologist+age+menopause+density)^2,data=brca,Ntimes=200),
glm_C_error(recall~radiologist+history+symptoms+menopause,data=brca,Ntimes=200),
glm_C_error(recall~(radiologist+history+symptoms+menopause)^2,data=brca,Ntimes=200),
glm_C_error(recall~radiologist+history+symptoms+density,data=brca,Ntimes=200),
glm_C_error(recall~(radiologist+history+symptoms+density)^2,data=brca,Ntimes=200),
glm_C_error(recall~radiologist+history+menopause+density,data=brca,Ntimes=200),
glm_C_error(recall~(radiologist+history+menopause+density)^2,data=brca,Ntimes=200),
glm_C_error(recall~radiologist+symptoms+menopause+density,data=brca,Ntimes=200),
glm_C_error(recall~(radiologist+symptoms+menopause+density)^2,data=brca,Ntimes=200),

glm_C_error(recall~radiologist+age+history,data=brca,Ntimes=200),
glm_C_error(recall~(radiologist+age+history)^2,data=brca,Ntimes=200),
glm_C_error(recall~radiologist+age+symptoms,data=brca,Ntimes=200),
glm_C_error(recall~(radiologist+age+symptoms)^2,data=brca,Ntimes=200),
glm_C_error(recall~radiologist+age+menopause,data=brca,Ntimes=200),
glm_C_error(recall~(radiologist+age+menopause)^2,data=brca,Ntimes=200),
glm_C_error(recall~radiologist+age+density,data=brca,Ntimes=200),
glm_C_error(recall~(radiologist+age+density)^2,data=brca,Ntimes=200),
glm_C_error(recall~radiologist+history+symptoms,data=brca,Ntimes=200),
glm_C_error(recall~(radiologist+history+symptoms)^2,data=brca,Ntimes=200),
glm_C_error(recall~radiologist+history+menopause,data=brca,Ntimes=200),
glm_C_error(recall~(radiologist+history+menopause)^2,data=brca,Ntimes=200),
glm_C_error(recall~radiologist+history+density,data=brca,Ntimes=200),
glm_C_error(recall~(radiologist+history+density)^2,data=brca,Ntimes=200),
glm_C_error(recall~radiologist+symptoms+menopause,data=brca,Ntimes=200),
glm_C_error(recall~(radiologist+symptoms+menopause)^2,data=brca,Ntimes=200),
glm_C_error(recall~radiologist+symptoms+density,data=brca,Ntimes=200),
glm_C_error(recall~(radiologist+symptoms+density)^2,data=brca,Ntimes=200),
glm_C_error(recall~radiologist+menopause+density,data=brca,Ntimes=200),
glm_C_error(recall~(radiologist+menopause+density)^2,data=brca,Ntimes=200))
glm_C_error(recall~radiologist*(age+history+symptoms+menopause),data=brca,Ntimes=200)

modelselect=glm(recall~radiologist*(age+history+symptoms+menopause),data=brca)
summary(modelselect)

n = nrow(brca)
pretest_cases = sample.int(n,50,replace=FALSE)
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
brca_predict



