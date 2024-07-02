# Purpose
Create a database of your Spotify streaming history to better understand music streaming habits and tastes.

# Quick Summary
  ## Where's the data coming from?
  Spotify allows you to download your streaming history in 2 different formats:
    1) extended streaming history (all time streams)
    2) account data (1 year streams)

  ## What does this script do?  
    1) It will read a zip file downloaded from Spotify (either extended or 1 year format) and normalize the data.
    2) The script calls the API to get more info for each table.
    3) Data is normalized.
    4) Take that normalized data and add it to the database.
    5) Read the database for analysis purposes (I lean towards PowerBI and sometimes matplotlib)

# Contents / Directories
## 1) /explore_spotify/
  Contains the 3 major classes used for processing.

  ### DataProcessor.py
    Combines the uses of the other 2 classes to perform as the main class executing functions.
  
  ### DatabaseTerminal.py
    Functions to read and write to the database. This does not include the scripts to create the database (for those see sql_build).
  
  ### SpotifyTerminal.py
    Used for calling the Spotify API for additional data about track, album, and artist.
  
  ## 2) /sql_analyze/
    SQL scripts to create views that help analyze the data from this process.
  
  ## 3) /sql_build/
    SQL scripts to create the schemas, main tables, builder tables (just for genre), and staging tables for writing new data.
  
# Requirements
1) Spotify App w/ IDs to access the Spotify API
  These are required to get more details about each track, album, & artist.
  I Recommend you check out their developer terms: https://developer.spotify.com/compliance-tips.
2) Setting up an entire postgresql database
  These scripts require a database for saving results.
  Scripts for the schemas and tables are available in the sql_scripts directory.
3) Create a couple folders in the base directory called:
  files_to_process/data_staging/
  files_to_process/archived/
