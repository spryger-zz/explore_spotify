print('hi')
from DataProcessor import DataProcessorProcessor as DataProcessor
#from . import DatabaseTerminal
#from DatabaseTerminal import DatabaseTerminal_1

#System
# import os
# import json
# import zipfile
#Data Processing
# import pandas as pd
# import math

##########################
### General Data Model ###
##########################

# Streams > Tracks > Artists > Albums
# Must be populated in reverse order (start with albums, then artists, then tracks, then streams)

######################################
### General Process of This Script ###
######################################

# 1) Instantiate DataProcessor
# 2) Check if data file is there
# 3) Read the extended streams into one dataframe
# 4) Format the extended streams to how they should be added
# 5) Load the extended streams into the database staging area


print('starting')
proc = DataProcessor()

print('checking files')
proc.check_files_in_input()

print('reading and normalizing extended streams')
proc.normalize_raw_extended_streams()

print('moving input to archive')
proc.move_input_to_archive()

print('loading extended streams to db staging')
proc.add_dataframe_to_db_staging(proc.df_streams, 'staging.staging_streams')