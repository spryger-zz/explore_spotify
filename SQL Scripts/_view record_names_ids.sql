

CREATE VIEW main.record_name_id AS
SELECT 
	t.name as track_name,
	al.name as album_name,
	ar.name as artist_name, 
	t.id as track_id,
	al.id as album_id,
	ar.id as artist_id
FROM main.tracks t
INNER JOIN main.albums al
	ON t.album_id = al.id 
INNER JOIN main.artists ar
	ON al.artist_id = ar.id

	
