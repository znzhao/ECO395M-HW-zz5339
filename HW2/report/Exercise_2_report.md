Exercise 2
==========

By Chong Wang, Tianping Wu, Zhenning Zhao

Exercise 2.1
------------

Long story short, we "hand-build" a model for price that outperforms the "medium" model that we considered in class, and the KNN model did not beat the “hand-build” model that we selected.

The models that we checked are listed below.

``` r
model1 = price ~ lotSize + age + livingArea + pctCollege + bedrooms + fireplaces + bathrooms + rooms + heating + fuel + centralAir
model2 = price ~ lotSize + age + livingArea + pctCollege*fireplaces + bedrooms  + bathrooms + rooms + heating + centralAir
model3 = price ~ landValue + livingArea + pctCollege + bedrooms + fireplaces + bathrooms + rooms + heating + fuel + centralAir
model4 = price ~ landValue + livingArea + bedrooms + bathrooms + rooms + heating + fuel + centralAir
model5 = price ~ landValue + lotSize*(bedrooms + bathrooms) + livingArea*(fuel+ heating + centralAir) + pctCollege*(fireplaces+age) + rooms
model6 = price ~ landValue + lotSize*bedrooms + livingArea*fuel + pctCollege*(fireplaces+age) + bathrooms + rooms + heating + centralAir
model7 = price ~ landValue + lotSize*bedrooms + livingArea*fuel + pctCollege*(fireplaces+age) + centralAir
```

The performance of the models are mesured with average out-of-sample RMSE. We use the 80% of the data to do regressions and calculate RMSE for the rest 20%, and rerun the Monte Carlo training-testing split to calculate the average RMSE. The result of the models are listed below.

|         | AVG RMSE |
|---------|:--------:|
| model 1 | 66519.70 |
| model 2 | 66254.90 |
| model 3 | 60769.80 |
| model 4 | 60680.62 |
| model 5 | 59915.80 |
| model 6 | 60267.81 |
| model 7 | 61008.73 |

The best model that we solved is model 5. This model beats all the other models that we choose by having a smaller average RMSE of around 59900, while the average RMSE of the baseline model is around 66000. The regression result is:

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

However, by using exactly same variables in the linear regression model it is very hard to beat the linear regression with the KNN model.

![](Exercise_2_report_files/figure-markdown_github/graph2.1.1-1.png)

From the plot of average RMSE vs K we can tell the optimal K for the KNN model is about 10-12. The lowest average RMSE that we can get with KNN model is about 63000, which is still higher than the average RMSE that we conclude using a linear model with interactions.

Exercise 2.2
------------

### Exercise 2.2.1

First, in order to get the most accurate predictions of radiologists’ recall rates, we construct three logistic models. Because we need to take consideration that all the risk factors need to be constant, we choose age, history of breast biopsy/surgery, breast cancer symptom, menopause/hormone-therapy status and breast density classification as independent variables and recall as dependent variable in our logistic model. After considering the chance of interactions, we selected three following models:

``` r
model1 = recall~radiologist*(age+history+symptoms+menopause+density)
model2 = recall~radiologist+age+history+symptoms+menopause+density
model3 = recall~(radiologist+age+history+symptoms+menopause+density)^2
```

The performance of the models are measured with error rate, which is calculated by sum of the right diagonal numbers of confusion matrix divided by 987 screening mammograms. We use the 80% of the data to do logistic regressions and calculate error rate for the rest 20%, and rerun the Monte Carlo training-testing split to calculate the average error rate. The threshold that we used for the calculation is about 0.1509, which is the average rate for the recalled patients. The result of the models are listed below:

|         |  AVG RMSE |
|---------|:---------:|
| model 1 | 0.4052284 |
| model 2 | 0.4474112 |
| model 3 | 0.3964467 |

After running for several times, we found the error rate of model 1 and model 3 is significantly smaller than that of model 2. We use model 1 to predict in the following as the error rate of model 1 is slightly smaller than that of model 3.

Then, we randomly chosen 100 samples, which consist of around 10% of 987 screening mammograms. After that, we repeat these 100 samples for 5 times each. In order to address the problem that the radiologists don’t see the same patients, we added an additional row, which is arranged by repeated series radiologist13, radiologist34, radiologist66, radiologist89 and radiologist95. Therefore, we let five radiologists see the same patients. Finally, we predict the recall rates of each radiologist with model 1. The results is below.

| radiologist   |  Prob\_recall|
|:--------------|-------------:|
| radiologist13 |     0.1357191|
| radiologist34 |     0.0892768|
| radiologist66 |     0.1894795|
| radiologist89 |     0.2016454|
| radiologist95 |     0.1244217|

From the above table, we can clearly see that radiologist89 is most clinically conservative, whose recall rate is 0.23. Radiologist66, radiologist13, radiologist95 and radiologist34, ranked 2nd, 3rd, 4th and 5th respectivelly in terms of clinically conservative index.

