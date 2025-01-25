from DatabaseTerminal import DatabaseTerminalProcessor as DatabaseTerminal
from DataProcessor import DataProcessorProcessor as DataProcessor

db = DatabaseTerminal() 
db.open()

tracks_df = db.query('''
    SELECT distinct track_id 
    FROM staging.staging_streams 
    WHERE track_id not in (SELECT id FROM main.tracks)
    ''')

proc = DataProcessor()
proc.get_new_table_data(tracks_df['track_id'], 'tracks')

db.execute_general_sql('TRUNCATE TABLE staging.staging_tracks')
db.execute_insert_values_from_df(proc.api_table_data, 'staging.staging_tracks')

db.close()