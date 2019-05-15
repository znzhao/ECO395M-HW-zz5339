The Streams Analysis of Pop Music in 2018
=========================================

By Chong Wang, Tianping Wu, Zhenning Zhao, Zhiyang Lin

Introduction
------------

Popular music market is extremely large, especially in recent years. Pop songs inspire generations from all walks of life. Every day, oceans of pop tracks jump on to the Top 200 List of Spotify. In this project, we analysed the data of the 2018 popular music database from Spotify.com, in order to help the big digital music server improve playlist song recommendations and to help the record companies make decisions on which album to promote according to the predictions on the playing streams.

This project mainly answers the following questions: first, predict the streams of the tracks; and second, analysis the pattern of the popularity trend. To answer the first question, we used stepwise method, the lasso method and the random forest and boosting to build a prediction model of the streams of the tracks, with the features of the songs and the albums as predictor. In order to answer the second question, we first used PCA and K-means to cluster the songs by features, dividing songs into different categories. Then we plotted the trend of the popularity of different type of songs, showing the change in the trend of the listener’s taste.

Data
----

The dataset that we use comes from spotify.com. Spotify is one of the biggest digital music servicer that gives you access to many songs. From <https://spotifycharts.com>, we have the weekly data of the top 200 songs in the US. We use the data of 2018, giving us 1,497 different songs.

Fortunately, Spotify has a public API, which provides us many useful features of the songs. We use python robot to gather the data of not only the song features but also the data of the artists and the album. In the end, the formal dataset includes the following variables:

Table1: Variable Descriptions

<table style="width:56%;">
<colgroup>
<col width="23%" />
<col width="31%" />
</colgroup>
<thead>
<tr class="header">
<th>variables</th>
<th>descriptions</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td>id</td>
<td>song ID</td>
</tr>
<tr class="even">
<td>duration_ms_x</td>
<td>The duration of the track in milliseconds.</td>
</tr>
<tr class="odd">
<td>acousticness</td>
<td>A confidence measure from 0.0 to 1.0 of whether the track is acoustic. 1.0 represents high confidence the track is acoustic.</td>
</tr>
<tr class="even">
<td>danceability</td>
<td>Danceability describes how suitable a track is for dancing based on a combination of musical elements including tempo, rhythm stability, beat strength, and overall regularity. A value of 0.0 is least danceable and 1.0 is most danceable.</td>
</tr>
<tr class="odd">
<td>energy</td>
<td>Energy is a measure from 0.0 to 1.0 and represents a perceptual measure of intensity and activity. Typically, energetic tracks feel fast, loud, and noisy. For example, death metal has high energy, while a Bach prelude scores low on the scale. Perceptual features contributing to this attribute include dynamic range, perceived loudness, timbre, onset rate, and general entropy.</td>
</tr>
<tr class="even">
<td>instrumentalness</td>
<td>Predicts whether a track contains no vocals. “Ooh” and “aah” sounds are treated as instrumental in this context. Rap or spoken word tracks are clearly “vocal”. The closer the instrumentalness value is to 1.0, the greater likelihood the track contains no vocal content. Values above 0.5 are intended to represent instrumental tracks, but confidence is higher as the value approaches 1.0.</td>
</tr>
<tr class="odd">
<td>liveness</td>
<td>Detects the presence of an audience in the recording. Higher liveness values represent an increased probability that the track was performed live. A value above 0.8 provides strong likelihood that the track is live.</td>
</tr>
<tr class="even">
<td>loudness</td>
<td>The overall loudness of a track in decibels (dB). Loudness values are averaged across the entire track and are useful for comparing relative loudness of tracks. Loudness is the quality of a sound that is the primary psychological correlate of physical strength (amplitude). Values typical range between -60 and 0 db.</td>
</tr>
<tr class="odd">
<td>mode</td>
<td>Mode indicates the modality (major or minor) of a track, the type of scale from which its melodic content is derived. Major is represented by 1 and minor is 0.</td>
</tr>
<tr class="even">
<td>speechiness</td>
<td>Speechiness detects the presence of spoken words in a track. The more exclusively speech-like the recording (e.g. talk show, audio book, poetry), the closer to 1.0 the attribute value. Values above 0.66 describe tracks that are probably made entirely of spoken words. Values between 0.33 and 0.66 describe tracks that may contain both music and speech, either in sections or layered, including such cases as rap music. Values below 0.33 most likely represent music and other non-speech-like tracks.</td>
</tr>
<tr class="odd">
<td>tempo</td>
<td>The overall estimated tempo of a track in beats per minute (BPM). In musical terminology, tempo is the speed or pace of a given piece and derives directly from the average beat duration.</td>
</tr>
<tr class="even">
<td>valence</td>
<td>A measure from 0.0 to 1.0 describing the musical positiveness conveyed by a track. Tracks with high valence sound more positive (e.g. happy, cheerful, euphoric), while tracks with low valence sound more negative (e.g. sad, depressed, angry).</td>
</tr>
<tr class="odd">
<td>key</td>
<td>The estimated overall key of the track. Integers map to pitches using standard Pitch Class notation . E.g. 0 = C, 1 = C♯/D♭, 2 = D, and so on. If no key was detected, the value is -1.</td>
</tr>
<tr class="even">
<td>time_signature</td>
<td>An estimated overall time signature of a track. The time signature (meter) is a notational convention to specify how many beats are in each bar (or measure).</td>
</tr>
<tr class="odd">
<td>relseaseDuration</td>
<td>The date the album was first released.</td>
</tr>
</tbody>
</table>

