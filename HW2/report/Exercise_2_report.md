Exercise 2
==========

By Chong Wang, Tianping Wu, Zhenning Zhao

Exercise 2.1
============

Long story short, we "hand-build" a model for price that outperforms the "medium" model that we considered in class, and the KNN model did not beat the “hand-build” model that we selected.

The models that we checked are listed below.

The performance of the models are mesured with average out-of-sample RMSE. We use the 80% of the data to do regressions and calculate RMSE for the rest 20%, and rerun the Monte Carlo training-testing split to calculate the average RMSE. The result of the models are listed below.

|         | AVG RMSE |
|---------|:--------:|
| model 1 | 66445.34 |
| model 2 | 66273.29 |
| model 3 | 60521.15 |
| model 4 | 60442.53 |
| model 5 | 59826.62 |
| model 6 | 60213.68 |
| model 7 | 60966.02 |

The best model that we solved is model 5. This model beats all the other models that we choose by having a smaller average RMSE of around 60000, while the average RMSE of the baseline model is around 66000. The regression result is:

|                                   |  coefficients.Estimate|  coefficients.Std..Error|  coefficients.t.value|  coefficients.Pr...t..|
|-----------------------------------|----------------------:|------------------------:|---------------------:|----------------------:|
| (Intercept)                       |          -8.643001e+03|             1.770303e+04|            -0.4882215|              0.6254558|
| landValue                         |           8.332313e-01|             4.815750e-02|            17.3022099|              0.0000000|
| lotSize                           |           8.886326e+03|             8.083021e+03|             1.0993817|              0.2717569|
| bedrooms                          |          -9.010594e+03|             3.051553e+03|            -2.9527897|              0.0031923|
| bathrooms                         |           2.423306e+04|             3.872891e+03|             6.2571003|              0.0000000|
| livingArea                        |           9.013328e+01|             5.689994e+00|            15.8406634|              0.0000000|
| fuelelectric                      |          -4.945208e+04|             4.874015e+04|            -1.0146066|              0.3104374|
| fueloil                           |           3.908867e+04|             1.311235e+04|             2.9810578|              0.0029133|
| heatinghot water/steam            |           1.277797e+04|             1.276971e+04|             1.0006468|              0.3171397|
| heatingelectric                   |           4.673921e+04|             4.935837e+04|             0.9469359|              0.3438057|
| centralAirNo                      |           3.461381e+04|             1.046454e+04|             3.3077241|              0.0009602|
| pctCollege                        |           1.982960e+01|             2.603112e+02|             0.0761765|              0.9392876|
| fireplaces                        |           4.139041e+04|             1.479376e+04|             2.7978287|              0.0052026|
| age                               |          -5.979931e+02|             2.613114e+02|            -2.2884313|              0.0222343|
| rooms                             |           2.539648e+03|             9.776609e+02|             2.5976782|              0.0094665|
| lotSize:bedrooms                  |           1.639476e+03|             2.742749e+03|             0.5977493|              0.5500866|
| lotSize:bathrooms                 |          -3.076214e+03|             3.420065e+03|            -0.8994609|              0.3685343|
| livingArea:fuelelectric           |           2.420885e+01|             2.803848e+01|             0.8634150|              0.3880308|
| livingArea:fueloil                |          -2.464235e+01|             7.454578e+00|            -3.3056672|              0.0009672|
| livingArea:heatinghot water/steam |          -1.068582e+01|             6.773995e+00|            -1.5774770|              0.1148714|
| livingArea:heatingelectric        |          -2.824654e+01|             2.859791e+01|            -0.9877132|              0.3234334|
| livingArea:centralAirNo           |          -2.527276e+01|             5.479314e+00|            -4.6123959|              0.0000043|
| pctCollege:fireplaces             |          -7.022711e+02|             2.601372e+02|            -2.6996180|              0.0070106|
| pctCollege:age                    |           1.042842e+01|             4.879803e+00|             2.1370580|              0.0327353|

From the regression we can find many factors that could influence the house price.

First of all, the most important factor is the land value. When we include the land value into account, the RMSE dropped dramatically. It is clearly true that the higher the land value is, the higher the house price is.

Second, the room with more bedrooms have a lower price. This makes sense because more bedrooms means there are more people sharing the apartment, hence the utility of each person is dropping. On the other hand, the apartment with more bathrooms have a higher price. The apartment with larger living area have a higher price, and the price of the apartment drops as the age of the apartment grows. These conclusions matches our intuition.

Third, comparing with the apartments fueling with gas, the apartments fueling with oil have higher prices. comparing with the apartments having a central air conditioner, the apartments with separate air conditioner have higher price. What’s more, the apartments with a fireplace is more expensive, and the older the apartment is the lower the price is.

Forth, the interactions between the number of bedrooms or bathrooms and the lotsize are not significant, but the interactions between the living area and the fuel and whether the house has a central air conditioner is significant. To be more specific, the effect of the living area on the price of the room fueled with oil is lower than the room fueled with gas. And it is also true that the effect of the living area on the price of the room without a central air conditioner is lower than the room that has a central air conditioner.The interactions between whether the apartment is close to a college and the age of the house and the number of fireplaces are significant.

By using exactly same variables in the linear regression model it is very hard to beat the linear regression with the KNN model.

![](Exercise_2_report_files/figure-markdown_github/graph2.1.1-1.png)

From the plot of average RMSE vs K we can tell the optimal K for the KNN model is about 10-15. The lowest average RMSE that we can get with KNN model is about 63000, which is still higher than the average RMSE that we conclude using a linear model with interactions.
