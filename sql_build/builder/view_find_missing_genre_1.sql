
CREATE OR REPLACE VIEW builder.view_find_missing_genre_1 AS
SELECT artist_id,
	artist_name,
	SUM(duration_hr) as hours_listened
FROM main.view_basic_stream_data vbsd
WHERE genre_1 is null
GROUP BY artist_id,
	artist_name
ORDER BY SUM(duration_hr) DESC