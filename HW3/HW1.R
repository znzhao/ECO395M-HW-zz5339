library(tidyverse)
library(mosaic)
library(foreach)
library(doMC)
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
formula(stepwise)

## Gamma Lasso model
gbx = sparse.model.matrix(Rent ~ (.-CS_PropertyID-green_rating)^2, data=GB_cleaned)[,-1] 
gby = GB_cleaned$Rent
gblasso = gamlr(gbx, gby, lambda.min.ratio=0.000001)
plot(gblasso) # the path plot!
gbbeta = coef(gblasso)
log(gblasso$lambda[which.min(AICc(gblasso))])
sum(gbbeta!=0)

gbcvl = cv.gamlr(gbx, gby, verb=TRUE)

gbb.min = coef(gbcvl, select="min")
log(gbcvl$lambda.min)
sum(gbb.min!=0) # note: this is random!  because of the CV randomness

