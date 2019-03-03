library(tidyverse)
library(mosaic)
library(class)
library(FNN)
data(SaratogaHouses)

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
colnames(temp)<- c("heating_hotair", "heating_watersteam", "heatingelectric")
SaratogaHouses = cbind(SaratogaHouses,temp)
temp = model.matrix( ~ fuel-1,SaratogaHouses)
SaratogaHouses = cbind(SaratogaHouses,temp)
temp = model.matrix( ~ centralAir-1,SaratogaHouses)
SaratogaHouses = cbind(SaratogaHouses,temp)

c(
# model 1
lm_avgrmse(price ~ lotSize + age + livingArea + pctCollege + bedrooms + fireplaces + bathrooms + rooms + heating + fuel + centralAir, SaratogaHouses, Ntimes = 500),
# model 2
lm_avgrmse(price ~ lotSize + age + livingArea + pctCollege*fireplaces + bedrooms  + bathrooms + rooms + heating + centralAir, SaratogaHouses, Ntimes = 500),
# model 3
lm_avgrmse(price ~ landValue + livingArea + pctCollege + bedrooms + fireplaces + bathrooms + rooms + heating + fuel + centralAir, SaratogaHouses, Ntimes = 500),
# model 4
lm_avgrmse(price ~ landValue + livingArea + bedrooms + bathrooms + rooms + heating + fuel + centralAir, SaratogaHouses, Ntimes = 500),
# model 5, which is the best
lm_avgrmse(price ~ landValue + lotSize*bedrooms + livingArea*fuel + pctCollege*(fireplaces+age) + bathrooms + rooms + heating + centralAir, SaratogaHouses, Ntimes = 500),
# model 6
lm_avgrmse(price ~ landValue + lotSize*bedrooms + livingArea*fuel + pctCollege*(fireplaces+age) + centralAir, SaratogaHouses, Ntimes = 500)
)




X = subset(SaratogaHouses, select=c(-waterfront,-sewer,-newConstruction,-heating, -fuel, -centralAir, -centralAirNo, -fueloil, -heating_hotair))
y = subset(SaratogaHouses, select=c(price))

KNN_result <- data.frame(K=c(), rsme=c())
for(v in c(3:20)){
avgrmse = KNN_avgrmse(data_X = X, data_y = y, K = v, Ntimes = 100)
KNN_result <- rbind(KNN_result,c(v,avgrmse))
}

colnames(KNN_result) <- c("K","AVG_RMSE")
ggplot(data = KNN_result, aes(x = K, y = AVG_RMSE)) + 
  geom_point(shape = "O") +
  geom_line(col = "red")

