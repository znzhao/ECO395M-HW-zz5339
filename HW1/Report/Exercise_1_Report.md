Exercise 1
==========

By Chong Wang, Tinaping Wu, Zhenning Zhao

Exercise 1.1
------------

The environmentally conscious buildings have some obvious advantages, not only from an eco-friendly view, but also from the financial view, but the "data guru" clearly didn't make an reasonable argument to show the advantages clearly. To be more specific, we conclude that the duration that he calculated to recover the cost is wrong.

<img src="Exercise_1_Report_files/figure-markdown_github/p1.1-1.png" style="display: block; margin: auto;" />

The first step is to clean the data. The "data guru" noticed that a handful of the buildings in the data set had very low occupancy rates. Although this is a true fact, which can be shown in the above graph, he didn't provide a ggod reason for why remove the buildings with less than 10% leasing rate from consideration. It might be true that there are something weird happening with the buildings that have an occupancy rate of zero, but there is no good reason to remove 215 data points from the whole data set. According to a [research conducted by IBM](https://www.ibm.com/support/knowledgecenter/en/SSFCZ3_10.5.2/com.ibm.tri.doc/wpm_metrics/r_occupancy_rate.html), the buildings with a zero leasing rate is called not-used buildings. So we decide to exclude these data points fro the original dataset, instead of all the data with a leasing rate less than 10%.

After that, we tried to clean the data further from the view that the "data guru" didn't think of. We noticed that this new project is in Austin. Since we checked from the internet that the tallest building in Austin is 56 floors, it makes no sense to do the analysis with the building that are too tall for Austin. Hence, we exclude all the buildings whose cluster has a building taller than 56 stories, and we end up with 6,618 data in the dataset.

<img src="Exercise_1_Report_files/figure-markdown_github/p1.2-1.png" style="display: block; margin: auto;" />

According to the "data guru", there are still many outlier from the dataset after the data cleaning, so he choose to use the median instead of the mean to calculate the expected rent for green buildings and non-green buildings. We plot the boxplot of green buildings and non-green buildings, to give a basic taste of the data. it seems that the "data guru" was right about the outliers, but it is unclear why there are so many outliers. So we digged deeper, and got some interesting findings.

Exercise 1.2
------------

Exercise 1.3
------------

In this exercise, we used K-nearest neighbors(KNN) to build a predictive model for price, given mileage, separately for each of two trim levels: 350 and 65 AMG. First, we run the KNN models for the trim level of 350. Here is the plot for mileage vs price for the trim level of 350:

<img src="Exercise_1_Report_files/figure-markdown_github/s350-1.png" style="display: block; margin: auto;" />

We splited the data into a training and a testing set. There are 80% of the data are in the training set. Then we run the K-nearest-neighbors, for many different values of K, starting at K=3 and going as high as the sample size. For each value of K, fit the model to the training set and make predictions on the test set, and calculate the out-of-sample root mean-squared error (RMSE) for each value of K. The plot of K versus RSME is showed below:

<img src="Exercise_1_Report_files/figure-markdown_github/s350p_KNNplot-1.png" style="display: block; margin: auto;" />

The optimal K for trim level 350 is printed below:

    ## [1] 12

Since the traning set is chosen randomly, if we run the KNN for several times, we will get different result. But generally, we can get the optimal K for trim level 350 is about 19. Then for the optimal value of K in this one running, a plot of the fitted modelis shown below:

<img src="Exercise_1_Report_files/figure-markdown_github/s350p_optimalplot-1.png" style="display: block; margin: auto;" />

Second, we run the KNN models for the trim level of 65 AMG similarly. Here is the plot for mileage vs price for the trim level of 65 AMG:

<img src="Exercise_1_Report_files/figure-markdown_github/s65AMG-1.png" style="display: block; margin: auto;" />

We splited the data into a training and a testing set. There are 80% of the data are in the training set. Then we run the K-nearest-neighbors, for many different values of K, starting at K=3 and going as high as the sample size. For each value of K, fit the model to the training set and make predictions on the test set, and calculate the out-of-sample root mean-squared error (RMSE) for each value of K. The plot of K versus RSME is showed below:

<img src="Exercise_1_Report_files/figure-markdown_github/s65AMGp_KNNplot-1.png" style="display: block; margin: auto;" />

The optimal K for trim level 65 AMG is printed below:

    ## [1] 13

Since the traning set is chosen randomly, if we run the KNN for several times, we will get different result. But generally, we can get the optimal K for trim level 65 AMG is about 16. Then for the optimal value of K in this one running, a plot of the fitted modelis shown below:

<img src="Exercise_1_Report_files/figure-markdown_github/s65p_optimalplot-1.png" style="display: block; margin: auto;" />

In the end, it is showed that the average optimal K for trim level 350 is 19, which is larger than optimal K = 16 for trim level 65 AMG. We think that this is because that the sample size for the first data subset is larger than the second, and hence has a larger optimal K.
