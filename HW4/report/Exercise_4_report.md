Exercise 4
==========

By Chong Wang, Tianping Wu, Zhenning Zhao

Exercise 4.1 Clustering and PCA
-------------------------------

Exercise 4.2 Market segmentation
--------------------------------

### 4.2.1 Data pre-process

First we decided to eliminate as many bots as possible from the slip through. All users with spam posts are assumed to be pots as only a few dozens of them had spam posts. Users with pornography posts are a bit complicated because more than a few couple hundred users had them and at the same time also posted significant amount of other types of posts, so they might just be actual human users with interests in pornography to some extent . To distinguish between humans and bots, we set an arbitrary rule of 20/80 to delete all users having more than 20% of their total posts in pornagraphy. Next, column chatter and uncategorized are deleted because they are the labels that do not fit at all into any of the interest categories. At the end, we are left with 7,676 users to determine market segmentation using clustering and principal components analysis methodologies.

    ##           chatter current_events travel photo_sharing uncategorized
    ## hmjoe4g3k       2              0      2             2             2
    ## clk1m5w8s       3              3      2             1             1
    ## jcsovtak3       6              3      4             3             1
    ## 3oeb4hiln       1              5      2             2             0
    ## fd75x1vgk       5              2      0             6             1
    ## h6nvj91yp       6              4      2             7             0
    ## ma7kfewxq       1              2      7             1             0
    ## u48d61ztj       5              3      3             6             1
    ## y2g68vhkf       6              2      0             1             0
    ## n467yj1st       5              2      4             4             0
    ##           tv_film sports_fandom politics food family home_and_garden music
    ## hmjoe4g3k       1             1        0    4      1               2     0
    ## clk1m5w8s       1             4        1    2      2               1     0
    ## jcsovtak3       5             0        2    1      1               1     1
    ## 3oeb4hiln       1             0        1    0      1               0     0
    ## fd75x1vgk       0             0        2    0      1               0     0
    ## h6nvj91yp       1             1        0    2      1               1     1
    ## ma7kfewxq       1             1       11    1      0               0     0
    ## u48d61ztj       1             1        0    0      0               0     2
    ## y2g68vhkf       0             0        0    2      2               1     1
    ## n467yj1st       5             9        1    5      4               0     1
    ##           news online_gaming shopping health_nutrition college_uni
    ## hmjoe4g3k    0             0        1               17           0
    ## clk1m5w8s    0             0        0                0           0
    ## jcsovtak3    1             0        2                0           0
    ## 3oeb4hiln    0             0        0                0           1
    ## fd75x1vgk    0             3        2                0           4
    ## h6nvj91yp    0             0        5                0           0
    ## ma7kfewxq    1             0        1                1           1
    ## u48d61ztj    0             1        3                1           0
    ## y2g68vhkf    0             2        0               22           1
    ## n467yj1st    0             1        0                7           4
    ##           sports_playing cooking eco computers business outdoors crafts
    ## hmjoe4g3k              2       5   1         1        0        2      1
    ## clk1m5w8s              1       0   0         0        1        0      2
    ## jcsovtak3              0       2   1         0        0        0      2
    ## 3oeb4hiln              0       0   0         0        1        0      3
    ## fd75x1vgk              0       1   0         1        0        1      0
    ## h6nvj91yp              0       0   0         1        1        0      0
    ## ma7kfewxq              1       1   0         1        3        1      0
    ## u48d61ztj              0      10   0         1        0        0      1
    ## y2g68vhkf              0       5   2         1        1        3      0
    ## n467yj1st              1       4   1         2        0        0      0
    ##           automotive art religion beauty parenting dating school
    ## hmjoe4g3k          0   0        1      0         1      1      0
    ## clk1m5w8s          0   0        0      0         0      1      4
    ## jcsovtak3          0   8        0      1         0      1      0
    ## 3oeb4hiln          0   2        0      1         0      0      0
    ## fd75x1vgk          0   0        0      0         0      0      0
    ## h6nvj91yp          1   0        0      0         0      0      0
    ## ma7kfewxq          0   1        1      0         0      0      0
    ## u48d61ztj          1   0        0      5         1      0      0
    ## y2g68vhkf          0   1        0      5         0      0      1
    ## n467yj1st          4   0       13      1         3      0      3
    ##           personal_fitness fashion small_business spam adult
    ## hmjoe4g3k               11       0              0    0     0
    ## clk1m5w8s                0       0              0    0     0
    ## jcsovtak3                0       1              0    0     0
    ## 3oeb4hiln                0       0              0    0     0
    ## fd75x1vgk                0       0              1    0     0
    ## h6nvj91yp                0       0              0    0     0
    ## ma7kfewxq                0       0              0    0     0
    ## u48d61ztj                0       4              0    0     0
    ## y2g68vhkf               12       3              1    0     0
    ## n467yj1st                2       1              0    0     0

### 4.2.2 Clustering

In order to determine market segment by k-means clustering, we must first select the number of initial centroids, or in other words, the number of user types. 3 types of supporting analysis were used to help us determine the quantity: Elbow plot(SSE), CH index and Gap statistics.

    ## [1] 5.1 4.1 4.1 2.1

![](Exercise_4_report_files/figure-markdown_github/graph_4.2.1.1-1.png)

As shown above, the results are subtle and therefore difficult to determine the best number for K. We eventually picked K=7 for two reasons, 1. we observed a weak signal of dipping in the Gap statistic graph and 2. we found about the equal number of interest groups with relatively strong correlated interests from our correlation analysis as shown below.

![](Exercise_4_report_files/figure-markdown_github/graph_4.2.2-1.png)

