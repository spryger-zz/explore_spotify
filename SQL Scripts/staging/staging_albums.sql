CREATE TABLE IF NOT EXISTS staging.staging_albums (
	id VARCHAR PRIMARY KEY,
	name VARCHAR,
	album_type VARCHAR,
	release_date VARCHAR,
	release_date_precision VARCHAR,
	popularity INTEGER,
	total_tracks INTEGER,
	album_label VARCHAR,
	created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
	updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
	artist_id VARCHAR,
	album_image_640_url VARCHAR,
	album_image_300_url VARCHAR,
	album_image_64_url VARCHAR
);