At last, we performed robust test on our results. We predicted recall rates by using model 2 and model 3. The below tables showed the results, which is consistent with the result predicted by model 1.

    ## [1] "model 2"

| radiologist   |  Prob\_recall|
|:--------------|-------------:|
| radiologist13 |     0.1530652|
| radiologist34 |     0.1027990|
| radiologist66 |     0.2000887|
| radiologist89 |     0.2146799|
| radiologist95 |     0.1467961|

    ## [1] "model 3"

| radiologist   |  Prob\_recall|
|:--------------|-------------:|
| radiologist13 |     0.1432242|
| radiologist34 |     0.0935221|
| radiologist66 |     0.1937180|
| radiologist89 |     0.2547362|
| radiologist95 |     0.1582047|

In conclusion, holding patient risk factors equal, the order of clinically conservative characteristic in recalling patients is: radiologist89 &gt; radiologist66 &gt; radiologist13 &gt; radiologist95 &gt; radiologist34, when letting radiologists see the same patients.

### Exercise 2.2.2

The second point that we want to make is that when the radiologists at this hospital interpret a mammogram to make a decision on whether to recall the patient, they should be weighing the history of the patients, the breast cancer symptoms and the menopause status of the patient more heavily than they currently are. Although this means they have to recall more patients back for further checks, it will minimize the false negative rate, identifying more precisely the patients who do end up getting cancer, so that they can be treated as early as possible.

First we build the baseline model, which suggests that when the doctors recall a patient, they tend to think that the patient has a cancer.

To formalize the model by regression, we regressed the patient’s cancer outcome on the radiologist’s recall decision with the logistic regression. The regression model is:

``` r
baseline = cancer ~ recall
```

We split the dataset into the training set and the testing set using the standard 80-20 rule, and re-run the regression for 100 times to eliminate the stochasticity, and ending up with similar rates to the ones calculated with the entire database.

If we build a model using the recall decision and all the other clinical risk factors and it significantly performs better than the baseline model, it means that there are some risk factors that the doctors are missing.

We checked (1) the model regressing cancer indicator on the recall indicator and all the risk factors, (2) the model regressing cancer indicator on the recall indicator and all the risk factors and their interactions (3) two hand-build models. The thresholds that we chose for these models are the same as the baseline model, so that we can compare these models on the same level. The regression models are:

Before we show the result of the models, we need to explain the criteria that we use to judge these model. When we try to identify the patient, different kinds of error has different cost. It might not be a big problem if a healthy woman is recalled to do some further test, but it may cause death if the doctor didn’t identify the patients who have cancer. Hence the accurate rate is not the best criteria. Instead, we calculate the deviance of these model, and choose the model with smaller deviance.

The average deviance of the models are listed in the following table:

|          | AVG Deviance for Different Models |
|----------|:---------------------------------:|
| Baseline |              1.500853             |
| Model 1  |              1.560098             |
| Model 2  |              1.459631             |
| Model 3  |              1.442899             |

From the table we can tell that the Model 3 has the lowest average deviation, which means we can perform better than the doctors currently do if they give more weight on the terms in Model 3. Overall we can say that the doctors did great jobs at identifying the patients who do get cancer. the drop between Model3 and the baseline is very small.

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

The accuracy rate is (824+22)/987 = 85.7%, the false negative rate is 15/(22+15) = 40.5%, the false positive rate is 126/(126+22) = 85.1%.

The confusion matrix for the model using the entire dataset is:

|            | prediction = 0 | prediction = 1 |
|------------|:--------------:|:--------------:|
| cancer = 0 |       797      |       153      |
| cancer = 1 |       14       |       23       |

The accuracy rate is (797+23)/987 = 83.1%, the false negative rate is 14/(23+14) = 37.8%, the false positive rate is 153/(153+23) = 86.9%.

Although this is the insample rates, we can still conclude that the false negative rate is decreasing, which means it will lower the false negative rate, identifying more precisely the patients who do end up getting cancer, so that they can be treated as early as possible, while the false positive rate is slightly increasing, meaning the doctors have to be more conservative and hence slightly increase the rate of the false alert. However, clearly the fact that we identified more cancer patients matters more.

Exercise 2.3
------------

|          |  Accurate Rate|
|----------|--------------:|
| share-LM |      0.4964523|
| viral-LM |      0.5066414|
| GLM      |      0.6270652|

|           | prediction = 0 | prediction = 1 |
|-----------|:--------------:|:--------------:|
| viral = 0 |      2528      |      1508      |
| viral = 1 |      1395      |      2498      |

![](Exercise_2_report_files/figure-markdown_github/table2.3.3-1.png)

![](Exercise_2_report_files/figure-markdown_github/share2.3.3-1.png)

|           | prediction = 0 | prediction = 1 |
|-----------|:--------------:|:--------------:|
| viral = 0 |      2722      |      1279      |
| viral = 1 |      1671      |      2257      |
