from DatabaseTerminal import DatabaseTerminalProcessor as DatabaseTerminal

# 1) Instantiate DatabaseTerminal
# 2) Truncate staging.staging_streams
# 3) Move the non-overlap between staging.raw_streams and main.streams to staging.staging_streams
#    Use played_at timestamp as the overlap identifier
#    Keep only tracks (songs) rather than episodes (podcasts)


db = DatabaseTerminal() 
db.open()
db.execute_general_sql('TRUNCATE TABLE staging.staging_streams')
db.execute_general_sql('''
    INSERT INTO staging.staging_streams (track_id, track_name, artist_name, album_name, track_type, duration_ms, played_at, reason_start, reason_end, shuffle, skipped, context, data_source)
    SELECT track_id, track_name, artist_name, album_name, track_type, duration_ms, played_at, reason_start, reason_end, shuffle, skipped, context, data_source
    FROM staging.raw_streams
    WHERE played_at > (SELECT MAX(played_at) FROM main.streams)
        AND track_type = 'track'
''')
db.close()