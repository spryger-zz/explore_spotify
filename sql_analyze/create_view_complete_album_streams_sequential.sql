
/*** Complete front to back listens to an album ***/
CREATE OR REPLACE VIEW main.view_complete_album_streams_sequential AS

WITH streams_lagged AS (
	SELECT track_name, album_name, artist_name, main_genre
		, played_at
		, stream_id, track_id, album_id
		, album_total_tracks, disc_number, track_number
		, LAG(stream_id, track_number - 1) OVER (ORDER BY played_at) as lagged_track_number
	FROM main.view_basic_stream_data  
)

, streams_lagged_with_album_sequence AS (
	SELECT *
		, ROW_NUMBER() OVER (PARTITION BY lagged_track_number ORDER BY played_at) AS album_sequence_check
	FROM streams_lagged
)

, album_listen_timestamp AS (
	SELECT *
		, CASE WHEN album_sequence_check = track_number AND track_number = album_total_tracks THEN played_at 
			ELSE NULL END AS album_listen_stamp
	FROM streams_lagged_with_album_sequence 
)

SELECT album_listen_stamp, album_name, artist_name, album_id, album_total_tracks, main_genre
FROM album_listen_timestamp 
WHERE album_listen_stamp IS NOT NULL --filter out partial album streams
	AND album_total_tracks > 2
--	AND album_id = '7Eoz7hJvaX1eFkbpQxC5PA'
GROUP BY album_listen_stamp, album_name, artist_name, album_id, album_total_tracks, main_genre
--artist_name = 'Makaya McCraven'
ORDER BY album_listen_stamp;


SELECT a.*, b.album_duration_min
FROM main.view_complete_album_streams a
INNER JOIN (SELECT album_id, ROUND(SUM(duration_ms / 1000 / 60),2) AS album_duration_min FROM main.tracks GROUP BY album_id) b
ON a.album_id = b.album_id