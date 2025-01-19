CREATE TABLE IF NOT EXISTS staging.raw_streams (
	id INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
	track_id VARCHAR NOT NULL,
	track_name VARCHAR,
	artist_name VARCHAR,
	album_name VARCHAR,
	track_type VARCHAR,
	duration_ms INT8,
	played_at TIMESTAMPTZ NOT NULL,
	reason_start VARCHAR,
	reason_end VARCHAR,
	shuffle VARCHAR,
	skipped VARCHAR,
	context VARCHAR,
	username VARCHAR,
	data_source VARCHAR,
	created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
	updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);