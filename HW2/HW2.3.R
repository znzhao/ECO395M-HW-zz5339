library(tidyverse)
library(mosaic)
library(class)
library(FNN)


urlfile<-'https://raw.githubusercontent.com/znzhao/ECO395M-HW-zz5339/master/HW2/online_news.csv'
OnlineNews<-read.csv(url(urlfile))

OnlineNews$viral = ifelse(OnlineNews$shares > 1400, 1, 0)
summary(OnlineNews)

  p1 <- ggplot(data = OnlineNews) + 
    geom_point(mapping = aes(y = shares, x =num_imgs),alpha = 0.01) + ylim(0, 2000)
  p1
  
  p2 <- ggplot(data = OnlineNews) + 
    geom_density(mapping = aes(x = shares),alpha = 0.01)+xlim(0,5000)
  p2
  
### Split into training and testing sets
n = nrow(OnlineNews)
n_train = round(0.8*n)  # round to nearest integer
n_test = n - n_train
train_cases = sample.int(n, n_train, replace=FALSE)
test_cases = setdiff(1:n, train_cases)
OnlineNews_train = OnlineNews[train_cases,]
OnlineNews_test = OnlineNews[test_cases,]

### simple LM w/o polarity
lm_OnlineNews_1 = lm(shares ~ n_tokens_title + n_tokens_content + num_hrefs + 
                     num_self_hrefs + num_imgs + num_videos + 
                     average_token_length + num_keywords + data_channel_is_lifestyle + 
                     data_channel_is_entertainment + data_channel_is_bus + 
                     + data_channel_is_socmed + data_channel_is_tech + 
                     data_channel_is_world + self_reference_avg_sharess + 
                     weekday_is_monday + weekday_is_tuesday + weekday_is_wednesday + 
                     weekday_is_thursday + weekday_is_friday + weekday_is_saturday, data=OnlineNews_train)

### simple binomial LM w/o polarity 
lm_OnlineNews_2 = lm(viral ~ n_tokens_title + n_tokens_content + num_hrefs + 
                       num_self_hrefs + num_imgs + num_videos + 
                       average_token_length + num_keywords + data_channel_is_lifestyle + 
                       data_channel_is_entertainment + data_channel_is_bus + 
                       + data_channel_is_socmed + data_channel_is_tech + 
                       data_channel_is_world + self_reference_avg_sharess + 
                       weekday_is_monday + weekday_is_tuesday + weekday_is_wednesday + 
                       weekday_is_thursday + weekday_is_friday + weekday_is_saturday, data=OnlineNews_train)

### simple binomial logistic w/o polarity 
glm_OnlineNews_1 = glm(viral ~ n_tokens_title + n_tokens_content + num_hrefs + 
                       num_self_hrefs + num_imgs + num_videos + 
                       average_token_length + num_keywords + data_channel_is_lifestyle + 
                       data_channel_is_entertainment + data_channel_is_bus + 
                       + data_channel_is_socmed + data_channel_is_tech + 
                       data_channel_is_world + self_reference_avg_sharess + 
                       weekday_is_monday + weekday_is_tuesday + weekday_is_wednesday + 
                       weekday_is_thursday + weekday_is_friday + weekday_is_saturday, data=OnlineNews_train, family=binomial)

### simple LM w/o polarity w/interaction
lm_OnlineNews_4 = lm(viral ~ (n_tokens_title + n_tokens_content + num_hrefs + 
                       num_self_hrefs + num_imgs + num_videos + 
                       average_token_length + num_keywords + data_channel_is_lifestyle + 
                       data_channel_is_entertainment + data_channel_is_bus + 
                       + data_channel_is_socmed + data_channel_is_tech + 
                       data_channel_is_world + self_reference_avg_sharess + 
                       weekday_is_monday + weekday_is_tuesday + weekday_is_wednesday + 
                       weekday_is_thursday + weekday_is_friday + weekday_is_saturday)^2, data=OnlineNews_train)


lm_OnlineNews_5 = lm(viral ~ poly(n_tokens_title, 3) + n_tokens_content + num_hrefs + 
                       num_imgs + num_videos + 
                       poly(average_token_length, 3) + num_keywords + data_channel_is_lifestyle + 
                       data_channel_is_entertainment + data_channel_is_bus + 
                       + data_channel_is_socmed + data_channel_is_tech + 
                       data_channel_is_world + self_reference_avg_sharess + 
                       weekday_is_monday + weekday_is_tuesday + weekday_is_wednesday + 
                       weekday_is_thursday + weekday_is_friday + weekday_is_saturday + 
                       poly(avg_positive_polarity, 3) + poly(avg_negative_polarity, 3), data=OnlineNews_train)

coef(lm_OnlineNews_5) %>% round(3)

### Set model
lm_OnlineNews_SetModel <- lm_OnlineNews_5

### Predictions in sample
yhat_train_test1 = predict(lm_OnlineNews_SetModel, OnlineNews_train)
#summary(yhat_train_test1)
class_train_test1 = ifelse(yhat_train_test1 > 0.5, 1, 0)

###in sample performance
confusion_in = table(y = OnlineNews_train$viral, yhat = class_train_test1)
confusion_in
sum(diag(confusion_in))/sum(confusion_in)

