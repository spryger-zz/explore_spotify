SELECT album_id,
	album_name,
	artist_name,
	album_total_tracks,
	MIN(played_year) as first_played_year,
	ROUND(SUM(duration_min),2) as duration_min,
	ROUND(ROUND(COUNT(distinct track_id),2) / album_total_tracks,2) * 100 as pct_streamed,
	COUNT(distinct track_id) as tracks_streamed
FROM main.view_basic_stream_data vbsd 
WHERE album_total_tracks > 2
GROUP BY album_id, album_name, artist_name, album_total_tracks
/* LISTENED TO EVER SONG ON THE ALBUM */
HAVING COUNT(distinct track_id) >= album_total_tracks
/* LISTENED TO ALL BUT ONE SONG */
--HAVING album_total_tracks - COUNT(distinct track_id) = 1
/* PERCENTAGE LISTENED TO */
--HAVING ROUND(COUNT(distinct track_id),2) / album_total_tracks > .80
ORDER BY first_played_year