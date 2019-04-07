Exercise 3
==========

By Chong Wang, Tianping Wu, Zhenning Zhao

Exercise 3.1
------------

Exercise 3.2
------------

### Why can’t I just get data from a few different cities and run the regression of “Crime” on “Police” to understand how more cops in the streets affect crime?

We cannot just do the simple regression of “Crime” on “Police” because although Crime rate depends on police force, the demand of police force might also depend on the crime rate. One could assume that when a city put more police on the street the crime rate tends to drop, and more police is needed if the crime rate of a city is high. So it’s actually 2 equations other than one to be regressed. However, the data that we have on hand mixed these two effects so that we cannot tell what is the cause for the changes in the crime rate. So we cannot simply do the regression of “Crime” on “Police”.

### How were the researchers from UPenn able to isolate this effect? Briefly describe their approach and discuss their result in the “Table 2” below, from the researcher's paper.

The researchers from UPenn took the endogeneity problem into consideration and included an instrument variable that is days with a high alert and a control variable that is ridership in order to isolate this effect. They first collected DC’s crime data as well as data of days when there was a high alert for potential terrorist attacks.

Because in the days when there’s a high alert for potential terrorist attacks, the mayor of DC will respond to that actively by sending more cops in the street, that decision made by mayor has no intention to reduce the crime in the street. In the days when there’s a high alert, people may not go out, thus the chances of the crime will decrease which induce less crimes that was not caused by more cops in those days. The researchers then chose ridership as a control variable. If the number of ridership is as usual, that means the number of people do not decrease due to the high alert; If the number of ridership is less as usual, that means the number of people decrease due to the high alert. Thus, researchers need to control the ridership. From table 1, we saw that days with a high alert have lower crimes, since the coefficient is -6.046, which is also significant at 5% level after including the control variable ridership.

Thus, holding the number of people go out in the days when there’s a high alert fixed (holding the ridership fixed), the crime becomes lower in those days is due to more cops in the street.

### Why did they have to control for Metro ridership? What was that trying to capture?

Although the technology mentioned above is very genius, someone might argue that it might not be true that the correlation between the alert and the crime rate is zero. During the high alert days people might be too scared to go out, so there might be less chances for crime opportunities, leading to a lower crime rate.

Hence, the researcher controlled for Metro ridership (as a way of measuring population outdoor activeness) and rerun the regression again. If the result of regressing crime rate on police force controlling the ridership is still negative, then it’s more convincible to say that the regression captures the influence of police force on crime rate.

From the second regression of table 2, it is shown that holding the ridership fixed, the parameter in front of the police force is still negative. This result in some degree rules out the possibility that mentioned above. However, we can’t for sure prove that more cops leads to less crime. The street criminals might be too afraid of terrorists and decide not to go out and during a high alert day. This would lead to a reduction in crime that is not related to more police in the streets.

### Below I am showing you "Table 4" from the researchers' paper. Just focus on the first column of the table. Can you describe the model being estimated here? What is the conclusion?

Table 4 demonstrates on effect of high alert on crime across different districts in DC. By having models with interaction terms between districts and alert days, it can be shown that only the effect in district 1 is significant. High alert days with more cops bring the daily total number of crimes down in district 1. This makes sense because D.C. would most likely deploy high ratio of the extra cops in this district for security reasons as terrorists targets like US Capitol,the White House, Federal Triangle and US Supreme Court are all there. The effects in the other districts are insignificant as the confidence interval lies on the coefficient of zero.