###Benchmark in sample performance
sum(OnlineNews_test$viral)/count(OnlineNews_test)

### Predictions out of sample
yhat_test_test1 = predict(lm_OnlineNews_SetModel, OnlineNews_test)
#summary(yhat_test_test1)
class_test_test1 = ifelse(yhat_test_test1 > 0.5, 1, 0)

###out of sample performance
confusion_out = table(y = OnlineNews_test$viral, yhat = class_test_test1)
confusion_out
sum(diag(confusion_out))/sum(confusion_out)

###Benchmark out of sample performance
sum(OnlineNews_train$viral)/count(OnlineNews_train)

# # Root mean-squared prediction error
# rmse = function(y, yhat) {
#   sqrt( mean( (y - yhat)^2 ) )
# }
# rmse(OnlineNews_test$shares, yhat_test1)

######################################################################################
# Zhenning
######################################################################################
lm_C_error(shares ~ num_self_hrefs +
             (n_tokens_title + n_tokens_content + num_hrefs + 
                num_imgs + num_videos + 
                average_token_length + num_keywords + weekday_is_monday+ weekday_is_tuesday+ weekday_is_wednesday+weekday_is_thursday+weekday_is_friday+weekday_is_saturday + self_reference_avg_sharess)*
             (data_channel_is_lifestyle +
                data_channel_is_entertainment + data_channel_is_bus + 
                + data_channel_is_socmed + data_channel_is_tech +
                data_channel_is_world) ,
           data=OnlineNews, y = OnlineNews$viral, threshold = 1400, Ntimes = 50)

summary(lm(shares ~ num_self_hrefs +  num_hrefs+weekday_is_monday+ weekday_is_tuesday+ weekday_is_wednesday+weekday_is_thursday+weekday_is_friday+weekday_is_saturday + 
             (n_tokens_title + n_tokens_content + 
                num_imgs + num_videos + 
                average_token_length + num_keywords + self_reference_avg_sharess)*
             (data_channel_is_lifestyle +
                data_channel_is_entertainment + data_channel_is_bus + 
                + data_channel_is_socmed + data_channel_is_tech +
                data_channel_is_world) ,
           data=OnlineNews))

glm_C_error(viral ~ num_self_hrefs +  num_hrefs+weekday_is_monday+ weekday_is_tuesday+ weekday_is_wednesday+weekday_is_thursday+weekday_is_friday+weekday_is_saturday + 
              (n_tokens_title + n_tokens_content + 
                 num_imgs + num_videos + 
                 average_token_length + num_keywords + self_reference_avg_sharess)*
              (data_channel_is_lifestyle +
                 data_channel_is_entertainment + data_channel_is_bus + 
                 + data_channel_is_socmed + data_channel_is_tech +
                 data_channel_is_world), threshold = 0.5,
             data=OnlineNews,Ntimes = 10)

X = subset(OnlineNews,select = c(num_self_hrefs,n_tokens_title,n_tokens_content,num_hrefs, num_imgs,num_videos,average_token_length,num_keywords, is_weekend,data_channel_is_lifestyle,data_channel_is_entertainment,data_channel_is_bus,data_channel_is_socmed, data_channel_is_tech,data_channel_is_world, self_reference_avg_sharess))
x = subset(OnlineNews,select = c(num_self_hrefs,n_tokens_title,n_tokens_content,num_hrefs, num_imgs,num_videos,average_token_length,num_keywords, is_weekend,data_channel_is_lifestyle,data_channel_is_entertainment,data_channel_is_bus,data_channel_is_socmed, data_channel_is_tech,data_channel_is_world, self_reference_avg_sharess, weekday_is_monday, weekday_is_tuesday, weekday_is_wednesday, weekday_is_thursday, weekday_is_friday, weekday_is_saturday, weekday_is_sunday,global_rate_positive_words, global_rate_negative_words, avg_positive_polarity, min_positive_polarity, max_positive_polarity, avg_negative_polarity, min_negative_polarity, max_negative_polarity, title_subjectivity, title_sentiment_polarity, abs_title_sentiment_polarity))

Y = subset(OnlineNews,select = c(viral))

KNN_result <- data.frame(K=c(), rsme=c())
k_grid = seq(3, 150, by=20)
for(v in k_grid){
  avgrmse = KNN_C_error(data_X = X,data_y = Y, K = v,Ntimes = 5)
KNN_result <- rbind(KNN_result,c(v,avgrmse))
}
colnames(KNN_result) <- c("K","AVG_RMSE")
ggplot(data = KNN_result, aes(x = K, y = AVG_RMSE)) + 
  geom_point(shape = "O") +
  geom_line(col = "red")


obj_Y = subset(OnlineNews,select = c(viral))

KNN_result <- data.frame(K=c(), rsme=c())
k_grid = seq(53, 250, by=30)
for(v in k_grid){
  avgrmse = KNN_C_error_linear(data_X = x,data_y = Y,obj_y = obj_Y, K = v,threshold = 1400,Ntimes = 5)
  KNN_result <- rbind(KNN_result,c(v,avgrmse))
}
colnames(KNN_result) <- c("K","AVG_RMSE")
ggplot(data = KNN_result, aes(x = K, y = AVG_RMSE)) + 
  geom_point(shape = "O") +
  geom_line(col = "red")