The explanation of the variables comes from the following link: <https://developer.spotify.com/documentation/web-api/reference/tracks/get-audio-analysis/> Although this project only run on the dataset of 2018, we can do similar analysis for spotify for more songs and more recent data with similar method.

Prediction
----------

We want to build the best predictive model for streams. We chose between linear regression model and decision tree models, using methods like stepwise selection, lasso regression and random forests.

In the first model, We started with the null model by regressing streams on one, followed by running stepwise selection within 25 song feature variables and obtained our final model.

In the second model, We began with the medium model by regressing streams on all other 25 variables, and used stepwise method to choose variables within all the 25 song features and their interactions.

The two selected models are shown below. we had 5 and 31 significant coefficients, respectively in the first and second model.

    ## Streams ~ danceability + speechiness + explicitTRUE + key8

    ## Streams ~ duration_ms_x + acousticness + danceability + energy + 
    ##     liveness + loudness + mode + speechiness + valence + key6 + 
    ##     key8 + key10 + explicitTRUE + relseaseDuration + explicitTRUE:relseaseDuration + 
    ##     valence:explicitTRUE + duration_ms_x:key8 + energy:liveness + 
    ##     acousticness:liveness + mode:speechiness + mode:key10 + speechiness:explicitTRUE + 
    ##     liveness:key6 + acousticness:energy + valence:key6 + mode:key6 + 
    ##     danceability:key8 + key8:explicitTRUE + valence:key8 + speechiness:key8

We then used the Lasso model to assemble the best predictive model possible for streams. We used this method to select above two models. We didn’t consider the interaction terms in model 3, while included the interaction terms in model 4.

In the model 3, from the path plot below we could see that minimum AIC occurs at segment 8

![](final_project_files/figure-markdown_github/pathplot3-1.png)

Thus, we used the model at the segment 8 and chose 6 coefficients. The specific model is shown below.

    ## Streams ~ danceability + speechiness + key8 + explicitTRUE + 
    ##     relseaseDuration

In the model4, from the path plot below we could see that minimum AIC occurs at segment 5.

![](final_project_files/figure-markdown_github/pathplot4-1.png)

Thus, we used the model at the segment 5 and chose 8 coefficients. The specific model is shown below.

    ## Streams ~ danceability + danceability:time_signature4 + danceability:explicitTRUE + 
    ##     energy:speechiness + speechiness:relseaseDuration + key8:explicitTRUE + 
    ##     time_signature4:explicitTRUE

Afterwards, we used the decision tree models to assemble the best predictive model possible for streams. We tried the random forest model and the boosting model on the dataset, which gave us 2 non-linear models: model 5 and model 6.

    ## [1] 34861789 34604471 34848498 34852566 34812298 35412832

