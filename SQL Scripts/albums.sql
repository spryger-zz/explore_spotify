CREATE TABLE IF NOT EXISTS main.albums (
	id VARCHAR PRIMARY KEY,
	name VARCHAR,
	album_type VARCHAR,
	release_date DATE,
	release_date_precision VARCHAR,
	popularity INTEGER,
	total_tracks INTEGER,
	album_label VARCHAR,
	created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
	updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
	artist_id VARCHAR
);


ALTER TABLE main.albums
ALTER COLUMN release_date TYPE VARCHAR; 

ALTER TABLE main.albums
ADD CONSTRAINT albums_artist_fkey FOREIGN KEY (artist_id) REFERENCES artists (id);

ALTER TABLE main.albums
ADD artist_id VARCHAR;

--Populate new artist ID
UPDATE main.albums t2
SET    artist_id = t1.artist_id
FROM   main.tracks t1
WHERE  t2.id = t1.album_id
AND    t2.artist_id IS DISTINCT FROM t1.artist_id;

create table main.dupe_albums as (select * from main.albums);