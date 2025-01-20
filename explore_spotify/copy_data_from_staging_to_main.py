from DatabaseTerminal import DatabaseTerminalProcessor as DatabaseTerminal

db = DatabaseTerminal() 
db.open()

db.execute_general_sql('''
    INSERT INTO main.artists (id, name, popularity, genre_count, genre_1, genre_2, genre_3, genre_4, genre_5, followers)
    SELECT id, name, popularity, genre_count, genre_1, genre_2, genre_3, genre_4, genre_5, followers
    FROM staging.staging_artists
''')

db.execute_general_sql('''
    INSERT INTO main.albums (id, name, album_type, release_date, release_date_precision, popularity, total_tracks, album_label, artist_id, album_image_640_url, album_image_300_url, album_image_64_url)
    SELECT id, name, album_type, release_date, release_date_precision, popularity, total_tracks, album_label, artist_id, album_image_640_url, album_image_300_url, album_image_64_url
    FROM staging.staging_albums
''')

db.execute_general_sql('''
    INSERT INTO main.tracks (id, name, disc_number, track_number, explicit, duration_ms, album_id, artist_count, popularity)
    SELECT id, name, disc_number, track_number, explicit, duration_ms, album_id, artist_count, popularity
    FROM staging.staging_tracks
''')

db.execute_general_sql('''
    INSERT INTO main.streams (track_id, track_name, artist_name, album_name, track_type, duration_ms, played_at, reason_start, reason_end, shuffle, skipped, context, username, data_source)
    SELECT track_id, track_name, artist_name, album_name, track_type, duration_ms, played_at, reason_start, reason_end, shuffle, skipped, context, username, data_source
    FROM staging.staging_streams
''')
db.close()