Lastly, we used k-fold cross validation in order to compare 6 models above. We found that the CVs of model 2 has the minimum CV, and therefore it is our best predictive model possible for streams. A linear model with interactions is easy to interpret.

The second best model is model 5, which came from the random forest method. The random forest model has one advantage over the linear regression: it will only give us positive predictions. As a result, we used both model 2 and model 5 to do the predictions.

|                               |  coefficients.Estimate|  coefficients.Std..Error|  coefficients.t.value|  coefficients.Pr...t..|
|-------------------------------|----------------------:|------------------------:|---------------------:|----------------------:|
| (Intercept)                   |           1.646100e+07|             1.452541e+07|             1.1332558|              0.2573131|
| duration\_ms\_x               |          -2.172727e+01|             2.087135e+01|            -1.0410092|              0.2980624|
| acousticness                  |          -5.616762e+05|             1.367282e+07|            -0.0410798|              0.9672385|
| danceability                  |           2.364541e+07|             8.254704e+06|             2.8644771|              0.0042433|
| energy                        |          -7.675973e+05|             1.429147e+07|            -0.0537102|              0.9571742|
| liveness                      |           1.162265e+08|             3.825623e+07|             3.0381073|              0.0024275|
| loudness                      |           9.342085e+05|             5.982664e+05|             1.5615260|              0.1186399|
| mode                          |           5.195895e+06|             3.091328e+06|             1.6807970|              0.0930395|
| speechiness                   |           1.675947e+07|             1.822265e+07|             0.9197054|              0.3578951|
| valence                       |          -1.835778e+07|             7.807869e+06|            -2.3511902|              0.0188602|
| key6                          |          -2.396707e+06|             1.078424e+07|            -0.2222415|              0.8241603|
| key8                          |          -3.773707e+07|             2.441152e+07|            -1.5458713|              0.1223759|
| key10                         |          -6.653445e+06|             4.303636e+06|            -1.5460056|              0.1223435|
| explicitTRUE                  |          -9.515646e+07|             2.669989e+07|            -3.5639269|              0.0003784|
| relseaseDuration              |          -7.172592e+01|             3.537077e+02|            -0.2027831|              0.8393359|
| explicitTRUE:relseaseDuration |           1.187783e+04|             3.432025e+03|             3.4608806|              0.0005556|
| valence:explicitTRUE          |           2.769236e+07|             9.218679e+06|             3.0039404|              0.0027154|
| duration\_ms\_x:key8          |           2.328996e+02|             7.181771e+01|             3.2429264|              0.0012127|
| energy:liveness               |          -1.493510e+08|             5.134338e+07|            -2.9088650|              0.0036883|
| acousticness:liveness         |          -1.126892e+08|             3.795888e+07|            -2.9687190|              0.0030445|
| mode:speechiness              |          -2.902330e+07|             1.437260e+07|            -2.0193487|              0.0436532|
| mode:key10                    |           1.896886e+07|             6.976023e+06|             2.7191505|              0.0066310|
| speechiness:explicitTRUE      |          -2.920611e+07|             1.893065e+07|            -1.5427947|              0.1231208|
| liveness:key6                 |           8.207375e+07|             3.105448e+07|             2.6428951|              0.0083175|
| acousticness:energy           |           3.696090e+07|             2.256555e+07|             1.6379345|              0.1016742|
| valence:key6                  |          -3.256067e+07|             1.836554e+07|            -1.7729216|              0.0764728|
| mode:key6                     |           1.421859e+07|             8.024995e+06|             1.7717877|              0.0766610|
| danceability:key8             |          -5.464746e+07|             2.495492e+07|            -2.1898470|              0.0287102|
| key8:explicitTRUE             |           2.921233e+07|             9.725016e+06|             3.0038335|              0.0027163|
| valence:key8                  |           4.742451e+07|             1.782397e+07|             2.6607156|              0.0078922|
| speechiness:key8              |          -4.504812e+07|             2.673174e+07|            -1.6851926|              0.0921883|