We created this heat map hoping to have a deeper analysis of each cluster. Even though we would never know the full picture of each cluster, we believed interests with high proximity, or high correlation, would most likely be fit into same cluster. The more common interests we find from each cluster, the better we can describe each market segment and therefore are able to help our client creating cluster based market strategies.

Some distinct market segments with highly correlated interests are listed below based on the heat map

1.  Personal fitness, outdoors, health & nutrition

![](Exercise_4_report_files/figure-markdown_github/graph_4.2.3-1.png)

1.  Fashion, cooking, beauty, shopping, photo sharing

![](Exercise_4_report_files/figure-markdown_github/graph_4.2.4.1-1.png)

1.  Online gaming, college&university, sports playing

![](Exercise_4_report_files/figure-markdown_github/graph_4.2.5-1.png)

1.  Sports fandom, food, family, religion, parenting, school

![](Exercise_4_report_files/figure-markdown_github/graph_4.2.6.1-1.png)

1.  Politics, news, computers, travel, automobiles

![](Exercise_4_report_files/figure-markdown_github/graph_4.2.7.1-1.png)

1.  TV film, art, music

![](Exercise_4_report_files/figure-markdown_github/graph_4.2.8-1.png)

1.  Everything, shopping, photo sharing - From the graphs above, we can see the last group being a very special one, showing moderate interests in almost all areas (compared to strong distinct tastes in other groups). Within the group, interests toward shopping and photo sharing seems to stand out.

### 4.2.3 Principal Components Analysis

After data pre-process, In order to reduce dimension of 33 different categories variables, we decided to use principal components analysis methods to find principal components, which can explain most of the variability in the data.

After center and scale the data, we did the correlation analysis of total 33 categories first. In the correlation matrix above, we found that the correlation of those categories are relatively weak, as most correlation coefficients are below 0.3. Thus, we suppose that the proportion of variance explained by most dominant principal components will not be as high as we expected.

We first got the loadings matrix and scores matrix from principal components methods. Then we calculated proportion of variance explained (PVE) to decide the number of principal components that we need to choose.

In the above table, we can see that the first eight principal components can explain most of the variability. The first principal component explains 13% of the variability; the second principal component explains 8% of the variability; the third principal component explains 8% of the variability;the fourth principal component explains 7% of the variability; the fifth principal component explains 7% of the variability; the sixth principal component explains 5% of the variability; the seventh principal component explains 4% of the variability; the eighth principal component explains 4% of the variability. Together, the first eight principal components explain 56% of the variability.

In the PVE Plot, we can see that between eighth and ninth components, there’s a significant gap in the Scree Plot. Also, from the Cumulative PVE Plot, we can find that first eight principal components can explain more than 50% of the total variability. Thus, we choose 8 principal components to divide the market of NutrientH20 into 8 segments. The characteristics of these 8 market segments are actually latent factor inferred from 33 interests categories.

Then we got top 5 interests of followers of NutrientH20 in each market segment.

In the 1st market segment, top 5 interest of followers are "religion", "food", "parenting", "sports\_fandom" and "school".

In the 2nd market segment, top 5 interest of followers are "sports\_fandom", "religion", "parenting", "food" and "school".

In the 1st and 2nd market segment, the top 5 interests are same, so we combine them into one segment as new 1st market segment.

In the 2nd market segment, top 5 interest of followers are "politics", "travel", "computers", "news" and "automotive".

In the 3rd market segment, top 5 interest of followers are "health\_nutrition", "personal\_fitness", "outdoors", "politics" and "news".

In the 4th market segment, top 5 interest of followers are "beauty", "fashion", "cooking", "photo\_sharing" and "shopping".

In the 5th market segment, top 5 interest of followers are "online\_gaming", "sports\_playing", "college\_uni", "cooking" and "automotive".

In the 6th market segment, top 5 interest of followers are "automotive", "shopping", "photo\_sharing", "news" and "current\_events".

In the 7th market segment, top 5 interest of followers are "news", "automotive", "tv\_film", "art" and "beauty".

Finally, we extracted 7 market segments.

### 4.2.4 Conclusion

From the clustering and principal component analysis, we extracted 7 analysis from both of them. The first market segment found by clustering is similar with the third segment found by PCA as they have same interests - Personal fitness, outdoors and health & nutrition.

The second market segment found by clustering is similar with the fourth segment found by PCA as they have same interests - Fashion, cooking, beauty, shopping and photo sharing.

The third market segment found by clustering is similar with the fifth segment found by PCA as they have same interests - Online gaming, college&university and sports playing.

The fourth market segment found by clustering is similar with the first segment found by PCA as they have same interests - Sports fandom, food, religion, parenting and school.

The fifth market segment found by clustering is similar with the second segment found by PCA as they have same interests - Politics, news, computers, travel and automobiles.

The sixth market segment found by clustering is similar with the seventh segment found by PCA as they have similar interests - TV film and art.

The seventh market segment found by clustering is similar with the sixth segment found by PCA as they have similar interests - shopping and photo sharing.

Finally, we labeled above seven market segments to show their unique characteristics.

We named the first market segment as “Mr. fit”. Those kinds of people focus on working out and keeping in a good shape.

We named the second market segment as “Mrs. fashion”. Those kinds of people like keeping up with fashion and sharing their happy moments with friends.

We named the third market segment as “typical college student”. College students consist with most parts of this group. They are fond of entertainment such as online games and sports during their rest time.

We named the fourth market segment as “middle-age parents”. They care about the fostering of their children. Also, they have interests in sports games.

We named the fifth market segment as “business man”. They pay attention to daily news online. Also, they like travelling during vacation.

We named the sixth market segment as “Hippie”. They like visiting gallery and enjoying movies.

We named the seventh market segment as “Typical online user with interests toward everything but mainly shopping and photo sharing”. This is the typical you and me.

Exercise 4.3 Association rules for grocery purchases
----------------------------------------------------
