
--DROP VIEW IF EXISTS main.view_basic_stream_data;
CREATE OR REPLACE VIEW main.view_basic_stream_data AS
SELECT 
	t.name as track_name,
	al.name as album_name,
	ar.name as artist_name,
	g.main_genre,
	s.played_at,
	date_trunc('day', s.played_at) as played_day,
	date_trunc('month', s.played_at) as played_month,
	date_trunc('year', s.played_at) as played_year,
	s.duration_ms,
	ROUND(s.duration_ms / 1000.0 , 10) as duration_s,
	ROUND(s.duration_ms / 60000.0 , 10) as duration_min,
	ROUND(s.duration_ms / 3600000.0 , 10) as duration_hr,
	ar.genre_1,
	s.id as stream_id,
	t.id as track_id,
	al.id as album_id,
	ar.id as artist_id,
	al.total_tracks AS album_total_tracks
FROM main.streams s
INNER JOIN main.tracks t
	ON s.track_id = t.id
INNER JOIN main.albums al
	ON t.album_id = al.id 
INNER JOIN main.artists ar
	ON al.artist_id = ar.id
LEFT JOIN builder.genres g 
	ON ar.genre_1 = g.raw_genre;