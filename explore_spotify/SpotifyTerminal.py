#System
import os
#API
import requests
#Data Processing
from datetime import datetime

class SpotifyTerminal:
    def __init__(self):
        AUTH_URL = 'https://accounts.spotify.com/api/token'
        
        # POST
        auth_response = requests.post(AUTH_URL, {
            'grant_type': 'client_credentials',
            'client_id': os.getenv('SPOTIPY_CLIENT_ID'),
            'client_secret': os.getenv('SPOTIPY_CLIENT_SECRET'),
        })
        
        # convert the response to JSON
        auth_response_data = auth_response.json()
        
        # save the access token
        access_token = auth_response_data['access_token']
        
        self.headers = {
            'Authorization': 'Bearer {token}'.format(token=access_token)
        }
        self.init_timestamp = datetime.now().strftime("%Y%m%d_%H_%M_%S")
        self.BASE_URL = 'https://api.spotify.com/v1/'

    def __repr__(self):
        return 'initialized at: {}'.format(self.init_timestamp)

    def check_api_status_code(self, status_code, id):
        if status_code != 200:
            print('API Error {}: Bad call on ID: {}')
        else:
            return
    
    def call_api_id(self, id, endpoint):
        # turn a list of IDs into a string for the API
        if type(id) == list:
            id = '?ids='+'%2C'.join(id)
        else:
            id = '/' + id
            
        # actual GET request with proper header
        r = requests.get(self.BASE_URL + endpoint + id, headers=self.headers)
        self.check_api_status_code(r.status_code, id)
        return r

    def call_api_id_additional(self, id, endpoint, additional, offset=None):
        # This function is supposed to give you auxiliary, tangential info about the object you're searching for
        # Not sure how transferable it is right now, but it was built to call an artist ID and return all of their albums
        
        # turn a list of IDs into a string for the API
        id = '/' + id
            
        # actual GET request with proper header
        if offset == None:
            r = requests.get(self.BASE_URL + endpoint + id + '/' + additional + '?include_groups=album&limit=50', headers=self.headers)
        else:
            r = requests.get(self.BASE_URL + endpoint + id + '/' + additional + '?include_groups=album&limit=50&offset=' + offset, headers=self.headers)
        self.check_api_status_code(r.status_code, id)
        return r

    def call_api_album_tracks(self, id, offset=None):
        # This function is supposed to give you auxiliary, tangential info about the object you're searching for
        # Not sure how transferable it is right now, but it was built to call an artist ID and return all of their albums
        
        # turn a list of IDs into a string for the API
        id = '/' + id
            
        # actual GET request with proper header
        if offset == None:
            r = requests.get(self.BASE_URL + 'albums' + id + '/' + 'tracks' + '?limit=50', headers=self.headers)
        else:
            r = requests.get(self.BASE_URL + 'albums' + id + '/' + 'tracks' + '?&limit=50&offset=' + offset, headers=self.headers)
        self.check_api_status_code(r.status_code, id)
        return r

    def call_api_search(self, track_name, artist_name):
        track_name_formatted = track_name.replace(' ', '%20')
        artist_name_formatted = artist_name.replace(' ', '%20')
        endpoint = 'search?q=track%3A{}%20artist%3A{}&type=track&limit=1'.format(track_name_formatted, artist_name_formatted)
        # actual GET request with proper header
        r = requests.get(self.BASE_URL + endpoint, headers=self.headers)
        self.check_api_status_code(r.status_code, id)
        return r

    def parse_track_result(self, item):
        try:
            result = item['track']
        except:
            result = item
        subset = dict((k, result[k]) for k in ('id', 'name', 'duration_ms', 'popularity', 'disc_number', 'track_number', 'explicit', 'type'))
        subset['album_id'] = result['album']['id']
        subset['artist_id'] = result['artists'][0]['id']
        subset['artist_count'] = len(result['artists'])
        try:
            subset['context'] = item['context']['uri']
        except:
            pass
        try:
            subset['played_at'] = item['played_at']
        except:
            pass
        return subset