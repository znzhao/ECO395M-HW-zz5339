Exercise 2
==========

By Chong Wang, Tianping Wu, Zhenning Zhao

|         | AVG RMSE |
|---------|:--------:|
| model 1 | 66068.44 |
| model 2 | 65825.60 |
| model 3 | 59765.10 |
| model 4 | 59677.72 |
| model 5 | 59126.45 |
| model 6 | 59432.07 |
| model 7 | 60182.50 |

``` r
summary(lm(price ~ landValue + lotSize*(bedrooms + bathrooms) + livingArea*(fuel+ heating + centralAir) + pctCollege*(fireplaces+age) + rooms, data=data))
```

    ## 
    ## Call:
    ## lm(formula = price ~ landValue + lotSize * (bedrooms + bathrooms) + 
    ##     livingArea * (fuel + heating + centralAir) + pctCollege * 
    ##     (fireplaces + age) + rooms, data = data)
    ## 
    ## Residuals:
    ##     Min      1Q  Median      3Q     Max 
    ## -231721  -34928   -5458   27010  453713 
    ## 
    ## Coefficients:
    ##                                     Estimate Std. Error t value Pr(>|t|)
    ## (Intercept)                       -8.643e+03  1.770e+04  -0.488 0.625456
    ## landValue                          8.332e-01  4.816e-02  17.302  < 2e-16
    ## lotSize                            8.886e+03  8.083e+03   1.099 0.271757
    ## bedrooms                          -9.011e+03  3.052e+03  -2.953 0.003192
    ## bathrooms                          2.423e+04  3.873e+03   6.257 4.95e-10
    ## livingArea                         9.013e+01  5.690e+00  15.841  < 2e-16
    ## fuelelectric                      -4.945e+04  4.874e+04  -1.015 0.310437
    ## fueloil                            3.909e+04  1.311e+04   2.981 0.002913
    ## heatinghot water/steam             1.278e+04  1.277e+04   1.001 0.317140
    ## heatingelectric                    4.674e+04  4.936e+04   0.947 0.343806
    ## centralAirNo                       3.461e+04  1.046e+04   3.308 0.000960
    ## pctCollege                         1.983e+01  2.603e+02   0.076 0.939288
    ## fireplaces                         4.139e+04  1.479e+04   2.798 0.005203
    ## age                               -5.980e+02  2.613e+02  -2.288 0.022234
    ## rooms                              2.540e+03  9.777e+02   2.598 0.009466
    ## lotSize:bedrooms                   1.639e+03  2.743e+03   0.598 0.550087
    ## lotSize:bathrooms                 -3.076e+03  3.420e+03  -0.899 0.368534
    ## livingArea:fuelelectric            2.421e+01  2.804e+01   0.863 0.388031
    ## livingArea:fueloil                -2.464e+01  7.455e+00  -3.306 0.000967
    ## livingArea:heatinghot water/steam -1.069e+01  6.774e+00  -1.577 0.114871
    ## livingArea:heatingelectric        -2.825e+01  2.860e+01  -0.988 0.323433
    ## livingArea:centralAirNo           -2.527e+01  5.479e+00  -4.612 4.28e-06
    ## pctCollege:fireplaces             -7.023e+02  2.601e+02  -2.700 0.007011
    ## pctCollege:age                     1.043e+01  4.880e+00   2.137 0.032735
    ##                                      
    ## (Intercept)                          
    ## landValue                         ***
    ## lotSize                              
    ## bedrooms                          ** 
    ## bathrooms                         ***
    ## livingArea                        ***
    ## fuelelectric                         
    ## fueloil                           ** 
    ## heatinghot water/steam               
    ## heatingelectric                      
    ## centralAirNo                      ***
    ## pctCollege                           
    ## fireplaces                        ** 
    ## age                               *  
    ## rooms                             ** 
    ## lotSize:bedrooms                     
    ## lotSize:bathrooms                    
    ## livingArea:fuelelectric              
    ## livingArea:fueloil                ***
    ## livingArea:heatinghot water/steam    
    ## livingArea:heatingelectric           
    ## livingArea:centralAirNo           ***
    ## pctCollege:fireplaces             ** 
    ## pctCollege:age                    *  
    ## ---
    ## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
    ## 
    ## Residual standard error: 59090 on 1704 degrees of freedom
    ## Multiple R-squared:  0.6445, Adjusted R-squared:  0.6397 
    ## F-statistic: 134.3 on 23 and 1704 DF,  p-value: < 2.2e-16
