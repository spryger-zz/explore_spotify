CREATE TABLE IF NOT EXISTS main.artists (
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
	created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
	updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

UPDATE main.artists a
SET genre_1 = b.genre_1_override
FROM builder.artist_genre_override b
WHERE b.artist_id = a.id;


ALTER TABLE staging.staging_artists
ADD artist_image_url VARCHAR;

