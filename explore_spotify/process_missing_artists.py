from DatabaseTerminal import DatabaseTerminalProcessor as DatabaseTerminal
from DataProcessor import DataProcessorProcessor as DataProcessor

db = DatabaseTerminal() 
db.open()

artists_df = db.query('''
    SELECT distinct id as artist_id
    FROM main.artists
    --WHERE artist_id not in (SELECT id FROM main.artists)
    ''')

proc = DataProcessor()
proc.get_new_table_data(artists_df['artist_id'], 'artists')

db.execute_general_sql('TRUNCATE TABLE staging.staging_artists')
db.execute_insert_values_from_df(proc.api_table_data, 'staging.staging_artists')

db.close()