
DROP TABLE staging.staging_artists;
CREATE TABLE IF NOT EXISTS staging.staging_artists (
	id VARCHAR PRIMARY KEY,
	name VARCHAR,
	popularity VARCHAR,
	genre_count INTEGER,
	genre_1 VARCHAR,
	genre_2 VARCHAR,
	genre_3 VARCHAR,
	genre_4 VARCHAR,
	genre_5 VARCHAR,
	followers INTEGER,
	artist_image_640_url VARCHAR,
	artist_image_300_url VARCHAR,
	artist_image_64_url VARCHAR,	
	created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
	updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);


