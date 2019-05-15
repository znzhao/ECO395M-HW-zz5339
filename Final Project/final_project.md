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

    ## Importance of components:
    ##                           PC1     PC2     PC3     PC4    PC5     PC6
    ## Standard deviation     1.6740 1.33171 1.21131 1.20116 1.0966 1.08682
    ## Proportion of Variance 0.1121 0.07094 0.05869 0.05771 0.0481 0.04725
    ## Cumulative Proportion  0.1121 0.18302 0.24171 0.29943 0.3475 0.39477
    ##                            PC7     PC8     PC9    PC10    PC11    PC12
    ## Standard deviation     1.07922 1.05784 1.05297 1.04306 1.04009 1.03156
    ## Proportion of Variance 0.04659 0.04476 0.04435 0.04352 0.04327 0.04257
    ## Cumulative Proportion  0.44136 0.48612 0.53047 0.57399 0.61726 0.65983
    ##                           PC13    PC14    PC15    PC16    PC17    PC18
    ## Standard deviation     1.02623 1.01947 1.00306 0.97324 0.94496 0.90611
    ## Proportion of Variance 0.04213 0.04157 0.04025 0.03789 0.03572 0.03284
    ## Cumulative Proportion  0.70195 0.74353 0.78377 0.82166 0.85738 0.89022
    ##                           PC19   PC20   PC21    PC22    PC23    PC24
    ## Standard deviation     0.86968 0.8046 0.7778 0.64744 0.45744 0.31693
    ## Proportion of Variance 0.03025 0.0259 0.0242 0.01677 0.00837 0.00402
    ## Cumulative Proportion  0.92047 0.9464 0.9706 0.98733 0.99570 0.99972
    ##                           PC25
    ## Standard deviation     0.08359
    ## Proportion of Variance 0.00028
    ## Cumulative Proportion  1.00000
