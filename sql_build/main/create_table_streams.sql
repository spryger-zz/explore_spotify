--DROP TABLE streams
CREATE TABLE IF NOT EXISTS main.streams (
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

ALTER TABLE streams
ADD CONSTRAINT streams_track_fkey FOREIGN KEY (track_id) REFERENCES tracks (id)


ALTER TABLE main.streams 
    ALTER id ADD GENERATED ALWAYS AS IDENTITY 
        (START WITH 74035)