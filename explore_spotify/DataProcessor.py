#from . import SpotifyTerminal, DatabaseTerminal
from SpotifyTerminal import SpotifyTerminalProcessor as SpotifyTerminal
from DatabaseTerminal import DatabaseTerminalProcessor as DatabaseTerminal
#System
import os
import json
import zipfile
#Data Processing
import pandas as pd
import math
import numpy as np


class DataProcessorProcessor:
    def __init__(self):
        # Locations of the data to process and where to archive it
        
        self.input_path = 'processing/input_spotify_data/'
        # self.staging_path = 'processing/staging/'
        self.archive_path = 'processing/archive/'

        self.streams_columns = ['track_id','track_name','artist_name','album_name','track_type','duration_ms','played_at','reason_start','reason_end','shuffle','skipped','context','username','data_source']
        self.tracks_columns = ['id','name','disc_number','track_number','explicit','duration_ms','album_id','artist_id','artist_count','popularity']
        self.albums_columns = ['id','name','album_type','release_date','release_date_precision','popularity','total_tracks','album_label']
        self.artists_columns = ['id','name','popularity','genre_count','genre_1','genre_2','genre_3','genre_4','genre_5','followers']

        # create instance of database terminal
        # self.db = DatabaseTerminal()
                
    def get_db_table_ids(self):
        # Opening the database to read all the ids that exist
        self.db = DatabaseTerminal()
        self.db.open()
        #self.db_stream_list = list(self.db.query('SELECT id FROM main.streams')['id'])
        self.db_track_list = list(self.db.query('SELECT id FROM main.tracks')['id'])
        self.db_artist_list = list(self.db.query('SELECT id FROM main.artists')['id'])
        self.db_album_list = list(self.db.query('SELECT id FROM main.albums')['id'])

        # Get stream data to measure overlap
        self.db_streams_check_overlap = self.db.query('SELECT id, track_id, played_at, data_source FROM main.streams')

        # Genres don't have an inherent Spotify ID, so we use the name as unique
        # This genre table maps the raw_genre direct from spotify to a main_genre that is easier to use
        self.db_genre_map = self.db.query('SELECT raw_genre, main_genre FROM builder.genres')
        # This table record_name_id is just a mapping of all unique track ids, with their corresponding album and artist names and ids
        # This is needed to create a unique identifyer of artist_name and track_name
        self.db_record_name_id = self.db.query('SELECT rni.*, al.popularity as album_popularity FROM main.record_name_id rni INNER JOIN main.albums al ON rni.album_id = al.id')
        
        self.db.close()

    def print_db_stats(self):
        # quick printing of row counts of the DB tables
        print('total streams: {}'.format(len(self.db_stream_list)))
        print('total tracks: {}'.format(len(self.db_track_list)))
        print('total artists: {}'.format(len(self.db_artist_list)))
        print('total albums: {}'.format(len(self.db_album_list)))

    ###################################
    ### DATA DOWNLOAD NORMALIZATION ###
    ###################################
    
    def check_files_in_input(self):
        # This function does 2 things:
        # 1) It makes sure there is one and only one file in the input area
        # 2) It reads the file name and sets it's file path and name to self variables
        files_in_input = os.listdir(self.input_path)
        num_files_in_input = len(files_in_input)
        if num_files_in_input > 1:
            print('too many files in input')
            self.input_path_file = None
            return
        elif num_files_in_input == 0:
            print('no files in input')
            self.input_path_file = None
            return
        else:
            self.input_file = files_in_input[0]
            self.input_path_file = self.input_path + self.input_file
            print('input_file: {}'.format(self.input_file))
    
    def normalize_raw_extended_streams(self):
        # This function intakes the extended streaming data (all time historical streams), normalizes the column names, and flattens it into a single dataframe
        # NOTE: extended streams contains lots of information already about each track.
        # Open and append streaming audio hisotry 
        if self.input_path_file == None:
            print('normalizer could not find input file')
            return
        streaming_data_raw = []
        with zipfile.ZipFile(self.input_path_file, "r") as myzip:
            for filename in myzip.namelist():
                if 'Streaming_History_Audio' in filename:
                    with myzip.open(filename) as f: 
                        data = f.read()
                        d = json.loads(data)
                        streaming_data_raw.extend(d)
        df_streams = pd.DataFrame(streaming_data_raw)
        
        # Create a DataFrame for tracks and streams
        # Combine URI into a single column
        # Separate Tracks from Episodes
        df_streams['all_uri'] = np.where(df_streams["spotify_track_uri"].isnull(), df_streams["spotify_episode_uri"], df_streams["spotify_track_uri"] )
        df_streams['track_name'] = np.where(df_streams["master_metadata_track_name"].isnull(), df_streams["episode_name"], df_streams["master_metadata_track_name"] )
        df_streams['track_type'] = np.where(df_streams["master_metadata_track_name"].isnull(), 'episode', 'track' )
        df_streams = df_streams[df_streams['all_uri'].notnull()]
        df_streams['track_id'] = df_streams.apply(lambda row: row.all_uri[-22:], axis=1)
        stream_column_rename = {'master_metadata_album_artist_name':'artist_name', 
                                'master_metadata_album_album_name':'album_name',
                                'ms_played':'duration_ms',
                                'ts':'played_at'
                                }
        # Basic Renaming and formatting
        df_streams.rename(columns=stream_column_rename,inplace=True)
        df_streams['data_source'] = 'extended_history'
        df_streams['context'] = None
        self.df_streams = df_streams[self.streams_columns]

    def normalize_raw_account_data_streams(self):
        # This function intakes the account streaming data (1 year streams), combines the artist and track name into a unique ID, and tries to see if that unique ID already exists in the DB
        # Open Streaming History File
        if self.input_path_file == None:
            print('normalizer could not find input file')
            return
        streaming_data_raw = []
        with zipfile.ZipFile(self.input_path_file, "r") as myzip:
            for filename in myzip.namelist():
                if 'StreamingHistory_music' in filename:
                    with myzip.open(filename) as f: 
                        data = f.read()
                        d = json.loads(data)
                        streaming_data_raw.extend(d)
        df_streams = pd.DataFrame(streaming_data_raw)
        # Prep the name matching table
        name_id_match_table = self.db_record_name_id.copy()
        name_id_match_table.sort_values(by='album_popularity', ascending=False, inplace=True)
        name_id_match_table = name_id_match_table.drop_duplicates(subset=['track_name','artist_name'])
        # Match IDs to the account data streams
        df_streams = df_streams.merge(name_id_match_table[['track_name','artist_name','track_id','artist_id','album_id']], how='left', left_on=['trackName','artistName'], right_on=['track_name','artist_name'])
        df_streams.drop(['track_name','artist_name'],axis=1,inplace=True)
        # Separate streams that matched to existing tracks vs ones that did not match to an existing track
        existing_streams = df_streams[df_streams['track_id'].notnull()]
        missing_streams = df_streams[df_streams['track_id'].isnull()]
        # Search for tracks via API
        tracks_to_search = missing_streams.drop_duplicates(subset=['trackName','artistName'])

        # Call API for missing data and append to existing df_streams
        print('    Calling Spotify API for track and name: {} items'.format(len(tracks_to_search)))
        sp = SpotifyTerminal()
        tracks_list = []
        still_missing_streams = []
        for index, row in tracks_to_search.iterrows():
            r = sp.call_api_search(row['trackName'],row['artistName'])
            if r.status_code != 200:
                print('bad call on iteration: {}'.format(index))
                print('    status code: {}'.format(r.status_code))
                break
            elif len(r.json()['tracks']['items']) > 0:
                track_parsed = sp.parse_track_result(r.json()['tracks']['items'][0])
                track_parsed['trackName'] = row['trackName']
                track_parsed['artistName'] = row['artistName']
                tracks_list.append(track_parsed)
            else:
                print('could not find {}'.format(row['artistName'] + row['trackName']))
                still_missing_streams.append(tracks_to_search.loc[index])
                pass
        # turn newly found data into a dataframe
        tracks_with_data = pd.DataFrame(data=tracks_list)
        # merge newly found data back to the streams table
        missing_streams_merged = missing_streams[['endTime','artistName','trackName','msPlayed']].merge(tracks_with_data, how='left', on=['artistName','trackName'])
        missing_streams_merged.rename(columns={'id':'track_id'}, inplace=True)
        # Split streams that we found data for away from streams we missed data for
        still_missing_streams = missing_streams_merged[missing_streams_merged['track_id'].isnull()][['endTime','artistName','trackName','msPlayed']]
        found_missing_streams = missing_streams_merged[missing_streams_merged['track_id'].notnull()][['endTime','artistName','trackName','msPlayed','track_id','artist_id','album_id']]
        # Append newly found streams to existing streams list
        for index, row in found_missing_streams.iterrows():
            df_streams = pd.concat([df_streams, pd.DataFrame([row])], ignore_index=True)
        
        # Prep the dataframe to conform to normalization
        # Set the data source filed to "Account Data"
        df_streams['data_source'] = 'account_data'
        df_streams['track_type'] = 'track'
        df_streams['album_name'] = None
        df_streams['reason_start'] = None
        df_streams['reason_end'] = None
        df_streams['shuffle'] = None
        df_streams['skipped'] = None
        df_streams['context'] = None
        df_streams['username'] = 'brian.cross741'
        df_streams.rename(columns={'trackName':'track_name','artistName':'artist_name','msPlayed':'duration_ms','endTime':'played_at'}, inplace=True)
        self.df_streams = df_streams[self.streams_columns]
    
    def move_input_to_archive(self):
        os.rename(self.input_path_file, self.archive_path + self.input_file)

    ###############################
    ### UPDATE DB WITH NEW DATA ###
    ###############################

    def add_dataframe_to_db_staging(self, df_to_load, destination_table):
        if destination_table[:7] == 'staging':
            # Opening the database
            self.db = DatabaseTerminal() # WOULD LIKE TO DELETE THIS IF POSSIBLE
            self.db.open()
            self.db.execute_values(df_to_load, destination_table)
            self.db.close()
        else:
            print('destination table not a staging table')
            return
    
    def check_new_streams_db_overlap(self):
        # PREREQUISITE:
        #   Run either of these 2 prior to running this (df_streams needs to exist)
        #      1) normalize_raw_extended_streams
        #      2) normalize_raw_account_data_streams
        if self.df_streams['data_source'].nunique() > 1:
            print('too many different data_source types for the current process')
            return
        data_source_to_load = self.df_streams['data_source'].max()

    def temp_load_quicksave_to_df_streams(self, quick_save):
        self.df_streams = quick_save
    
    #########################################
    #### API CALLS TO EXPAND INFORMATION ####
    #########################################
    
    def parse_album_result(self, item):
        subset = dict((k, item[k]) for k in ('id', 'name', 'album_type', 'release_date', 'release_date_precision', 'popularity', 'total_tracks', 'label'))
        subset['album_label'] = subset.pop('label')
        subset['artist_id'] = item['artists'][0]['id']
        subset['album_image_640_url'] = None
        subset['album_image_300_url'] = None
        subset['album_image_64_url'] = None
        for image_data in item['images']:
            if image_data['height'] == 640 and image_data['width'] == 640:
                subset['album_image_640_url'] = image_data['url']
            elif image_data['height'] == 300 and image_data['width'] == 300:
                subset['album_image_300_url'] = image_data['url']
            elif image_data['height'] == 64 and image_data['width'] == 64:
                subset['album_image_64_url'] = image_data['url']
            else:
                pass
        return subset

    def parse_artist_result(self, item):
        # collect the total number of genres for each artist
        item['genre_count'] = len(item['genres'])
    
        # create fields for the top 5 genres
        if len(item['genres']) > 4:
            item['genre_5'] = item['genres'][4]
        else:
            item['genre_5'] = None
        
        if len(item['genres']) > 3:
            item['genre_4'] = item['genres'][3]
        else:
            item['genre_4'] = None
        
        if len(item['genres']) > 2:
            item['genre_3'] = item['genres'][2]
        else:
            item['genre_3'] = None
        
        if len(item['genres']) > 1:
            item['genre_2'] = item['genres'][1]
        else:
            item['genre_2'] = None
        
        if len(item['genres']) > 0:
            item['genre_1'] = item['genres'][0]
        else:
            item['genre_1'] = None
    
        item['followers'] = item['followers']['total']
        
        subset = dict((k, item[k]) for k in ('id','name','popularity','followers','genre_count','genre_1','genre_2','genre_3','genre_4','genre_5'))
        return subset
    
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
    
    
    def get_new_table_data(self, search_list, table_type):
        # table_type can be ['artists','albums','tracks']
        #LIST FRACTION is the number of times the length of the list can be divided by either 50 or 20
        #ARTISTS and TRACKS have a call limit of 50 at a time, and ALBUMS is 20
        if table_type == 'artists' or table_type == 'tracks' or table_type == 'episodes':
            list_fraction = math.ceil(len(search_list) / 50)
        elif table_type == 'albums':
            list_fraction = math.ceil(len(search_list) / 20)
        
        #INITIALIZE
        sp = SpotifyTerminal()
        iteration = 0
        final = []
    
        #ITERATE
        for search_list_group in np.array_split(search_list, list_fraction):
            search_list_group = search_list_group.tolist()
            
            #CALL OPERATION
            result = sp.call_api_id(search_list_group, table_type)
            
            #EXCEPTION FOR ERRORS
            if result.status_code != 200:
                print('bad call on iteration: {}'.format(iteration))
                print('    status code: {}'.format(result.status_code))
                break
                
            #PARSE AND APPEND
            for i in result.json()[table_type]:
                if i is not None:
                    if table_type == 'tracks':
                        result_clean = self.parse_track_result(i)
                        final.append(result_clean)
                    elif table_type == 'artists':
                        result_clean = self.parse_artist_result(i)
                        final.append(result_clean)
                    elif table_type == 'albums':
                        result_clean = self.parse_album_result(i)
                        final.append(result_clean)
                else:
                    pass
            iteration += 1
        self.api_table_data = pd.DataFrame(data=final)