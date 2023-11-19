CREATE TABLE IF NOT EXISTS albums (
	id VARCHAR PRIMARY KEY,
	name VARCHAR,
	album_type VARCHAR,
	release_date DATE,
	release_date_precision VARCHAR,
	popularity INTEGER,
	total_tracks INTEGER,
	album_label VARCHAR,
	created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
	updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);