From the model 2, we can clearly see that danceability, energy, liveness, loudness, mode, spechiness and key6 have positive effects on streams, which means the more these factors used in the song, the song will be played by more people. Also, we need to pay attention to release duration. The longer the release duration is, the song will be played by less people, which means people prefer to play latest songs on Spotify.

![](final_project_files/figure-markdown_github/pdp-1.png)

From model 5, we get the Partial dependence functions of the song features, and the result seems robust to the model 2.

PCA and Clustering
------------------

### General methodologies

We would like to segment the 1,497 songs into groups with similar features in order to recommend to listeners who share the same interests/taste. For the reason of reducing unnecessary noises and computations, we first reduced the initial 27 variables by PCA. Next, we clustered them into groups with similar principle components, and based on the features in each principal component and the actual songs in each cluster, we were able to describe them in secular terminologies such as “genre”.

### PCA

We would like to use PCA to balance between the amount of computation load and explanatory variability, while eliminating as much noise as possible from our data. After centering and scaling of the data, we calculated the the loading matrix/scores matrix in order to derive the proportion of variance explained (PVE) and decide the number of principal components needed.

| ID   | Standard deviation  | Proportion of Variance | Cumulative Proportion |
|:-----|:--------------------|:-----------------------|:----------------------|
| PC1  | 2.80212353537273    | 0.112084941414909      | 0.1121                |
| PC2  | 1.77344288190906    | 0.0709377152763623     | 0.183                 |
| PC3  | 1.46727876624167    | 0.058691150649667      | 0.2417                |
| PC4  | 1.44279628131763    | 0.0577118512527051     | 0.2994                |
| PC5  | 1.2024934848242     | 0.0480997393929679     | 0.3475                |
| PC6  | 1.18118422033003    | 0.0472473688132011     | 0.3948                |
| PC7  | 1.16471426274806    | 0.0465885705099224     | 0.4414                |
| PC8  | 1.11901808461181    | 0.0447607233844724     | 0.4861                |
| PC9  | 1.10874235654547    | 0.0443496942618188     | 0.5305                |
| PC10 | 1.08797663277924    | 0.0435190653111695     | 0.574                 |
| PC11 | 1.08178043639889    | 0.0432712174559556     | 0.6173                |
| PC12 | 1.06412510961753    | 0.0425650043847012     | 0.6598                |
| PC13 | 1.05315275540945    | 0.0421261102163779     | 0.702                 |
| PC14 | 1.03932598862547    | 0.0415730395450188     | 0.7435                |
| PC15 | 1.00612785222318    | 0.0402451140889271     | 0.7838                |
| PC16 | 0.947189585246249   | 0.03788758340985       | 0.8217                |
| PC17 | 0.892958210859255   | 0.0357183284343702     | 0.8574                |
| PC18 | 0.821043647001771   | 0.0328417458800708     | 0.8902                |
| PC19 | 0.756342698063931   | 0.0302537079225572     | 0.9205                |
| PC20 | 0.647404260335455   | 0.0258961704134182     | 0.9464                |
| PC21 | 0.604914885182242   | 0.0241965954072897     | 0.9706                |
| PC22 | 0.419178980270296   | 0.0167671592108118     | 0.9873                |
| PC23 | 0.209254918185628   | 0.00837019672742513    | 0.9957                |
| PC24 | 0.100442731001129   | 0.00401770924004517    | 0.9997                |
| PC25 | 0.00698743489964209 | 0.000279497395985684   | 1                     |

In the table above, we see that the first 20 principle components explain more than 90% of the variability. We believe that these 20 principle components would keep our computation load low and eliminate some of the noises, while keeping the majority of the variability. Clustering would further group our songs based on these 20 principle components.

### Clustering

K-means++ clustering was used to determine our market segments. 3 types of supporting analysis were used to help us determine the the number of them(centroids): Elbow plot(SSE), CH index and Gap statistics.

![](final_project_files/figure-markdown_github/K-grid-1.png)

![](final_project_files/figure-markdown_github/CH-grid-1.png)

![](final_project_files/figure-markdown_github/Gap-1.png)

