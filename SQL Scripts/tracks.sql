CREATE TABLE IF NOT EXISTS tracks (
	id VARCHAR PRIMARY KEY,
	name VARCHAR,
	disc_number INTEGER,
	track_number INTEGER,
	explicit BOOLEAN,
	type VARCHAR,
	album_id VARCHAR ,
	artist_id VARCHAR,
	artist_count INTEGER,
	popularity INTEGER
);

ALTER TABLE tracks
ADD CONSTRAINT tracks_album_fkey FOREIGN KEY (album_id) REFERENCES albums (id);

ALTER TABLE tracks
ADD CONSTRAINT tracks_artist_fkey FOREIGN KEY (artist_id) REFERENCES artists (id);