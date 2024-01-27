SELECT * FROM information_schema.table_constraints
WHERE constraint_schema = 'public'

SELECT * FROM information_schema.columns
WHERE table_schema = 'public'
	AND table_name = 'artists'

INSERT INTO artists(id)
VALUES ('Artist1');

INSERT INTO albums(id)
VALUES ('Album1');

INSERT INTO tracks(id, artist_id, album_id)
VALUES ('Track1','Artist1','Album1');
INSERT INTO tracks(id, artist_id, album_id)
VALUES ('Track2','Artist1','Album1');

INSERT INTO streams(track_id, played_at)
VALUES ('Track1','2023-01-01');
INSERT INTO streams(track_id, played_at)
VALUES ('Track2','2023-02-01');

UPDATE streams
SET duration_ms = 123
WHERE id = 1;


SELECT * FROM artists
SELECT * FROM albums
SELECT * FROM tracks
SELECT * FROM streams

DELETE FROM artists WHERE id in ('Artist1')

SELECT s.id as stream_id, 
	t.id as track_id, 
	al.id as album_id,
	ar.id as artist_id
FROM streams s
INNER JOIN tracks t
	ON s.track_id = t.id
INNER JOIN albums al
	ON t.album_id = al.id 
INNER JOIN artists ar
	ON t.artist_id = ar.id
LIMIT 10
	
UPDATE streams
SET duration_ms = 123
WHERE id = 1;
