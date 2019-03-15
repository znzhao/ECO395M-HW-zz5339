Exercise 2
==========

By Chong Wang, Tianping Wu, Zhenning Zhao

Exercise 2.1
------------

Long story short, we "hand-build" a model for price that outperforms the "medium" model that we considered in class, and the KNN model did not beat the “hand-build” model that we selected.

The models that we checked are listed below.

The performance of the models are mesured with average out-of-sample RMSE. We use the 80% of the data to do regressions and calculate RMSE for the rest 20%, and rerun the Monte Carlo training-testing split to calculate the average RMSE. The result of the models are listed below.

|         | AVG RMSE |
|---------|:--------:|
| model 1 | 66690.35 |
| model 2 | 66457.67 |
| model 3 | 60532.52 |
| model 4 | 60468.09 |
| model 5 | 59938.69 |
| model 6 | 60288.78 |
| model 7 | 61033.30 |

The best model that we solved is model 5. This model beats all the other models that we choose by having a smaller average RMSE of around 60000, while the average RMSE of the baseline model is around 66000. The regression result is:

|                                   | coefficients.Estimate | coefficients.Std..Error | coefficients.t.value | coefficients.Pr...t.. |
|-----------------------------------|:---------------------:|:-----------------------:|:--------------------:|:---------------------:|
| (Intercept)                       |     -8.643001e+03     |       1.770303e+04      |      -0.4882215      |       0.6254558       |
| landValue                         |      8.332313e-01     |       4.815750e-02      |      17.3022099      |       0.0000000       |
| lotSize                           |      8.886326e+03     |       8.083021e+03      |       1.0993817      |       0.2717569       |
| bedrooms                          |     -9.010594e+03     |       3.051553e+03      |      -2.9527897      |       0.0031923       |
| bathrooms                         |      2.423306e+04     |       3.872891e+03      |       6.2571003      |       0.0000000       |
| livingArea                        |      9.013328e+01     |       5.689994e+00      |      15.8406634      |       0.0000000       |
| fuelelectric                      |     -4.945208e+04     |       4.874015e+04      |      -1.0146066      |       0.3104374       |
| fueloil                           |      3.908867e+04     |       1.311235e+04      |       2.9810578      |       0.0029133       |
| heatinghot water/steam            |      1.277797e+04     |       1.276971e+04      |       1.0006468      |       0.3171397       |
| heatingelectric                   |      4.673921e+04     |       4.935837e+04      |       0.9469359      |       0.3438057       |
| centralAirNo                      |      3.461381e+04     |       1.046454e+04      |       3.3077241      |       0.0009602       |
| pctCollege                        |      1.982960e+01     |       2.603112e+02      |       0.0761765      |       0.9392876       |
| fireplaces                        |      4.139041e+04     |       1.479376e+04      |       2.7978287      |       0.0052026       |
| age                               |     -5.979931e+02     |       2.613114e+02      |      -2.2884313      |       0.0222343       |
| rooms                             |      2.539648e+03     |       9.776609e+02      |       2.5976782      |       0.0094665       |
| lotSize:bedrooms                  |      1.639476e+03     |       2.742749e+03      |       0.5977493      |       0.5500866       |
| lotSize:bathrooms                 |     -3.076214e+03     |       3.420065e+03      |      -0.8994609      |       0.3685343       |
| livingArea:fuelelectric           |      2.420885e+01     |       2.803848e+01      |       0.8634150      |       0.3880308       |
| livingArea:fueloil                |     -2.464235e+01     |       7.454578e+00      |      -3.3056672      |       0.0009672       |
| livingArea:heatinghot water/steam |     -1.068582e+01     |       6.773995e+00      |      -1.5774770      |       0.1148714       |
| livingArea:heatingelectric        |     -2.824654e+01     |       2.859791e+01      |      -0.9877132      |       0.3234334       |
| livingArea:centralAirNo           |     -2.527276e+01     |       5.479314e+00      |      -4.6123959      |       0.0000043       |
| pctCollege:fireplaces             |     -7.022711e+02     |       2.601372e+02      |      -2.6996180      |       0.0070106       |
| pctCollege:age                    |      1.042842e+01     |       4.879803e+00      |       2.1370580      |       0.0327353       |