As shown above, both elbow plot and CH index returned K=16 and gap statistics K=4. Clustering 16 segments would not show us distinct differences among them as we now only have 20 principle components to allocate. So we selected K=4 as our anchor and explored the nearby Ks to see which one provides us the best explanation for each cluster. By “best explanation”, we considered the following 2 categories.

-   Clusters that have songs with clear and unique distribution in any of the 20 features.
-   Clusters that have songs with clear genre by their artist name and actual music.(we played a considerable quantity of sample size from each cluster on Youtube to confirm this)

As the result, we eventually picked K = 5.

Song market segments breakdown by distribution of features After the 5 clusters are determined, we reversed the principle components into the original features to determine cluster characteristics. We show some of the cluster identifiable distributions and the summary of each cluster below.

![](final_project_files/figure-markdown_github/PC1-1.png)

![](final_project_files/figure-markdown_github/PC2-1.png)

![](final_project_files/figure-markdown_github/PC3-1.png)

Cluster 1: High in energy, high in loudness, high danceability, low speechiness, considerate amount of G key, low acousticness

Cluster 2: Many 5 quarter time signature songs, high in energy

Cluster 3: Many songs with high energy, high on loudness

Cluster 4: Many songs with high on loudness, high danceability, considerable amount of B flat key

Cluster 5: Many 3 quarter time signature songs, low speechiness

### Song market segments breakdown by genre

Since we have the full list of song names and artist names available in each cluster, we could actually listen to the songs and categorize them manually by the music genre standard as in pop, rock, rap, etc. If our cluster characteristics determined by K-means++ show close resemblance of the music genre, then our recommendation system may be effective, at least to the extent of traditional music listeners with distinct preference over specific genre.

Cluster 1: Many songs with electronically altered/amplified sounds, very rhythmic, but genre varying from pop to rap to country, etc. Typical examples would be I Get The Bag by Gucci Mane, Echame La Culpa by Luis Fonsi, IDGAF by Dua Lipa.

Cluster 2: Indeed many songs with 5/4 time signature, high energy and rhythmic, but clearly sets apart different vibe compared cluster 1, perhaps due to the different time signature. Typical examples would be Top Off by DJ Khaled, You Can Cry by Marshmello, and Creep on me by GASHI.

Cluster 3: Genre varies a lot in this cluster, as shown in the very different artists such as Drake, Kendrick Lamar, Taylor Swift, XXXTENTACION and Queen. We did realize that out of the many rap songs in this cluster, most of them were the “slower” ones. For example, Wow by Post Malone and Forever Ever by Trippie Redd.

Cluster 4: Songs in B flat key stands out, such as Betrayed by Lil Xan and Midnight Summer Jam by Justin Timberlake, which make this cluster a different vibe than others.

Cluster 5: Many indie and pop songs with long vowel sounds, typical examples would be A Million Dreams by Ziv Zaifman, Perfect by Ed Sheeran and The Night We met by Lord Huron.

### Trend in popularity

We also calculated the total streams of different song clusters by time. The following graph shows the trend in the total streams of different categories.

From this graph we can see that the stream of five types of songs doesn’t change too much in a year. Cluster 1 music has more streams overall, due to the fact that there are more songs in this categories. There is a peak in the end of April in 2018 for cluster 1, and then the streams goes back to normal. From this graph we can also see that at the end of the year cluster 1 music is not as popular as in the middle of the year, but type 3 music becomes more and more popular, especially in july and the end of the year. The popularity of cluster 2, cluster 4 and cluster 5 music doesn’t change too much in the whole year.

![](final_project_files/figure-markdown_github/trend-1.png)

Conclusion
----------

Traditionally music listeners explore songs by specific genre and artists. This confirmation bias, typically nurtured through years of artificial genre segmentation by media and artist reputation, could be limiting listeners from the songs that they really want to exposed to. The question of “Why are we attracted to certain songs?” is a philosophical discussion that is beyond the scope of our project here, but given the data from spotify data and our clustering method, we perhaps show that key, time signature and speed of the songs are some of the contributing factors to our inner biological working of what to like and dislike. Then, our basic recommendation system, most likely already used by music industry like Spotify, could recommend songs not by mere genre and artist names, but also by specific keys and time signatures each listener is attracted to, subconsciously.
