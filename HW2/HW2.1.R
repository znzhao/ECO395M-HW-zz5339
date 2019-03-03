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

# All interactions
# the ()^2 says "include all pairwise interactions"
lm_big = lm(price ~ (. - sewer - waterfront - landValue - newConstruction)^2, data=SaratogaHouses)
summary(lm_big)

####
# Compare out-of-sample predictive performance
####

# performance check
SaratogaHouses$n_heating = as.numeric(SaratogaHouses$heating)
SaratogaHouses$n_fuel = as.numeric(SaratogaHouses$fuel)
SaratogaHouses$n_centralAir = as.numeric(SaratogaHouses$centralAir)

# model 1
lm_avgrmse(price ~ lotSize + age + livingArea + pctCollege + bedrooms + fireplaces + bathrooms + rooms + heating + fuel + centralAir, SaratogaHouses, Ntimes = 500)
# model 2
lm_avgrmse(price ~ lotSize + age + livingArea + pctCollege*fireplaces + bedrooms  + bathrooms + rooms + heating + centralAir, SaratogaHouses, Ntimes = 500)
# model 3, which is the best
lm_avgrmse(price ~ lotSize*bedrooms + livingArea*fuel + pctCollege*(fireplaces+age) + bathrooms + rooms + heating + centralAir, SaratogaHouses, Ntimes = 500)
# model 4
lm_avgrmse(price ~ lotSize*bedrooms + livingArea*fuel + pctCollege*(fireplaces+age) + centralAir, SaratogaHouses, Ntimes = 500)



KNN_result <- data.frame(K=c(), rsme=c())

X = select(SaratogaHouses,lotSize , age , livingArea , pctCollege , bedrooms , fireplaces , bathrooms , rooms , n_heating , n_fuel , n_centralAir )
y = select(SaratogaHouses, price)

for(v in c(3:20)){
avgrmse = KNN_avgrmse(data_X = X, data_y = y, K = v, Ntimes = 100)
KNN_result <- rbind(KNN_result,c(v,avgrmse))
}

colnames(KNN_result) <- c("K","AVG_RMSE")
ggplot(data = KNN_result, aes(x = K, y = AVG_RMSE)) + 
  geom_point(shape = "O") +
  geom_line(col = "red")