From the regression we can find many factors that could influence the house price.

First of all, the most important factor is the land value. When we include the land value into account, the RMSE dropped dramatically. It is clearly true that the higher the land value is, the higher the house price is.

Second, the room with more bedrooms have a lower price. This makes sense because more bedrooms means there are more people sharing the apartment, hence the utility of each person is dropping. On the other hand, the apartment with more bathrooms have a higher price. The apartment with larger living area have a higher price, and the price of the apartment drops as the age of the apartment grows. These conclusions matches our intuition.

Third, comparing with the apartments fueling with gas, the apartments fueling with oil have higher prices. comparing with the apartments having a central air conditioner, the apartments with separate air conditioner have higher price. What’s more, the apartments with a fireplace is more expensive, and the older the apartment is the lower the price is.

Forth, the interactions between the number of bedrooms or bathrooms and the lotsize are not significant, but the interactions between the living area and the fuel and whether the house has a central air conditioner is significant. To be more specific, the effect of the living area on the price of the room fueled with oil is lower than the room fueled with gas. And it is also true that the effect of the living area on the price of the room without a central air conditioner is lower than the room that has a central air conditioner.The interactions between whether the apartment is close to a college and the age of the house and the number of fireplaces are significant.

By using exactly same variables in the linear regression model it is very hard to beat the linear regression with the KNN model.

![](Exercise_2_report_files/figure-markdown_github/graph2.1.1-1.png)

From the plot of average RMSE vs K we can tell the optimal K for the KNN model is about 10-15. The lowest average RMSE that we can get with KNN model is about 63000, which is still higher than the average RMSE that we conclude using a linear model with interactions.

Exercise 2.2
------------

### Exercise 2.2.1

