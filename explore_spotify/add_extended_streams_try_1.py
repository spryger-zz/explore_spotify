from . import DataProcessor

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
# 5) Pass off to next process which reads data from Spotify API
