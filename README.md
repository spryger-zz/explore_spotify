# Purpose
Intake Spotify streaming history to better understand music streaming habits and tastes

# Requirements
1) Spotify App w/ IDs to access the Spotify API
  These are required to get more details about each track, album, & artist.
  Never hurts to check out their developer terms: https://developer.spotify.com/compliance-tips.
2) Setting up an entire postgresql database
  I know, it's not exactly streamlined, but I'm showing off what I can do.
  Scripts for the schemas and tables are available here.
3) Create a couple folders in the base directory called:
   files_to_process/data_staging/
   files_to_process/archived/

# Quick Summary
## Where's the data coming from?
Spotify allows you to download your streaming history in 2 different formats:
  1) extended streaming history (all time streams)
  2) account data (1 year streams)

## What does this script do?  
  1) It will read a zip file downloaded from Spotify (either extended or 1 year format) and normalize the data.
  2) This requires some API calls because the 1 year format is very narrow scope (artist, track, timestamp, duration).
  3) Take that normalized data and add it to the database.
  4) Read the database for analysis purposes (I lean towards PowerBI and sometimes matplotlib)