|                                                   | coefficients.Estimate | coefficients.Std..Error | coefficients.t.value | coefficients.Pr...t.. |
|---------------------------------------------------|:---------------------:|:-----------------------:|:--------------------:|:---------------------:|
| (Intercept)                                       |       0.0646504       |        0.0802181        |       0.8059327      |       0.4204851       |
| radiologistradiologist34                          |       0.1362391       |        0.1168730        |       1.1657020      |       0.2440300       |
| radiologistradiologist66                          |       0.0441043       |        0.1300871        |       0.3390365      |       0.7346578       |
| radiologistradiologist89                          |       0.0538733       |        0.1191576        |       0.4521181      |       0.6512880       |
| radiologistradiologist95                          |       0.0672942       |        0.1128583        |       0.5962717      |       0.5511370       |
| ageage5059                                        |       0.0235449       |        0.0814978        |       0.2889019      |       0.7727200       |
| ageage6069                                        |       0.0700083       |        0.0952850        |       0.7347253      |       0.4626896       |
| ageage70plus                                      |       -0.0163438      |        0.0974823        |      -0.1676596      |       0.8668871       |
| history                                           |       0.0033248       |        0.0717259        |       0.0463546      |       0.9630374       |
| symptoms                                          |       0.2712195       |        0.1167454        |       2.3231702      |       0.0203822       |
| menopausepostmenoNoHT                             |       0.0544189       |        0.0631920        |       0.8611669      |       0.3893652       |
| menopausepostmenounknown                          |       0.0504485       |        0.1399803        |       0.3603973      |       0.7186309       |
| menopausepremeno                                  |       0.1149102       |        0.0864056        |       1.3298932      |       0.1838754       |
| radiologistradiologist34:ageage5059               |       -0.1502730      |        0.1195903        |      -1.2565649      |       0.2092227       |
| radiologistradiologist66:ageage5059               |       0.0310176       |        0.1233979        |       0.2513629      |       0.8015884       |
| radiologistradiologist89:ageage5059               |       0.0698584       |        0.1193006        |       0.5855660      |       0.5583075       |
| radiologistradiologist95:ageage5059               |       -0.0029036      |        0.1111955        |      -0.0261127      |       0.9791729       |
| radiologistradiologist34:ageage6069               |       -0.2053966      |        0.1368268        |      -1.5011430      |       0.1336537       |
| radiologistradiologist66:ageage6069               |       0.1295682       |        0.1472956        |       0.8796475      |       0.3792747       |
| radiologistradiologist89:ageage6069               |       0.0417234       |        0.1373233        |       0.3038330      |       0.7613222       |
| radiologistradiologist95:ageage6069               |       -0.2291511      |        0.1358573        |      -1.6867041      |       0.0919914       |
| radiologistradiologist34:ageage70plus             |       -0.0866439      |        0.1351808        |      -0.6409477      |       0.5217125       |
| radiologistradiologist66:ageage70plus             |       0.0734234       |        0.1446998        |       0.5074191      |       0.6119796       |
| radiologistradiologist89:ageage70plus             |       0.2168328       |        0.1488598        |       1.4566244      |       0.1455533       |
| radiologistradiologist95:ageage70plus             |       -0.0102200      |        0.1342733        |      -0.0761130      |       0.9393453       |
| radiologistradiologist34:history                  |       -0.0715935      |        0.0970816        |      -0.7374575      |       0.4610279       |
| radiologistradiologist66:history                  |       -0.0904766      |        0.0965069        |      -0.9375149      |       0.3487341       |
| radiologistradiologist89:history                  |       0.1354899       |        0.1028969        |       1.3167534      |       0.1882416       |
| radiologistradiologist95:history                  |       0.1913119       |        0.0964196        |       1.9841599      |       0.0475279       |
| radiologistradiologist34:symptoms                 |       -0.1617323      |        0.1610901        |      -1.0039867      |       0.3156428       |
| radiologistradiologist66:symptoms                 |       -0.2397796      |        0.1692441        |      -1.4167674      |       0.1568816       |
| radiologistradiologist89:symptoms                 |       -0.2891575      |        0.2007379        |      -1.4404725      |       0.1500660       |
| radiologistradiologist95:symptoms                 |       -0.2041870      |        0.1569547        |      -1.3009294      |       0.1936007       |
| radiologistradiologist34:menopausepostmenoNoHT    |       -0.0593911      |        0.0865682        |      -0.6860614      |       0.4928432       |
| radiologistradiologist66:menopausepostmenoNoHT    |       -0.0940416      |        0.0895871        |      -1.0497225      |       0.2941150       |
| radiologistradiologist89:menopausepostmenoNoHT    |       -0.1617020      |        0.0906139        |      -1.7845171      |       0.0746614       |
| radiologistradiologist95:menopausepostmenoNoHT    |       -0.1050014      |        0.0904748        |      -1.1605594      |       0.2461151       |
| radiologistradiologist34:menopausepostmenounknown |       0.0043501       |        0.1982345        |       0.0219441      |       0.9824972       |
| radiologistradiologist66:menopausepostmenounknown |       -0.0178815      |        0.1858325        |      -0.0962238      |       0.9233633       |
| radiologistradiologist89:menopausepostmenounknown |       0.6305388       |        0.3901480        |       1.6161529      |       0.1063961       |
| radiologistradiologist95:menopausepostmenounknown |       0.0540688       |        0.1887681        |       0.2864296      |       0.7746121       |
| radiologistradiologist34:menopausepremeno         |       -0.2054432      |        0.1265947        |      -1.6228424      |       0.1049577       |
| radiologistradiologist66:menopausepremeno         |       0.0248477       |        0.1317827        |       0.1885502      |       0.8504860       |
| radiologistradiologist89:menopausepremeno         |       -0.0715095      |        0.1255364        |      -0.5696317      |       0.5690634       |
| radiologistradiologist95:menopausepremeno         |       -0.1094439      |        0.1187297        |      -0.9217898      |       0.3568743       |

| radiologist         |  Prob\_recall|
|:--------------------|-------------:|
| radiologist13       |     0.1414687|
| radiologist34       |     0.0832916|
| radiologist66       |     0.1737384|
| radiologist89       |     0.2143642|
| radiologist95       |     0.1206523|
| \#\#\# Exercise 2.2 |            .2|

The second point that we want to make is that when the radiologists at this hospital interpret a mammogram to make a decision on whether to recall the patient, they should be weighing the history of the patients, the breast cancer symptoms and the menopause status of the patient more heavily than they currently are. Although this means they have to recall more patients back for further checks, it will minimize the false negative rate, identifying more precisely the patients who do end up getting cancer, so that they can be treated as early as possible.

