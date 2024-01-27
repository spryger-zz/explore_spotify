--drop table main.tracks
CREATE TABLE IF NOT EXISTS main.tracks (
	id VARCHAR PRIMARY KEY,
	name VARCHAR,
	disc_number INTEGER,
	track_number INTEGER,
	explicit BOOLEAN,
	duration_ms INTEGER,
	album_id VARCHAR ,
	artist_id VARCHAR,
	artist_count INTEGER,
	popularity INTEGER,
	created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
	updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

ALTER TABLE main.tracks
ADD CONSTRAINT tracks_album_fkey FOREIGN KEY (album_id) REFERENCES albums (id);

ALTER TABLE main.tracks
ADD CONSTRAINT tracks_artist_fkey FOREIGN KEY (artist_id) REFERENCES artists (id);

ALTER TABLE main.tracks
RENAME COLUMN type to duration_ms;

ALTER TABLE main.tracks
ALTER COLUMN duration_ms TYPE INTEGER USING (duration_ms::integer); 