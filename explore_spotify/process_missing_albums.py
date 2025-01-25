from DatabaseTerminal import DatabaseTerminalProcessor as DatabaseTerminal
from DataProcessor import DataProcessorProcessor as DataProcessor

db = DatabaseTerminal() 
db.open()

albums_df = db.query('''
    SELECT distinct album_id 
    FROM staging.staging_tracks
    WHERE album_id not in (SELECT id FROM main.albums)
    ''')

proc = DataProcessor()
proc.get_new_table_data(albums_df['album_id'], 'albums')

db.execute_general_sql('TRUNCATE TABLE staging.staging_albums')
db.execute_insert_values_from_df(proc.api_table_data, 'staging.staging_albums')

db.close()