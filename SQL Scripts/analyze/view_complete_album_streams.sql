--DROP VIEW main.view_complete_album_streams
CREATE OR REPLACE VIEW main.view_complete_album_streams AS
SELECT artist_name,
	album_name,
	played_day,
	main_genre,
	SUM(duration_min) as minutes_played,
	COUNT(*) as tracks_played,
	album_total_tracks,
	album_id,
	artist_id,
	album_image_640_url,
	album_image_300_url,
	album_image_64_url
FROM main.view_basic_stream_data
WHERE album_total_tracks > 2
GROUP BY artist_name,
	album_name,
	played_day,
	main_genre,
	album_total_tracks,
	album_id,
	artist_id,
	album_image_640_url,
	album_image_300_url,
	album_image_64_url
HAVING COUNT(DISTINCT track_number) = album_total_tracks
ORDER BY played_day;
