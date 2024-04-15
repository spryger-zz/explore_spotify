CREATE TABLE IF NOT EXISTS staging.staging_tracks (
	id VARCHAR PRIMARY KEY,
	name VARCHAR,
	disc_number INTEGER,
	track_number INTEGER,
	explicit BOOLEAN,
	duration_ms INTEGER,
	album_id VARCHAR ,
	artist_count INTEGER,
	popularity INTEGER,
	created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
	updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);