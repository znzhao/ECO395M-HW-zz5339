# This file will do data cleaning after the spider grabbed data from Spotify.com
# Run this file to get the final dataset that we use in this project.
library(tidyverse)
songdata = data.frame()
for (i in c(0:70)) {
  temp <- read.csv(paste("E:/data/data-1/test",i,".csv",sep = "",collapse=""))
  songdata = rbind(songdata,temp)
}

spotify_charts <- read.csv("E:/data/data/spotify_charts.csv")

songdata = cbind(spotify_charts, songdata)
album = subset(songdata, select = c(album))

releaseDate = c()
for (i in c(1:nrow(album))) {
  word = str_split(album$album[i],pattern = ", ")
  temp = word[[1]][grep(pattern = "'release_date'", x = word[[1]])]
  word = str_split(temp,pattern = ": ")
  temp = substr(x = word[[1]][2], start = 2, stop = nchar(word[[1]][2])-1)
  temp = temp
  releaseDate = c(releaseDate,temp)
}

for (i in c(1:length(releaseDate))){
  if (nchar(releaseDate[i]) == 4) {
    releaseDate[i] = paste(releaseDate[i], "-01-01", sep = "")
  }
  if (nchar(releaseDate[i]) == 7) {
    releaseDate[i] = paste(releaseDate[i], "-01",sep = "")
  }
  }
release_date = as.data.frame(releaseDate)
release_date$releaseDate = as.Date(release_date$releaseDate)
songdata = subset(songdata, select = c(-URL, -album, -artists, -disc_number, -duration_ms_y,-external_ids, -external_urls))
songdata = subset(songdata, select = c(-href, -preview_url, -track_number, -type_x, -type_y, -uri_x, -uri_y, -analysis_url, -track_href))
songdata = cbind(songdata, release_date)

songdata2018 = subset(songdata,  (as.Date(songdata$Date)>"2018-1-1") & (as.Date(songdata$Date)<"2019-1-1") )

sounddata_2018 = songdata2018 %>%
  group_by(id, artist_name, album_name,releaseDate, duration_ms_x, explicit, is_local, name, popularity, acousticness, danceability,energy, instrumentalness, key, liveness, loudness, mode, speechiness, tempo, time_signature, valence) %>%
  summarise(Streams = sum(Streams))

write.csv(sounddata_2018, file = "E:/data/sounddata_2018.csv",row.names=FALSE)
write.csv(songdata2018, file = "E:/data/sounddata_2018weekly.csv",row.names=FALSE)
