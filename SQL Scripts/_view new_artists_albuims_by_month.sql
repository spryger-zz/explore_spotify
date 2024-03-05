

CREATE VIEW new_artists_streamed_monthly AS
SELECT ar.name as artist_name, 
	ar.id as artist_id, 
	min(date_trunc('month', played_at)) as first_played_month, 
	sum(s.duration_ms) AS ms_played
FROM streams s
INNER JOIN tracks t
	ON s.track_id = t.id
INNER JOIN albums al
	ON t.album_id = al.id 
INNER JOIN artists ar
	ON al.artist_id = ar.id
GROUP BY ar.name, ar.id
ORDER BY first_played_month DESC, 
	ms_played DESC;
	
CREATE VIEW new_albums_streamed_monthly AS
SELECT al.name as album_name, 
	al.id as album_id, 
	min(date_trunc('month', played_at)) as first_played_month, 
	sum(s.duration_ms) AS ms_played
FROM streams s
INNER JOIN tracks t
	ON s.track_id = t.id
INNER JOIN albums al
	ON t.album_id = al.id 
GROUP BY al.name, al.id
ORDER BY first_played_month DESC, 
	ms_played DESC;

SELECT * FROM new_artists_streamed_monthly

SELECT * FROM new_albums_streamed_monthly