import urllib.request
from bs4 import BeautifulSoup
import xlwt
import requests
import spotipy
import spotipy.util as util
import json
import numpy as np
import pandas as pd
import re
import time

# get the token
username = 'znzhao@utexas.edu'
scope = 'user-library-read'

token = util.prompt_for_user_token(username,scope,
                          client_id='9504e0a87f154046b76cd8a2a6328b8e',
                          client_secret='1f81a004a42a408bba33aa8080f19806',
                          redirect_uri='http://localhost/')
headers = {"Authorization": "Bearer {}".format(token)}


df=pd.read_csv('E:\Project\Python\spider\spotify_charts.csv',sep=',')

track_id1 = []


for i in range(0,df.shape[0]):
    track_id1.append(df['URL'][i][31:])

for i in range(0,51):
    songs_attributes = []
    track_info = []
    album_list = []
    artist_list = []
    for j in range(int(i*200),200*(i+1)):
        tempurl = track_id1[j]
        myURL1 = 'https://api.spotify.com/v1/audio-features/' + tempurl
        myURL2 = 'https://api.spotify.com/v1/tracks/' + tempurl 
        # get the song feature information
        audiof_request = requests.get(myURL1, headers=headers)
        audiof_json = json.loads(audiof_request.text)
        # get the track information
        track_request = requests.get(myURL2, headers=headers)
        track_json = json.loads(track_request.text)
        #get the artist name
        artist_ids = track_json.get('artists')[0]['id']
        artist_name = track_json.get('artists')[0]['name']
        track_id = track_json.get('id')
        artist = {'artist_id':artist_ids, 'artist_name':artist_name, 'id': track_id}
        #get the album info
        album_ids = track_json.get('album')['id']
        album_name = track_json.get('album')['name']
        album = {'album_id':album_ids, 'album_name':album_name, 'id': track_id}
        # set up the dataset
        songs_attributes.append(audiof_json)
        track_info.append(track_json)
        album_list.append(album)
        artist_list.append(artist)
        #time.sleep(0.0001)
        print(j)
        for m in range(1,101):
            if (j/len(track_id1) == m/100):
                print("complete:" + str(m/100))

    my_songs = pd.DataFrame(songs_attributes)  
    my_track = pd.DataFrame(track_info)
    my_artist = pd.DataFrame(artist_list)
    my_album = pd.DataFrame(album_list)
    
    my_data = pd.merge(my_track,my_songs, how='inner', on = 'id', left_index=False)
    my_data = pd.merge(my_album,my_data, how='inner', on = 'id', left_index=False)
    my_data = pd.merge(my_artist,my_data, how='inner', on = 'id', left_index=False)
    filename = 'E:\test' + str(i) + '.csv'
    my_data.to_csv(r'E:\test' + str(i) + '.csv',sep=',')