First we build the baseline model, which suggests that when the doctors recall a patient, they tend to think that the patient has a cancer.

To formalize the model by regression, we regressed the patient’s cancer outcome on the radiologist’s recall decision with the logistic regression. The regression model is:

We split the dataset into the training set and the testing set using the standard 80-20 rule, and re-run the regression for 100 times to eliminate the stochasticity, and ending up with similar rates to the ones calculated with the entire database.

If we build a model using the recall decision and all the other clinical risk factors and it significantly performs better than the baseline model, it means that there are some risk factors that the doctors are missing.

We checked (1) the model regressing cancer indicator on the recall indicator and all the risk factors, (2) the model regressing cancer indicator on the recall indicator and all the risk factors and their interactions (3) two hand-build models. The thresholds that we chose for these models are the same as the baseline model, so that we can compare these models on the same level. The regression models are:

Before we show the result of the models, we need to explain the criteria that we use to judge these model. When we try to identify the patient, different kinds of error has different cost. It might not be a big problem if a healthy woman is recalled to do some further test, but it may cause death if the doctor didn’t identify the patients who have cancer. Hence the accurate rate is not the best criteria. Instead, we calculate the deviance of these model, and choose the model with smaller deviance.

The average deviance of the models are listed in the following table:

|          | AVG Deviation for Different Models |
|----------|:----------------------------------:|
| Baseline |              1.374563              |
| Model 1  |              1.391644              |
| Model 2  |              1.442991              |
| Model 3  |              1.314381              |

From the table we can tell that the Model 3 has the lowest average deviation, which means we can perform better than the doctors currently do if they give more weight on the terms in Model 3.

The logistic regression of model 3 using the whole dataset is shown below:

|                          | coefficients.Estimate | coefficients.Std..Error | coefficients.t.value | coefficients.Pr...t.. |
|--------------------------|:---------------------:|:-----------------------:|:--------------------:|:---------------------:|
| (Intercept)              |       0.0165484       |        0.0109027        |       1.5178354      |       0.1293784       |
| recall                   |       0.1299492       |        0.0165467        |       7.8534925      |       0.0000000       |
| history                  |       0.0079463       |        0.0155115        |       0.5122888      |       0.6085643       |
| symptoms                 |       0.0119353       |        0.0273940        |       0.4356900      |       0.6631576       |
| menopausepostmenoNoHT    |       -0.0010441      |        0.0142239        |      -0.0734067      |       0.9414975       |
| menopausepostmenounknown |       0.0410178       |        0.0328765        |       1.2476318      |       0.2124640       |
| menopausepremeno         |       -0.0058343      |        0.0152413        |      -0.3827939      |       0.7019556       |

From the regression result we can tell that the doctor should consider more about the patient’s history, the breast cancer symptoms and the menopause status of the patient. More specifically, if a person has the history of having cancer, or she has the breast cancer symptoms, or the hormone-therapy status is unknown, she is more likely to have cancers. This result matches our intuition.

To compare the result, we made some predictions with the baseline model and the model we choose.The threshold of positive prediction is chosen as 0.0395, which is slightly higher than the prior probability of having a cancer.

The confusion matrix for the baseline model using the entire dataset is:

|            | prediction = 0 | prediction = 1 |
|------------|:--------------:|:--------------:|
| cancer = 0 |       824      |       126      |
| cancer = 1 |       15       |       22       |

The accuracy rate is (824+22)/987 = 85.7%, the true positive rate is 22/(22+15) = 59.5%, the specificity is 22/(126+22) = 14.9%.

The confusion matrix for the model using the entire dataset is:

|            | prediction = 0 | prediction = 1 |
|------------|:--------------:|:--------------:|
| cancer = 0 |       797      |       153      |
| cancer = 1 |       14       |       23       |

The accuracy rate is (797+23)/987 = 83.1%, the true positive rate is 23/(23+14) = 62.2%, the specificity is 23/(153+23) = 13.1%.

Although this is the insample rates, we can still conclude that the true positive rate is increasing, which means it will minimize the false negative rate, identifying more precisely the patients who do end up getting cancer, so that they can be treated as early as possible, while the specificity is slightly decreasing, meaning the doctors have to be more conservative and hence slightly increase the rate of the false alert.
