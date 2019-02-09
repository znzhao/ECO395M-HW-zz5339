Exercise 1
==========

author: Chong Wang, Tinaping Wu, Zhenning Zhao

Exercise 1.1
------------

Exercise 1.2
------------

Exercise 1.3
------------

In this exercise, we used K-nearest neighbors(KNN) to build a predictive model for price, given mileage, separately for each of two trim levels: 350 and 65 AMG. First, we run the KNN models for the trim level of 350. Here is the plot for mileage vs price for the trim level of 350:

<img src="Exercise_1_Report_files/figure-markdown_github/s350-1.png" style="display: block; margin: auto;" />

We splited the data into a training and a testing set. There are 80% of the data are in the training set. Then we run the K-nearest-neighbors, for many different values of K, starting at K=3 and going as high as the sample size. For each value of K, fit the model to the training set and make predictions on the test set, and calculate the out-of-sample root mean-squared error (RMSE) for each value of K. The plot of K versus RSME is showed below:

<img src="Exercise_1_Report_files/figure-markdown_github/s350p_KNNplot-1.png" style="display: block; margin: auto;" />

The optimal K for trim level 350 is printed below:

    ## [1] 22

Since the traning set is chosen randomly, if we run the KNN for several times, we will get different result. But generally, we can get the optimal K for trim level 350 is about 19. Then for the optimal value of K in this one running, a plot of the fitted modelis shown below:

    ## [1] 9637.687

<img src="Exercise_1_Report_files/figure-markdown_github/s350p_optimalplot-1.png" style="display: block; margin: auto;" />

Second, we run the KNN models for the trim level of 65 AMG similarly. Here is the plot for mileage vs price for the trim level of 65 AMG:

<img src="Exercise_1_Report_files/figure-markdown_github/s65AMG-1.png" style="display: block; margin: auto;" />

We splited the data into a training and a testing set. There are 80% of the data are in the training set. Then we run the K-nearest-neighbors, for many different values of K, starting at K=3 and going as high as the sample size. For each value of K, fit the model to the training set and make predictions on the test set, and calculate the out-of-sample root mean-squared error (RMSE) for each value of K. The plot of K versus RSME is showed below:

The optimal K for trim level 65 AMG is printed below:

    ## [1] 10

Since the traning set is chosen randomly, if we run the KNN for several times, we will get different result. But generally, we can get the optimal K for trim level 65 AMG is about 16. Then for the optimal value of K in this one running, a plot of the fitted modelis shown below:

    ## [1] 24631.32

<img src="Exercise_1_Report_files/figure-markdown_github/s65p_optimalplot-1.png" style="display: block; margin: auto;" />
