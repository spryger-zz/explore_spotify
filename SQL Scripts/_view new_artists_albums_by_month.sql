
DROP VIEW IF EXISTS main.new_artists_streamed_monthly;

CREATE VIEW main.new_artists_streamed_monthly AS

WITH first_artist_played_month AS (
SELECT artist_id,
	MIN(played_month) as first_played_month,
	SUM(duration_min) as min_streamed_total,
	SUM(duration_hr) as hr_streamed_total
FROM main.view_basic_stream_data 
GROUP BY artist_id)

SELECT data_table.artist_name,
	data_table.main_genre,
	agg_table.first_played_month,
	ROUND(agg_table.min_streamed_total, 2) as min_streamed_total,
	ROUND(SUM(data_table.duration_min), 2) as min_streamed_in_month,
	ROUND(agg_table.hr_streamed_total, 2) as hr_streamed_total,
	ROUND(SUM(data_table.duration_hr), 2) as hr_streamed_in_month
FROM first_artist_played_month agg_table
INNER JOIN main.view_basic_stream_data data_table
	ON agg_table.artist_id = data_table.artist_id
	AND agg_table.first_played_month = data_table.played_month
GROUP BY data_table.artist_name,
	data_table.main_genre,
	agg_table.first_played_month,
	agg_table.min_streamed_total,
	agg_table.hr_streamed_total
ORDER BY agg_table.first_played_month,
	SUM(data_table.duration_min) DESC
	;



drop view if exists main.new_albums_streamed_monthly;
CREATE VIEW main.new_albums_streamed_monthly AS
SELECT al.name as album_name, 
	al.id as album_id, 
	ar.name as artist_name,
	ar.id as artist_id,
	g.main_genre,
	min(date_trunc('month', played_at)) as first_played_month, 
	ROUND(sum(s.duration_ms) / 60000,2) AS min_played
FROM streams s
INNER JOIN tracks t
	ON s.track_id = t.id
INNER JOIN albums al
	ON t.album_id = al.id 
INNER JOIN artists ar
	ON al.artist_id = ar.id
INNER JOIN builder.genres g
	on ar.genre_1 = g.raw_genre
GROUP BY al.name, 
	al.id, 
	ar.name,
	ar.id,
	g.main_genre
ORDER BY first_played_month DESC, 
	min_played DESC;

SELECT * FROM new_artists_streamed_monthly

SELECT * FROM new_albums_streamed_monthly